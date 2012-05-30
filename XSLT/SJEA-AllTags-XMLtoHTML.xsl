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
     
     4/27/2012: First draft
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


    <!--Define tags that need whitespace stripped or preserved-->
    <xsl:strip-space elements="tei:seg tei:l" />
    <xsl:preserve-space elements="" />
    
        
        
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

        <!--mjc: the path/filename to output to-->
        <xsl:variable name="idno">
            <xsl:value-of
                select="substring-after(substring-before($id, '.xml'), concat($xmlpath, 'SJ'))"
            />
        </xsl:variable>

        <!--mjc: get the path of the file for this output-->
        <xsl:variable name="filename">
            <xsl:value-of
                select="concat('MS', $idno)"
            > </xsl:value-of>
        </xsl:variable>


        <!--mjc: ALLTAGS                                    -->
        <!--     =======                                    -->
        <!--     Generaate the AllTags output               -->
        <xsl:result-document href="{concat($filename, '-alltags.html')}" format="html">
            <xsl:call-template name="generateHTML">
                <xsl:with-param name="view" select="string('alltags')" tunnel="yes"/>
                <xsl:with-param name="idno" select="$idno" tunnel="yes"/>
            </xsl:call-template>
        </xsl:result-document>
        
        <!--mjc: CRITICAL                                   -->
        <!--     ========                                   -->
        <!--     Generaate the Critical output              -->
        <xsl:result-document href="{concat($filename, '-critical.html')}" format="html">
            <xsl:call-template name="generateHTML">
                <xsl:with-param name="view" select="string('critical')" tunnel="yes"/>
                <xsl:with-param name="idno" select="$idno" tunnel="yes"/>
            </xsl:call-template>
        </xsl:result-document>
        
        <!--mjc: SCRIBAL                                    -->
        <!--     =======                                    -->
        <!--     Generaate the Scribal output               -->
        <xsl:result-document href="{concat($filename, '-scribal.html')}" format="html">
            <xsl:call-template name="generateHTML">
                <xsl:with-param name="view" select="string('scribal')" tunnel="yes"/>
                <xsl:with-param name="idno" select="$idno" tunnel="yes"/>
            </xsl:call-template>
        </xsl:result-document>
        
        <!--mjc: DIPLOMATIC                                 -->
        <!--     ==========                                 -->
        <!--     Generaate the Diplomatic output            -->
        <xsl:result-document href="{concat($filename, '-diplomatic.html')}" format="html">
            <xsl:call-template name="generateHTML">
                <xsl:with-param name="view" select="string('diplomatic')" tunnel="yes"/>
                <xsl:with-param name="idno" select="$idno" tunnel="yes"/>
            </xsl:call-template>
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
        <xsl:param name="view" tunnel="yes"/>
        <xsl:param name="idno" tunnel="yes"/>
        
        <xsl:variable name="pagetitle">
            <xsl:call-template name="generateTitle"/>
        </xsl:variable>
        
        <!--mjc: layout the main structure of the HTML output doc -->
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <link href="{concat($csspath, 'manuscript.css')}" rel="stylesheet" type="text/css"/>
                <title>
                    <xsl:value-of select="concat($pagetitle, '-', $view)"/>
                </title>
                
                <!--mjc: add the teiHeader info -->
                <xsl:comment>
                    <xsl:text>XML source info</xsl:text>
                    <xsl:copy-of select="//tei:teiHeader"/>
                </xsl:comment>
            </head>
            
            <body class="contentArea">
                <h1><xsl:value-of select="concat(//tei:sourceDesc//tei:repository, ', MS ', //tei:sourceDesc//tei:idno, ' (', $idno, ')')"/></h1>

                <xsl:call-template name="processBody"/>
            </body>
        </html>
    </xsl:template>
    

    <!--***************************-->
    <!--mjc: generateTitle template-->
    <!--     =============         -->
    <!--     create a <head>/<title>                                          -->
    <!--     use the value in teiHeader/fileDesc/titleStmt/title[@type='main']-->
    <!--***************************-->
    <xsl:template name="generateTitle">
        <xsl:param name="id" tunnel="yes"/>
        <xsl:param name="idno" tunnel="yes"/>
        
        <xsl:variable name="repos">
            <xsl:value-of select="//tei:sourceDesc//tei:repository"/>
        </xsl:variable>
        
        <xsl:value-of select="concat($repos, ', MS ', $idno)"/>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: copyNodes template-->
    <!--     =========         -->
    <!--mjc: format the body of the file-->
    <!--*************************-->
    <xsl:template name="copyNodes">
        <xsl:param name="name"/>
        
        <xsl:for-each select="$name">
        <xsl:choose>
            <xsl:when test="self::comment()">
                ***COMMMENT***
            </xsl:when>
            
            <xsl:when test="./descendant::*">
                +++DESCENDENT***
                <xsl:copy>
                    
                    <xsl:call-template name="copyNodes">
                        <xsl:with-param name="name" select="./descendant::node()[1]"/>
                    </xsl:call-template>
                </xsl:copy>
                ---/DESENDENT***
            </xsl:when>
            
            <xsl:when test="./following-sibling::*">
                +++SIBLING***
                <xsl:copy-of select="."/>
                    
                
                <xsl:call-template name="copyNodes">
                    <xsl:with-param name="name" select="./following-sibling::node()[1]"/>
                </xsl:call-template>
                ---/SIBLING***
            </xsl:when>
            
            <xsl:otherwise>
                ***SELF***
                <xsl:copy-of select="."/>
                    
            </xsl:otherwise>
        </xsl:choose>
        </xsl:for-each>
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
    
    
    <!--*************************-->
    <!--mjc: convertNum template-->
    <!--     ==========         -->
    <!--mjc: convert a number to the word equivalent-->
    <!--*************************-->
    <xsl:template name="convertNum">
        <xsl:param name="num"/>
        
        <xsl:choose>
            <xsl:when test="$num=1">
                One
            </xsl:when>
            <xsl:when test="$num=2">
                Two
            </xsl:when>
            <xsl:when test="$num=3">
                Three
            </xsl:when>
            <xsl:when test="$num=4">
                Four
            </xsl:when>
            <xsl:when test="$num=5">
                Five
            </xsl:when>
            <xsl:when test="$num=6">
                Six
            </xsl:when>
            <xsl:when test="$num=7">
                Seven
            </xsl:when>
            <xsl:when test="$num=8">
                Eight
            </xsl:when>
            <xsl:when test="$num=9">
                Nine
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: div2 template-->
    <!--     ====         -->
    <!--mjc: turn <div2> into <div> and create headings -->
    <!--     based on view types.                       -->
    <!--*************************-->
    <xsl:template match="tei:div2">
        <xsl:param name="view" tunnel="yes"/>
        
        <div>
            <xsl:choose>
                <xsl:when test="$view='critical'">
                    <xsl:variable name="numW">
                        <xsl:call-template name="convertNum">
                            <xsl:with-param name="num" select="number(@n)"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <h2 align='center'>Passus <xsl:value-of select="$numW"/></h2>
                    <xsl:apply-templates/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: head template-->
    <!--     ====         -->
    <!--mjc: turn <head> into <div> and create headings -->
    <!--     based on view types.                       -->
    <!--*************************-->
    <xsl:template match="tei:head">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:if test="$view!='critical'">
            <xsl:choose>
                <xsl:when test="@rend">
                    <h2><span class="{substring-after(substring-before(@rend, ')'), '(')}"><xsl:apply-templates/></span></h2>
                </xsl:when>
                
                <xsl:when test="@place">
                    <h2><span class="{@place}"><xsl:apply-templates/></span></h2>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: fw template-->
    <!--     ==         -->
    <!--mjc: for now let's ignore running headers.      -->
    <!--     This may change as the layout is completed.-->
    <!--*************************-->
    <xsl:template match="tei:fw">
        <xsl:if test="@type='tunningHead'"/>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: milestone template-->
    <!--     =========         -->
    <!--mjc: turn <milestone>s into links to page images.-->
    <!--     img names given in @entity.                 -->
    <!--     path to imgs is "./MS <x> jpeg files".      -->
    <!--*************************-->
    <xsl:template match="tei:milestone">
        <xsl:param name="id" tunnel="yes"/>
        
        <!--mjc: for formatting, put a <br/> before every <milestone>   -->
        <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
        
        <xsl:variable name="imgName">
            <xsl:value-of select="concat($imgpath, @entity, '-thumbnail.jpg')"/>
        </xsl:variable>
        
        <!--mjc: if the <milestone> is immediately followed by a <marginalia>   -->
        <!--      with @place='top...' then put a <span> here for the text      -->
        <xsl:if test="name(./following-sibling::*[1])='marginalia'">
            <xsl:variable name="pos" select="substring(./following-sibling::*[1]/@place, 1, 3)"/>
            
            <xsl:if test="$pos='top'">
                <xsl:call-template name="generateMarginalia">
                    <xsl:with-param name="margin" select="./following-sibling::tei:marginalia[1]"/>
                </xsl:call-template>
                <!--mjc: tell parser not to turn <br/> into <br></br>-->
                <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
            </xsl:if>
        </xsl:if>
        
        <!--dg: create <img> tags instead of <a> tags for the images. This shows the manuscript page -->
        <!--    as a thumbnail and matches the wireframes we have provided Tim for review.           -->
        <a href="{concat('/',concat(@entity, '-image.html'))}" target="_blank"><img src='{$imgName}' class="image"></img></a>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: l template-->
    <!--     =         -->
    <!--mjc: format the lines (<l>s) of the file-->
    <!--*************************-->
    <xsl:template match="tei:l">
        <xsl:param name="id" tunnel="yes"/>
        <xsl:param name="view" tunnel="yes"/>
        <xsl:param name="idno" tunnel="yes"/>
        
        <xsl:variable name="manLine" select="substring-after(@xml:id, '.')"/>
        <xsl:variable name="HLLine" as="xs:double" select="number(substring-after(@n, '.'))"/>

        <!--mjc: display every forth line number-->
        <xsl:if test="(number($manLine) mod 4) = 0">
            <span class="lineMarker">
                <xsl:value-of select="concat($idno, ' ', number($manLine))"/>
                <xsl:if test="$view = 'critical' or $view = 'alltags'">
                    <xsl:value-of select="concat(' (HL ', $HLLine, ')')"/>
                </xsl:if>
            </span>
        </xsl:if>
        
        <!--mjc: if the line is followed by a <marginalia> with @place of left or right,    -->
        <!--     then display it with this line.                                            -->
        <!--     if @place is bottom then display it on another line                        -->
        <xsl:choose>
            <xsl:when test="name(./following-sibling::*[1])='marginalia'">
                <xsl:variable name="pos" select="substring(@place, 1, 3)"/>
                
                <span class="line">
                    <xsl:if test="$pos!='top'">
                        <xsl:apply-templates/>
                        <xsl:call-template name="generateMarginalia">
                            <xsl:with-param name="margin" select="./following-sibling::tei:marginalia[1]"/>
                        </xsl:call-template>
                    </xsl:if>
                </span>
            </xsl:when>
            
            <xsl:otherwise>
                <span class="line">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        
        <!--mjc: tell parser not to turn <br/> into <br></br>-->
        <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: seg template-->
    <!--     ===         -->
    <!--mjc: format the <seg> tags. there are two types -->
    <!--     we are interested in:                      -->
    <!--     - @type=bverse : add several pre-spaces in -->
    <!--        the critical view                       -->
    <!--     - @type=punct : for medial punctuation     -->
    <!--*************************-->
    <xsl:template match="tei:seg">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:choose>
            <xsl:when test="@type='bverse' and $view='critical'">
                <xsl:choose>
                    <!--if there's any medial punct, then we don't want to add any extra spaces -->
                    <xsl:when test="//tei:g/@ref='#puncelev' or //tei:seg/@type='punct'">
                        <xsl:choose>
                            <xsl:when test="preceding-sibling::tei:g[1] or preceding-sibling::tei:seg[1]/@type='punct'">
                                <xsl:apply-templates/>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                    <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <span class="bverse">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="@type = 'shadowHyphen'">
                <xsl:choose>
                    <xsl:when test="$view = 'critical'"/>
                    
                    <xsl:when test="$view = 'diplomatic'">
                        <xsl:value-of xml:space="preserve"> </xsl:value-of>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <span class="shadowHyphen"><xsl:apply-templates/></span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates/><xsl:value-of xml:space="preserve"> </xsl:value-of>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: g template-->
    <!--     =         -->
    <!--mjc: format text in the <g> tag with @ref   -->
    <!--     for punctuation.                       -->
    <!--     - #puncelev = #61793                    -->
    <!--*************************-->
    <xsl:template match="tei:g">
        <xsl:choose>
            <xsl:when test="@ref='#puncelev'">
                <!--&#61793;-->
                <span class="puncelev">&#x61B; </span>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: del template-->
    <!--     ===         -->
    <!--mjc: format text in the <del> tag-->
    <!--*************************-->
    <xsl:template match="tei:del">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:if test="$view = 'diplomatic' or $view = 'alltags'">
            <xsl:choose>
                <xsl:when test="substring(text()[1], 1, 1) = '.'">{<span class="del-illegible">
                        <xsl:apply-templates/>
                    </span>}</xsl:when>
                
                <xsl:otherwise>
                    <xsl:choose>
                        <!--if the <del> is outside of a word (<l>/<seg>/<del>) then we want a space after it-->
                        <xsl:when test="parent::tei:seg/parent::tei:l">
                            {<span class="del-legible">
                                <xsl:apply-templates/>
                            </span>}
                        </xsl:when>
                        
                        <!--otherwise, we don't-->
                        <xsl:otherwise>{<span class="del-legible">
                            <xsl:apply-templates/>
                        </span>}</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: expan template-->
    <!--     =====         -->
    <!--mjc: italicize text in the <expan> tag-->
    <!--     except in critical view.         -->
    <!--*************************-->
    <xsl:template match="tei:expan">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:choose>
            <xsl:when test="$view = 'critical'">
                <xsl:apply-templates/>
            </xsl:when>
            
            <xsl:otherwise>
                <i><xsl:apply-templates/></i>
            </xsl:otherwise>
        </xsl:choose>
        
        <!--some <expan> tags are inside text() nodes and so need to preserve the following space-->
        <xsl:if test="substring(./following-sibling::text()[1], 1, 1) = ' '">
            <xsl:value-of xml:space="preserve"> </xsl:value-of>
        </xsl:if>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: hi template-->
    <!--     ==         -->
    <!--mjc: apply actions of <hi> tags except to critical view:    -->
    <!--     'it' - italics                                         -->
    <!--     'sup"- superposition                                   -->
    <!--     'ul' - underline                                       -->
    <!--     'o5' - character is 5 lines high                       -->
    <!--     'tr' - red highlight                                   -->
    <!--     'BinR'-red outline around text                         -->
    <!--*************************-->
    <xsl:template match="tei:hi">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:choose>
            <xsl:when test="$view = 'critical'">
                <xsl:apply-templates/>
            </xsl:when>
            
            <xsl:otherwise>
                <span class="{@rend}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: damage template-->
    <!--     ======         -->
    <!--mjc: show elipses in <damage> with aqua text in alltags view.   -->
    <!--     otherwise in black.                                        -->
    <!--*************************-->
    <xsl:template match="tei:damage">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:choose>
            <xsl:when test="$view = 'alltags'">
                <span class="damage"><xsl:apply-templates/></span>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: choice template-->
    <!--     ======         -->
    <!--mjc: display the options in a <choice> in different ways        -->
    <!--     depending on the view. There are several types of <choice>s-->
    <!--        - <orig> / <reg>                                        -->
    <!--        - <sic> / <corr>                                        -->
    <!--*************************-->
    <xsl:template match="tei:choice">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:choose>
            <xsl:when test="$view = 'critical'">
                <xsl:choose>
                    <xsl:when test="./descendant::tei:orig">
                        <span><xsl:apply-templates select="./descendant::tei:reg"/></span>
                    </xsl:when>
                    <xsl:when test="./descendant::tei:sic">
                        <span><xsl:value-of select="./descendant::tei:corr"/></span>
                    </xsl:when>
                    <xsl:when test="./descendant::tei:expan">
                        <span name="{./tei:abbr/text()}"><xsl:value-of select="./tei:expan/tei:seg"/></span>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="$view = 'scribal'">
                <xsl:choose>
                    <xsl:when test="./descendant::tei:orig">
                        <span class="orig"><xsl:apply-templates select="./descendant::tei:orig"/><xsl:value-of xml:space="preserve"> </xsl:value-of></span> 
                    </xsl:when>
                    <xsl:when test="./descendant::tei:sic">
                        <span class="sic"><xsl:value-of select="./descendant::tei:sic"/></span>
                    </xsl:when>
                    <xsl:when test="./descendant::tei:expan">
                        <span class="expan" name="{./tei:abbr/text()}"><i><xsl:value-of select="./tei:expan/tei:seg"/></i></span>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="$view = 'diplomatic'">
                <xsl:choose>
                    <xsl:when test="./descendant::tei:orig">
                        <span><xsl:apply-templates select="./descendant::tei:orig"/><xsl:value-of xml:space="preserve"> </xsl:value-of></span>
                    </xsl:when>
                    <xsl:when test="./descendant::tei:sic">
                        <span><xsl:value-of select="./descendant::tei:sic"/></span>
                    </xsl:when>
                    <xsl:when test="./descendant::tei:expan">
                        <span class="expan" name="{./tei:abbr/text()}"><i><xsl:value-of select="./tei:expan/tei:seg"/></i></span>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="$view = 'alltags'">
                <xsl:choose>
                    <xsl:when test="./descendant::tei:orig">
                        <span class="orig"><xsl:value-of select="./descendant::tei:orig"/> / </span><span class="reg"><xsl:apply-templates select="./descendant::tei:reg"/></span>
                    </xsl:when>
                    <xsl:when test="./descendant::tei:sic">
                        <span class="sic"><xsl:value-of select="./descendant::tei:corr"/> / </span><span class="corr"><xsl:value-of select="./descendant::tei:corr"/></span>
                    </xsl:when>
                    <xsl:when test="./descendant::tei:expan">
                        <span class="expan" name="{./tei:abbr/text()}"><i><xsl:value-of select="./tei:expan/tei:seg"/></i></span>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            
        </xsl:choose>
    </xsl:template>
    
    
    
    
    <!--*************************-->
    <!--mjc: add template-->
    <!--     ===         -->
    <!--mjc: format text in the <add> tag           -->
    <!--     output in gray font for AllTags view   -->
    <!--*************************-->
    <xsl:template match="tei:add">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:choose>
            <xsl:when test="$view = 'alltags' or $view = 'scribal'">
                <span class="add-{@place}" title="{@hand}" alt="{@hand}"><xsl:apply-templates/></span>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: trailer | explicit templates-->
    <!--     =======   ========         -->
    <!--mjc: format text in the <trailer> and <explicit> tags   -->
    <!--     display in italics (except Crit) and use @place to -->
    <!--     populate @class field.                             -->
    <!--*************************-->
    <xsl:template match="tei:trailer | tei:explicit">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:choose>
            <xsl:when test="$view = 'critical'">
                <span class="{@place}"><xsl:apply-templates/></span>
                <!--mjc: tell parser not to turn  into <br></br>-->
                <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
            </xsl:when>
            
            <xsl:otherwise>
                <span class="{@place}"><i><xsl:apply-templates/></i></span>
                <!--mjc: tell parser not to turn  into <br></br>-->
                <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: marginalia template-->
    <!--     ==========         -->
    <!--mjc: format text in the <marginalia> tag    -->
    <!--     except for Critical view.              -->
    <!--     use @place to populate @class field.   -->
    <!--*************************-->
    <xsl:template name="generateMarginalia">
        <xsl:param name="view" tunnel="yes"/>
        <xsl:param name="margin"/>
        
        <xsl:choose>
            <xsl:when test="$view = 'critical'"/>
            
            <xsl:otherwise>
                <xsl:for-each select="$margin">
                    <span class="margin-{@place}" title="{@hand}" alt="{@hand}"><xsl:apply-templates/></span>
                </xsl:for-each>
                
                <!--mjc: in some cases there can be multiple <marginalia> tags in a row  -->
                <!--     handle that special condition here                              -->
                <xsl:if test="name($margin/following-sibling::*[1])='marginalia'">
                    
                    <xsl:call-template name="generateMarginalia">
                        <xsl:with-param name="margin" select="$margin/following-sibling::tei:marginalia[1]"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--mjc: Otherwise we don't want to process <marginalia> normally-->
    <xsl:template match="tei:marginalia"/>
    
    
    <!--*************************-->
    <!--mjc: note template-->
    <!--     ====         -->
    <!--mjc: format <notes>: create red, super-script   -->
    <!--     capital T, with link to something. for now -->
    <!--     put the text of the note in a @title       -->
    <!--*************************-->
    <xsl:template match="tei:note">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:variable name="noteBody">
            <xsl:apply-templates/>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$view = 'diplomatic'"/>
                
            <xsl:otherwise>
                <span class="supNote" title="{$noteBody}" alt="{$noteBody}">N</span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--*************************-->
    <!--mjc: supplied template-->
    <!--     ========         -->
    <!--mjc: format <supplied>: put text in [],   -->
    <!--     except for Diplomatic view.          -->
    <!--*************************-->
    <xsl:template match="tei:supplied">
        <xsl:param name="view" tunnel="yes"/>
        
        <xsl:choose>
            <xsl:when test="$view = 'diplomatic'"/>
            
            <xsl:otherwise>
                [<span class="supplied"><xsl:apply-templates/></span>]
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    <xsl:template match="text()">
        <xsl:value-of select="normalize-space()" />
    </xsl:template>
    
    
</xsl:stylesheet>
