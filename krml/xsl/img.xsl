<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Image -->
    <xsl:template match="img">
        <string key="@id">
            <xsl:value-of select="@src"/>
        </string>
        <string key="@type">
            <xsl:text>_Image</xsl:text>
        </string>
        <xsl:call-template name="label">
            <xsl:with-param name="text" select="@alt"/>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
