<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Literal (text/plain, without language) -->
    <xsl:template match="p[not(code[not(following-sibling::*)])][not(a|del|em|strong)]">
        <!-- Make default language explicit -->
        <xsl:if test="$language">
            <string key="@language">
                <xsl:value-of select="$language"/>
            </string>
        </xsl:if>
        <!-- Cast content to number or string -->
        <xsl:choose>
            <xsl:when test="number(text())">
                <number key="@value">
                    <xsl:value-of select="text()"/>
                </number>
            </xsl:when>
            
            <xsl:otherwise>
                <string key="@value">
                    <xsl:value-of select="text()"/>
                </string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Literal (text/plain, with language or datatype) -->
    <xsl:template match="p[code[not(following-sibling::*)]][not(node() = /document/dl/dt)][not(a|del|em|strong)]">
        <xsl:variable name="type" select="code[not(following-sibling::*)]"/>
        <xsl:choose>
            <!-- Determine if code is BCP47 language tag -->
            <xsl:when test="matches($type, '^[a-z]{2,3}(?:-[a-zA-Z]{4})?(?:-[A-Z]{2,3})?$')">
                <string key="@language">
                    <xsl:value-of select="$type"/>
                </string>
            </xsl:when>
            <xsl:otherwise>
                <string key="@type">
                    <xsl:value-of select="$type"/>
                </string>
            </xsl:otherwise>
        </xsl:choose>
        <string key="@value">
            <xsl:value-of select="normalize-space(text())"/>
        </string>
    </xsl:template>

    <!-- Literal (text/plain, defined datatype) -->
    <xsl:template match="p[code[not(following-sibling::*)]][node() = /document/dl/dt]">
        <xsl:variable name="value" select="code"/>
        <string key="@type">
            <xsl:value-of select="/document/dl/dt[node() = $value]"/>
        </string>
        <string key="@value">
            <xsl:value-of select="normalize-space(text())"/>
        </string>
    </xsl:template>

    <!-- Literal (text/html, without language) -->
    <xsl:template match="p[a|del|em|strong][not(code[not(following-sibling::*)] or $language)]">
        <string key="@type">
            <xsl:text>_HTML</xsl:text>
        </string>
        <string key="@value">
            <xsl:text>&lt;p&gt;</xsl:text>
            <xsl:value-of select="serialize(node())"/>
            <xsl:text>&lt;/p&gt;</xsl:text>
        </string>
    </xsl:template>

    <!-- Literal (text/html, with language) -->
    <xsl:template match="p[a|del|em|strong][code[not(following-sibling::*)] or $language]">
        <string key="@type">
            <xsl:text>_HTML</xsl:text>
        </string>
        <string key="@value">
            <xsl:text>&lt;p lang="</xsl:text>
            <xsl:choose>
                <xsl:when test="code[not(following-sibling::*)]">
                    <xsl:value-of select="code[not(following-sibling::*)]"/>
                </xsl:when>
                <xsl:when test="$language">
                    <xsl:value-of select="$language"/>
                </xsl:when>
            </xsl:choose>
            <xsl:text>"&gt;</xsl:text>
            <xsl:value-of select="serialize(node())"/>
            <xsl:text>&lt;/p&gt;</xsl:text>
        </string>
    </xsl:template>

</xsl:stylesheet>
