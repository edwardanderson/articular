<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Hyperlink -->
    <xsl:template match="a">
        <!-- Identifier -->
        <xsl:apply-templates select="@href" mode="identifier"/>
        <!-- Label -->
        <xsl:apply-templates select="." mode="label"/>
    </xsl:template>

</xsl:stylesheet>
