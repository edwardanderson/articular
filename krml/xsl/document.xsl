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
    <xsl:param name="krml-context-uri">http://example.com/krml.json</xsl:param>
    <xsl:param name="embed-context" select="true()"/>
    <!-- Document -->
    <xsl:param name="base">http://example.org/</xsl:param>
    <xsl:param name="context">https://linked.art/ns/v1/linked-art.json</xsl:param>
    <xsl:param name="language"/>
    <xsl:param name="title"/>
    <xsl:param name="vocab">http://example.org/terms/</xsl:param>
    <!-- Data -->
    <xsl:param name="boolean-true" select="('true', 'True', 'TRUE')"/>
    <xsl:param name="boolean-false" select="('false', 'False', 'FALSE')"/>

    <!-- Child templates -->
    <xsl:import href="a.xsl"/>
    <xsl:import href="blockquote.xsl"/>
    <xsl:import href="context.xsl"/>
    <xsl:import href="dl.xsl"/>
    <!-- <xsl:import href="identifier.xsl"/> -->
    <xsl:import href="img.xsl"/>
    <!-- <xsl:import href="label.xsl"/> -->
    <xsl:import href="li.xsl"/>
    <xsl:import href="p.xsl"/>
    <!-- <xsl:import href="table.xsl"/> -->
    <!-- <xsl:import href="h1.xsl"/> -->
    <xsl:import href="ul.xsl"/>

    <!-- === Templates === -->

    <!-- Document -->
    <xsl:template match="/document">
        <xsl:variable name="xml">
            <map>
                <!-- @context -->
                <xsl:call-template name="context">
                    <xsl:with-param name="base" select="$base"/>
                    <xsl:with-param name="vocab" select="$vocab"/>
                    <xsl:with-param name="language" select="$language"/>
                </xsl:call-template>
                <!-- (Un)named graph -->
                <xsl:if test="$title">
                    <string key="@id">
                        <xsl:value-of select="encode-for-uri($title)"/>
                    </string>
                </xsl:if>
                <!-- Content -->
                <array key="@graph">
                    <!-- Data -->
                    <xsl:apply-templates select="ul"/>
                    <!-- Definition -->
                    <xsl:apply-templates select="dl"/>
                </array>
            </map>
        </xsl:variable>
        <xsl:value-of select="xml-to-json($xml)"/>
    </xsl:template>

</xsl:stylesheet>
