<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Blank -->
    <xsl:template match="li[not(a|img|blockquote)]" mode="identifier">
        <string key="@id">
            <xsl:text>_:</xsl:text>
            <xsl:apply-templates select="node()[not(self::code)]" mode="plain-text"/>
        </string>
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
