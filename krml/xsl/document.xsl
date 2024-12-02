<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <xsl:output method="text" encoding="utf-8"/>
    <xsl:mode on-multiple-match="fail" on-no-match="deep-skip"/>
    <xsl:strip-space elements="*"/>

    <!-- === Parameters === -->

    <!-- Application -->
    <xsl:param name="embed-context" select="true()"/>
    <xsl:param name="krml-context-uri">http://example.com/krml.json</xsl:param>
    <xsl:param name="metadata" select="false()"/>
    <!-- Document -->
    <xsl:param name="base">http://example.org/</xsl:param>
    <xsl:param name="id"/>
    <xsl:param name="language"/>
    <xsl:param name="title"/>
    <xsl:param name="vocab">http://example.org/terms/</xsl:param>

    <!-- Child templates -->
    <xsl:import href="a.xsl"/>
    <xsl:import href="blockquote.xsl"/>
    <xsl:import href="context.xsl"/>
    <xsl:import href="dl.xsl"/>
    <xsl:import href="img.xsl"/>
    <xsl:import href="li.xsl"/>
    <xsl:import href="p.xsl"/>
    <xsl:import href="pre.xsl"/>
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
                <!-- Named graph -->
                <xsl:if test="$id">
                    <string key="@id">
                        <xsl:value-of select="$id"/>
                    </string>
                </xsl:if>
                <!-- Content -->
                <array key="@graph">
                    <!-- Metadata -->
                    <xsl:if test="$metadata">
                        <xsl:if test="$id | $title">
                            <map>
                                <xsl:if test="$id">
                                    <string key="@id">
                                        <xsl:value-of select="$id"/>
                                    </string>
                                </xsl:if>
                                <string key="@type">
                                    <xsl:text>_Dataset</xsl:text>
                                </string>
                                <xsl:if test="$title">
                                    <string key="_label">
                                        <xsl:value-of select="$title"/>
                                    </string>
                                </xsl:if>
                            </map>
                        </xsl:if>
                    </xsl:if>
                    <!-- Data -->
                    <xsl:apply-templates select="ul"/>
                    <!-- Predicate annotations -->
                    <xsl:apply-templates select="ul/li/ul/li[a][(ol|ul)/li]" mode="predicate-annotation"/>
                    <!-- Class annotations-->
                    <xsl:apply-templates select="//li[text() = 'a']/ul/li[a]" mode="class-annotation"/>
                    <!-- Definitions -->
                    <xsl:apply-templates select="dl"/>
                </array>
            </map>
        </xsl:variable>
        <xsl:value-of select="xml-to-json($xml)"/>
        <!-- <xsl:value-of select="serialize($xml)"></xsl:value-of> -->
    </xsl:template>

</xsl:stylesheet>
