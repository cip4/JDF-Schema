<?xml version="1.0" encoding="iso-8859-1"?>
<!--
	parentChild.xsl 
	Maxine Chappell.
	Maxxml Limited
	26th Sep 2003.
	
	Takes a list of schema filenames as input. This file does not have a schema but the
	structure is very simple:
	
		<?xml version="1.0"?>
		<schemalist>
			<filename>....</filename>
			<filename>....</filename>
			...
		</schemalist>
		
	Scans each file in that list to produce an xml representation of all of the parent child relationships in the 	schema - to be used for impact analysis. i.e. being able to identify every incidence of type, element, group 	and attribute group reuse. 
		
	The processing is done in phases. First a single tree is built from all the input
	schemas then (phase 2) it is sorted on item name and . The intermediate tree,
	in variable Phase1output, contains 
	
	A third phase outputs the table as a comma-separated values (CSV) file which could be
	input to other applications, such as spreadsheets.
	
	NB: This XSLT uses some Xalan-specific features, particularly to do the 3-phase processing.
	
	
	
	
-->
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xalan="http://xml.apache.org/xalan" xmlns:redirect="org.apache.xalan.lib.Redirect" extension-element-prefixes="redirect" exclude-result-prefixes="xsd xalan">
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" xalan:indent-amount="1"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="schemalist">
		<!-- Phase 1 - Make the intermediate tree: -->
			<xsl:variable name="Phase1Globals">
				<xsl:element name="Items">
					<xsl:apply-templates select="*" mode="ph1">
							<xsl:sort select="./@Name"/>				
					</xsl:apply-templates>
				</xsl:element>
			</xsl:variable>
			<xsl:variable name="Phase2Schema">
				<xsl:element name="SchemaSet">
					<xsl:apply-templates select="*" mode="ph2"/>				
				</xsl:element>
			</xsl:variable>
			<!-- Now need to iterate through all of the globals, through every schema to capture reuse or no reuse -->
			<xsl:element name="Reuse">
				
			<xsl:for-each select="xalan:nodeset($Phase1Globals)/Items/Global">
				<xsl:variable name="global" select="./@Name"/>
				<xsl:choose>
					<xsl:when test="./@Type='Attribute Group' ">
						<xsl:call-template name="checkAttributeGroup">
							<xsl:with-param name="cGlobal" select="."/>
							<xsl:with-param name="Phase2Schema" select="$Phase2Schema"/>
						</xsl:call-template>					
					</xsl:when>
					<xsl:when test="./@Type= 'Element' ">
						<xsl:call-template name="checkElement">
							<xsl:with-param name="cGlobal" select="."/>
							<xsl:with-param name="Phase2Schema" select="$Phase2Schema"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="./@Type= 'Simple Type' ">
						<xsl:call-template name="checkSimpleType">
							<xsl:with-param name="cGlobal" select="."/>
							<xsl:with-param name="Phase2Schema" select="$Phase2Schema"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="./@Type= 'Complex Type' ">
						<xsl:call-template name="checkComplexType">
							<xsl:with-param name="cGlobal" select="."/>
							<xsl:with-param name="Phase2Schema" select="$Phase2Schema"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="./@Type= 'Group' ">
						<xsl:call-template name="checkGroup">
							<xsl:with-param name="cGlobal" select="."/>
							<xsl:with-param name="Phase2Schema" select="$Phase2Schema"/>
						</xsl:call-template>
					</xsl:when>							
			
				</xsl:choose>
			</xsl:for-each>
			
			</xsl:element><!-- Reuse -->
						
	</xsl:template>
	<xsl:template match="filename" mode="ph1">
		<xsl:variable name="Filename" select="."/>
		<xsl:variable name="Schema" select="document(string(.))"/>
		<!-- Extract all of the global defintitions across all of the schema files-->
		<!-- ****Attribute Groups**** --> 
		<xsl:for-each select="$Schema/xs:schema/xs:attributeGroup">								
			<xsl:call-template name="globalItem">
				<xsl:with-param name="Name"><xsl:value-of select="./@name"/></xsl:with-param>
				<xsl:with-param name="Type">Attribute Group</xsl:with-param>
				<xsl:with-param name="DefinFile"><xsl:value-of select="$Filename"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<!-- ****Elements**** --> 
		<xsl:for-each select="$Schema/xs:schema/xs:element">		
			<xsl:choose>
				<xsl:when test="./@substitutionGroup"/>
				<xsl:otherwise>
					<xsl:call-template name="globalItem">
						<xsl:with-param name="Name"><xsl:value-of select="./@name"/></xsl:with-param>
						<xsl:with-param name="Type">Element</xsl:with-param>
						<xsl:with-param name="DefinFile"><xsl:value-of select="$Filename"/></xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!-- ****Simple Types**** -->
		<xsl:for-each select="$Schema/xs:schema/xs:simpleType">								
			<xsl:call-template name="globalItem">
				<xsl:with-param name="Name"><xsl:value-of select="./@name"/></xsl:with-param>
				<xsl:with-param name="Type">Simple Type</xsl:with-param>
				<xsl:with-param name="DefinFile"><xsl:value-of select="$Filename"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<!-- ****Complex Types**** -->
		<xsl:for-each select="$Schema/xs:schema/xs:complexType">								
			<xsl:call-template name="globalItem">
				<xsl:with-param name="Name"><xsl:value-of select="./@name"/></xsl:with-param>
				<xsl:with-param name="Type">Complex Type</xsl:with-param>
				<xsl:with-param name="DefinFile"><xsl:value-of select="$Filename"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<!-- ****Groups**** -->
		<xsl:for-each select="$Schema/xs:schema/xs:group">								
			<xsl:call-template name="globalItem">
				<xsl:with-param name="Name"><xsl:value-of select="./@name"/></xsl:with-param>
				<xsl:with-param name="Type">Group</xsl:with-param>
				<xsl:with-param name="DefinFile"><xsl:value-of select="$Filename"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="globalItem">		
		<xsl:param name="Name"/>
		<xsl:param name="Type"/>
		<xsl:param name="DefinFile"/>								
		<xsl:element name="Global">
			<xsl:attribute name="Name"><xsl:value-of select="$Name"/></xsl:attribute>
			<xsl:attribute name="Type"><xsl:value-of select="$Type"/></xsl:attribute>
			<xsl:attribute name="DefinFile"><xsl:value-of select="$DefinFile"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="checkAttributeGroup">
		<xsl:param name="cGlobal"/>
		<xsl:param name="Phase2Schema"/>
		<xsl:choose>
		<xsl:when test="xalan:nodeset($Phase2Schema)//*[substring(./@ref,(string-length(./@ref)- string-length($cGlobal/@Name))+1)=$cGlobal/@Name]"/>
		<xsl:otherwise>
							<xsl:element name="GlobalNOTReused">
				<xsl:attribute name="cName"><xsl:value-of select="$cGlobal/@Name"/></xsl:attribute>
				<xsl:attribute name="cType"><xsl:value-of select="$cGlobal/@Type"/></xsl:attribute>
				<xsl:attribute name="cFile"><xsl:value-of select="$cGlobal/@DefinFile"/></xsl:attribute>				
			</xsl:element>
		</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	<xsl:template name="checkElement">
		<xsl:param name="cGlobal"/>
		<xsl:param name="Phase2Schema"/>
		<xsl:choose>
			<xsl:when test="xalan:nodeset($Phase2Schema)//*[substring(./@ref,(string-length(./@ref)- string-length($cGlobal/@Name))+1)=$cGlobal/@Name]"/>
			<xsl:otherwise>
				<xsl:element name="GlobalNOTReused">
					<xsl:attribute name="cName"><xsl:value-of select="$cGlobal/@Name"/></xsl:attribute>
					<xsl:attribute name="cType"><xsl:value-of select="$cGlobal/@Type"/></xsl:attribute>
					<xsl:attribute name="cFile"><xsl:value-of select="$cGlobal/@DefinFile"/></xsl:attribute>				
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="checkSimpleType">
		<xsl:param name="cGlobal"/>
		<xsl:param name="Phase2Schema"/>
		<!-- Check for simple reuse -->
		<xsl:choose>
			<xsl:when test="xalan:nodeset($Phase2Schema)//*[substring(./@type,(string-length(./@type)- string-length($cGlobal/@Name))+1)=$cGlobal/@Name]"/>
			<xsl:otherwise>
				<!-- Check for extension/restriction -->
				<xsl:choose>
					<xsl:when test="xalan:nodeset($Phase2Schema)//*[substring(./@base,(string-length(./@base)- string-length($cGlobal/@Name))+1)=$cGlobal/@Name]"/>
					<xsl:otherwise>
						<!-- Check for list -->	
						<xsl:choose>	
							<xsl:when test="xalan:nodeset($Phase2Schema)//*[substring(./@itemType,(string-length(./@itemType)- string-length($cGlobal/@Name))+1)=$cGlobal/@Name]"/>
							<xsl:otherwise>
								<!-- Check for union -->
								<xsl:choose>
									<xsl:when test="xalan:nodeset($Phase2Schema)//*[substring(./@memberType,(string-length(./@memberType)- string-length($cGlobal/@Name))+1)=$cGlobal/@Name]"/>
									<xsl:otherwise>
										<xsl:element name="GlobalNOTReused">
											<xsl:attribute name="cName"><xsl:value-of select="$cGlobal/@Name"/></xsl:attribute>
											<xsl:attribute name="cType"><xsl:value-of select="$cGlobal/@Type"/></xsl:attribute>
											<xsl:attribute name="cFile"><xsl:value-of select="$cGlobal/@DefinFile"/></xsl:attribute>											
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>							
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="checkComplexType">
		<xsl:param name="cGlobal"/>
		<xsl:param name="Phase2Schema"/>
		<xsl:choose>
			<!-- Check for simple reuse -->
			<xsl:when test="xalan:nodeset($Phase2Schema)//*[substring(./@type,(string-length(./@type)- string-length($cGlobal/@Name))+1)=$cGlobal/@Name]"/>
			<xsl:otherwise>
				<xsl:choose>
					<!-- Check for extension/restriction -->
					<xsl:when test="xalan:nodeset($Phase2Schema)//*[substring(./@base,(string-length(./@base)- string-length($cGlobal/@Name))+1)=$cGlobal/@Name]"/>
					<xsl:otherwise>
						<xsl:element name="GlobalNOTReused">
							<xsl:attribute name="cName"><xsl:value-of select="$cGlobal/@Name"/></xsl:attribute>
							<xsl:attribute name="cType"><xsl:value-of select="$cGlobal/@Type"/></xsl:attribute>
							<xsl:attribute name="cFile"><xsl:value-of select="$cGlobal/@DefinFile"/></xsl:attribute>							
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:template>
	<xsl:template name="checkGroup">
		<xsl:param name="cGlobal"/>
		<xsl:param name="Phase2Schema"/>
		<!-- Check for simple reuse -->
		<xsl:choose>
		<xsl:when test="xalan:nodeset($Phase2Schema)//*[substring(./@ref,(string-length(./@ref)- string-length($cGlobal/@Name))+1)=$cGlobal/@Name]"/>
			<xsl:otherwise>
				<xsl:element name="GlobalNOTReused">
					<xsl:attribute name="cName"><xsl:value-of select="$cGlobal/@Name"/></xsl:attribute>
					<xsl:attribute name="cType"><xsl:value-of select="$cGlobal/@Type"/></xsl:attribute>
					<xsl:attribute name="cFile"><xsl:value-of select="$cGlobal/@DefinFile"/></xsl:attribute>				
				</xsl:element>
			</xsl:otherwise>	
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template match="filename" mode="ph2">
		<!-- Create a tree for the input schema: -->
		<xsl:variable name="file" select="."/>
		<xsl:element name="schema">
			<xsl:attribute name="file"><xsl:value-of select="$file"/></xsl:attribute>		
			<xsl:copy-of select="* | document($file)/*/*"/>
		</xsl:element>		
	</xsl:template>	
</xsl:stylesheet>
