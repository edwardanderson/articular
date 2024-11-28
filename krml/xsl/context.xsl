<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions">

    <!-- @context -->
    <xsl:template name="context">
        <xsl:param name="base"/>
        <xsl:param name="vocab"/>
        <xsl:param name="language"/>
        <array key="@context">
            <xsl:choose>
                <xsl:when test="$embed-context">
                    <map>
                        <number key="@version">1.1</number>
                        <string key="dcmitype">http://purl.org/dc/dcmitype/</string>
                        <string key="owl">http://www.w3.org/2002/07/owl#</string>
                        <string key="rdf">http://www.w3.org/1999/02/22-rdf-syntax-ns#</string>
                        <string key="rdfs">http://www.w3.org/2000/01/rdf-schema#</string>
                        <map key="_HTML">
                            <string key="@id">rdf:HTML</string>
                        </map>
                        <map key="_Image">
                            <string key="@id">dcmitype:Image</string>
                        </map>
                        <map key="_Text">
                            <string key="@id">dcmitype:Text</string>
                        </map>
                        <map key="_content">
                            <string key="@id">rdf:value</string>
                        </map>
                        <map key="_label">
                            <string key="@id">rdfs:label</string>
                        </map>
                        <map key="_sameAs">
                            <string key="@id">owl:sameAs</string>
                            <string key="@container">@set</string>
                        </map>
                        <map key="_seeAlso">
                            <string key="@id">rdfs:seeAlso</string>
                            <string key="@container">@set</string>
                        </map>
                    </map>
                </xsl:when>
                <xsl:otherwise>
                    <string>
                        <xsl:value-of select="$krml-context-uri"/>
                    </string>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$base | $language | $vocab | /document/dl">
                <map>
                    <!-- Parameters -->
                    <xsl:if test="$base">
                        <string key="@base">
                            <xsl:value-of select="$base"/>
                        </string>                    
                    </xsl:if>
                    <xsl:if test="$language">
                        <string key="@language">
                            <xsl:value-of select="$language"/>
                        </string>
                    </xsl:if>
                    <xsl:if test="$vocab">
                        <string key="@vocab">
                            <xsl:value-of select="$vocab"/>
                        </string>
                    </xsl:if>
                    <!-- Defined term -->
                    <xsl:apply-templates select="/document/dl" mode="context"/>
                </map>
            </xsl:if>
        </array>
    </xsl:template>

</xsl:stylesheet>
