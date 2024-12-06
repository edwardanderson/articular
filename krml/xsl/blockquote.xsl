<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Blockquote (literal) -->
    <xsl:template match="li[not(ul/li)]/blockquote[not(p/a)]">
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
