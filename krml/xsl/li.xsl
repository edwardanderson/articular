<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Subject -->
    <xsl:template match="li[not(ul/li[text() = ('â')])]" mode="subject">
        <xsl:apply-templates select="."/>
        <!-- Predicate -->
        <xsl:apply-templates select="(ul|ol)/li" mode="predicate"/>
    </xsl:template>

    <!-- Inverse object of rdf:type -->
    <xsl:template match="li[ul/li[text() = ('â')]][not(a)]" mode="subject">
        <string key="@type">
            <xsl:value-of select="text()"/>
        </string>
    </xsl:template>

    <xsl:template match="li[ul/li[text() = ('â')]][a]" mode="subject">
        <string key="@type">
            <xsl:value-of select="a/@href"/>
        </string>
    </xsl:template>

    <!-- == Subect/Object Resource == -->

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

    <!-- Blockquote -->
    <xsl:template match="li[blockquote]">
        <xsl:apply-templates select="blockquote"/>
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

    <!-- Undefined (blank node instance) -->
    <xsl:template match="li
        [
            not(starts-with(text(), '&quot;'))
        ]
        [
            not(a|blockquote|img|pre)
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
        <!-- <xsl:call-template name="inverse-type"/> -->
        <xsl:apply-templates select="../../../../../li[ul/li[text() = ('â')]]" mode="subject"/>
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

    <!-- Predicate class -->
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
            <xsl:apply-templates select="a/@title"/>
            <xsl:call-template name="label">
                <xsl:with-param name="text" select="a"/>
            </xsl:call-template>
        </map>
    </xsl:template>

    <!-- == Class == -->

    <!-- Class (single, literal) -->
    <xsl:template match="li
        [
            text() = 'a'
        ]
        [
            count(ul/li) eq 1
        ]
        [
            not(ul/li/a)
        ]"
        mode="predicate">
        <string key="@type">
            <xsl:value-of select="ul/li/text()"/>
        </string>
    </xsl:template>

    <!-- Class (multiple, literal) -->
    <xsl:template match="li
        [
            text() = 'a'
        ]
        [
            count(ul/li) gt 1
        ]"
        mode="predicate">
        <array key="@type">
            <xsl:for-each select="ul/li">
                <string>
                    <xsl:value-of select="text()"/>
                </string>
            </xsl:for-each>
        </array>
    </xsl:template>

    <!-- Class (single, reified) -->
    <xsl:template match="li
        [
            text() = 'a'
        ]
        [
            ul/li/ul/li
        ]
        [
            count(ul/li) eq 1
        ]"
        mode="predicate">
        <map key="@type">
            <xsl:for-each select="ul/li">
                <!-- Identifier -->
                <string key="@id">
                    <xsl:value-of select="encode-for-uri(text())"/>
                </string>
                <!-- Predicate -->
                <xsl:apply-templates select="(ul|ol)/li" mode="predicate"/>
            </xsl:for-each>
        </map>
    </xsl:template>

    <!-- Class (multiple, reified) -->
    <xsl:template match="li
        [
            text() = 'a'
        ]
        [
            ul/li/ul/li
        ]
        [
            count(ul/li) gt 1
        ]"
        mode="predicate">
        <array key="@type">
            <xsl:for-each select="ul/li">
                <map>
                    <!-- Identifier -->
                    <string key="@id">
                        <xsl:value-of select="encode-for-uri(text())"/>
                    </string>
                    <!-- Predicate -->
                    <xsl:apply-templates select="(ul|ol)/li" mode="predicate"/>
                </map>
            </xsl:for-each>
        </array>
    </xsl:template>

    <!-- Class (reified, identified) -->
    <xsl:template match="li
        [
            text() = 'a'
        ]
        [
            count(ul/li) eq 1
        ]
        [
            ul/li/a
        ]"
        mode="predicate">
        <string key="@type">
            <xsl:value-of select="ul/li/a/@href"/>
        </string>
    </xsl:template>

    <!-- Class (invese) -->
    <!-- <xsl:template match="li[text() = ('â', '^a')]">

    </xsl:template> -->

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
