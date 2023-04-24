<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xal="http://www.w3.org/1999/XSL/Transform"
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
      <se-ep-request>
        <xsl:attribute name="lang">
          <xsl:value-of select="$config/map[@key='header']/string[@key='language']" />
        </xsl:attribute>
        <xsl:attribute name="dtd-version">
          <xsl:value-of select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request']/string[@key='version']"/>
        </xsl:attribute>
        <xsl:attribute name="file">
          <xsl:value-of select="''"/>
        </xsl:attribute>
        <xsl:attribute name="status">
          <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='status']"/>
        </xsl:attribute>
        <xsl:attribute name="date-produced">
          <xsl:value-of  select="current-dateTime()"/>
        </xsl:attribute>
        <xsl:attribute name="ro">
          <xsl:value-of select="$config/map[@key='header']/string[@key='receiving-office']" />
        </xsl:attribute>
        <xsl:attribute name="produced-by">
          <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='produced-by']"/>
        </xsl:attribute>

        <xsl:call-template name="main">
          <xsl:with-param name="submission" select="$submission"/>
          <xsl:with-param name="config" select="$config"/>
        </xsl:call-template>
      </se-ep-request>
    </xsl:result-document>

  </xsl:template>

  <xsl:template name="main">
    <xsl:param name="submission"/>
    <xsl:param name="config"/>
    <file-reference-id>
      <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='userReference']" />
    </file-reference-id>

    <request-petition>
    </request-petition>

    <invention-title>
      <xsl:attribute name="lang">
        <xsl:value-of select="$config/map[@key='header']/string[@key='language']" />
      </xsl:attribute>

      <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='titleOfInvention']"/>
    </invention-title>

    <xsl:call-template name="parties">
      <xsl:with-param name="object" select="$submission/map[@key='parties']"/>
      <xsl:with-param name="config" select="$config"/>
    </xsl:call-template>

    <xsl:call-template name="check-list">
      <xsl:with-param name="attachments" select="$submission/array[@key='attachments']"/>
    </xsl:call-template>

    <xsl:call-template name="figure-to-publish">
      <xsl:with-param name="attachments" select="$submission/array[@key='attachments']"/>
    </xsl:call-template>

    <language-of-filing>
      <xsl:value-of select="$config/map[@key='header']/string[@key='language']" />
    </language-of-filing>

    <xsl:call-template name="signatories">
      <xsl:with-param name="signature" select="$submission/map[@key='signature']"/>
    </xsl:call-template>

    <xsl:call-template name="office-specific-data">
      <xsl:with-param name="object" select="$submission"/>
      <xsl:with-param name="config" select="$config"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="figure-to-publish">
    <xsl:param name="attachments" />

    <xsl:variable name="figureToPublish">
      <xsl:for-each select="$attachments/map">
        <xsl:if test="current()/string[@key='attachmentType'] = 'ABSTRACT'">
          <xsl:value-of select="current()/string[@key='figureToBePublished']"/>
        </xsl:if>

        <xsl:if test="current()/string[@key='attachmentType'] = 'COMBINED'">
          <xsl:for-each select="current()/array[@key='combinedFileTypeScopes']/map">
            <xsl:if test="current()/string[@key='type'] = 'ABSTRACT'">
              <xsl:value-of select="current()/string[@key='figureToBePublished']"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <figure-to-publish>
      <fig-number>
        <xsl:value-of select="$figureToPublish"/>
      </fig-number>
    </figure-to-publish>
  </xsl:template>

  <xsl:template name="parties">
    <xsl:param name="object" />
    <xsl:param name="config" />

    <parties>
      <xsl:call-template name="applicants">
        <xsl:with-param name="applicants" select="$object/array[@key='applicants']"/>
        <xsl:with-param name="config" select="$config"/>
      </xsl:call-template>

      <xsl:if test="$object/array[@key='representatives'] != ''">
        <xsl:call-template name="agents">
          <xsl:with-param name="agents" select="$object/array[@key='representatives']"/>
          <xsl:with-param name="config" select="$config"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:if test="$object/array[@key='inventors'] != ''">
        <xsl:call-template name="inventors">
          <xsl:with-param name="inventors" select="$object/array[@key='inventors']"/>
          <xsl:with-param name="config" select="$config"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:if test="$object/array[@key='communicationAddress'] != ''">
        <xsl:call-template name="communicationAddress">
          <xsl:with-param name="communicationAddress" select="$object/array[@key='communicationAddress']"/>
          <xsl:with-param name="config" select="$config"/>
        </xsl:call-template>
      </xsl:if>

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
        <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='appt-type']"/>
      </xsl:attribute>
      <xsl:attribute name="designation">
        <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='designation']"/>
      </xsl:attribute>

      <xsl:call-template name="addressBook">
        <xsl:with-param name="object" select="$object"/>
        <xsl:with-param name="language" select="$config/map[@key='header']/string[@key='language']"/>
      </xsl:call-template>

      <xsl:if test="$object/map[@key='personalDetails'] != ''">
        <xsl:call-template name="nationality">
          <xsl:with-param name="nationality" select="$object/map[@key='personalDetails']/string[@key='nationality']"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:if test="$object/map[@key='companyDetails'] != ''">
        <xsl:call-template name="nationality">
          <xsl:with-param name="nationality" select="$object/map[@key='companyDetails']/string[@key='placeOfBusiness']"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:call-template name="residence">
        <xsl:with-param name="residence" select="$object/map[@key='personalDetails']/map[@key='residenceAddress']/string[@key='nationality']"/>
      </xsl:call-template>

    </applicant>
  </xsl:template>

  <xsl:template name="inventors">
    <xsl:param name="inventors" />
    <xsl:param name="config" />

    <inventors>
      <xsl:for-each select="$inventors/map">
        <xsl:call-template name="inventor">
          <xsl:with-param name="object" select="current()"/>
          <xsl:with-param name="config" select="$config"/>
        </xsl:call-template>
      </xsl:for-each>

    </inventors>
  </xsl:template>

  <xsl:template name="inventor">
    <xsl:param name="object" />
    <xsl:param name="config" />

    <xsl:variable name="invRights">
      <!-- TODO Important ! This information is not mandatory in our Frontend, however it is mandatory in the
      ep dtd Forcing a default value at the moment but it has to be review when the pilots start as
      the dtd will change -->
      <xsl:choose>
        <xsl:when test="$object/string[@key='declarationOfRights'] = 'EMPLOYER'">
          <xsl:value-of select="'employee'"/>
        </xsl:when>
        <xsl:when test="$object/string[@key='declarationOfRights'] = 'SUCCESSOR'">
          <xsl:value-of select="'successor'"/>
        </xsl:when>
        <xsl:when test="$object/string[@key='declarationOfRights'] = 'AGREEMENT'">
          <xsl:value-of select="'under-agreement'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'under-agreement'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <inventor>
      <xsl:attribute name="sequence">
        <xsl:value-of select="$object/number[@key='sequenceNumber']"/>
      </xsl:attribute>
      <xsl:attribute name="designation">
        <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='designation']"/>
      </xsl:attribute>

      <xsl:call-template name="addressBook">
        <xsl:with-param name="object" select="$object"/>
        <xsl:with-param name="language" select="$config/map[@key='header']/string[@key='language']" />
      </xsl:call-template>
    </inventor>
  </xsl:template>

  <xsl:template name="agents">
    <xsl:param name="agents" />
    <xsl:param name="config" />

    <agents>
      <xsl:for-each select="$agents/map">
        <xsl:call-template name="agent">
          <xsl:with-param name="object" select="current()"/>
          <xsl:with-param name="language" select="$config/map[@key='header']/string[@key='language']" />
        </xsl:call-template>
      </xsl:for-each>

    </agents>
  </xsl:template>

  <xsl:template name="agent">
    <xsl:param name="object" />
    <xsl:param name="language" />

    <xsl:variable name="repType">
      <xsl:if test="$object/string[@key='role'] = 'REPRESENTATIVE_LEGAL_ENTITY' or $object/string[@key='role'] = 'REPRESENTATIVE_NATURAL_PERSON'">
        <xsl:value-of select="'attorney'"/>
      </xsl:if>
      <xsl:if test="$object/string[@key='role'] = 'REPRESENTATIVE_EMPLOYEE'">
        <xsl:value-of select="'common-representative'"/>
      </xsl:if>
      <xsl:if test="$object/string[@key='role'] = 'AGENT_LEGAL_ENTITY' or $object/string[@key='role'] = 'AGENT_NATURAL_PERSON'">
        <xsl:value-of select="'agent'"/>
      </xsl:if>

    </xsl:variable>

    <agent>
      <xsl:attribute name="rep-type">
        <xsl:value-of select="$repType"/>
      </xsl:attribute>
      <xsl:attribute name="sequence">
        <xsl:value-of select="$object/number[@key='sequenceNumber']"/>
      </xsl:attribute>

      <xsl:call-template name="addressBook">
        <xsl:with-param name="object" select="$object"/>
        <xsl:with-param name="language" select="$language" />
      </xsl:call-template>

      <se-pow-att>
        <xsl:attribute name="se-ch-pow-att">
          <xsl:value-of select="'false'"/>
        </xsl:attribute>
      </se-pow-att>
      <se-number-general-power-of-attorney>
        <xsl:attribute name="se-ch-gen-pow-att">
          <xsl:value-of select="'false'"/>
        </xsl:attribute>
        <xsl:attribute name="se-number-general-power-of-attorney">
          <xsl:value-of select="''"/>
        </xsl:attribute>
      </se-number-general-power-of-attorney>
    </agent>
  </xsl:template>

  <xsl:template name="communicationAddress">
    <xsl:param name="communicationAddress"/>
    <xsl:param name="config" />

    <correspondence-address>
      <xsl:for-each select="$communicationAddress/map">
        <addressbook>
          <xsl:attribute name="lang">
            <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
          </xsl:attribute>

          <xsl:if test="current()/string[@key='role'] = 'COMMUNICATION_ADDRESS_NATURAL_PERSON'">
            <xsl:call-template name="personalDetails">
              <xsl:with-param name="prefix" >
                <xsl:value-of select="''"/>
              </xsl:with-param>
              <xsl:with-param name="lastName" >
                <xsl:value-of select="current()/string[@key='lastName']"/>
              </xsl:with-param>
              <xsl:with-param name="firstName" >
                <xsl:value-of select="current()/string[@key='firstName']"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="current()/string[@key='role'] = 'COMMUNICATION_ADDRESS_LEGAL_ENTITY'">
            <xsl:call-template name="companyDetails">
              <xsl:with-param name="name" >
                <xsl:value-of select="current()/string[@key='company']"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>

          <xsl:call-template name="addressDetail">
            <xsl:with-param name="poBox">
              <xsl:value-of select="current()/map[@key='correspondenceAddress']/string[@key='poBox']"/>
            </xsl:with-param>
            <xsl:with-param name="street">
              <xsl:value-of select="current()/map[@key='correspondenceAddress']/string[@key='streetAddress']"/>
            </xsl:with-param>
            <xsl:with-param name="city">
              <xsl:value-of select="current()/map[@key='correspondenceAddress']/string[@key='city']"/>
            </xsl:with-param>
            <xsl:with-param name="postcode">
              <xsl:value-of select="current()/map[@key='correspondenceAddress']/string[@key='postalCode']"/>
            </xsl:with-param>
            <xsl:with-param name="addressCountry">
              <xsl:value-of select="current()/map[@key='correspondenceAddress']/string[@key='country']"/>
            </xsl:with-param>
          </xsl:call-template>

          <xsl:call-template name="contactDetail">
            <xsl:with-param name="phone">
              <xsl:value-of select="current()/map[@key='correspondenceAddress']/string[@key='telephone']"/>
            </xsl:with-param>
            <xsl:with-param name="email">
              <xsl:value-of select="current()/map[@key='correspondenceAddress']/string[@key='email']"/>
            </xsl:with-param>
          </xsl:call-template>
        </addressbook>
      </xsl:for-each>
    </correspondence-address>
  </xsl:template>

  <xsl:template name="check-list">
    <xsl:param name="attachments" />

    <se-check-list>
      <xsl:for-each select="$attachments/map">
        <xsl:if test="current()/string[@key='attachmentType'] = 'DESCRIPTION'">
          <cl-description>
            <xsl:attribute name="page-count">
              <xsl:value-of select="current()/number[@key='totalPages']"/>
            </xsl:attribute>
            <xsl:attribute name="ppf">
              <xsl:value-of select="'1'"/>
            </xsl:attribute>
            <xsl:attribute name="ppl">
              <xsl:value-of select="current()/number[@key='totalPages']"/>
            </xsl:attribute>
          </cl-description>
        </xsl:if>
        <xsl:if test="current()/string[@key='attachmentType'] = 'CLAIMS'">
          <cl-claims>
            <xsl:attribute name="page-count">
              <xsl:value-of select="current()/number[@key='totalPages']"/>
            </xsl:attribute>
            <xsl:attribute name="ppf">
              <xsl:value-of select="'1'"/>
            </xsl:attribute>
            <xsl:attribute name="ppl">
              <xsl:value-of select="current()/number[@key='totalPages']"/>
            </xsl:attribute>
            <xsl:attribute name="number-of-claims">
              <xsl:value-of select="current()/number[@key='numberOfClaims']"/>
            </xsl:attribute>
          </cl-claims>
        </xsl:if>
        <xsl:if test="current()/string[@key='attachmentType'] = 'ABSTRACT'">
          <cl-abstract>
            <xsl:attribute name="page-count">
              <xsl:value-of select="current()/number[@key='totalPages']"/>
            </xsl:attribute>
            <xsl:attribute name="ppf">
              <xsl:value-of select="'1'"/>
            </xsl:attribute>
            <xsl:attribute name="ppl">
              <xsl:value-of select="current()/number[@key='totalPages']"/>
            </xsl:attribute>
          </cl-abstract>
        </xsl:if>
        <xsl:if test="current()/string[@key='attachmentType'] = 'DRAWINGS'">
          <cl-drawings>
            <xsl:attribute name="page-count">
              <xsl:value-of select="current()/number[@key='totalPages']"/>
            </xsl:attribute>
            <xsl:attribute name="ppf">
              <xsl:value-of select="'1'"/>
            </xsl:attribute>
            <xsl:attribute name="ppl">
              <xsl:value-of select="current()/number[@key='totalPages']"/>
            </xsl:attribute>
          </cl-drawings>
        </xsl:if>
        <xsl:if test="current()/string[@key='attachmentType'] = 'COMBINED'">
          <xsl:call-template name="combinedCheckList">
            <xsl:with-param name="typeScopes" select="current()/array[@key='combinedFileTypeScopes']"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="current()/string[@key='attachmentType'] = 'GENERAL' or
                              current()/string[@key='attachmentType'] = 'SPECIFIC' or
                              current()/string[@key='attachmentType'] = 'SEARCH' or
                              current()/string[@key='attachmentType'] = 'OTHER'" >
          <cl-other-document>
            <xsl:value-of select="current()/string[@key='description']"/>
          </cl-other-document>
        </xsl:if>
      </xsl:for-each>

    </se-check-list>
  </xsl:template>

  <xsl:template name="signatories">
    <xsl:param name="signature" />

    <signatories>
      <signatory>
        <name>
          <xsl:attribute name="name-type">
            <xsl:value-of select="'natural'"/>
          </xsl:attribute>

          <xsl:value-of select="$signature/string[@key='signerFullName']"/>
        </name>
        <electronic-signature>
          <xsl:attribute name="date">
            <xsl:value-of select="$signature/string[@key='signatureDate']"/>
          </xsl:attribute>
          <!-- TODO  find how to fill the place signed -->
          <xsl:attribute name="place-signed">
            <xsl:value-of select="'place'"/>
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
              <enhanced-signature>
                <pkcs7>
                  <!-- TODO  find how to fill pkcs7 -->
                </pkcs7>
              </enhanced-signature>
            </xsl:otherwise>
          </xsl:choose>

        </electronic-signature>
        <signatory-capacity>
          <xsl:value-of select="$signature/string[@key='signerCapacity']"/>
        </signatory-capacity>
      </signatory>
    </signatories>
  </xsl:template>

  <xsl:template name="office-specific-data">
    <xsl:param name="object" />
    <xsl:param name="config" />

    <office-specific-data>
      <xsl:attribute name="office">
        <xsl:value-of select="$config/map[@key='header']/string[@key='receiving-office']"/>
      </xsl:attribute>
      <xsl:attribute name="office-dtd">
        <xsl:value-of select="''"/>
      </xsl:attribute>
      <xsl:attribute name="file">
        <xsl:value-of select="''"/>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="''"/>
      </xsl:attribute>
      <xsl:attribute name="lang">
        <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
      </xsl:attribute>
      <xsl:attribute name="status">
        <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='status']"/>
      </xsl:attribute>

      <past-record>
        <ep-application>
          <xsl:attribute name="lang">
            <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
          </xsl:attribute>

          <application-number>
            <xsl:value-of select="$object/map[@key='basicFilingInfo']/map[@key='applicationNumberContainer']/string[@key='applicationNumber']"/>
          </application-number>

          <publication-number>
            <xsl:value-of select="$object/map[@key='basicFilingInfo']/map[@key='applicationNumberContainer']/string[@key='publicationNumber']"/>
          </publication-number>

          <grant-date>
            <xsl:value-of select="$object/map[@key='basicFilingInfo']/string[@key='grantDate']"/>
          </grant-date>
        </ep-application>
        <translation-type>
          <se-section-88></se-section-88>
        </translation-type>
      </past-record>

    </office-specific-data>
  </xsl:template>

  <xsl:template name="combinedCheckList">
    <xsl:param name="typeScopes" />

    <xsl:for-each select="$typeScopes/map">
      <xsl:if test="current()/string[@key='type'] = 'DESCRIPTION'">
        <cl-description>
          <xsl:attribute name="page-count">
            <xsl:value-of select="(current()/number[@key='end'] - current()/number[@key='start']) + 1"/>
          </xsl:attribute>
          <xsl:attribute name="ppf">
            <xsl:value-of select="current()/number[@key='start']"/>
          </xsl:attribute>
          <xsl:attribute name="ppl">
            <xsl:value-of select="current()/number[@key='end']"/>
          </xsl:attribute>
        </cl-description>
      </xsl:if>
      <xsl:if test="current()/string[@key='type'] = 'CLAIMS'">
        <cl-claims>
          <xsl:attribute name="page-count">
            <xsl:value-of select="(current()/number[@key='end'] - current()/number[@key='start']) + 1"/>
          </xsl:attribute>
          <xsl:attribute name="ppf">
            <xsl:value-of select="current()/number[@key='start']"/>
          </xsl:attribute>
          <xsl:attribute name="ppl">
            <xsl:value-of select="current()/number[@key='end']"/>
          </xsl:attribute>
          <xsl:attribute name="number-of-claims">
            <xsl:value-of select="current()/number[@key='numberOfClaims']"/>
          </xsl:attribute>
        </cl-claims>
      </xsl:if>
      <xsl:if test="current()/string[@key='type'] = 'ABSTRACT'">
        <cl-abstract>
          <xsl:attribute name="page-count">
            <xsl:value-of select="(current()/number[@key='end'] - current()/number[@key='start']) + 1"/>
          </xsl:attribute>
          <xsl:attribute name="ppf">
            <xsl:value-of select="current()/number[@key='start']"/>
          </xsl:attribute>
          <xsl:attribute name="ppl">
            <xsl:value-of select="current()/number[@key='end']"/>
          </xsl:attribute>
        </cl-abstract>
      </xsl:if>
      <xsl:if test="current()/string[@key='type'] = 'DRAWINGS'">
        <cl-drawings>
          <xsl:attribute name="page-count">
            <xsl:value-of select="(current()/number[@key='end'] - current()/number[@key='start']) + 1"/>
          </xsl:attribute>
          <xsl:attribute name="ppf">
            <xsl:value-of select="current()/number[@key='start']"/>
          </xsl:attribute>
          <xsl:attribute name="ppl">
            <xsl:value-of select="current()/number[@key='end']"/>
          </xsl:attribute>
        </cl-drawings>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <xsl:template name="addressBook">
    <xsl:param name="object" />
    <xsl:param name="language" />

    <addressbook>
      <xsl:attribute name="lang">
        <xsl:value-of select="$language"/>
      </xsl:attribute>

      <xsl:if test="$object/map[@key='personalDetails'] != ''">
        <xsl:call-template name="personalDetails">
          <xsl:with-param name="prefix" >
            <xsl:value-of select="$object/map[@key='personalDetails']/string[@key='title']"/>
          </xsl:with-param>
          <xsl:with-param name="lastName" >
            <xsl:value-of select="$object/map[@key='personalDetails']/string[@key='lastName']"/>
          </xsl:with-param>
          <xsl:with-param name="firstName" >
            <xsl:value-of select="$object/map[@key='personalDetails']/string[@key='firstName']"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <xsl:if test="$object/map[@key='companyDetails'] != ''">
        <xsl:call-template name="companyDetails">
          <xsl:with-param name="name" >
            <xsl:value-of select="$object/map[@key='companyDetails']/string[@key='company']"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <xsl:variable name="registeredNumber">
        <xsl:choose>
          <xsl:when test="$object/map[@key='personalDetails']/string[@key='idNumber'] != ''">
            <xsl:value-of select="$object/map[@key='personalDetails']/string[@key='idNumber']"/>
          </xsl:when>
          <xsl:when test="$object/map[@key='companyDetails']/string[@key='idNumber'] != ''">
            <xsl:value-of select="$object/map[@key='companyDetails']/string[@key='registrationNumber']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="registeredNumber">
        <xsl:with-param name="registeredNumber">
          <xsl:value-of select="$registeredNumber"/>
        </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="addressDetail">
        <xsl:with-param name="poBox">
          <xsl:value-of select="$object/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='poBox']"/>
        </xsl:with-param>
        <xsl:with-param name="street">
          <xsl:value-of select="$object/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='streetAddress']"/>
        </xsl:with-param>
        <xsl:with-param name="city">
          <xsl:value-of select="$object/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='city']"/>
        </xsl:with-param>
        <xsl:with-param name="postcode">
          <xsl:value-of select="$object/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='postalCode']"/>
        </xsl:with-param>
        <xsl:with-param name="addressCountry">
          <xsl:value-of select="$object/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='country']"/>
        </xsl:with-param>
      </xsl:call-template>

        <xsl:call-template name="contactDetail">
          <xsl:with-param name="phone">
            <xsl:value-of select="$object/map[@key='contactDetails']/string[@key='telephone']"/>
          </xsl:with-param>
          <xsl:with-param name="email">
            <xsl:value-of select="$object/map[@key='contactDetails']/string[@key='email']"/>
          </xsl:with-param>
        </xsl:call-template>
    </addressbook>
  </xsl:template>

  <xsl:template name="personalDetails">
    <xsl:param name="prefix" />
    <xsl:param name="lastName" />
    <xsl:param name="firstName" />

    <prefix>
      <xsl:value-of select="$prefix"/>
    </prefix>
    <last-name>
      <xsl:value-of select="$lastName"/>
    </last-name>
    <first-name>
      <xsl:value-of select="$firstName"/>
    </first-name>
  </xsl:template>

  <xsl:template name="registeredNumber">
    <xsl:param name="registeredNumber" />
    <registered-number>
      <xsl:value-of select="$registeredNumber"/>
    </registered-number>
  </xsl:template>

  <xsl:template name="companyDetails">
    <xsl:param name="name" />
    <name>
      <xsl:value-of select="$name"/>
    </name>
  </xsl:template>

  <xsl:template name="businessInfo">
    <xsl:param name="orgName" />
    <xsl:param name="department" />

    <orgname>
      <xsl:value-of select="$orgName"/>
    </orgname>
    <department>
      <xsl:value-of select="$department"/>
    </department>
  </xsl:template>

  <xsl:template name="nationality">
    <xsl:param name="nationality" select="''"/>

    <nationality>
      <country>
        <xsl:value-of select="$nationality"/>
      </country>
    </nationality>
  </xsl:template>

  <xsl:template name="residence">
    <xsl:param name="residence" select="''"/>

    <residence>
      <country>
        <xsl:value-of select="$residence"/>
      </country>
    </residence>
  </xsl:template>

  <xsl:template name="addressDetail">
    <xsl:param name="poBox" />
    <xsl:param name="street" />
    <xsl:param name="city" />
    <xsl:param name="postcode" />
    <xsl:param name="addressCountry" />

    <address>
      <street>
        <xsl:value-of select="$street"/>
      </street>
      <postcode>
        <xsl:value-of select="$postcode"/>
      </postcode>
      <mailcode>
        <xsl:value-of select="$poBox"/>
      </mailcode>
      <city>
        <xsl:value-of select="$city"/>
      </city>
      <country>
        <xsl:value-of select="$addressCountry"/>
      </country>
    </address>
  </xsl:template>

  <xsl:template name="contactDetail">
    <xsl:param name="phone" />
    <xsl:param name="email" />

    <phone>
      <xsl:value-of select="$phone"/>
    </phone>
    <email>
      <xsl:value-of select="$email"/>
    </email>
    <organisation-number/>
  </xsl:template>

</xsl:stylesheet>