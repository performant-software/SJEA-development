<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <!-- This actually works (i.e., it eliminates all corr elements without MsL in the @ana attribute), although it strips the schema declarations and pulls in the data from the xpointer referenced files. JIC 20080925 -->

    <xsl:output method="xml" indent="no" encoding="UTF-8"/>
    <!-- 
        <xsl:strip-space elements="*"/>
    -->
    <!-- <xsl:template match='/'>
        <xsl:apply-templates select='*'/>
    </xsl:template>
    
    <xsl:template match="*[not(//corr)]|@*|text()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()"/>
        </xsl:copy>
    </xsl:template> -->

    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;?oxygen RNGSchema="allitSeenet.rnc" type="compact"?&gt;&#xA;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;?xml-stylesheet type="text/css" href="stylesheets/Diplomatic.css"?&gt;&#xA;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;?oxygen SCHSchema="evidence.sch"?&gt;&#xA;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template xpath-default-namespace="http://www.tei-c.org/ns/1.0" match="*|@*|text()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template xpath-default-namespace="http://www.tei-c.org/ns/1.0" match="//corr">
        <xsl:choose>
            <xsl:when test="contains(@ana, 'MsL')">
                <xsl:copy>
                    <xsl:apply-templates select="*|@*|text()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template xpath-default-namespace="http://www.tei-c.org/ns/1.0" match="//l">
        <l xmlns="http://www.tei-c.org/ns/1.0" xml:id="{@xml:id}">
            <hi rend="lnumber"><xsl:value-of select="@xml:id"/></hi>
            <xsl:text>  </xsl:text>
            <xsl:apply-templates/>
        </l>
    </xsl:template>
    
    <xsl:template xpath-default-namespace="http://www.tei-c.org/ns/1.0" match="//note[@xml:id]"/>
    
    <xsl:template xpath-default-namespace="http://www.tei-c.org/ns/1.0" match="//milestone">
        <milestone xmlns="http://www.tei-c.org/ns/1.0" xml:id="{@xml:id}" rendition="{@rendition}" unit="{@unit}" n="{@n}" facs="{@facs}"/>
        <p xmlns="http://www.tei-c.org/ns/1.0" rend="milestone"><xsl:value-of select="@unit"/> <xsl:value-of select="@n"/></p>
    </xsl:template>

</xsl:stylesheet>
