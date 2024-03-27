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
            <xsl:choose>
                <xsl:when test="$embed-context">
                    <map>
                        <number key="@version">1.1</number>
                        <string key="dc">http://purl.org/dc/elements/1.1/</string>
                        <string key="dcmit">http://purl.org/dc/dcmitype/</string>
                        <string key="html">http://www.w3.org/1999/xhtml/</string>
                        <string key="owl">http://www.w3.org/2002/07/owl#</string>
                        <string key="rdf">http://www.w3.org/1999/02/22-rdf-syntax-ns#</string>
                        <string key="rdfs">http://www.w3.org/2000/01/rdf-schema#</string>
                        <string key="schema">https://schema.org/</string>
                        <string key="xsd">http://www.w3.org/2001/XMLSchema#</string>
                        <map key="_content">
                            <string key="@id">rdf:value</string>
                            <string key="@container">@set</string>
                        </map>
                        <map key="_format">
                            <null key="@language"/>
                            <string key="@id">dc:format</string>
                        </map>
                        <map key="_label">
                            <string key="@id">rdfs:label</string>
                        </map>
                        <map key="_sameAs">
                            <string key="@id">
                                <xsl:value-of select="$definition-equivalence"/>
                            </string>
                            <string key="@container">@set</string>
                        </map>
                        <map key="_seeAlso">
                            <string key="@id">rdfs:seeAlso</string>
                            <string key="@container">@set</string>
                        </map>
                        <map key="_title">
                            <string key="@id">dc:title</string>
                        </map>
                        <map key="_type">
                            <string key="@id">dc:type</string>
                            <string key="@type">@vocab</string>
                        </map>
                        <map key="_Dataset">
                            <string key="@id">dcmit:Dataset</string>
                        </map>
                        <map key="_Image">
                            <string key="@id">
                                <xsl:value-of select="$class-image"/>
                            </string>
                        </map>
                        <map key="_Text">
                            <string key="@id">
                                <xsl:value-of select="$class-blockquote"/>
                            </string>
                        </map>
                    </map>
                </xsl:when>
                <xsl:otherwise>
                    <string>
                        <xsl:value-of select="$articular-context-uri"/>
                    </string>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$language | $base | $vocab">
                <map>
                    <!-- Parameters -->
                    <xsl:if test="$language">
                        <string key="@language">
                            <xsl:value-of select="$language"/>
                        </string>
                    </xsl:if>
                    <string key="@base">
                        <xsl:value-of select="$base"/>
                    </string>
                    <string key="@vocab">
                        <xsl:value-of select="$vocab"/>
                    </string>
                    <!-- User aliases -->
                    <xsl:apply-templates select="/document/ul/li/ul/li" mode="context"/>
                </map>
            </xsl:if>
            <xsl:if test="$context">
                <string>
                    <xsl:value-of select="$context"/>
                </string>
            </xsl:if>
        </array>
    </xsl:template>

    <!-- Predicate aliases -->
    <xsl:template match="(ol|ul)/li/(ol|ul)/li" mode="context">
        <xsl:if test="a/@href">
            <map key="{a/text()}">
                <string key="@id">
                    <xsl:value-of select="a/@href"/>
                </string>
            </map>
        </xsl:if>
        <xsl:apply-templates select="(ol|ul)/li/(ol|ul)/li" mode="context"/>
    </xsl:template>

</xsl:stylesheet>
