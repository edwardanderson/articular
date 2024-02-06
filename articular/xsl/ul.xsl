<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <xsl:output method="text" encoding="utf-8"/>

    <xsl:strip-space elements="*"/>

    <!-- === Parameters === -->
    <!-- Application -->
    <xsl:param name="autotype" select="true()"/>
    <xsl:param name="boolean-true" select="('true', 'True', 'TRUE')"/>
    <xsl:param name="boolean-false" select="('false', 'False', 'FALSE')"/>
    <xsl:param name="context">https://linked.art/ns/v1/linked-art.json</xsl:param>
    <!-- Data-->
    <xsl:param name="base">http://example.org/</xsl:param>
    <xsl:param name="vocab">http://example.org/terms/</xsl:param>
    <xsl:param name="language"></xsl:param>
    <xsl:param name="class-image">schema:ImageObject</xsl:param>
    <xsl:param name="class-blockquote">html:blockquote</xsl:param>

    <xsl:variable name="bcp-47" select="document(bcp_47.xml)"/>

    <!-- Child templates -->
    <xsl:import href="context.xsl"/>
    <xsl:import href="li.xsl"/>
    <xsl:import href="identifier.xsl"/>
    <xsl:import href="label.xsl"/>
    <xsl:import href="a.xsl"/>
    <xsl:import href="img.xsl"/>
    <xsl:import href="blockquote.xsl"/>
    <xsl:import href="p.xsl"/>

    <!-- Document -->
    <xsl:template match="/">
        <xsl:variable name="xml">
            <map>
                <!-- @context -->
                <xsl:call-template name="context">
                    <xsl:with-param name="base" select="$base"/>
                    <xsl:with-param name="vocab" select="$vocab"/>
                    <xsl:with-param name="language" select="$language"/>
                    <!-- <xsl:with-param name="context" select="$context"/> -->
                </xsl:call-template>
                <!-- Subject -->
                <xsl:apply-templates select="ul/li" mode="subject"/>
            </map>
        </xsl:variable>
        <xsl:value-of select="xml-to-json($xml)"/>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>
