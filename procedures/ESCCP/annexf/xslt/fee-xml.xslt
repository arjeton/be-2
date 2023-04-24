<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

  <xsl:import href="/procedures/common/annexf/xslt/common/fees.xslt" />

  <xsl:param name="submissionJson"/>
  <xsl:param name="configJson"/>

  <xsl:variable name="submissionXml" select="json-to-xml($submissionJson)"/>
  <xsl:variable name="configXml" select="json-to-xml($configJson)/map"/>

  <xsl:variable name="pdfLanguage" select="$configXml/map[@key='header']/string[@key='language']"/>
  <xsl:variable name="configVersion" select="$submissionXml/map/string[@key='configurationVersion']"/>

  <xsl:output
    encoding="utf-8"
    indent="yes"
  />

  <xsl:template name="initial">
    <xsl:call-template name="main">
      <xsl:with-param name="submission" select="$submissionXml/map"/>
      <xsl:with-param name="config" select="$configXml"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="main">
    <xsl:param name="submission"/>
    <xsl:param name="config"/>
    <xsl:result-document doctype-system="{$config/map[@key='annexF']/map[@key='blob']/map[@key='fee']/string[@key='dtd']}">
      <es-ccp-fee-sheet>
        <xsl:attribute name="date-produced">
          <xsl:value-of select="format-dateTime(current-dateTime(), '[D01]/[M01]/[Y]')"/>
        </xsl:attribute>
        <xsl:attribute name="dtd-version">
          <xsl:value-of select="$config/map[@key='annexF']/map[@key='blob']/map[@key='fee']/string[@key='version']"/>
        </xsl:attribute>
        <xsl:attribute name="lang">
          <xsl:value-of select="$config/map[@key='header']/string[@key='language']" />
        </xsl:attribute>
        <xsl:attribute name="produced-by">
          <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='produced-by']"/>
        </xsl:attribute>
        <xsl:attribute name="ro">
          <xsl:value-of select="$submission/string[@key='receivingOffice']" />
        </xsl:attribute>
        <xsl:attribute name="status">
          <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='status']"/>
        </xsl:attribute>
        <xsl:call-template name="body">
          <xsl:with-param name="submission" select="$submission"/>
          <xsl:with-param name="config" select="$config"/>
        </xsl:call-template>
      </es-ccp-fee-sheet>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="body">
    <xsl:param name="submission"/>
    <xsl:param name="config"/>

    <file-reference-id>
      <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='userReference']" />
    </file-reference-id>
    <date>
      <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='date']" />
    </date>
    <xsl:call-template name="fees">
      <xsl:with-param name="fees" select="$submission/map[@key='fees']"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="fees">
    <xsl:param name="fees" />

    <xsl:variable name="currency" >
      <xsl:value-of select="$fees/map[@key='feesSelection']/string[@key='currency']"/>
    </xsl:variable>

    <fees>
      <xsl:for-each select="$fees/map[@key='feesSelection']/array[@key='selectedFees']/map">
        <fee>
          <xsl:attribute name="fee-code">
            <xsl:value-of select="current()/string[@key='code']"/>
          </xsl:attribute>
          <xsl:attribute name="fee-description">
            <xsl:call-template name="feeDescription">
              <xsl:with-param name="feeCode" select="current()/string[@key='code']"/>
              <xsl:with-param name="pdfLanguage" select="$pdfLanguage"/>
              <xsl:with-param name="configVersion" select="$configVersion"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="count">
            <xsl:value-of select="current()/number[@key='quantity']"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$fees/string[@key='methodOfPayment'] = ('alreadyPaid')">
              <xsl:attribute name="to-pay">
                <xsl:value-of select="'no'"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="to-pay">
                <xsl:value-of select="'yes'"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

          <fee-each>
            <xsl:value-of select="format-number(current()/number[@key='price'], '#.###,##')" />
          </fee-each>
          <amount-total>
            <xsl:value-of select="format-number(current()/number[@key='subtotal'], '#.###,##')" />
          </amount-total>
        </fee>
      </xsl:for-each>
    </fees>

    <amount-grand-total>
      <xsl:attribute name="currency">
        <xsl:value-of select="$currency"/>
      </xsl:attribute>
      <xsl:value-of select="format-number($fees/map[@key='feesSelection']/number[@key='total'], '#.###,##')" />
    </amount-grand-total>
  </xsl:template>

</xsl:stylesheet>
