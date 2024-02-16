<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Tree -->
    <xsl:template match="ol">
        <xsl:for-each select="li">
            <map>
                <!-- Subject -->
                <xsl:apply-templates select="." mode="subject"/>
            </map>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>
