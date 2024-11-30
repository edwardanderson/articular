<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- == Graph == -->

    <xsl:template match="dl">
        <xsl:apply-templates select="dt"/>
    </xsl:template>

    <!-- Same as -->
    <xsl:template match="dt">
        <xsl:variable name="label" select="text()"/>
        <xsl:variable name="term" select="generate-id(.)"/>
        <!-- Match subject or object resource -->
        <xsl:if test="text() = /document//ul/li/text() or text() = /document//ul/li/ul/li/ul/li/text()">
            <map>
                <string key="@id">
                    <xsl:value-of select="following-sibling::dd[1]/a/@href"/>
                </string>
                <xsl:if test="count(following-sibling::dd[generate-id(preceding-sibling::dt[1]) = $term]) gt 1">
                    <array key="_sameAs">
                        <xsl:for-each select="following-sibling::dd[generate-id(preceding-sibling::dt[1]) = $term]">
                            <xsl:if test="position() gt 1">
                                <map>
                                    <string key="@id">
                                        <xsl:value-of select="a/@href"/>
                                    </string>
                                    <string key="_label">
                                        <xsl:value-of select="$label"/>
                                    </string>
                                </map>    
                            </xsl:if>
                        </xsl:for-each>
                    </array>
                </xsl:if>
            </map>
        </xsl:if>
    </xsl:template>

    <!-- == Context == -->

    <xsl:template match="dl" mode="context">
        <xsl:apply-templates select="dt" mode="context"/>
    </xsl:template>

    <!-- Term definition -->
    <xsl:template match="dt" mode="context">
        <xsl:choose>
            <!-- Predicate -->
            <xsl:when test="text() = /document//ul/li/ul/li[ul/li]/text()">
                <map key="{encode-for-uri(text())}">
                    <string key="@id">
                        <xsl:value-of select="following-sibling::dd[1]/a/@href"/>
                    </string>
                    <string key="@container">
                        <xsl:text>@set</xsl:text>
                    </string>
                </map>
            </xsl:when>
            <!-- Class -->
            <xsl:when test="text() = /document//ul/li/a/@title">
                <map key="{encode-for-uri(text())}">
                    <string key="@id">
                        <xsl:value-of select="following-sibling::dd[1]/a/@href"/>
                    </string>
                    <string key="@container">
                        <xsl:text>@set</xsl:text>
                    </string>
                </map>
            </xsl:when>
            <!-- Datatype -->
            <xsl:when test="text() = /document//ul/li/ul/li/ul/li/blockquote/p/code">
                <map key="{text()}">
                    <string key="@id">
                        <xsl:value-of select="following-sibling::dd[1]/a/@href"/>
                    </string>
                    <string key="@type">
                        <xsl:text>@id</xsl:text>
                    </string>
                </map>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
