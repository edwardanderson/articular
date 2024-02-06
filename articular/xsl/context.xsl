<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- @context -->
    <xsl:template name="context">
        <xsl:param name="base"/>
        <xsl:param name="vocab"/>
        <xsl:param name="language"/>
        <xsl:param name="context"/>
        <array key="@context">
            <map>
                <string key="@base"><xsl:value-of select="$base"></xsl:value-of></string>
                <xsl:if test="$language">
                    <string key="@language"><xsl:value-of select="$language"></xsl:value-of></string>
                </xsl:if>
                <number key="@version">1.1</number>
                <string key="@vocab"><xsl:value-of select="$vocab"/></string>
                <string key="html">http://www.w3.org/1999/xhtml/</string>
                <string key="rdf">http://www.w3.org/1999/02/22-rdf-syntax-ns#</string>
                <string key="rdfs">http://www.w3.org/2000/01/rdf-schema#</string>
                <string key="schema">https://schema.org/</string>
                <string key="xsd">http://www.w3.org/2001/XMLSchema#</string>
                <map key="_label">
                    <string key="@id">rdfs:label</string>
                </map>
                <map key="_seeAlso">
                    <string key="@id">rdfs:seeAlso</string>
                    <string key="@container">@set</string>
                </map>
                <map key="_value">
                    <string key="@id">rdf:value</string>
                </map>
                <!-- User aliases -->
                <!-- <xsl:apply-templates select="//ul/li/ul/li[a][ul/li]" mode="context"/> -->
                <xsl:apply-templates select="/ul/li/ul/li[ul/li]" mode="context"/>
            </map>
            <xsl:if test="$context">
                <string>
                    <xsl:value-of select="$context"/>
                </string>
            </xsl:if>
        </array>
    </xsl:template>

    <!-- Predicate aliases -->
    <xsl:template match="//ul/li/ul/li[ul/li]" mode="context">
        <xsl:if test="a">
            <map key="{a/text()}">
                <string key="@id">
                    <xsl:value-of select="a/@href"/>
                </string>
            </map>
        </xsl:if>
        <xsl:apply-templates select="ul/li/ul/li" mode="context"/>
    </xsl:template>

</xsl:stylesheet>
