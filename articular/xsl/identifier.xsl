<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Blank -->
    <xsl:template match="li[not(a|img|blockquote)][not(node() = /document/dl/dt)]" mode="identifier">
        <xsl:variable name="text" select="text()"/>
        <!-- <xsl:variable name="text" select="normalize-space(text()[1])[1]"/> -->
        <!-- Name blank node if referenced elsewhere. -->
        <xsl:if test="count(//li[text() = $text]) gt 1">
            <string key="@id">
                <xsl:text>_:</xsl:text>
                <!-- Remove special characters. -->
                <xsl:variable name="bnode"
                    select="
                    translate(
                        encode-for-uri(
                            translate($text, ' ', '_')
                        ), '%', '_'
                    )"
                />
                <xsl:value-of select="$bnode"/>
            </string>
        </xsl:if>
    </xsl:template>

    <!-- Defined -->
    <xsl:template match="li[not(a|img|blockquote)][node() = /document/dl/dt]" mode="identifier">
        <xsl:variable name="value" select="text()"/>
        <xsl:apply-templates select="/document/dl/dt[node() = $value]/following-sibling::dd[1]/a/@href" mode="identifier"/>
    </xsl:template>

    <!-- Identified -->
    <xsl:template match="@href|@src" mode="identifier">
        <string key="@id">
            <xsl:choose>
                <!-- Mint -->
                <xsl:when test=". = ''">
                    <xsl:value-of select="encode-for-uri(../normalize-space(@alt|text()))"/>
                </xsl:when>
                <!-- URI -->
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </string>
    </xsl:template>

</xsl:stylesheet>
