<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
  <xsl:param name="submissionJson"/>
  <xsl:param name="configJson"/>

  <xsl:variable name="submissionXml" select="json-to-xml($submissionJson)/map"/>
  <xsl:variable name="configXml" select="json-to-xml($configJson)/map"/>

  <xsl:output
    encoding="utf-8"
    method="xml"
    indent="yes"
  />

  <xsl:template name="initial">
    <xsl:call-template name="body">
      <xsl:with-param name="submission" select="$submissionXml"/>
      <xsl:with-param name="config" select="$configXml"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="body">
    <xsl:param name="submission"/>
    <xsl:param name="config"/>

    <xsl:result-document doctype-system="{$config/map[@key='annexF']/map[@key='blob']/map[@key='request']/string[@key='dtd']}">
      <es-ccp-request>
        <xsl:attribute name="lang">
          <xsl:value-of select="$config/map[@key='header']/string[@key='language']" />
        </xsl:attribute>
        <xsl:attribute name="dtd-version">
          <xsl:value-of select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request']/string[@key='version']"/>
        </xsl:attribute>
        <xsl:attribute name="type">
          <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='status']"/>
        </xsl:attribute>
        <xsl:attribute name="date-produced">
          <xsl:value-of  select="current-dateTime()"/>
        </xsl:attribute>
        <xsl:attribute name="ro">
          <xsl:value-of select="$submission/string[@key='receivingOffice']" />
        </xsl:attribute>
        <xsl:attribute name="produced-by">
          <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='produced-by']"/>
        </xsl:attribute>

        <file-reference-id>
          <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='userReference']" />
        </file-reference-id>

<!--    //TODO should be filled once receiver is configured-->
        <application-type/>

        <xsl:call-template name="pastRecord">
          <xsl:with-param name="basicFilingInfo" select="$submission/map[@key='basicFilingInfo']"/>
        </xsl:call-template>

        <xsl:call-template name="parties">
          <xsl:with-param name="object" select="$submission/map[@key='parties']"/>
          <xsl:with-param name="config" select="$config"/>
        </xsl:call-template>

        <xsl:call-template name="authorisations">
          <xsl:with-param name="marketingDeclarations" select="$submission/map[@key='declaration']/array[@key='marketingDeclarations']"/>
        </xsl:call-template>

        <es-check-list>
          <cl-es-ccp-request/>
          <cl-fee-calculation/>
          <xsl:for-each select="$submission/array[@key='attachments']/map[string[@key='attachmentSubType']='SPC' and string[@key='country'] != '' ]">
            <cl-marketing-ex>
              <xsl:call-template name="documentContent">
                <xsl:with-param name="document" select="current()"/>
              </xsl:call-template>
            </cl-marketing-ex>
          </xsl:for-each>
          <xsl:for-each select="$submission/array[@key='attachments']/map[string[@key='attachmentSubType']='SPC' and not(string[@key='country'])]">
            <cl-marketing-eu>
              <xsl:call-template name="documentContent">
                <xsl:with-param name="document" select="current()"/>
              </xsl:call-template>
            </cl-marketing-eu>
          </xsl:for-each>
        </es-check-list>

        <xsl:call-template name="signatories">
          <xsl:with-param name="signature" select="$submission/map[@key='signature']"/>
          <xsl:with-param name="config" select="$config" />
        </xsl:call-template>
      </es-ccp-request>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="documentContent">
    <xsl:param name="document"/>

    <xsl:if test="$document/string[@key='country'] != ''">
      <xsl:attribute name="country">
        <xsl:value-of select="$document/string[@key='country']"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="page-count">
      <xsl:value-of select="$document/number[@key='totalPages']"/>
    </xsl:attribute>
    <xsl:attribute name="applicant-file-name">
      <xsl:value-of select="$document/string[@key='originalFileName']"/>
    </xsl:attribute>
    <xsl:attribute name="eolf-file-name">
      <xsl:value-of select="$document/string[@key='fileName']"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="parties">
    <xsl:param name="object" />
    <xsl:param name="config" />

    <parties>
      <xsl:call-template name="applicants">
        <xsl:with-param name="applicants" select="$object/array[@key='applicants']"/>
        <xsl:with-param name="config" select="$config"/>
      </xsl:call-template>
    </parties>
  </xsl:template>

  <xsl:template name="applicants">
    <xsl:param name="applicants" />
    <xsl:param name="config" />
    <applicants>
      <xsl:for-each select="$applicants/map">
        <xsl:call-template name="applicant">
          <xsl:with-param name="object" select="current()"/>
          <xsl:with-param name="config" select="$config" />
        </xsl:call-template>
      </xsl:for-each>
    </applicants>
  </xsl:template>

  <xsl:template name="applicant">
    <xsl:param name="object" />
    <xsl:param name="config" />

    <applicant>
      <xsl:attribute name="sequence">
        <xsl:value-of select="$object/number[@key='sequenceNumber']"/>
      </xsl:attribute>
      <xsl:attribute name="app-type">
        <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='produced-by']"/>
      </xsl:attribute>
      <xsl:attribute name="designation">
        <xsl:value-of select="'all'"/>
      </xsl:attribute>

      <xsl:call-template name="addressBook">
        <xsl:with-param name="object" select="$object"/>
        <xsl:with-param name="language" select="$config/map[@key='header']/string[@key='language']"/>
      </xsl:call-template>

      <nationality>
        <country>
          <xsl:value-of select="$object/map[@key='personalDetails']/string[@key='nationality']"/>
        </country>
      </nationality>
    </applicant>
  </xsl:template>

  <xsl:template name="addressBook">
    <xsl:param name="object" />
    <xsl:param name="language" />

    <addressbook>
      <xsl:attribute name="lang">
        <xsl:value-of select="$language"/>
      </xsl:attribute>

      <prefix>
        <xsl:value-of select="$object/map[@key='personalDetails']/string[@key='title']"/>
      </prefix>
      <last-name>
        <xsl:value-of select="$object/map[@key='personalDetails']/string[@key='lastName']"/>
      </last-name>
      <first-name>
        <xsl:value-of select="$object/map[@key='personalDetails']/string[@key='firstName']"/>
      </first-name>
      <registered-number>
        <xsl:value-of select="$object/map[@key='personalDetails']/string[@key='idNumber']"/>
      </registered-number>

      <address>
        <street>
          <xsl:value-of select="$object/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='streetAddress']"/>
        </street>
        <postcode>
          <xsl:value-of select="$object/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='postalCode']"/>
        </postcode>
        <city>
          <xsl:value-of select="$object/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='city']"/>
        </city>
        <state/>
        <country>
          <xsl:value-of select="$object/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='country']"/>
        </country>
      </address>
    </addressbook>
  </xsl:template>

  <xsl:template name="authorisations">
    <xsl:param name="marketingDeclarations" />
    <authorisations>
      <xsl:for-each select="$marketingDeclarations/map">
        <APPM>
          <xsl:if test="current()/string[@key='firstMarketingAuthorisation'] = 'FIRST_MARKETING_AUTHORISATION_YES'">
            <xsl:attribute name="appm-type">
              <xsl:value-of select="'national-and-community'"/>
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="current()/string[@key='firstMarketingAuthorisation'] = 'FIRST_MARKETING_AUTHORISATION_NO'">
            <xsl:attribute name="appm-type">
              <xsl:value-of select="'national'"/>
            </xsl:attribute>
          </xsl:if>
        
          <authorisation-country>
            <xsl:if test="current()/string[@key='authority'] = 'AUTHORITY_NATIONAL'">
              <xsl:value-of select="'ES'"/>
            </xsl:if>

            <xsl:if test="current()/string[@key='authority'] = 'AUTHORITY_EUROPEAN'">
              <xsl:value-of select="'EU'"/>
            </xsl:if>
          </authorisation-country> 
          
          <authorisation-number>
            <xsl:value-of select="current()/string[@key='authorizationNumber']"/>
          </authorisation-number>
          <product-identity>
            <xsl:value-of select="current()/string[@key='productName']"/>
          </product-identity>
          <authorisation-date>
            <xsl:value-of select="current()/string[@key='authorizationDate']"/>
          </authorisation-date>
        </APPM>

        <xsl:if test="current()/string[@key='firstMarketingAuthorisation'] = 'FIRST_MARKETING_AUTHORISATION_NO'">
          <APPM>
            <xsl:attribute name="appm-type">
              <xsl:value-of select="'community'"/>
            </xsl:attribute>

            <authorisation-country>
              <xsl:value-of select="current()/map[@key='firstMarketingAuthorisationContainer']/string[@key='country']"/>
            </authorisation-country>
            <authorisation-number>
              <xsl:value-of select="current()/map[@key='firstMarketingAuthorisationContainer']/string[@key='authorizationNumber']"/>
            </authorisation-number>
            <product-identity>
              <xsl:value-of select="current()/map[@key='firstMarketingAuthorisationContainer']/string[@key='productName']"/>
            </product-identity>
            <authorisation-date>
              <xsl:value-of select="current()/map[@key='firstMarketingAuthorisationContainer']/string[@key='authorizationDate']"/>
            </authorisation-date>
            <legal-basis>
              <xsl:value-of select="current()/map[@key='firstMarketingAuthorisationContainer']/string[@key='legalBases']"/>
            </legal-basis>
          </APPM>
        </xsl:if>
      </xsl:for-each>
  </authorisations>
</xsl:template>

  <xsl:template name="signatories">
    <xsl:param name="signature" />
    <xsl:param name="config" />

    <signatories>
      <signatory>
        <name>
          <xsl:attribute name="name-type">
            <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='name-type']"/>
          </xsl:attribute>

          <xsl:value-of select="$signature/string[@key='signerFullName']" />
        </name>
        <electronic-signature>
          <xsl:attribute name="date">
            <xsl:value-of select="$signature/string[@key='signatureDate']"/>
          </xsl:attribute>
          <xsl:attribute name="place-signed">
            <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='place-signed']"/>
          </xsl:attribute>

          <xsl:choose>
            <xsl:when test="$signature/string[@key='signatureType']='ALPHABETICAL'">
              <basic-signature>
                <text-string>
                  <xsl:value-of select="$signature/string[@key='signatureText']"/>
                </text-string>
              </basic-signature>
            </xsl:when>
            <xsl:otherwise>
              <basic-signature>
                <fax-image>
                  <xsl:attribute name="file">
                    <xsl:value-of select="$signature/string[@key='signatureFileName']"/>
                  </xsl:attribute>
                </fax-image>
              </basic-signature>
            </xsl:otherwise>
          </xsl:choose>
        </electronic-signature>
        <signatory-capacity>
          <xsl:value-of select="concat($signature/string[@key='signerCapacity'], '; FunctionOfPerson:', $signature/string[@key='signerFunction'])" />
        </signatory-capacity>
      </signatory>
    </signatories>
  </xsl:template>

  <xsl:template name="pastRecord">
    <xsl:param name="basicFilingInfo"/>

    <past-record>

      <xsl:if test="$basicFilingInfo/string[@key='patentType']">
        <xsl:variable name="patentType">
          <xsl:if test="$basicFilingInfo/string[@key='patentType'] = 'PATENT_TYPE_NATIONAL'">
            <xsl:value-of select="'national-patent'"/>
          </xsl:if>
          <xsl:if test="$basicFilingInfo/string[@key='patentType'] = 'PATENT_TYPE_EUROPEAN'">
            <xsl:value-of select="'european-patent'"/>
          </xsl:if>
        </xsl:variable>

        <patent>
          <xsl:attribute name="type">
            <xsl:value-of select="$patentType" />
          </xsl:attribute>

          <xsl:if test="$basicFilingInfo/map[@key='applicationNumberContainer']">
            <patent-application-number>
              <document-id>
                <xsl:value-of select="$basicFilingInfo/map[@key='applicationNumberContainer']/string[@key='applicationNumber']" />
              </document-id>
              <filing-date>
                <xsl:value-of select="$basicFilingInfo/string[@key='filingDate']" />
              </filing-date>
            </patent-application-number>

            <patent-number>
              <document-id>
                <xsl:value-of select="$basicFilingInfo/map[@key='applicationNumberContainer']/string[@key='publicationNumber']" />
              </document-id>
              <grant-date>
                <xsl:value-of select="$basicFilingInfo/string[@key='grantDate']" />
              </grant-date>
            </patent-number>
          </xsl:if>

          <xsl:if test="$basicFilingInfo/string[@key='titleOfInvention']">
            <es-invention-title>
              <xsl:value-of select="$basicFilingInfo/string[@key='titleOfInvention']" />
            </es-invention-title>
          </xsl:if>
        </patent>
      </xsl:if>

    </past-record>
  </xsl:template>
</xsl:stylesheet>