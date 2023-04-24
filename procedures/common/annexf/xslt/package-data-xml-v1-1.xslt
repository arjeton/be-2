<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
  <xsl:param name="submissionJson"/>
  <xsl:param name="configJson"/>

  <xsl:variable name="submissionXml" select="json-to-xml($submissionJson)/map"/>
  <xsl:variable name="configXml" select="json-to-xml($configJson)/map"/>

  <xsl:output
    encoding="utf-8"
    indent="yes"
  />

  <xsl:template name="initial">
    <xsl:call-template name="main" >
      <xsl:with-param name="submission" select="$submissionXml" />
      <xsl:with-param name="config" select="$configXml"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="main" >
    <xsl:param name="submission"/>
    <xsl:param name="config"/>

    <xsl:result-document doctype-system="{$config/map[@key='annexF']/map[@key='blob']/map[@key='packageData']/string[@key='dtd']}">
      <package-data>
        <xsl:attribute name="lang">
          <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
        </xsl:attribute>
        <xsl:attribute name="dtd-version">
          <xsl:value-of select="$config/map[@key='annexF']/map[@key='blob']/map[@key='packageData']/string[@key='version']"/>
        </xsl:attribute>
        <xsl:attribute name="produced-by">
          <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='produced-by']"/>
        </xsl:attribute>

        <xsl:call-template name="transmittalInfo">
          <xsl:with-param name="config" select="$config" />
        </xsl:call-template>

        <xsl:call-template name="body">
          <xsl:with-param name="submission" select="$submission" />
          <xsl:with-param name="config" select="$config" />
        </xsl:call-template>
      </package-data>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="transmittalInfo">
    <xsl:param name="config"/>

    <transmittal-info>
      <new-application>
        <to>
          <country>
            <xsl:value-of select="$config/map[@key='header']/string[@key='country']"/>
          </country>
        </to>
      </new-application>
    </transmittal-info>
  </xsl:template>

  <xsl:template name="body">
    <xsl:param name="submission"/>
    <xsl:param name="config"/>

    <xsl:call-template name="signatures">
      <xsl:with-param name="object" select="$submission/map[@key='signature']"/>
      <xsl:with-param name="config" select="$config" />
    </xsl:call-template>

    <application-request>
    <xsl:attribute name="file">
      <xsl:value-of select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request']/string[@key='name']"/>
    </xsl:attribute>
    </application-request>
    <application-body-doc>
    <xsl:attribute name="file">
      <xsl:value-of select="$config/map[@key='annexF']/map[@key='blob']/map[@key='application']/string[@key='name']"/>
    </xsl:attribute>
    </application-body-doc>

    <xsl:call-template name="otherDocuments">
      <xsl:with-param name="object" select="$submission"/>
      <xsl:with-param name="config" select="$config"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="signatures">
    <xsl:param name="object" />
    <xsl:param name="config" />
    
    <signatories>
      <signatory>
        <name>
          <xsl:attribute name="name-type">
            <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='name-type']"/>
          </xsl:attribute>

          <xsl:value-of select="$object/string[@key='signerFullName']" />
        </name>
        <electronic-signature>
          <xsl:attribute name="date">
            <xsl:value-of select="$object/string[@key='signatureDate']"/>
          </xsl:attribute>
          <xsl:attribute name="place-signed">
            <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='place-signed']"/>
          </xsl:attribute>

          <xsl:choose>
            <xsl:when test="$object/string[@key='signatureType']='ALPHABETICAL'">
              <basic-signature>
                <text-string>
                  <xsl:value-of select="$object/string[@key='signatureText']"/>
                </text-string>
              </basic-signature>
            </xsl:when>
            <xsl:otherwise>
              <basic-signature>
                <text-string>
                  <xsl:value-of select="$object/string[@key='signatureFileName']"/>
                </text-string>
              </basic-signature>
            </xsl:otherwise>
          </xsl:choose>

        </electronic-signature>
        <signatory-capacity>
          <xsl:value-of select="concat($object/string[@key='signerCapacity'], '; FunctionOfPerson:', $object/string[@key='signerFunction'])" />
        </signatory-capacity>
      </signatory>
    </signatories>
  </xsl:template>

  <xsl:template name="otherDocuments">
        <xsl:param name="object" />
        <xsl:param name="config" />

        <xsl:variable name="xml" select="'xml'" />
        <xsl:variable name="pdf" select="'pdf'" />

        <other-documents>
          <xsl:call-template name="document">
              <xsl:with-param name="fileName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='application']/string[@key='name']"/>
              <xsl:with-param name="fileType" select="$xml"/>
              <xsl:with-param name="documentName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='application']/string[@key='annexFDocumentName']"/>
          </xsl:call-template>

          <xsl:call-template name="document">
              <xsl:with-param name="fileName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='fee']/string[@key='name']"/>
              <xsl:with-param name="fileType" select="$xml"/>
              <xsl:with-param name="documentName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='fee']/string[@key='annexFDocumentName']"/>
          </xsl:call-template>

          <!-- TODO Add necessary documents to generate the fee file -->
          <!-- <xsl:call-template name="document">
              <xsl:with-param name="fileName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='feePdf']/string[@key='name']"/>
              <xsl:with-param name="fileType" select="$pdf"/>
              <xsl:with-param name="documentName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='feePdf']/string[@key='annexFDocumentName']"/>
          </xsl:call-template> -->

          <xsl:call-template name="document">
              <xsl:with-param name="fileName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request']/string[@key='name']"/>
              <xsl:with-param name="fileType" select="$xml"/>
              <xsl:with-param name="documentName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request']/string[@key='annexFDocumentName']"/>
          </xsl:call-template>

          <xsl:call-template name="document">
              <xsl:with-param name="fileName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request-pdf']/string[@key='name']"/>
              <xsl:with-param name="fileType" select="$pdf"/>
              <xsl:with-param name="documentName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request-pdf']/string[@key='annexFDocumentName']"/>
          </xsl:call-template>

          <!-- TODO Add necessary documents to generate the fee file -->
          <!-- <xsl:if test="$object/map[@key='parties']/array[@key='inventors'] != ''">
            <xsl:call-template name="document">
                  <xsl:with-param name="fileName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='inventor']/string[@key='name']"/>
              <xsl:with-param name="fileType" select="$pdf"/>
              <xsl:with-param name="documentName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='inventor']/string[@key='annexFDocumentName']"/>
            </xsl:call-template>
          </xsl:if> -->

          <xsl:for-each select="$object/array[@key='attachments']/map">
              <xsl:call-template name="document">
                  <xsl:with-param name="fileName" select="current()/string[@key='fileName']"/>
                  <xsl:with-param name="fileType" select="current()/string[@key='fileExtension']"/>
                  <xsl:with-param name="documentName" select="current()/string[@key='docTypeLabel']"/>
              </xsl:call-template>
          </xsl:for-each>
        </other-documents>
    </xsl:template>

  <xsl:template name="document">
    <xsl:param name="fileName" />
    <xsl:param name="fileType" />
    <xsl:param name="documentName" />
    <other-doc>
      <xsl:attribute name="file">
        <xsl:value-of select="$fileName"/>
      </xsl:attribute>
      <xsl:attribute name="file-type">
        <xsl:value-of select="$fileType"/>
      </xsl:attribute>
      <document-name>
        <xsl:value-of select="$documentName" />
      </document-name>
    </other-doc>
  </xsl:template>

</xsl:stylesheet>