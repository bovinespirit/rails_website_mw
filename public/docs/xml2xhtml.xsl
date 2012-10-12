<?xml version="1.0" encoding="iso-8859-1"?>
<!-- Copyright © 2002, 2003 Matthew West          -->
<!-- $Id: xml2xhtml.xsl,v 1.3 2003/11/07 02:57:40 mfw Exp $ -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xslt"
		xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">
 <xsl:output omit-xml-declaration="no"
             method="xml"
             doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
             doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	     xalan:indent-amount="1"
	     indent="no"
             encoding="iso-8859-1" />
 <xsl:template match="/">
  <html>
   <head>
    <link rel="stylesheet" href="convert.css" />
   </head> 
   <body>
    <pre>
     <xsl:apply-templates select="comment()" mode="prolog" />
     <xsl:apply-templates select="* | processing-instruction()" />
    </pre> 
   </body>
  </html> 
 </xsl:template>

 <xsl:template match="*">
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="showName">
   <xsl:with-param name="name" select="name()" />
  </xsl:call-template> 
  <xsl:apply-templates select="@*" />
  <xsl:choose>
   <xsl:when test="node()">
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>&lt;</xsl:text> 
    <xsl:text>/</xsl:text>
    <xsl:call-template name="showName">
     <xsl:with-param name="name" select="name()" />
    </xsl:call-template> 
   </xsl:when>
   <xsl:otherwise> 
    <xsl:text>/</xsl:text>
   </xsl:otherwise>
  </xsl:choose> 
  <xsl:text>&gt;</xsl:text>
 </xsl:template>

 <xsl:template name="showName">
  <xsl:param name="name" />
  <xsl:choose>
   <xsl:when test="substring-before($name, ':')">
    <span class="namespace">
     <xsl:value-of select="substring-before($name, ':')" />
    </span>
    <xsl:text>:</xsl:text>
    <span class="element">
     <xsl:value-of select="substring-after($name, ':')" />
    </span>
   </xsl:when>
   <xsl:otherwise>
    <span class="element">
     <xsl:value-of select="$name" />
    </span>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>       
 
 <xsl:template match="processing-instruction()">
  <span class="process">
   <xsl:text>&lt;?</xsl:text>
   <xsl:value-of select="name()" />
  </span> 
  <xsl:text> </xsl:text>
  <span class="text"> 
   <xsl:value-of select="." />
  </span> 
  <xsl:text>?&gt;</xsl:text>
 </xsl:template>

 <xsl:template match="@*">
  <xsl:text> </xsl:text>
  <span class="attribute">
   <xsl:value-of select="name()" />
   <xsl:text>=</xsl:text>
  </span>
  <span class="text"> 
   <xsl:text>"</xsl:text>
   <xsl:value-of select="." />
   <xsl:text>"</xsl:text>
  </span> 
 </xsl:template>

 <xsl:template match="text()">
  <span class="text"> 
   <xsl:value-of select="." />
  </span> 
 </xsl:template>

 <xsl:template match="comment()">
  <span class="comment">
   <xsl:text>&lt;!--</xsl:text>
   <xsl:value-of select="." />
   <xsl:text>--&gt;</xsl:text>
  </span>
 </xsl:template>

 <xsl:template match="comment()" mode="prolog">
  <span class="comment">
   <xsl:text>&lt;!--</xsl:text>
   <xsl:value-of select="." />
   <xsl:text>--&gt;</xsl:text>
  </span><xsl:text>
</xsl:text>
 </xsl:template>

</xsl:stylesheet>
