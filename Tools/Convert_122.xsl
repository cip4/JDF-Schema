<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:jdf="http://www.CIP4.org/JDFSchema_1_1" xmlns:jdf2="http://www.CIP4.org/JDFSchema_1_2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xsl fo jdf jdf2">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	<!--The Document root - 
	Changes to new namespace
	Adds a Version attribute (overwritten by original)
		Adds a schemaLocation attribute (overwrites original)-->
	<xsl:template match="/jdf:JDF">
		<xsl:element name="{name()}" namespace="http://www.CIP4.org/JDFSchema_1_2">
			<xsl:if test='name()="JDF"'>
				<xsl:attribute name="Version">1.1</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="@*"/>
			<xsl:attribute name="schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance">http://www.CIP4.org/JDFSchema_1_2 file:///D:\JDF\CIP4\jdf\schema\Version_1_2\JDF.xsd</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>
	<!--All other element in version 1 namespace - 
	Uses default namespace
	If a JDF node, adds Version attribute (overwritten by original)-->
	<xsl:template match="jdf:*">
		<xsl:element name="{name()}" namespace="http://www.CIP4.org/JDFSchema_1_2">
			<xsl:if test='name()="JDF"'>
				<xsl:attribute name="Version">1.1</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="@*"/>
			<xsl:choose>
				<xsl:when test='name()="ResourceLinkPool"'>
					<xsl:apply-templates select="node()">
						<xsl:sort select="@Usage"/>
						<xsl:sort select="name()"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<!--All other nodes copied in default namespace-->
	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="comment()">
		<xsl:copy/>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:attribute name="{name()}" namespace=""><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	<xsl:template name="JDFKnownNode">
		<xsl:param name="NodeType"/>
		<xsl:attribute name="{name()}" namespace=""><xsl:value-of select="."/></xsl:attribute>
		<xsl:attribute name="type" namespace="http://www.w3.org/2001/XMLSchema-instance"><xsl:value-of select="$NodeType"/></xsl:attribute>
	</xsl:template>
	<!-- All the known JDF process nodes have xsi:type added -->
	<xsl:template match='@Type[string()="Product"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ProcessGroup"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Combined"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Approval"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Buffer"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Combine"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Delivery"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ManualLabor"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Ordering"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Packing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ResourceDefinition"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Split"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Verification"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ColorCorrection"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ColorSpaceConversion"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ContactCopying"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ContoneCalibration"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="DBDocTemplateLayout"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="DBTemplateMerging"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="FilmToPlateCopying"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="FormatConversion"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ImageReplacement"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ImageSetting"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Imposition"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="InkZoneCalculation"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Interpreting"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="LayoutElementProduction"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="LayoutPreparation"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="PDFToPSConversion"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Preflight"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="PreviewGeneration"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Proofing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="PSToPDFConversion"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Rendering"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Scanning"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Screening"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Separation"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="SoftProofing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Tiling"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Trapping"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ConventionalPrinting"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="DigitalPrinting"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="IDPrinting"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="AdhesiveBinding"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="BlockPreparation"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="BoxPacking"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="CaseMaking"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="CasingIn"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ChannelBinding"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="CoilBinding"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Collecting"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="CoverApplication"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Creasing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Cutting"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Dividing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Embossing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="EndSheetGluing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Folding"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Gathering"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Gluing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="HeadBandApplication"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="HoleMaking"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Inserting"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Jacketing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Labeling"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Laminating"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="LongitudinalRibbonOperations"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Numbering"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Palletizing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Perforating"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="PlasticCombBinding"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="RingBinding"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="SaddleStitching"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ShapeCutting"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Shrinking"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="SideSewing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="SpinePreparation"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="SpineTaping"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Stacking"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Stitching"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Strapping"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="StripBinding"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ThreadSealing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="ThreadSewing"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Trimming"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="WireCombBinding"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match='@Type[string()="Wrapping"]'>
		<xsl:call-template name="JDFKnownNode">
			<xsl:with-param name="NodeType" select="string()"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
