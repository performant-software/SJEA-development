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
    <xsl:variable name="xmlpath">
        <xsl:value-of>xml/</xsl:value-of>
    </xsl:variable>
    <xsl:variable name="imgpath">
        <xsl:value-of>images/</xsl:value-of>
    </xsl:variable>
    <xsl:variable name="csspath">
        <xsl:value-of>stylesheets/</xsl:value-of>
    </xsl:variable>
    



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
            <xsl:value-of select="substring-after(substring-before($id, '.xml'), $xmlpath)"/>
        </xsl:variable>

        <xsl:result-document href="{concat($idno, '.html')}" format="html">
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
                <link href="{concat($csspath, 'manuscript.css')}" rel="stylesheet" type="text/css"/>
                <title>
                    <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </title>
                <style>
                    div { padding-bottom: 12px }
                </style>
            </head>

            <body class="contentArea">
                <!--add a button to view XML copy of document-->
                <span class="xmlButton">
                    <a href="{$id}">
                        <img src="{concat($imgpath, 'xmlbutton.jpg')}" height="14" width="36"/>
                    </a>
                </span>

                <h2>
                    <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </h2>

                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>


    <!--*************************-->
    <!--mjc: origdate template-->
    <!--     ========         -->
    <!--mjc: format the <origdate> of the file-->
    <!--*************************-->
    <xsl:template match="//tei:sourceDesc">
        <xsl:for-each select="//tei:origDate">
            <div class="origdate">
                <b>Date: </b>
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>

        <xsl:for-each select="//tei:physDesc">
            <xsl:for-each select="//tei:support">
                <div class="support">
                    <b>Support: </b>
                    <xsl:value-of select="text()"/>
                </div>
            </xsl:for-each>

            <xsl:for-each select="//tei:extent/tei:measure">
                <xsl:if test="@type='leavesCount'">
                    <div class="extent">
                        <b>Extent: </b>
                        <xsl:value-of select="text()"/>
                    </div>
                </xsl:if>

                <xsl:if test="@type='pageDimensions'">
                    <div class="format">
                        <b>Format: </b>
                        <xsl:value-of select="text()"/>
                    </div>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//tei:foliation">
                <div class="foliation">
                    <b>Foliation: </b>
                    <xsl:value-of select="text()"/>
                </div>
            </xsl:for-each>

            <xsl:for-each select="//tei:collation">
                <div class="foliation">
                    <b>Collation: </b>
                    <xsl:apply-templates/>
                </div>
            </xsl:for-each>

            <xsl:for-each select="//tei:condition">
                <div class="foliation">
                    <b>Condition: </b>
                    <xsl:value-of select="text()"/>
                </div>
            </xsl:for-each>

            <xsl:for-each select="//tei:layout">
                <div class="foliation">
                    <b>Page layout: </b>
                    <xsl:apply-templates/>
                </div>
            </xsl:for-each>

            <xsl:for-each select="//tei:handNote">
                <div class="handnote">
                    <b>The scribe &#x2014; script and dialect: </b>
                    <xsl:apply-templates/>
                </div>
            </xsl:for-each>

            <xsl:for-each select="//tei:decoNote">
                <div class="handnote">
                    <b>Decoration: </b>
                    <xsl:apply-templates/>
                </div>
            </xsl:for-each>

            <xsl:for-each select="//tei:binding">
                <div class="handnote">
                    <b>Binding: </b>
                    <xsl:apply-templates/>
                </div>
            </xsl:for-each>

            <xsl:for-each select="../tei:msContents">
                <div class="contents">
                    <b>Contents: </b>
                    <xsl:apply-templates select="."/>
                </div>
            </xsl:for-each>
    
            <xsl:for-each select="//tei:provenance">
                <div class="handnote">
                    <b>Provenance: </b>
                    <xsl:apply-templates/>
                </div>
            </xsl:for-each>
            
            <xsl:for-each select="//tei:listBibl">
                <div class="handnote">
                    <b>Bibliography: </b>
                    <!--mjc: tell parser not to turn <br/> into <br></br>-->
                    <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
                    <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
                    <xsl:apply-templates/>
                </div>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="//tei:sourceDesc//tei:title">
        <i>
            <xsl:value-of select="text()"/>
        </i>
    </xsl:template>


    <xsl:template match="//tei:collation//tei:item">
        <div class="collItem">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:p">
        <div class="p">
            <xsl:apply-templates/>
        </div>

    </xsl:template>

    <xsl:template match="tei:table">
        <table class="descTab">
            <xsl:apply-templates/>
        </table>
        <!--mjc: tell parser not to turn <br/> into <br></br>-->
        <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
    </xsl:template>

    <xsl:template match="tei:row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="tei:cell">
        <xsl:choose>
            <xsl:when test="./tei:title">
                <th>
                    <xsl:apply-templates select="./tei:title/tei:hi"/>
                </th>
            </xsl:when>
            
            <xsl:otherwise>
                <td>
                    <xsl:apply-templates/>
                </td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:bibl">
        <div class="bibEntry">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="//tei:msContents">
        <xsl:for-each select="./tei:msItem">
            <div class="msitem">
                <xsl:for-each select="./tei:title">
                    <xsl:value-of select="concat(text(), ':')"/>
                    <!--mjc: tell parser not to turn <br/> into <br></br>-->
                    <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
                </xsl:for-each>
                
                <xsl:for-each select="./tei:msItem">
    
                        <xsl:apply-templates/>
                    <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
                </xsl:for-each>
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:locus">
        <xsl:value-of select="text()"/>
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <xsl:if test="@rend='italic'">
            <i><xsl:apply-templates/></i>
        </xsl:if>
        
        <xsl:if test="@rend ='bold'">
            <b><xsl:apply-templates/></b>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt | tei:editionStmt | tei:publicationStmt"/>


</xsl:stylesheet>
