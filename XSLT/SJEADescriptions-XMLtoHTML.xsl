<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:idhmc="http://idhmc.tamu.edu/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="#default html a fo rng tei teix" version="2.0">
    
    <!-- *************************************************************************
     This XSLT was written by Matthew Christy of the TAMU IDHMC for Tim
     Stinson's "Seige of Jerusalem" project. It is an online publication 
     of multiple copies of "The Seige of Jerusalem" including transcriptions
     in various formats (Scribal, Critical, Diplomatic, and All) and 
     page images in jpeg and tiff formats.
     
     This XSLT handles the separate manuscript description files.
     
     5/14/2012: First draft
    -->
    
    <!--mjc: Variables-->
    <!--     =========-->
    
    
    
    
    <!--mjc: HTML Output-->
    <!--     ===========-->
    <xsl:output method="html" indent="no" name="html" normalization-form="none"/>
    
    
    <!--mjc: XML Input-->
    <!--     =========-->
    <xsl:template match="SJEA/part">
        <xsl:apply-templates select="document(@code)/tei:TEI">
            <xsl:with-param name="id" select="@code" tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>
    
    
    <!--************************-->
    <!--mjc: tei:TEI template   -->
    <!--     =======            -->
    <!--     determines what HTML files to produce and what to name them-->
    <!--************************-->
    <xsl:template match="tei:TEI">
        <xsl:param name="id" tunnel="yes"/>
        
        <!--mjc: grab par tof the input filename to build the output filename-->
        <xsl:variable name="idno">
            <xsl:value-of select="substring-before($id, '.xml')"/>
        </xsl:variable>
        
        <xsl:result-document href="{concat(idno, '.html')}" format="html">
            <xsl:call-template name="generateHTML"/>
        </xsl:result-document>
    </xsl:template>
    
    
    
    <!--**************************-->
    <!--mjc: generateHTML template-->
    <!--     =====================-->
    <!--     create the HTML structure for the page -->
    <!--     and generate other page elements       -->
    <!-- param: view (a string that indicates which -->
    <!--        view is being built                 -->
    <!--**************************-->
    <xsl:template name="generateHTML">
        <xsl:param name="id" tunnel="yes"/>
        
        <!--mjc: layout the main structure of the HTML output doc -->
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <link href="../stylesheets/manuscript.css" rel="stylesheet" type="text/css"/>
                <title>
                    <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </title>
                
                <!--mjc: add the teiHeader info -->
                <xsl:comment>
                    <xsl:text>XML source info</xsl:text>
                    <xsl:copy-of select="//tei:teiHeader"/>
                </xsl:comment>
            </head>
            
            <body class="contentArea">
                <h1><xsl:value-of select="//tei:titleStmt/tei:title"/></h1>
                <!--add a button to view XML copy of document-->
                <span class="xmlButton"><a href="../{$id}"><img src="../xmlbutton.jpg" height="14" width="36"/></a></span>
                
                <xsl:call-template name="processBody"/>
            </body>
        </html>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: processBody template-->
    <!--     ===========         -->
    <!--mjc: format the body of the file-->
    <!--*************************-->
    <xsl:template name="processBody">
        <!-- main text -->
        <xsl:for-each select="//tei:text/tei:body/tei:div1">
            <span id="div1">
                <xsl:apply-templates/>
            </span>
        </xsl:for-each>
    </xsl:template>
    
    
</xsl:stylesheet>