<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Plain text (without language or datatype) -->
    <xsl:template match="p[not(strong|em|del)][not(code)]">
        <xsl:choose>
            <xsl:when test="$autotype">
                <xsl:choose>
                    <!-- Date: YYYY-MM-DD -->
                    <xsl:when test="matches(text(), '^\d{4}-[01]\d-[0-3]\d$')">
                        <string key="@type">xsd:date</string>
                        <string key="@value">
                            <xsl:apply-templates select="text()"/>
                        </string>
                    </xsl:when>
                    <!-- Integer -->
                    <xsl:when test="matches(text(), '^\d+$')">
                        <string key="@type">xsd:integer</string>
                        <string key="@value">
                            <xsl:apply-templates select="text()"/>
                        </string>
                    </xsl:when>
                    <!-- Decimal -->
                    <xsl:when test="matches(text(), '^[0-9]+\.[0-9]+$')">
                        <string key="@type">xsd:decimal</string>
                        <number key="@value">
                            <xsl:apply-templates select="text()"/>
                        </number>
                    </xsl:when>
                    <!-- Boolean: true -->
                    <xsl:when test="text() = $boolean-true">
                        <boolean key="@value">true</boolean>
                    </xsl:when>
                    <!-- Boolean: false -->
                    <xsl:when test="text() = $boolean-false">
                         <boolean key="@value">false</boolean>
                    </xsl:when>
                    <!-- Undetected -->
                    <xsl:otherwise>
                        <string key="@value">
                            <xsl:apply-templates select="text()"/>
                        </string>
                        <xsl:if test="$language">
                            <string key="@language">
                                <xsl:value-of select="$language"/>
                            </string>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <string key="@value">
                    <xsl:apply-templates select="text()"/>
                </string>
                <xsl:if test="$language">
                    <string key="@language">
                        <xsl:value-of select="$language"/>
                    </string>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Plain text (with language or datatype) -->
    <xsl:template match="p[not(strong|em|del)][code]">
        <xsl:choose>
            <!-- Datatype -->
            <xsl:when test="code=('integer', 'boolean')">
                <string key="@type">
                    <xsl:value-of select="concat('xsd:', code)"/>
                </string>
                <string key="@value">
                    <xsl:apply-templates select="text()"/>
                </string>
            </xsl:when>
            <xsl:when test="code = 'date'">
                <xsl:choose>
                    <!-- gYear -->
                    <xsl:when test="matches(text(), '^-?\d+\s*$')">
                        <string key="@type">
                            <xsl:value-of select="'xsd:gYear'"/>
                        </string>
                        <string key="@value">
                            <xsl:apply-templates select="text()"/>
                        </string>
                    </xsl:when>
                    <!-- gMonth -->
                    <xsl:when test="matches(text(), '^-?\d+-[01][0-9]{1}\s*$')">
                        <string key="@type">
                            <xsl:value-of select="'xsd:gMonth'"/>
                        </string>
                        <string key="@value">
                            <xsl:apply-templates select="text()"/>
                        </string>
                    </xsl:when>
                    <!-- Date -->
                    <xsl:when test="matches(text(), '^-?\d+-[01]{1}[0-9]{1}-[0123]{1}[0-9]{1}\s*$')">
                        <string key="@type">
                            <xsl:value-of select="'xsd:date'"/>
                        </string>
                        <string key="@value">
                            <xsl:apply-templates select="text()"/>
                        </string>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- BCP 47 language -->
            <xsl:when test="matches(code, '^[a-z]{2}(-[A-Z]{2})?$')">
                <string key="@language">
                    <xsl:value-of select="code"/>
                </string>
                <string key="@value">
                    <xsl:apply-templates select="text()"/>
                </string>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- HTML (without language or datatype) -->
    <xsl:template match="p[strong|em|del][not(code)]">
        <xsl:choose>
            <!-- Default language -->
            <xsl:when test="$language">
                <string key="@value">
                    <xsl:text>&lt;p lang="</xsl:text>
                    <xsl:value-of select="$language"/>
                    <xsl:text>"&gt;</xsl:text>
                    <xsl:value-of select="serialize(node())"/>
                    <xsl:text>&lt;/p&gt;</xsl:text>
                </string>
            </xsl:when>
            <xsl:otherwise>
                <string key="@value">
                    <xsl:value-of select="serialize(.)"/>
                </string>
            </xsl:otherwise>
        </xsl:choose>
        <string key="@type">
            <xsl:text>rdf:HTML</xsl:text>
        </string>
    </xsl:template>

    <!-- HTML (with language) -->
    <xsl:template match="p[strong|em|del][code]">
        <xsl:variable name="text" select="node()[not(self::code[not(following-sibling::*)])]"/>
        <xsl:variable name="content" select="normalize-space(serialize($text))"/>
        <!-- Content -->
        <xsl:choose>
            <!-- BCP 47 language -->
            <xsl:when test="matches(code, '^[a-z]{2}(-[A-Z]{2})?$')">
                <string key="@value">
                    <xsl:text>&lt;p lang="</xsl:text>
                    <xsl:value-of select="code"/>
                    <xsl:text>"&gt;</xsl:text>
                    <xsl:value-of select="$content"/>
                    <xsl:text>&lt;/p&gt;</xsl:text>
                </string>
            </xsl:when>
            <!-- Unrecognised language -->
            <xsl:otherwise>
                <string key="@value">
                    <xsl:text>&lt;p&gt;</xsl:text>
                    <xsl:value-of select="$content"/>
                    <xsl:text>&lt;/p&gt;</xsl:text>
                </string>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Datatype -->
        <string key="@type">
            <xsl:text>rdf:HTML</xsl:text>
        </string>
    </xsl:template>

</xsl:stylesheet>
