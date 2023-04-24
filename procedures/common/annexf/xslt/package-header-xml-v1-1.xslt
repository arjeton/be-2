<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
  <xsl:param name="digest" />
  <xsl:param name="configJson"/>

  <xsl:variable name="configXml" select="json-to-xml($configJson)/map"/>

  <xsl:output
    encoding="utf-8"
    indent="yes"
  />

  <xsl:template name="initial">
    <xsl:call-template name="main">
      <xsl:with-param name="config" select="$configXml"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="main">
    <xsl:param name="config"/>

    <xsl:result-document doctype-system="{$config/map[@key='annexF']/map[@key='header']/map[@key='header']/string[@key='dtd']}">
      <pkgheader>
        <xsl:attribute name="lang">
          <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
        </xsl:attribute>
        <xsl:attribute name="dtd-version">
          <xsl:value-of select="$config/map[@key='annexF']/map[@key='header']/map[@key='header']/string[@key='version']"/>
        </xsl:attribute>

        <xsl:call-template name="wadMessageDigest" />

        <xsl:call-template name="transmittalInfo" >
          <xsl:with-param name="receivingOffice" select="$config/map[@key='header']/string[@key='receiving-office']"/>
        </xsl:call-template>

        <xsl:call-template name="ipType" >
          <xsl:with-param name="ipType" select="$config/map[@key='header']/string[@key='ip-type']"/>
        </xsl:call-template>

        <xsl:call-template name="applicationSoftware" >
          <xsl:with-param name="softwareName" select="$config/map[@key='header']/string[@key='software-name']"/>
          <xsl:with-param name="softwareVersion" select="$config/map[@key='header']/string[@key='software-version']"/>
          <xsl:with-param name="formType" select="$config/map[@key='header']/string[@key='form-type']"/>
        </xsl:call-template>
        <transmission-type/>
      </pkgheader>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="wadMessageDigest">
    <wad-message-digest>
      <xsl:value-of select="$digest"/>
    </wad-message-digest>
  </xsl:template>

  <xsl:template name="transmittalInfo">
    <xsl:param name="receivingOffice" />
    <transmittal-info>
      <new-application>
        <to>
          <country>
            <xsl:value-of select="$receivingOffice"/>
          </country>
        </to>
      </new-application>
    </transmittal-info>
  </xsl:template>

  <xsl:template name="ipType">
    <xsl:param name="ipType" />
    <ip-type>
      <xsl:value-of select="$ipType"/>
    </ip-type>
  </xsl:template>

  <xsl:template name="applicationSoftware">
    <xsl:param name="softwareName" />
    <xsl:param name="softwareVersion" />
    <xsl:param name="formType" />
    <application-software>
      <software-name>
        <xsl:value-of select="$softwareName" />
      </software-name>
      <software-version>
        <xsl:value-of select="$softwareVersion" />
      </software-version>
      <software-message>
        <xsl:value-of select="concat('formType=', $formType, ';formVersion=001')" />
      </software-message>
    </application-software>
  </xsl:template>
</xsl:stylesheet>