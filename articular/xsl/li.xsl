<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Subject -->
    <xsl:template match="li" mode="subject">
        <xsl:apply-templates select="."/>
        <!-- Predicate -->
        <xsl:apply-templates select="ul/li" mode="predicate"/>
    </xsl:template>

    <!-- Predicate (identified) -->
    <xsl:template match="li[a]" mode="predicate">
        <array key="{a/text()}">
            <xsl:for-each select="ul/li">
                <map>
                    <xsl:apply-templates select="." mode="subject"/>
                </map>
            </xsl:for-each>
        </array>
    </xsl:template>

    <!-- Predicate (except class) -->
    <xsl:template match="li[not(text()[normalize-space()][1] = 'a&#xa;')][not(a)]" mode="predicate">
        <xsl:variable name="key" select="replace(normalize-space(text()[1]), ' ', '_')"/>

        <array key="{encode-for-uri($key)}">
            <xsl:for-each select="ul/li">
                <map>
                    <xsl:apply-templates select="." mode="subject"/>
                </map>
            </xsl:for-each>
        </array>
    </xsl:template>

    <!-- Predicate (class, single) -->
    <!-- <xsl:template match="li[text()[1] = 'a'][not(a)][count(ul/li) eq 1]" mode="predicate">
        <map key="@type">
            <string key="@id">
                <xsl:value-of select="ul/li/text()"/>
            </string>
        </map>
    </xsl:template> -->

    <!-- Predicate (class, multiple) -->
    <xsl:template match="li[text()[normalize-space()][1] = 'a&#xa;'][not(a)]" mode="predicate">
        <array key="@type">
            <xsl:for-each select="ul/li">
                <string>
                    <xsl:value-of select="text()"/>
                </string>
            </xsl:for-each>
        </array>
    </xsl:template>

    <!-- Blank node -->
    <xsl:template match="li[not(a|img|blockquote|table)]">
        <!-- Identifier -->
        <xsl:apply-templates select="." mode="identifier"/>
        <!-- Label -->
        <xsl:apply-templates select="." mode="label"/>
    </xsl:template>

    <!-- Hyperlink -->
    <xsl:template match="li[a][not(img|blockquote|table)]">
        <xsl:apply-templates select="a"/>
    </xsl:template>

    <!-- Image -->
    <xsl:template match="li[img][not(a|blockquote|table)]">
        <xsl:apply-templates select="img"/>
    </xsl:template>

    <!-- Blockquote -->
    <xsl:template match="li[blockquote][not(a|img|table)]">
        <xsl:apply-templates select="blockquote"/>
    </xsl:template>

    <!-- Table -->
    <xsl:template match="li[table][not(a|blockquote|img)]">
        <xsl:apply-templates select="table"/>
    </xsl:template>

</xsl:stylesheet>
