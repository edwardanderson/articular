<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:re="http://exslt.org/regular-expressions"
    exclude-result-prefixes="re">

<!--
    XSLT 1.0 `serialize()` implementation.
    <https://lenzconsulting.com/xml-to-string/xml-to-string.xsl>
 -->
<xsl:import href="xml-to-string.xsl"/>

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<!-- Document. -->
<xsl:template match="/">
    <document>
        <!-- Context. -->
        <context>
            <!-- Select only predicates. -->
            <xsl:apply-templates select="//ul/li[count(ancestor::ul) mod 2 = 1][ul]" mode="context"/>
        </context>
        <xsl:apply-templates select="section/h1"/>
        <xsl:apply-templates select="section[@class = 'level1']"/>
    </document>
</xsl:template>

<!-- Context. -->
<xsl:template match="li" mode="context">
    <xsl:variable name="key">
        <xsl:apply-templates select="text() | a/text()" mode="snake-case"/>
    </xsl:variable>
    <xsl:if test="$key != ''">
        <xsl:element name="{$key}">
            <xsl:choose>
                <xsl:when test="a">
                    <!-- Location. -->
                    <xsl:choose>
                        <xsl:when test="a/@href and not(a/@title = 'reverse')">
                            <id>
                                <xsl:value-of select="a/@href"/>
                            </id>
                        </xsl:when>
                        <xsl:when test="not(a/@href)">
                            <id>
                                <xsl:text>user:</xsl:text>
                                <xsl:apply-templates select="a/text()"/>
                            </id>
                        </xsl:when>
                    </xsl:choose>
                    <!-- Type. -->
                    <xsl:choose>
                        <xsl:when test="a/@title = 'reverse'">
                            <_reverse>
                                <xsl:value-of select="a/@href"/>
                            </_reverse>
                        </xsl:when>
                        <xsl:when test="a/@title != '' and a/@title != 'reverse'">
                            <type>
                                <xsl:value-of select="a/@title"/>
                            </type>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>user:</xsl:text>
                    <xsl:apply-templates select="text()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:if>
</xsl:template>

<!-- Section. -->
<xsl:template match="section">
    <xsl:apply-templates select="section/*[re:match(name(), 'h[2-7]')]"/>
    <xsl:apply-templates select="p"/>
    <xsl:apply-templates select="blockquote"/>
    <xsl:apply-templates select="figure"/>
    <xsl:apply-templates select="table"/>
    <xsl:apply-templates select="ul"/>
</xsl:template>

<!-- Heading. -->
<xsl:template match="h1">
    <_label>
        <xsl:apply-templates select="text() | a/text()" mode="markdown"/>
    </_label>
    <xsl:apply-templates select="a" mode="heading"/>
</xsl:template>

<!-- Hyperlink (heading). -->
<xsl:template match="a" mode="heading">
    <xsl:if test="@title">
        <type>
            <xsl:value-of select="@title"/>
        </type>
    </xsl:if>
    <xsl:if test="@href != ''">
        <_same_as>
            <xsl:apply-templates select="."/>
        </_same_as>
    </xsl:if>
</xsl:template>

<!-- Subheading. -->
<xsl:template match="section/*[re:match(name(), 'h[2-7]')]">
    <_see_also>
        <id>
            <xsl:text>#</xsl:text>
            <xsl:value-of select="../@id"/>
        </id>
        <_label>
            <xsl:value-of select="text() | a/text()"/>
        </_label>
        <xsl:if test="a">
            <xsl:if test="a/@title">
                <type>
                    <xsl:value-of select="a/@title"/>
                </type>
            </xsl:if>
            <xsl:if test="a/@href != ''">
                <_same_as>
                    <xsl:apply-templates select="a"/>
                </_same_as>
            </xsl:if>
        </xsl:if>
        <xsl:apply-templates select="parent::section"/>
    </_see_also>
</xsl:template>

<!-- Blockquote. -->
<xsl:template match="blockquote">
    <_comment>
        <type>_Quotation</type>
        <xsl:apply-templates select="p" mode="content"/>
        <!-- Attribution. -->
        <xsl:apply-templates select="p[last()]/following-sibling::ul"/>
    </_comment>
</xsl:template>

<!-- Paragraph. -->
<xsl:template match="p">
    <_comment>
        <type>_Comment</type>
        <xsl:apply-templates select="." mode="content"/>
        <!-- Mentions. -->
        <xsl:apply-templates select="a" mode="mentions"/>
    </_comment>
</xsl:template>

<!-- Paragraph content. -->
<xsl:template match="p" mode="content">
    <xsl:choose>
        <!-- Styled. -->
        <xsl:when test="*">
            <_content>
                <xsl:apply-templates select="." mode="xml-to-string"/>
            </_content>
            <_format>text/html</_format>
        </xsl:when>
        <!-- Plain text. -->
        <xsl:otherwise>
            <_content>
                <xsl:value-of select="text()"/>
            </_content>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Mentions. -->
<xsl:template match="a" mode="mentions">
    <_mentions>
        <xsl:apply-templates select="."/>
    </_mentions>
</xsl:template>

<!-- Image. -->
<xsl:template match="figure[img]">
    <_image>
        <id>
            <xsl:value-of select="img/@src"/>
        </id>
        <type>_Image</type>
        <xsl:if test="figcaption">
            <_label>
                <xsl:value-of select="figcaption"/>
            </_label>
        </xsl:if>
    </_image>
</xsl:template>

<!-- Table. -->
<xsl:template match="table">
    <_see_also>
        <type>_Table</type>
        <!-- Data. -->
        <_value>
            <!-- Heading. -->
            <xsl:for-each select="thead/tr/th">
                <xsl:if test="position() > 1">,</xsl:if>
                <xsl:value-of select="."/>
            </xsl:for-each>
            <!-- Newline. -->
            <xsl:text>\\n</xsl:text>
            <!-- Rows. -->
            <xsl:for-each select="tbody/tr">
                <xsl:for-each select="td">
                    <!-- Delimiter. -->
                    <xsl:if test="position() > 1">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                    <!-- Value. -->
                    <xsl:value-of select="."/>
                </xsl:for-each>
                <!-- Newline. -->
                <xsl:text>\\n</xsl:text>
            </xsl:for-each>
        </_value>
        <_format>text/csv</_format>
    </_see_also>
</xsl:template>

<!-- Predicate. -->
<xsl:template match="li[count(ancestor::ul) mod 2 = 1][ul]">
    <xsl:variable name="predicate">
        <xsl:apply-templates select="a/text() | text()" mode="snake-case"/>
    </xsl:variable>
    <xsl:for-each select="ul/li">
        <xsl:element name="{$predicate}">
            <xsl:apply-templates select="." mode="object"/>
        </xsl:element>
    </xsl:for-each>
</xsl:template>

<!-- Object. -->
<xsl:template match="li[count(ancestor::ul) mod 2 = 0]" mode="object">
    <xsl:choose>
        <xsl:when test="a">
            <xsl:apply-templates select="a"/>
        </xsl:when>
        <xsl:when test="code">
            <xsl:apply-templates select="code"/>
        </xsl:when>
        <xsl:when test="img">
            <id>
                <xsl:value-of select="img/@src"/>
            </id>
            <xsl:if test="img/@alt">
                <_label>
                    <xsl:value-of select="img/@alt"/>
                </_label>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="substring(img/@title, 5)">
                    <type>
                        <xsl:value-of select="substring(img/@title, 5)"/>
                    </type>
                </xsl:when>
                <xsl:otherwise>
                    <type>_Image</type>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <!-- String literal. -->
        <xsl:when test="substring(text(), 1, 1) = '&#8220;'">
            <xsl:value-of select="substring(text(), 2, string-length(text()) - 2)"/>
        </xsl:when>
        <!-- Labelled blank node. -->
        <xsl:otherwise>
            <_label>
                <xsl:apply-templates select="text()"/>
            </_label>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="ul/li"/>
</xsl:template>

<!-- Type. -->
<xsl:template match="li/code">
    <type>
        <xsl:value-of select="text()"/>
    </type>
</xsl:template>

<!-- Hyperlink location. -->
<xsl:template match="a">
    <!-- Location. -->
    <xsl:if test="@href != ''">
        <id>
            <!-- Patch out .md suffix. -->
            <xsl:value-of select="re:replace(@href, '(\.md$)|(\.md)(?=#[\w-]+$){1,}', 'g', '')"/>
        </id>
    </xsl:if>
    <!-- Type. -->
    <xsl:if test="@title">
        <type>
            <xsl:value-of select="@title"/>
        </type>
    </xsl:if>
    <!-- Label. -->
    <xsl:if test="text()">
        <_label>
            <xsl:apply-templates select="text()" mode="markdown"/>
        </_label>
    </xsl:if>
</xsl:template>

<!-- Strip whitespace. -->
<xsl:template match="text()">
    <xsl:value-of select="normalize-space()"/>
</xsl:template>

<!-- Plain text. -->
<xsl:template match="text()" mode="markdown">
    <xsl:apply-templates select="../*"/>
    <xsl:value-of select="normalize-space()"/>
</xsl:template>

<!-- Rich text HTML to Markdown -->
<!-- Bold. -->
<xsl:template match="strong">
    <xsl:text>**</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>**</xsl:text>
  </xsl:template>
<!-- Italics -->
<xsl:template match="em">
    <xsl:text>_</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>_</xsl:text>
</xsl:template>

<!-- Snake case. -->
<xsl:template match="text()" mode="snake-case">
    <xsl:value-of select="translate(normalize-space(), ' ', '_')"/>
</xsl:template>

</xsl:stylesheet>
