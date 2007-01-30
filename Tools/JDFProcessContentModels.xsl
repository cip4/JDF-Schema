<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:jdf="http://www.CIP4.org/JDFSchema_1_1">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="@*|text()"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>"JDF Process Content Models"</title>
			</head>
			<body>
				<table border="6">
					<CAPTION>
						<font color="red">
							<big>JDF Process Content Models</big>
						</font>
					</CAPTION>
					<tbody>
						<xsl:apply-templates/>
					</tbody>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match='/xs:schema/xs:complexType[xs:complexContent/xs:extension/@base="jdf:JDFAbstractNode"]'>
		<tr>
			<th colspan="5" align="left">
				<xsl:value-of select="@name"/>
			</th>
		</tr>
		<tr>
			<th>Name</th>
			<th>ProcessUsage</th>
			<th>Usage</th>
			<th>Min</th>
			<th>Max</th>
		</tr>
		<xsl:apply-templates select="xs:annotation/xs:appinfo"/>
		<tr>
			<td colspan="5" align="center">-=-</td>
		</tr>
	</xsl:template>
	<xsl:template match="xs:appinfo">
		<xsl:for-each select="Constraint">
			<tr>
				<td>
					<xsl:value-of select='substring-after(@Path, "ResourceLinkPool/")'/>
				</td>
				<xsl:choose>
					<xsl:when test="@ProcessUsage">
						<td>
							<xsl:value-of select="@ProcessUsage"/>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>All</td>
					</xsl:otherwise>
				</xsl:choose>
				<td>
					<xsl:value-of select="@Usage"/>
				</td>
				<td>
					<xsl:value-of select="@minOccurs"/>
				</td>
				<td>
					<xsl:value-of select="@maxOccurs"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
