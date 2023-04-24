<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
                xmlns:ext="http://org.epo.eolf.integration">

  <xsl:param name="feesJson"/>
  <xsl:variable name="feesXml" select="json-to-xml($feesJson)/map"/>

  <xsl:template name="feeDescription">
    <xsl:param name="feeCode"/>
    <xsl:param name="pdfLanguage"/>
    <xsl:param name="configVersion"/>

    <xsl:value-of select="ext:translate($feesXml/array[@key='fees']/map[string[@key='code'] = $feeCode]/string[@key='descriptionKey'], $pdfLanguage, $configVersion)" />
  </xsl:template>

</xsl:stylesheet>
