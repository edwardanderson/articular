<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Blockquote -->
    <xsl:template match="blockquote">
        <!-- Content -->
        <xsl:choose>
            <!-- Blank node -->
            <xsl:when test="p/(a|img) or ../ul/li">
                <!-- Class -->
                <xsl:if test="(../../../text()[1] != 'a') or not(../li)">
                    <string key="@type">_Text</string>
                </xsl:if>
                <!-- Value -->
                <array key="_content">
                    <xsl:choose>
                        <xsl:when test="p/(a|img|strong|em)">
                            <!-- Rich -->
                            <map>
                                <xsl:apply-templates select="p"/>
                            </map>
                            <!-- Plain -->
                            <map>
                                <!-- Temporary fix for assigning language.-->
                                <xsl:choose>
                                    <xsl:when test="p/code[not(following-sibling::*)]">
                                        <string key="@language">
                                            <xsl:value-of select="p/code[not(following-sibling::*)]"/>
                                        </string>
                                    </xsl:when>
                                    <xsl:when test="$language">
                                        <string key="@language">
                                            <xsl:value-of select="$language"/>
                                        </string>
                                    </xsl:when>
                                </xsl:choose>
                                <xsl:apply-templates select="p" mode="html-to-plain"/>
                            </map>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Plain -->
                            <map>
                                <xsl:apply-templates select="p"/>
                            </map>
                        </xsl:otherwise>
                    </xsl:choose>
                </array>
                <!-- See also -->
                <xsl:if test="p/(a|img)">
                    <array key="_seeAlso">
                        <xsl:apply-templates select="p/a" mode="reference"/>
                        <xsl:apply-templates select="p/img" mode="reference"/>
                    </array>
                </xsl:if>
            </xsl:when>
            <!-- Literal -->
            <xsl:otherwise>
                <xsl:apply-templates select="p"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- See also -->
    <xsl:template match="p/(a|img)" mode="reference">
        <map>
            <xsl:apply-templates select="."/>
        </map>
    </xsl:template>

</xsl:stylesheet>
