<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Blockquote (literal, identified) -->
    <xsl:template match="li[not(ul/li)]/blockquote[not(p/a)][preceding-sibling::a and not(preceding-sibling::node()[self::text() and normalize-space(.) != ''])]">
        <xsl:apply-templates select="preceding-sibling::a"/>
        <!-- Class -->
        <xsl:call-template name="class">
            <xsl:with-param name="application">
                <xsl:text>_Text</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
        <!-- Content -->
        <map key="_content">
            <xsl:apply-templates select="p"/>
        </map>
    </xsl:template>

    <!-- Blockquote (literal, named) -->
    <xsl:template match="li[not(ul/li)]/blockquote[not(p/a)][preceding-sibling::node()[self::text() and normalize-space(.) != ''] and not(preceding-sibling::a)]">
        <xsl:variable name="name" select="preceding-sibling::node()[self::text() and normalize-space(.) != '']"/>
        <!-- Name -->
        <string key="@id">
            <xsl:text>_:</xsl:text>
            <xsl:value-of select="encode-for-uri($name)"/>
        </string>
        <!-- Label -->
        <string key="_label">
            <xsl:value-of select="$name"/>
        </string>
        <!-- Class -->
        <xsl:call-template name="class">
            <xsl:with-param name="application">
                <xsl:text>_Text</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
        <!-- Content -->
        <map key="_content">
            <xsl:apply-templates select="p"/>
        </map>
    </xsl:template>

    <!-- Blockquote (literal, unidentified) -->
    <xsl:template match="li[not(ul/li)]/blockquote[not(p/a)][not(preceding-sibling::a or preceding-sibling::node()[self::text() and normalize-space(.) != ''])]">
        <xsl:apply-templates select="p"/>
    </xsl:template>

    <!-- Blockquote (reified) -->
    <xsl:template match="li[ul/li]/blockquote|li/blockquote[p/a]">
        <xsl:call-template name="class">
            <xsl:with-param name="application">
                <xsl:text>_Text</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
        <map key="_content">
            <xsl:apply-templates select="p"/>
        </map>
        <xsl:if test="p/a">
            <array key="_seeAlso">
                <xsl:apply-templates select="p/a" mode="reference"/>
            </array>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
