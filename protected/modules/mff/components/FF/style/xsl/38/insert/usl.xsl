<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output method="html" />
    <xsl:strip-space elements="formff_field_initeds"/>
    <xsl:template match="/">    
<xsl:copy-of select="//div[@id='formff_fieldvalue_initeds']" />    
<form enctype="multipart/form-data" id="formff_form" method="post">
<xsl:attribute name="action" >
	<xsl:value-of select="//form/@action"/>
</xsl:attribute>
<xsl:copy-of select="//input[@id='FFModel_id']" />
<xsl:copy-of select="//input[@id='activeaction']" />
<xsl:copy-of select="//div[@id='FFIND1_field_address']" />
<xsl:copy-of select="//div[@id='FFIND1_field_delivery_reply']" />
<xsl:copy-of select="//div[@id='FFIND1_field_file_petition']" />
<xsl:copy-of select="//div[@class='hiddenItems']" />
</form>
</xsl:template>
</xsl:stylesheet>
