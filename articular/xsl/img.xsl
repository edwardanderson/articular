<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Image -->
    <xsl:template match="img">
        <!-- Identifier -->
        <xsl:apply-templates select="@src" mode="identifier"/>
        <!-- Class -->
        <xsl:if test="not(../ul/li[text()[1] = 'a'])">
            <string key="@type">_Image</string>
        </xsl:if>
        <!-- Label -->
        <xsl:apply-templates select="." mode="label"/>
    </xsl:template>

</xsl:stylesheet>
