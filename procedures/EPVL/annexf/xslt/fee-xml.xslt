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
      <xsl:with-param name="submission" select="$submissionXml"/>
      <xsl:with-param name="config" select="$configXml"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="main">
    <xsl:param name="submission"/>
    <xsl:param name="config"/>
    <xsl:result-document doctype-system="{$config/map[@key='annexF']/map[@key='blob']/map[@key='fee']/string[@key='dtd']}">
      <se-ep-fee-sheet>
        <xsl:attribute name="date-produced">
          <xsl:value-of  select="current-dateTime()"/>
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
          <xsl:value-of select="$config/map[@key='header']/string[@key='receiving-office']" />
        </xsl:attribute>
        <xsl:attribute name="status">
          <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='status']"/>
        </xsl:attribute>
        <xsl:call-template name="body">
          <xsl:with-param name="submission" select="$submission/map"/>
          <xsl:with-param name="config" select="$config"/>
        </xsl:call-template>
      </se-ep-fee-sheet>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="body">
    <xsl:param name="submission"/>
    <xsl:param name="config"/>

    <file-reference-id />
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
      <xsl:choose>
        <xsl:when test="not($fees/map[@key='feesSelection']/string[@key='currency'])">
          <xsl:text>SEK</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$fees/map[@key='feesSelection']/string[@key='currency']"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <fees>
      <xsl:choose>
        <xsl:when test="$fees/map[@key='feesSelection'] != ''">
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
              <!-- TODO verify if it will always be yes for our cases -->
              <xsl:attribute name="to-pay">
                <xsl:value-of select="'yes'"/>
              </xsl:attribute>

              <fee-each>
                <xsl:value-of select="format-number(current()/number[@key='price'], '#.###,##')" />
              </fee-each>
              <amount-total>
                <xsl:value-of select="format-number(current()/number[@key='subtotal'], '#.###,##')" />
              </amount-total>
            </fee>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <fee>
            <xsl:attribute name="fee-code">
              <xsl:value-of select="''"/>
            </xsl:attribute>
            <xsl:attribute name="fee-description">
              <xsl:value-of select="''"/>
            </xsl:attribute>
            <xsl:attribute name="count">
              <xsl:value-of select="'0'"/>
            </xsl:attribute>
            <xsl:attribute name="to-pay">
              <xsl:value-of select="'no'"/>
            </xsl:attribute>

            <fee-each>
              <xsl:value-of select="format-number(0, '#.###,##')" />
            </fee-each>
            <amount-total>
              <xsl:value-of select="format-number(0, '#.###,##')" />
            </amount-total>
          </fee>
        </xsl:otherwise>
      </xsl:choose>


    </fees>

    <amount-grand-total>
      <xsl:attribute name="currency">
        <xsl:value-of select="$currency"/>
      </xsl:attribute>
      <xsl:value-of select="format-number($fees/map[@key='feesSelection']/number[@key='total'], '#.###,##')" />
    </amount-grand-total>

    <payment-mode>
      <deposit-account>
        <xsl:attribute name="currency">
          <xsl:value-of select="$currency"/>
        </xsl:attribute>

        <xsl:attribute name="pay-with">
          <xsl:choose>
            <xsl:when test="$fees/string[@key='methodOfPayment']='depositAccount'">
              <xsl:text>yes</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>no</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <!-- TODO validate if it is account number -->
        <dep-account-no>
          <xsl:if test="$fees/string[@key='methodOfPayment']='depositAccount'">
            <xsl:value-of select="$fees/map[@key='feesSelection']/map[@key='accountInformation']/string[@key='accountNumber']"/>
          </xsl:if>
        </dep-account-no>
      </deposit-account>
      <other>
        <xsl:attribute name="currency">
          <xsl:value-of select="$currency"/>
        </xsl:attribute>

        <xsl:attribute name="pay-with">
          <xsl:choose>
            <xsl:when test="not($fees/string[@key='methodOfPayment']='depositAccount')">
              <xsl:text>yes</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>no</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </other>
    </payment-mode>
  </xsl:template>

</xsl:stylesheet>