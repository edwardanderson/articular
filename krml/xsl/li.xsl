<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Subject -->
    <xsl:template match="li[not(ul/li[text() = ('â')])]" mode="subject">
        <xsl:apply-templates select="."/>
        <!-- Class -->
        <xsl:call-template name="class"/>
        <!-- Predicate -->
        <xsl:apply-templates select="(ul|ol)/li[not(text() eq 'a')]" mode="predicate"/>
    </xsl:template>

    <!-- == Subect/Object Resource == -->

    <!-- Blockquote -->
    <xsl:template match="li[blockquote]">
        <xsl:apply-templates select="blockquote"/>
    </xsl:template>

    <!-- Defined term -->
    <xsl:template match="li
        [
            text() = /document/dl/dt/text()
        ]
        [
            not(starts-with(text(), '&quot;'))
        ]
        [
            not(blockquote)
        ]">
        <xsl:variable name="value" select="text()"/>
        <string key="@id">
            <xsl:value-of select="/document/dl/dt[node() = $value]/following-sibling::dd[1]/a/@href"/>
        </string>
        <xsl:call-template name="label"/>
    </xsl:template>

    <!-- Hyperlink -->
    <xsl:template match="li[a][not(blockquote)]">
        <xsl:apply-templates select="a"/>
    </xsl:template>

    <!-- Image -->
    <xsl:template match="li[img]">
        <xsl:apply-templates select="img"/>
    </xsl:template>

    <!-- Preformatted text -->
    <xsl:template match="li[pre]">
        <xsl:apply-templates select="pre"/>
    </xsl:template>

    <!-- Table -->
    <xsl:template match="li[table]">
        <xsl:apply-templates select="table"/>
    </xsl:template>

    <!-- Undefined (blank node instance) -->
    <xsl:template match="li
        [
            not(starts-with(text(), '&quot;'))
        ]
        [
            not(a|blockquote|img|pre|table)
        ]
        [
            not(text() = /document/dl/dt/text())
        ]">
        <!-- Identifier -->
        <xsl:if test="count(//li[text() = current()/text()]) gt 1">
            <string key="@id">
                <xsl:text>_:</xsl:text>
                <xsl:value-of select="encode-for-uri(text())"/>
            </string>
        </xsl:if>
        <!-- Label -->
        <xsl:call-template name="label"/>
    </xsl:template>

    <!-- Undefined (blank node singleton) -->
    <xsl:template match="li
        [
            starts-with(text(), '&quot;')
        ]">
        <!-- Label -->
        <xsl:call-template name="label">
            <xsl:with-param name="text" select="substring-before(substring-after(., '&quot;'), '&quot;')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="label">
        <xsl:param name="text" select="text()"/>
        <xsl:if test="$text">
            <xsl:choose>
                <xsl:when test="code">
                    <map key="_label">
                        <string key="@language">
                            <xsl:value-of select="code"/>
                        </string>
                        <string key="@value">
                            <xsl:value-of select="$text"/>
                        </string>
                    </map>
                </xsl:when>
                <xsl:otherwise>
                    <string key="_label">
                        <xsl:value-of select="$text"/>
                    </string>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- == Predicate == -->

    <!-- Identified, ordered -->
    <xsl:template match="li
        [
            a
        ]
        [
            not(text() eq 'a')
        ]
        [
            ol
        ]"
        mode="predicate">
        <map key="{a/@href}">
            <array key="@list">
                <xsl:for-each select="ol/li">
                    <map>
                        <xsl:apply-templates select="." mode="subject"/>
                    </map>
                </xsl:for-each>
            </array>
        </map>
    </xsl:template>

    <!-- Identified, unordered -->
    <xsl:template match="li
        [
            a
        ]
        [
            not(text() eq 'a')
        ]
        [
            ul
        ]"
        mode="predicate">
        <array key="{a/@href}">
            <xsl:for-each select="ul/li">
                <map>
                    <xsl:apply-templates select="." mode="subject"/>
                </map>
            </xsl:for-each>
        </array>
    </xsl:template>

    <!-- Unidentified, ordered -->
    <xsl:template match="li
        [
            not(text() eq 'a')
        ]
        [
            ol
        ]"
        mode="predicate">
        <xsl:variable name="key" select="encode-for-uri(text())"/>
        <map key="{$key}">
            <array key="@list">
                <xsl:for-each select="ol/li">
                    <map>
                        <xsl:apply-templates select="." mode="subject"/>
                    </map>
                </xsl:for-each>
            </array>
        </map>
    </xsl:template>

    <!-- Unidentified, unordered -->
    <xsl:template match="li
        [
            not(text() eq 'a')
        ]
        [
            not(a)
        ]
        [
            ul
        ]"
        mode="predicate">
        <xsl:variable name="key" select="encode-for-uri(text())"/>
        <array key="{$key}">
            <xsl:for-each select="ul/li">
                <map>
                    <xsl:apply-templates select="." mode="subject"/>
                </map>
            </xsl:for-each>
        </array>
    </xsl:template>

    <!-- Class predicate -->
    <!-- <xsl:template match="li[text() eq 'a']" mode="predicate">
        <xsl:for-each select="ul/li">
            <map>
                <xsl:apply-templates select="."/>
            </map>
        </xsl:for-each>
    </xsl:template> -->

    <!-- Predicate annotation -->
    <xsl:template match="ul/li/ul/li
        [
            a
        ]
        [
            (ol|ul)/li
        ]"
        mode="predicate-annotation">
        <map>
            <string key="@id">
                <xsl:value-of select="a/@href"/>
            </string>
            <xsl:call-template name="class"/>
            <xsl:call-template name="label">
                <xsl:with-param name="text" select="a"/>
            </xsl:call-template>
        </map>
    </xsl:template>
 
    <!-- Class label annotation -->
    <xsl:template match="li
        [
            text() = 'a'
        ]
        /ul/li/a[
            @href and text() ne ''
        ]"
        mode="class-annotation">
        <map>
            <string key="@id">
                <xsl:value-of select="@href"/>
            </string>
            <xsl:call-template name="label"/>
        </map>
    </xsl:template>

</xsl:stylesheet>
