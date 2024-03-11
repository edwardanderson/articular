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
    <xsl:param name="autotype" select="false()"/>
    <xsl:param name="articular-context-uri">http://example.com/articular.json</xsl:param>
    <xsl:param name="embed-context" select="true()"/>
    <xsl:param name="frontmatter-metadata" select="false()"/>
    <!-- Document -->
    <xsl:param name="base">http://example.org/</xsl:param>
    <xsl:param name="context">https://linked.art/ns/v1/linked-art.json</xsl:param>
    <xsl:param name="graph-name"/>
    <xsl:param name="language"></xsl:param>
    <xsl:param name="vocab">http://example.org/terms/</xsl:param>
    <!-- Data -->
    <xsl:param name="boolean-true" select="('true', 'True', 'TRUE')"/>
    <xsl:param name="boolean-false" select="('false', 'False', 'FALSE')"/>
    <xsl:param name="class-image">html:img</xsl:param>
    <xsl:param name="class-blockquote">html:blockquote</xsl:param>
    <xsl:param name="definition-equivalence">owl:sameAs</xsl:param>

    <!-- Child templates -->
    <xsl:import href="a.xsl"/>
    <xsl:import href="blockquote.xsl"/>
    <xsl:import href="context.xsl"/>
    <xsl:import href="dl.xsl"/>
    <xsl:import href="identifier.xsl"/>
    <xsl:import href="img.xsl"/>
    <xsl:import href="label.xsl"/>
    <xsl:import href="li.xsl"/>
    <xsl:import href="p.xsl"/>
    <xsl:import href="table.xsl"/>
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
                    <!-- <xsl:with-param name="context" select="$context"/> -->
                </xsl:call-template>
                <!-- (Un)named graph -->
                <xsl:if test="$graph-name">
                    <string key="@id">
                        <xsl:value-of select="$graph-name"/>
                    </string>
                </xsl:if>
                <!-- Metadata -->
                <xsl:if test="$frontmatter-metadata">
                    <string key="_format">text/markdown</string>
                    <string key="_type">_Dataset</string>
                </xsl:if>
                <!-- Content -->
                <array key="@graph">
                    <!-- Data -->
                    <xsl:apply-templates select="ul"/>
                    <!-- Definition list -->
                    <xsl:apply-templates select="dl"/>
                </array>
            </map>
        </xsl:variable>
        <xsl:value-of select="xml-to-json($xml)"/>
        <!-- <xsl:value-of select="serialize($xml)"/> -->
    </xsl:template>

</xsl:stylesheet>
