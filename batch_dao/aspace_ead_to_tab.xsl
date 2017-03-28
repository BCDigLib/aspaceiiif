<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns:ead="urn:isbn:1-931666-22-9">
    <xsl:output method="text"/>
    <xsl:variable name="varTab">
        <xsl:text>&#x9;</xsl:text>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:for-each select="//ead:c[@level='file']">
            <xsl:choose>
                <xsl:when test="ead:did/ead:unitid">
                    <xsl:value-of select="ead:did/ead:unitid"/>
                    <xsl:value-of select="$varTab"/>
                    <xsl:value-of select="@id"/>
                    <xsl:value-of select="$varTab"/>
                    <xsl:value-of select="@level"/>
                    <xsl:value-of select="$varTab"/>
                    <xsl:value-of
                        select="normalize-space(//ead:ead/ead:archdesc[@level='collection']/ead:userestrict/ead:p)"/>
                    <xsl:text>
</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>