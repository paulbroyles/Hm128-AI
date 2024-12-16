<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="3.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="tei:teiHeader"/>
        
    <xsl:template match="tei:body">
        <xsl:for-each-group select=".//(tei:l, tei:head, tei:trailer, tei:pb)" group-starting-with="tei:pb">
            <xsl:variable name="filename" select="'../txt/sjea/'||current-group()[1]/@n||'.txt'"/>
            <xsl:result-document method="text" encoding="UTF-8" href="{$filename}">
                <xsl:apply-templates select="current-group()"/>
            </xsl:result-document>
            <xsl:text>==</xsl:text><xsl:value-of select="$filename"/><xsl:text>==&#xA;</xsl:text>
            <xsl:apply-templates select="current-group()"/>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="tei:l | tei:head | tei:trailer">
        <!-- Gather all marginalia associated with a line-style unit -->
        <xsl:apply-templates select="preceding-sibling::*[1][self::marginalia or self::fw]" mode="marginalia"/>
        <xsl:variable name="linetext">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:sequence select="replace(normalize-space($linetext),'%%','&#xA;')"/>
        <xsl:text>&#xA;</xsl:text>
        <!-- Deals with any case where one of these elements is the final element in a unit, whether lg or div, by adding an extra newline -->
        <xsl:if test="not(following-sibling::*)">
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:marginalia | tei:fw"/>
    <xsl:template match="tei:marginalia | tei:fw" mode="marginalia">
        <xsl:apply-templates select="preceding-sibling::*[1][self::marginalia or self::fw]" mode="marginalia"/>
        <xsl:text>[*</xsl:text>
        <xsl:apply-templates mode="#default"/>
        <xsl:text>*]&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:corr"/>
    <xsl:template match="tei:reg"/>
    
    <xsl:template match="tei:app">
        <xsl:apply-templates select="tei:lem"/>
    </xsl:template>
    
    <xsl:template match="tei:sic">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <xsl:apply-templates/>
    </xsl:template>
    
   
    <xsl:template match="tei:orig">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:del">
        <xsl:text>⟦</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>⟧</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add">
        <xsl:text>\</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>/</xsl:text>
    </xsl:template>
    
    <!--<xsl:template match="text()[preceding-sibling::*[1][self::del]][following-sibling::*[1][self::add]][normalize-space() = '']"/>
    <xsl:template match="text()[preceding-sibling::*[1][self::add]][following-sibling::*[1][self::del]][normalize-space() = '']"/>
    -->
    <xsl:template match="tei:expan">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <xsl:text>%%</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:seg[@type='shadowHyphen']">
        <xsl:text>-</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:if test="matches(., '^\s')">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="normalize-space()"/>
        <xsl:if test="matches(., '\s$')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>