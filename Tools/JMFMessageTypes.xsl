<?xml version="1.0" encoding="UTF-8"?>
<!-- The main template. Processing starts here -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:jdf="http://www.CIP4.org/JDFSchema_1_1">
	<xsl:template match="@*|text()"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>"JMF Message Types"</title>
			</head>
			<body>
				<table border="6">
					<CAPTION>
						<font color="red">
							<big>JMF Message Name and Usage</big>
						</font>
					</CAPTION>
					<COLGROUP align="center"/>
					<COLGROUP align="center"/>
					<COLGROUP align="center"/>
					<tbody>
						<th>Query Message Names</th>
						<th>Messages</th>
						<th>Message Usage</th>
						<xsl:apply-templates select='//*[xs:complexContent/xs:extension/@base="jdf:JMFAbstractQuery_"]'/>
						<th>Response Message Names</th>
						<th>Messages</th>
						<th>Message Usage</th>
						<xsl:apply-templates select='//*[xs:complexContent/xs:extension/@base="jdf:JMFAbstractResponse_"]'/>
						<th>Signal Message Names</th>
						<th>Messages</th>
						<th>Message Usage</th>
						<xsl:apply-templates select='//*[xs:complexContent/xs:extension/@base="jdf:JMFAbstractSignal_"]'/>
					</tbody>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match='*[xs:complexContent/xs:extension/@base="jdf:JMFAbstractQuery_"]'>
		<tr>
			<td>
				<xsl:value-of select="@name"/>
			</td>
			<xsl:call-template name="Messages"/>
			<td>
				<xsl:value-of select="xs:annotation/xs:documentation"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match='*[xs:complexContent/xs:extension/@base="jdf:JMFAbstractResponse_"]'>
		<tr>
			<td>
				<xsl:value-of select="@name"/>
			</td>
			<xsl:call-template name="Messages"/>
			<td>
				<xsl:value-of select="xs:annotation/xs:documentation"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match='*[xs:complexContent/xs:extension/@base="jdf:JMFAbstractSignal_"]'>
		<tr>
			<td>
				<xsl:value-of select="@name"/>
			</td>
			<xsl:call-template name="Messages"/>
			<td>
				<xsl:value-of select="xs:annotation/xs:documentation"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="Messages">
		<td>
			<xsl:value-of select='substring-after(xs:complexContent/xs:extension/xs:sequence/xs:element/@ref, "jdf:")'/>
			<br/>
			<xsl:value-of select="xs:complexContent/xs:extension/xs:sequence/xs:element/@name"/>
		</td>
	</xsl:template>
</xsl:stylesheet>
