<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Header 1 -->
    <xsl:template match="h1">
        <string key="_title">
            <xsl:value-of select="text()"/>
        </string>
    </xsl:template>

</xsl:stylesheet>
