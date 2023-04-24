<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xal="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
    <xsl:param name="submissionJson"/>
    <xsl:param name="configJson"/>
    <xsl:param name="dateProduced"/>

    <xsl:variable name="submissionXml" select="json-to-xml($submissionJson)"/>
    <xsl:variable name="configXml" select="json-to-xml($configJson)"/>

    <xsl:output
            encoding="UTF-8"
            method="xml"
            indent="yes"
    />

    <xsl:template name="initial">
        <xsl:call-template name="main">
            <xsl:with-param name="submission" select="$submissionXml/map"/>
            <xsl:with-param name="config" select="$configXml/map"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="main">
        <xsl:param name="submission"/>
        <xsl:param name="config"/>

        <xsl:result-document doctype-system="{$config/map[@key='annexF']/map[@key='filing']/map[@key='result-filing']/string[@key='dtd']}">
            <result-filing>
                <xsl:attribute name="dtd-version">
                    <xsl:value-of select="$config/map[@key='annexF']/map[@key='filing']/map[@key='result-filing']/string[@key='version']"/>
                </xsl:attribute>
                <xsl:attribute name="lang">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
                </xsl:attribute>
                <xsl:attribute name="status">
                    <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='status']"/>
                </xsl:attribute>

                <xsl:call-template name="server-software">
                    <xsl:with-param name="softwareName" select="$config/map[@key='header']/string[@key='software-name']"/>
                    <xsl:with-param name="softwareVersion" select="$config/map[@key='header']/string[@key='software-version']"/>
                </xsl:call-template>

                <xsl:call-template name="client-software">
                    <xsl:with-param name="softwareName" select="$config/map[@key='header']/string[@key='software-name']"/>
                    <xsl:with-param name="softwareVersion" select="$config/map[@key='header']/string[@key='software-version']"/>
                    <xsl:with-param name="formType" select="$config/map[@key='header']/string[@key='form-type']"/>
                </xsl:call-template>

                <xsl:call-template name="filing-procedure">
                    <xsl:with-param name="submission" select="$submission"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>

                <xsl:call-template name="received-on">
                    <xsl:with-param name="submission" select="$submission"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>

                <file-reference-id>
                    <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='userReference']" />
                </file-reference-id>

                <wad-message-digest>
                    <xsl:value-of select="$submission/map[@key='packageData']/map[@key='signedPackageFile']/string[@key='digest']"/>
                </wad-message-digest>

                <xsl:call-template name="olf-names">
                    <xsl:with-param name="parties" select="$submission/map[@key='parties']"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>

<!-- TODO Ask BAs POs about this section -->
<!--                <xsl:call-template name="olf-signers">-->
<!--                    <xsl:with-param name="config" select="$config"/>-->
<!--                </xsl:call-template>-->

                <!-- TODO Ask BAs POs about what means this result -->
                <olf-result>
                    <olf-status>
                        <xsl:attribute name="id">
                            <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='olf-status-id']"/>
                        </xsl:attribute>
                        <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='olf-status']" />
                    </olf-status>
                </olf-result>

                <xsl:call-template name="file-list">
                    <xsl:with-param name="attachments" select="$submission/array[@key='attachments']"/>
                </xsl:call-template>

            </result-filing>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="server-software">
        <xsl:param name="softwareName" />
        <xsl:param name="softwareVersion" />

        <server-software>
            <software-name>
                <xsl:value-of select="$softwareName" />
            </software-name>
            <software-version>
                <xsl:value-of select="$softwareVersion" />
            </software-version>
            <software-message/>
        </server-software>
    </xsl:template>

    <xsl:template name="client-software">
        <xsl:param name="softwareName" />
        <xsl:param name="softwareVersion" />
        <xsl:param name="formType" />

        <client-software>
            <software-name>
                <xsl:value-of select="$softwareName" />
            </software-name>
            <software-version>
                <xsl:value-of select="$softwareVersion" />
            </software-version>
            <software-message>
                <xsl:value-of select="concat('formType=', $formType, ';formVersion=001')" />
            </software-message>
            <filing-type>
                <xsl:value-of select="concat('submission ', $formType, ' v.001')" />
            </filing-type>
        </client-software>
    </xsl:template>

    <xsl:template name="filing-procedure">
        <xsl:param name="submission" />
        <xsl:param name="config" />

        <filing-procedure>
            <xsl:attribute name="form">
                <xsl:value-of select="$config/map[@key='header']/string[@key='form-type']"/>
            </xsl:attribute>
            <xsl:attribute name="version">
                <xsl:value-of select="'001'"/>
            </xsl:attribute>
            <xsl:attribute name="filing-mode">
                <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='filing-mode']"/>
            </xsl:attribute>
            <xsl:attribute name="lang">
                <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
            </xsl:attribute>
            <xsl:attribute name="request-entity-name">
                <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='request-entity-name']"/>
            </xsl:attribute>
            <xsl:attribute name="applnr-origin">
                <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='applnr-origin']"/>
            </xsl:attribute>

            <submission-id>
                <xsl:value-of select="$submission/string[@key='id']"/>
            </submission-id>

            <document-id>
                <xsl:attribute name="lang">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
                </xsl:attribute>

                <country>
                    <xsl:value-of select="$submission/string[@key='receivingOffice']"/>
                </country>
                <doc-number>
                    <xsl:value-of select="$submission/map[@key='receipt']/string[@key='applicationNumber']" />
                </doc-number>
            </document-id>
            <initial-ro>
                <xsl:attribute name="country">
                    <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='initial-ro']"/>
                </xsl:attribute>
            </initial-ro>
            <final-ro>
                <xsl:attribute name="country">
                    <xsl:value-of select="$submission/string[@key='receivingOffice']"/>
                </xsl:attribute>
            </final-ro>
        </filing-procedure>
    </xsl:template>

    <xsl:template name="received-on">
        <xsl:param name="submission" />
        <xsl:param name="config" />

        <received-on>
            <start-timestamp>
                <!-- TODO review how to get the timezone -->
                <xsl:attribute name="timezone">
                    <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='timezone']"/>
                </xsl:attribute>

                <date>
                    <xsl:value-of select="concat(substring($submission/string[@key='createdDate'],1,4), substring($submission/string[@key='createdDate'],6,2), substring($submission/string[@key='createdDate'],9,2))"/>
                </date>
                <time>
                    <xsl:value-of select="concat(substring($submission/string[@key='createdDate'],12,2), substring($submission/string[@key='createdDate'],15,2))"/>
                </time>
            </start-timestamp>

            <receiving-timestamp>
                <!-- TODO review how to get the timezone -->
                <xsl:attribute name="timezone">
                    <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='timezone']"/>
                </xsl:attribute>

                <date>
                    <xsl:value-of select="concat(substring($submission/map[@key='receipt']/string[@key='senderDate'],1,4), substring($submission/map[@key='receipt']/string[@key='senderDate'],6,2), substring($submission/map[@key='receipt']/string[@key='senderDate'],9,2))"/>
                </date>
                <time>
                    <xsl:value-of select="concat(substring($submission/map[@key='receipt']/string[@key='senderDate'],12,2), substring($submission/map[@key='receipt']/string[@key='senderDate'],15,2))"/>
                </time>
            </receiving-timestamp>
        </received-on>
    </xsl:template>

    <xsl:template name="olf-names">
        <xsl:param name="parties" />
        <xsl:param name="config" />
        <olf-names>
            <xsl:if test="$parties/array[@key='applicants'] != ''">
                <xsl:call-template name="applicants">
                    <xsl:with-param name="applicants" select="$parties/array[@key='applicants']"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$parties/array[@key='employees'] != ''">
                <xsl:call-template name="employees">
                    <xsl:with-param name="employees" select="$parties/array[@key='employees']"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$parties/array[@key='inventors'] != ''">
                <xsl:call-template name="inventors">
                    <xsl:with-param name="inventors" select="$parties/array[@key='inventors']"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$parties/array[@key='representatives'] != ''">
                <xsl:call-template name="agents">
                    <xsl:with-param name="agents" select="$parties/array[@key='representatives']"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>
            </xsl:if>

        </olf-names>
    </xsl:template>

    <xsl:template name="olf-signers">
        <xsl:param name="config" />
        <olf-signers>
        </olf-signers>
    </xsl:template>

    <xsl:template name="file-list">
        <xsl:param name="attachments"/>

        <filelist>
            <xsl:for-each select="$attachments/map">
                <file-content>
                    <xsl:attribute name="id">
                        <xsl:value-of select="current()/string[@key='fileName']"/>
                    </xsl:attribute>
                    <xsl:attribute name="document-name">
                        <xsl:value-of select="current()/string[@key='docTypeLabel']"/>
                    </xsl:attribute>
                    <xsl:attribute name="file-name">
                        <xsl:value-of select="current()/string[@key='fileName']"/>
                    </xsl:attribute>
                    <xsl:attribute name="file-type">
                        <xsl:value-of select="current()/string[@key='fileExtension']"/>
                    </xsl:attribute>
                    <xsl:attribute name="size">
                        <xsl:value-of select="current()/number[@key='bytes']"/>
                    </xsl:attribute>
                    <xsl:attribute name="date-produced">
                        <xsl:value-of select="current()/string[@key='createdDate']"/>
                    </xsl:attribute>
                    <xsl:attribute name="full-xml">
                        <xsl:choose>
                            <xsl:when test="current()/string[@key='fileExtension'] = 'xml'">
                                <xsl:value-of select="'yes'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'no'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="applicant-file-name">
                        <xsl:value-of select="current()/string[@key='originalFileName']"/>
                    </xsl:attribute>
                    <xsl:attribute name="total-number-pages">
                        <xsl:choose>
                            <xsl:when test="current()/number[@key='totalPages'] != ''">
                                <xsl:value-of select="current()/number[@key='totalPages']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'1'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>

                    <xsl:if test="current()/string[@key='attachmentType'] = 'COMBINED'">
                        <xsl:for-each select="current()/array[@key='combinedFileTypeScopes']/map">
                            <section-document>
                                <xsl:attribute name="section-document-name">
                                    <xsl:value-of select="current()/string[@key='type']"/>
                                </xsl:attribute>
                                <xsl:attribute name="first-page">
                                    <xsl:value-of select="current()/number[@key='start']"/>
                                </xsl:attribute>
                                <xsl:attribute name="last-page">
                                    <xsl:value-of select="current()/number[@key='end']"/>
                                </xsl:attribute>
                                <xsl:attribute name="number-pages">
                                    <xsl:value-of select="(current()/number[@key='end'] - current()/number[@key='start']) + 1"/>
                                </xsl:attribute>
                            </section-document>
                        </xsl:for-each>
                    </xsl:if>
                </file-content>
            </xsl:for-each>
        </filelist>
    </xsl:template>

    <xsl:template name="applicants">
        <xsl:param name="applicants" />
        <xsl:param name="config" />

        <xsl:for-each select="$applicants/map">
            <olf-applicant>
                <xsl:attribute name="app-type">
                    <xsl:choose>
                        <xsl:when test="current()/boolean[@key='inventor']">
                            <xsl:value-of select="'applicant-inventor'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'applicant'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="designation">
                    <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='designation']"/>
                </xsl:attribute>

                <xsl:call-template name="addressBook">
                    <xsl:with-param name="party" select="current()"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>


            </olf-applicant>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="employees">
        <xsl:param name="employees" />
        <xsl:param name="config" />

        <xsl:for-each select="$employees/map">
            <olf-applicant>
                <xsl:attribute name="app-type">
                    <xsl:value-of select="'employee'" />
                </xsl:attribute>
                <xsl:attribute name="designation">
                    <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='designation']"/>
                </xsl:attribute>

                <xsl:call-template name="addressBook">
                    <xsl:with-param name="party" select="current()"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>


            </olf-applicant>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="inventors">
        <xsl:param name="inventors" />
        <xsl:param name="config" />

        <xsl:for-each select="$inventors/map">
            <xsl:if test="not(current()/boolean[@key='isDeceased'])">
                <olf-inventor>
                    <xsl:attribute name="designation">
                        <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='designation']"/>
                    </xsl:attribute>
                    <xsl:attribute name="waiver">
                        <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='waiver']"/>
                    </xsl:attribute>
                    <xsl:attribute name="renunciation">
                        <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='renunciation']"/>
                    </xsl:attribute>
                    <!-- TODO Important ! This information is not mandatory in our Frontend, however it is mandatory in the
ep dtd Forcing a default value at the moment but it has to be review when the pilots start as
the dtd will change -->
                    <xsl:attribute name="inv-rights">
                        <xsl:choose>
                            <xsl:when test="current()/string[@key='declarationOfRights'] = 'EMPLOYER'">
                                <xsl:value-of select="'employee'"/>
                            </xsl:when>
                            <xsl:when test="current()/string[@key='declarationOfRights'] = 'SUCCESSOR'">
                                <xsl:value-of select="'successor'"/>
                            </xsl:when>
                            <xsl:when test="current()/string[@key='declarationOfRights'] = 'AGREEMENT'">
                                <xsl:value-of select="'under-agreement'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'under-agreement'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="inv-rights-date">
                        <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='inv-rights-date']"/>
                    </xsl:attribute>


                    <xsl:call-template name="addressBook">
                        <xsl:with-param name="party" select="current()"/>
                        <xsl:with-param name="config" select="$config"/>
                    </xsl:call-template>

                </olf-inventor>
            </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="$inventors/map">
            <xsl:if test="current()/boolean[@key='isDeceased']">
                <olf-deceased-inventor>
                    <xsl:call-template name="addressBook">
                        <xsl:with-param name="party" select="current()"/>
                        <xsl:with-param name="config" select="$config"/>
                    </xsl:call-template>
                </olf-deceased-inventor>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="agents">
        <xsl:param name="agents" />
        <xsl:param name="config" />

        <xsl:for-each select="$agents/map">
            <olf-agent>
                <xsl:attribute name="rep-type">
                    <xsl:if test="current()/string[@key='role'] = 'LEGAL_PRACTITIONER'">
                        <xsl:value-of select="'attorney'"/>
                    </xsl:if>
                    <xsl:if test="current()/string[@key='role'] = 'ASSOCIATION'">
                        <xsl:value-of select="'common-representative'"/>
                    </xsl:if>
                    <xsl:if test="current()/string[@key='role'] = 'PROFESSIONAL_REPRESENTATIVE'">
                        <xsl:value-of select="'agent'"/>
                    </xsl:if>
                    <xsl:if test="current()/string[@key='role'] = 'AGENT_LEGAL_ENTITY'">
                        <xsl:value-of select="'agent'"/>
                    </xsl:if>
                    <xsl:if test="current()/string[@key='role'] = 'AGENT_NATURAL_PERSON'">
                        <xsl:value-of select="'agent'"/>
                    </xsl:if>
                    <xsl:if test="current()/string[@key='role'] = 'REPRESENTATIVE_LEGAL_ENTITY'">
                        <xsl:value-of select="'common-representative'"/>
                    </xsl:if>
                    <xsl:if test="current()/string[@key='role'] = 'REPRESENTATIVE_NATURAL_PERSON'">
                        <xsl:value-of select="'common-representative'"/>
                    </xsl:if>
                    <xsl:if test="current()/string[@key='role'] = 'REPRESENTATIVE_EMPLOYEE'">
                        <xsl:value-of select="'common-representative'"/>
                    </xsl:if>
                </xsl:attribute>
                <xsl:attribute name="rep-address">
                    <xsl:choose>
                        <xsl:when test="current()/map[@key='contactDetails']/string[@key='streetAddress'] != ''">
                            <xsl:value-of select="'yes'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'no'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <!-- TODO in the dtd the values are authorisation-code  (1 | 2 | 3 | 4) ask BAs POs what does the numbers means -->
                <xsl:attribute name="authorisation-code">
                    <xsl:value-of select="$config/map[@key='wad']/map[@key='result-filing']/string[@key='authorisation-code']"/>
                </xsl:attribute>

                <xsl:call-template name="addressBook">
                    <xsl:with-param name="party" select="current()"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>
            </olf-agent>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="addressBook">
        <xsl:param name="party"/>
        <xsl:param name="config"/>

        <addressbook>
            <xsl:attribute name="lang">
                <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
            </xsl:attribute>

            <xsl:if test="$party/map[@key='personalDetails'] != ''">
                <xsl:call-template name="personalDetails">
                    <xsl:with-param name="prefix" >
                        <xsl:value-of select="$party/map[@key='personalDetails']/string[@key='title']"/>
                    </xsl:with-param>
                    <xsl:with-param name="lastName" >
                        <xsl:value-of select="$party/map[@key='personalDetails']/string[@key='lastName']"/>
                    </xsl:with-param>
                    <xsl:with-param name="firstName" >
                        <xsl:value-of select="$party/map[@key='personalDetails']/string[@key='firstName']"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$party/map[@key='companyDetails'] != ''">
                <xsl:call-template name="companyDetails">
                    <xsl:with-param name="name" >
                        <xsl:value-of select="$party/map[@key='companyDetails']/string[@key='company']"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$party/map[@key='company']/string[@key='company'] != ''">
                <xsl:call-template name="businessInfo">
                    <xsl:with-param name="orgName">
                        <xsl:value-of select="$party/map[@key='company']/string[@key='company']"/>
                    </xsl:with-param>
                    <xsl:with-param name="department">
                        <xsl:value-of select="$party/map[@key='company']/string[@key='department']"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>

            <xsl:call-template name="addressDetail">
                <xsl:with-param name="poBox">
                    <xsl:value-of select="$party/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='poBox']"/>
                </xsl:with-param>
                <xsl:with-param name="street">
                    <xsl:value-of select="$party/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='streetAddress']"/>
                </xsl:with-param>
                <xsl:with-param name="city">
                    <xsl:value-of select="$party/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='city']"/>
                </xsl:with-param>
                <xsl:with-param name="state">
                    <xsl:value-of select="$party/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='department']"/>
                </xsl:with-param>
                <xsl:with-param name="postcode">
                    <xsl:value-of select="$party/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='postalCode']"/>
                </xsl:with-param>
                <xsl:with-param name="addressCountry">
                    <xsl:value-of select="$party/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='country']"/>
                </xsl:with-param>
            </xsl:call-template>

            <xsl:if test="$party/string[@key='role'] != 'INVENTOR'">
                <xsl:call-template name="contactDetail">
                    <xsl:with-param name="phone">
                        <xsl:value-of select="$party/map[@key='contactDetails']/string[@key='telephone']"/>
                    </xsl:with-param>
                    <xsl:with-param name="fax">
                        <xsl:value-of select="$party/map[@key='contactDetails']/string[@key='fax']"/>
                    </xsl:with-param>
                    <xsl:with-param name="email">
                        <xsl:value-of select="$party/map[@key='contactDetails']/string[@key='email']"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>

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

    <xsl:template name="addressDetail">
        <xsl:param name="poBox" />
        <xsl:param name="street" />
        <xsl:param name="city" />
        <xsl:param name="state" />
        <xsl:param name="postcode" />
        <xsl:param name="addressCountry" />

        <address>
            <pobox>
                <xsl:value-of select="$poBox"/>
            </pobox>
            <street>
                <xsl:value-of select="$street"/>
            </street>
            <city>
                <xsl:value-of select="$city"/>
            </city>
            <state>
                <xsl:value-of select="$state"/>
            </state>
            <postcode>
                <xsl:value-of select="$postcode"/>
            </postcode>
            <country>
                <xsl:value-of select="$addressCountry"/>
            </country>
        </address>
    </xsl:template>

    <xsl:template name="contactDetail">
        <xsl:param name="phone" />
        <xsl:param name="fax" />
        <xsl:param name="email" />

        <phone>
            <xsl:value-of select="$phone"/>
        </phone>
        <fax>
            <xsl:value-of select="$fax"/>
        </fax>
        <email>
            <xsl:value-of select="$email"/>
        </email>
    </xsl:template>

</xsl:stylesheet>