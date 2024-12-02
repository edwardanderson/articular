<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Preformatted text. -->
    <xsl:template match="pre">
        <xsl:apply-templates select="code[@class]"/>
        <map key="_content">
            <string key="@value">
                <xsl:value-of select="code/text()"/>
            </string>        
        </map>
    </xsl:template>

    <xsl:template match="code[@class]">
        <string key="_format">
            <xsl:value-of select="substring-after(@class, '-')"/>
        </string>
    </xsl:template>

</xsl:stylesheet>
