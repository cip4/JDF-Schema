<?xml version="1.0" encoding="iso-8859-1"?>
<!--
	interim.xsl 
	
	Takes a list of schema filenames as input. This file does not have a schema but the
	structure is very simple:
	
		<?xml version="1.0"?>
		<schemalist>
			<filename>....</filename>
			<filename>....</filename>
			...
		</schemalist>
		
	Scans each file in that list to produce a data dictionary: a table of items. These kinds
	of global items are listed:
		
		
		complexType
		element
		simpleType
		group
		attributeGroup
		
	We list the data type of each, the namespace it comes from and its <annotation><documentation>.
	The result is an HTML table.
	
	The processing is done in phases. First a single tree is built from all the input
	schemas then (phase 2) it is sorted on item name and output as HTML. The intermediate tree,
	in variable Phase1output, contains two kinds of elements:
	
		<Schema> contains the name of an input schema
		<Item> contains data for a row of the final table
	
	A third phase outputs the table as a comma-separated values (CSV) file which could be
	input to other applications, such as spreadsheets.
	
	NB: This XSLT uses some Xalan-specific features, particularly to do the 3-phase processing.
	
	
	
	PLANNED ENHANCEMENTS:
	1. The input XML file should include user parameters to select the columns and item kinds
	   which are to be listed.
	2. Add additional (optional) column: restrictions on the data type.
	3. Put the prefixes on the elements listed in the data type column for complexType items.
	4. In the initial list of schemas show the standard prefixes as keys and use these in the 
	   Namespace column instead of the full schema references.
	5. Show item kind by colour coding?
	6. Check that there are no other kinds of item we want to list from the schemas.
	7. Invoke a Java class to list all schemas in a named directory at the start, to avoid
	   having to write schelist.xml as an input file.
-->

<xsl:stylesheet 
	version="1.1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:redirect="org.apache.xalan.lib.Redirect"
	extension-element-prefixes="redirect"
	exclude-result-prefixes="xsd xalan">
	
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" xalan:indent-amount="1"/>
        <xsl:strip-space elements="*"/>
        
        <xsl:variable name="Newline">
<xsl:text>
</xsl:text>
        </xsl:variable>
        
	<xsl:template match="schemalist">
		<!-- Phase 1 - Make the intermediate tree: -->
	        <xsl:variable name="Phase1output">
			<xsl:apply-templates select="*" mode="ph1"/>
		</xsl:variable>
		
		<!-- Phase 2 - Output the results as an HTML page: -->
		<xsl:element name="html">
			<xsl:element name="head">
				<xsl:element name="title">JDF XML schemas - data dictionary</xsl:element>
				<xsl:element name="style">
<![CDATA[
body,td { font-family:Verdana,Arial,sans-serif;font-size:8pt }
h1,th { font-size:12pt;font-weight:bold;background-color:#cccccc }
h2 { font-size:12pt;font-weight:bold;color:#999999 }
.oddrow { background-color:#ffffff }
.evenrow { background-color:#eeeeff }
]]>
				</xsl:element>
			</xsl:element>
			<xsl:element name="body">
				<xsl:attribute name="bgcolor">#ffffff</xsl:attribute>
				<xsl:attribute name="text">#000000</xsl:attribute>
				<xsl:element name="h1">JDF XML schemas - data dictionary</xsl:element>
				<xsl:element name="h2">Schemas included:</xsl:element>

				<!-- Output sorted list of schema names: -->
				<xsl:element name="p">
					<xsl:apply-templates select="xalan:nodeset($Phase1output)/Schema" mode="ph2">
						<xsl:sort select="."/>
					</xsl:apply-templates>
				</xsl:element>

				<!-- Output the main table: -->
				<xsl:element name="table">
					<xsl:attribute name="width">100%</xsl:attribute>
					<xsl:attribute name="border">0</xsl:attribute>
					<xsl:attribute name="cellspacing">0</xsl:attribute>
					<xsl:attribute name="cellpadding">4</xsl:attribute>
					
					<!-- Heading row: -->
					<xsl:element name="tr">
						<xsl:attribute name="class">tablehead</xsl:attribute>
						<xsl:element name="th">Schema item</xsl:element>
						<xsl:element name="th">Kind</xsl:element>
						<xsl:element name="th">Data type</xsl:element>
						<xsl:element name="th">Extends</xsl:element>
						<xsl:element name="th">Restricts</xsl:element>
						<xsl:element name="th">Head</xsl:element>
						<xsl:element name="th">SubstGroup</xsl:element>
						<xsl:element name="th">Comment</xsl:element>
						<xsl:element name="th">File</xsl:element>
					</xsl:element>
					
					<!-- Sorted data rows: -->
					<xsl:apply-templates select="xalan:nodeset($Phase1output)/Item" mode="ph2">
						<xsl:sort select="@Name"/>
					</xsl:apply-templates>
				</xsl:element>

				<xsl:element name="hr"/>
			</xsl:element>
		</xsl:element>
		
		<!-- Phase 3 - Output the results as a comma-separated values file: -->
		<redirect:write file="DataDictionary.csv">
			<!-- Heading row: -->
			<xsl:text>Schema item,Kind,Data type,Extends,Restricts,Abstract,Subst Group,Comment,Namespace</xsl:text>
			<xsl:value-of select="$Newline"/>
			
			<!-- Sorted data rows: -->
			<xsl:apply-templates select="xalan:nodeset($Phase1output)/Item" mode="ph3">
				<xsl:sort select="@Name"/>
			</xsl:apply-templates>
		</redirect:write>
	</xsl:template>
	
	<xsl:template match="filename" mode="ph1">
		<xsl:variable name="Filename" select="."/>
		<xsl:element name="Schema"><xsl:value-of select="$Filename"/></xsl:element>

		<!-- Create a tree for this input schema: -->
	        <xsl:variable name="Schema" select="document(string(.))"/>

		<!-- The following for-each sections extract data for each of the kinds of item
		     we are interested in listing from the input schemas: -->
		     
                <xsl:for-each select="$Schema/xsd:schema/xsd:attributeGroup">
                	<xsl:if test="@name">
	                	<xsl:call-template name="SchemaItem">
	                		<xsl:with-param name="Kind">global attributeGroup</xsl:with-param>
	                		<xsl:with-param name="Filename" select="$Filename"/>                 		
	                	</xsl:call-template>
                	</xsl:if>
                </xsl:for-each>

                <xsl:for-each select="$Schema/xsd:schema/xsd:complexType">
                	<xsl:if test="@name">
                		<xsl:call-template name="SchemaItem">
                			<xsl:with-param name="Kind">global complexType</xsl:with-param>
                			<xsl:with-param name="Filename" select="$Filename"/> 
                			<xsl:with-param name="Extends">
                				   <xsl:if test="xsd:simpleContent/xsd:extension">
				                	<xsl:value-of select="xsd:simpleContent/xsd:extension/@base"/>
				                </xsl:if>
				                 <xsl:if test="xsd:complexContent/xsd:extension">
				                	<xsl:value-of select="xsd:complexContent/xsd:extension/@base"/>
				                </xsl:if>
				      </xsl:with-param>
				      <xsl:with-param name="Restricts">
				                <xsl:if test="xsd:simpleContent/xsd:restriction">
				                	<xsl:value-of select="xsd:simpleContent/xsd:restriction/@base"/>
				                </xsl:if>
				                 <xsl:if test="xsd:complexContent/xsd:restriction">
				                	<xsl:value-of select="xsd:complexContent/xsd:restriction/@base"/>
				                </xsl:if>
				     </xsl:with-param>                			                			
                		</xsl:call-template>
                	</xsl:if>
                </xsl:for-each>

                <xsl:for-each select="$Schema/xsd:schema/xsd:element">
                	<xsl:call-template name="SchemaItem">
                		<xsl:with-param name="Kind">global element</xsl:with-param>
                		<xsl:with-param name="Filename" select="$Filename"/> 
                		<xsl:with-param name="DataType">
                			<xsl:if test="./@type">
				                <xsl:value-of select="@type"/>
				      </xsl:if>
					<xsl:if test="./@ref">
				                <xsl:value-of select="@ref"/>
				      </xsl:if>
				</xsl:with-param>
				<xsl:with-param name="Abstract">
                			<xsl:if test="./@abstract">
				                <xsl:value-of select="@abstract"/>
				      </xsl:if>					
				</xsl:with-param>
				<xsl:with-param name="SubGroup">
                			<xsl:if test="./@substitutionGroup">
				                <xsl:value-of select="@substitutionGroup"/>
				      </xsl:if>					
				</xsl:with-param>
				<xsl:with-param name="Extends">
					<xsl:if test="not(@type)">
						<xsl:value-of select="./xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
					</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="Restricts">
					<xsl:if test="not(@type)">
						<xsl:value-of select="./xsd:complexType/xsd:complexContent/xsd:restriction/@base"/>
					</xsl:if>
				</xsl:with-param>
                	</xsl:call-template>
                </xsl:for-each>

                <xsl:for-each select="$Schema/xsd:schema/xsd:simpleType">
                	<xsl:call-template name="SchemaItem">
                		<xsl:with-param name="Kind">global simpleType</xsl:with-param>
                		<xsl:with-param name="Filename" select="$Filename"/>
                		<xsl:with-param name="DataType" select="xsd:restriction/@base"/>
                	</xsl:call-template>
                </xsl:for-each>
                
                 <xsl:for-each select="$Schema/xsd:schema/xsd:group">
                	<xsl:call-template name="SchemaItem">
                		<xsl:with-param name="Kind">global group</xsl:with-param>
                		<xsl:with-param name="Filename" select="$Filename"/>                		
                	</xsl:call-template>
                </xsl:for-each>


	</xsl:template>

	<xsl:template name="SchemaItem"> <!-- Phase 1 but you can't set mode in call-template -->
		<xsl:param name="Kind"/>
		<xsl:param name="Filename"/>
		<xsl:param name="DataType"/>
		<xsl:param name="Extends"/>
		<xsl:param name="Restricts"/>
		<xsl:param name="Abstract"/>
		<xsl:param name="SubGroup"/>
		
		<xsl:element name="Item">
			<xsl:attribute name="Name"><xsl:value-of select="@name"/></xsl:attribute>
			<xsl:attribute name="Kind"><xsl:value-of select="$Kind"/></xsl:attribute>
			<xsl:attribute name="Type"><xsl:value-of select="$DataType"/></xsl:attribute>
			<xsl:attribute name="Extends"><xsl:value-of select="$Extends"/></xsl:attribute>
			<xsl:attribute name="Restricts"><xsl:value-of select="$Restricts"/></xsl:attribute>
			<xsl:choose>
				<xsl:when  test="$Abstract">
					<xsl:attribute name="Abstract"><xsl:value-of select="$Abstract"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="not($Abstract)">
					<xsl:attribute name="Abstract"></xsl:attribute>

				</xsl:when>
			</xsl:choose>			
			<xsl:choose>
				<xsl:when test="$SubGroup">
					<xsl:attribute name="SubGroup"><xsl:value-of select="$SubGroup"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="not($SubGroup)">
					<xsl:attribute name="SubGroup"></xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:attribute name="Note"><xsl:value-of select="normalize-space(translate(xsd:annotation/xsd:documentation,'&#xd;',' '))"/></xsl:attribute>
			<xsl:attribute name="Space"><xsl:value-of select="$Filename"/></xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="Schema" mode="ph2">
		<xsl:value-of select="."/>
		<xsl:element name="br"/>
	</xsl:template>
	
	<xsl:template match="Item" mode="ph2">
		<xsl:element name="tr">
			<xsl:choose>
				<xsl:when test="position() mod 2">
					<xsl:attribute name="class">oddrow</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">evenrow</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:element name="td"><xsl:value-of select="@Name"/></xsl:element>
			<xsl:element name="td"><xsl:value-of select="@Kind"/></xsl:element>
			<xsl:element name="td"><xsl:value-of select="@Type"/></xsl:element>
			<xsl:element name="td"><xsl:value-of select="@Extends"/></xsl:element>
			<xsl:element name="td"><xsl:value-of select="@Restricts"/></xsl:element>
			<xsl:element name="td"><xsl:value-of select="@Abstract"/></xsl:element>
			<xsl:element name="td"><xsl:value-of select="@SubGroup"/></xsl:element>
			<xsl:element name="td"><xsl:value-of select="@Note"/></xsl:element>
			<xsl:element name="td"><xsl:value-of select="@Space"/></xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="Item" mode="ph3">
<xsl:value-of select="@Name"/>,<xsl:value-of select="@Kind"/>,<xsl:value-of select="@Type"/>,<xsl:value-of select="@Extends"/>,<xsl:value-of select="@Restricts"/>,<xsl:value-of select="@Abstract"/>,<xsl:value-of select="@SubGroup"/>,&quot;<xsl:value-of select="translate(@Note,'&quot;',' ')"/>&quot;,<xsl:value-of select="@Space"/><xsl:value-of select="$Newline"/>
	</xsl:template>

</xsl:stylesheet>
