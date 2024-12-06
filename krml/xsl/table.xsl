<?xml version="1.0" encoding="utf-8"?>

<!-- Tables are not currently supported as in-list elements. -->

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Table -->
    <xsl:template match="table">
        <xsl:call-template name="class">
            <xsl:with-param name="application">
                <xsl:text>_Table</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
        <map key="_content">
            <string key="@type">_HTML</string>
            <string key="@value">
                <xsl:value-of select="serialize(.)"/>
            </string>
        </map>
        <!-- See also -->
        <xsl:if test="(thead|tbody)/tr/(th|td)/a">
            <array key="_seeAlso">
                <xsl:apply-templates select="(thead|tbody)/tr/(th|td)/a" mode="reference"/>
            </array>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
