<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Hyperlink -->
    <xsl:template match="a">
        <!-- Identifier -->
        <string key="@id">
            <xsl:value-of select="@href"/>
        </string>
        <!-- Label -->
        <xsl:apply-templates select="." mode="label"/>
    </xsl:template>

    <xsl:template match="a" mode="label">
        <xsl:choose>
            <xsl:when test="code">
                <map key="_label">
                    <string key="@language">
                        <xsl:value-of select="code"/>
                    </string>
                    <string key="@value">
                        <xsl:value-of select="normalize-space(text())"/>
                    </string>
                </map>
            </xsl:when>
            <xsl:when test="@href ne text()">
                <string key="_label">
                    <xsl:value-of select="text()"/>
                </string>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Reference -->
    <xsl:template match="a[@href]" mode="reference">
        <map>
            <string key="@id">
                <xsl:value-of select="@href"/>
            </string>
            <xsl:call-template name="label"/>
        </map>
    </xsl:template>

</xsl:stylesheet>
