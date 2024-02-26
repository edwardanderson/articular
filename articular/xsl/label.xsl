<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">
   
    <!-- Label (defined) -->
    <xsl:template match="li[not(code or (strong|em|del))][node() = /document/dl/dt]" mode="label">
        <xsl:variable name="value" select="text()"/>
        <string key="_label">
            <xsl:variable name="a" select="/document/dl/dt[node() = $value]/following-sibling::dd[1]/a"/>
            <xsl:choose>
                <xsl:when test="$a/@href != a/text()">
                    <xsl:apply-templates select="/document/dl/dt[node() = $value]/following-sibling::dd[1]/a/text()" mode="label"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="text()" mode="label"/>
                </xsl:otherwise>
            </xsl:choose>
        </string>
    </xsl:template>

    <!-- Label (without language) -->
    <xsl:template match="(li[not(node() = /document/dl/dt)]|a|img)[not(code or (strong|em|del))]" mode="label">
        <xsl:if test="(@alt|text()) != ''">
            <xsl:choose>
                <!-- Parent paragraph language -->
                <xsl:when test="../code">
                    <map key="_label">
                        <string key="@language">
                            <xsl:value-of select="../code"/>
                        </string>
                        <string key="@value">
                            <xsl:apply-templates select="@alt|text()"/>
                        </string>
                    </map>
                </xsl:when>
                <!-- Default language -->
                <xsl:when test="$language">
                    <map key="_label">
                        <string key="@language">
                            <xsl:value-of select="$language"/>
                        </string>
                        <string key="@value">
                            <xsl:apply-templates select="@alt|text()"/>
                        </string>
                    </map>
                </xsl:when>
                <xsl:otherwise>
                    <string key="_label">
                        <xsl:apply-templates select="@alt|text()"/>
                    </string>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- Label (with language) -->
    <xsl:template match="(li|a)[code[last()]]" mode="label">
        <map key="_label">
            <string key="@language">
                <xsl:value-of select="code"/>
            </string>
            <string key="@value">
                <xsl:apply-templates select="text()"/>
            </string>
        </map>
    </xsl:template>

    <!-- Label (styled, without language) -->
    <xsl:template match="(li|a|img)[(strong|em|del) and not(code)]" mode="label">
        <map key="_label">
            <string key="@value">
                <xsl:value-of select="serialize(node()[not(*)])"/>
            </string>
            <string key="@type">
                <xsl:value-of>rdf:HTML</xsl:value-of>
            </string>
        </map>
    </xsl:template>

    <!-- Label (styled, with language) -->
    <xsl:template match="(li|a|img)[(strong|em|del) and code]" mode="label">
        <map key="_label">
            <string key="@value">
                <xsl:text>&lt;p lang="</xsl:text>
                <xsl:value-of select="code"/>
                <xsl:text>"&gt;</xsl:text>
                <xsl:value-of select="serialize(node()[not(*)])"/>
                <xsl:text>&lt;/p&gt;</xsl:text>
            </string>
            <string key="@type">
                <xsl:value-of>rdf:HTML</xsl:value-of>
            </string>
        </map>
    </xsl:template>

    <xsl:template match="*" mode="plain-text">
        <xsl:variable name="text" select="normalize-space(text()[1])[1]"/>
        <xsl:if test="normalize-space($text) != ' '">
            <xsl:value-of select="$text"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
