<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Tree -->
    <xsl:template match="ul[not(li/ul/li[text() = ('â', '^a')])]">
        <xsl:for-each select="li">
            <map>
                <!-- Subject -->
                <xsl:apply-templates select="." mode="subject"/>
            </map>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="ul[li/ul/li[text() = ('â', '^a')]]">
        <xsl:for-each select="li/ul/li/ul/li">
            <map>
                <!-- Subject -->
                <xsl:apply-templates select="." mode="subject"/>
            </map>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
