<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- Definition list -->
    <xsl:template match="dl">
        <xsl:apply-templates select="dt"/>
    </xsl:template>

    <!-- Same as -->
    <xsl:template match="dt">
        <xsl:variable name="label" select="text()"/>
        <xsl:variable name="term" select="generate-id(.)"/>
        <xsl:if test="count(following-sibling::dd[generate-id(preceding-sibling::dt[1]) = $term]) gt 1">
            <map>
                <string key="@id">
                    <xsl:value-of select="following-sibling::dd[1]/a/@href"/>
                </string>
                <string key="_label">
                    <xsl:value-of select="$label"/>
                </string>
                <array key="_sameAs">
                    <xsl:for-each select="following-sibling::dd[generate-id(preceding-sibling::dt[1]) = $term]">
                        <xsl:if test="position() gt 1">
                            <map>
                                <string key="@id">
                                    <xsl:value-of select="a/@href"/>
                                </string>
                                <string key="_label">
                                    <xsl:value-of select="$label"/>
                                </string>
                            </map>    
                        </xsl:if>
                    </xsl:for-each>
                </array>
            </map>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
