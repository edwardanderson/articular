<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Preformatted text. -->
    <xsl:template match="pre">
        <!-- Class -->
        <xsl:call-template name="class">
            <xsl:with-param name="application">
                <xsl:text>_Text</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
        <!-- Format -->
        <xsl:apply-templates select="code[@class]"/>
        <!-- Content -->
        <map key="_content">
            <string key="@value">
                <xsl:value-of select="code/text()"/>
            </string>        
        </map>
    </xsl:template>

    <!-- Format -->
    <xsl:template match="code[@class]">
        <string key="_format">
            <xsl:value-of select="substring-after(@class, '-')"/>
        </string>
    </xsl:template>

</xsl:stylesheet>
