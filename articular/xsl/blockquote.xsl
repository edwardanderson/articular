<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <xsl:template match="blockquote">
        <!-- Content -->
        <xsl:choose>
            <!-- Blank node -->
            <xsl:when test="p/a or ../ul/li">
                <!-- Class -->
                <xsl:if test="../../../text()[1] != 'a'">
                    <string key="@type">
                        <xsl:value-of select="$class-blockquote"/>
                    </string>
                </xsl:if>
                <!-- Value -->
                <map key="_value">
                    <xsl:apply-templates select="p"/>
                </map>
                <!-- See also -->
                <xsl:if test="p/a">
                    <array key="_seeAlso">
                        <xsl:apply-templates select="p/a" mode="reference"/>
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
    <xsl:template match="a" mode="reference">
        <map>
            <xsl:apply-templates select="."/>
        </map>
    </xsl:template>

</xsl:stylesheet>
