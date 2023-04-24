<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xal="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
    <xsl:param name="submissionJson"/>
    <xsl:param name="configJson"/>
    <xsl:param name="dateProduced"/>

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
            <ep-request>
                <xsl:attribute name="lang">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
                </xsl:attribute>
                <xsl:attribute name="dtd-version">
                    <xsl:value-of select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request']/string[@key='version']"/>
                </xsl:attribute>
                <xsl:attribute name="date-produced">
                    <xsl:value-of select="$dateProduced"/>
                </xsl:attribute>
                <xsl:attribute name="ro">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='country']"/>
                </xsl:attribute>
                <xsl:attribute name="produced-by">
                    <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='produced-by']"/>
                </xsl:attribute>

                <xsl:call-template name="main">
                    <xsl:with-param name="submission" select="$submission"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>
            </ep-request>
        </xsl:result-document>

    </xsl:template>

    <xsl:template name="main">
        <xsl:param name="submission"/>
        <xsl:param name="config"/>

        <file-reference-id>
            <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='userReference']" />
        </file-reference-id>

        <request-petition>
            <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='petition']"/>
        </request-petition>

        <invention-title>
            <xsl:attribute name="lang">
                <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
            </xsl:attribute>

            <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='titleOfInvention']"/>
        </invention-title>

        <xsl:call-template name="parties">
            <xsl:with-param name="object" select="$submission/map[@key='parties']"/>
            <xsl:with-param name="config" select="$config"/>
        </xsl:call-template>


        <xsl:if test="$submission/map[@key='declaration']/array[@key='priorities'] != ''">
            <xsl:call-template name="priority-claims">
                <xsl:with-param name="priorities" select="$submission/map[@key='declaration']/array[@key='priorities']"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="check-list">
            <xsl:with-param name="attachments" select="$submission/array[@key='attachments']"/>
            <xsl:with-param name="bioInfo" select="$submission/map[@key='seqlBio']/array[@key='biologicalInfos']/map"/>
        </xsl:call-template>

        <figure-to-publish>
            <xsl:call-template name="figure-to-publish">
                <xsl:with-param name="attachments" select="$submission/array[@key='attachments']"/>
            </xsl:call-template>
        </figure-to-publish>

        <ep-language-of-filing>
            <xsl:attribute name="lang-code">
                <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='lang-code']"/>
            </xsl:attribute>
            <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
        </ep-language-of-filing>

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

        <fig-number>
            <xsl:value-of select="$figureToPublish"/>
        </fig-number>
    </xsl:template>

    <xsl:template name="parties">
        <xsl:param name="object" />
        <xsl:param name="config" />

        <parties>
            <xsl:call-template name="applicants">
                <xsl:with-param name="applicants" select="$object/array[@key='applicants']"/>
                <xsl:with-param name="config" select="$config"/>
            </xsl:call-template>

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

            <xsl:if test="$object/array[@key='representatives'] != ''">
                <xsl:call-template name="agents">
                    <xsl:with-param name="agents" select="$object/array[@key='representatives']"/>
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
                    <xsl:with-param name="appType" select="'applicant'"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>
            </xsl:for-each>
        </applicants>
    </xsl:template>

    <xsl:template name="applicant">
        <xsl:param name="object" />
        <xsl:param name="appType" />
        <xsl:param name="config" />

        <applicant>
            <xsl:attribute name="sequence">
                <xsl:value-of select="$object/number[@key='sequenceNumber']"/>
            </xsl:attribute>
            <xsl:attribute name="app-type">
                <xsl:value-of select="$appType"/>
            </xsl:attribute>
            <xsl:attribute name="designation">
                <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='designation']"/>
            </xsl:attribute>

            <xsl:call-template name="addressBook">
                <xsl:with-param name="object" select="$object"/>
                <xsl:with-param name="config" select="$config"/>
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

        <ep-inventor>
            <xsl:attribute name="sequence">
                <xsl:value-of select="$object/number[@key='sequenceNumber']"/>
            </xsl:attribute>
            <xsl:attribute name="designation">
                <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='designation']"/>
            </xsl:attribute>
            <xsl:attribute name="deceased">
                <xsl:choose>
                    <xsl:when test="$object/boolean[@key='isDeceased']">
                        <xsl:value-of select="'yes'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'no'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="inv-rights">
                <xsl:value-of select="$invRights"/>
            </xsl:attribute>

            <xsl:call-template name="addressBook">
                <xsl:with-param name="object" select="$object"/>
                <xsl:with-param name="config" select="$config"/>
            </xsl:call-template>
        </ep-inventor>
    </xsl:template>

    <xsl:template name="agents">
        <xsl:param name="agents" />
        <xsl:param name="config" />

        <agents>
            <xsl:for-each select="$agents/map">
                <xsl:call-template name="agent">
                    <xsl:with-param name="object" select="current()"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>
            </xsl:for-each>

        </agents>
    </xsl:template>

    <xsl:template name="agent">
        <xsl:param name="object" />
        <xsl:param name="config" />

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

        <ep-agent>
            <xsl:attribute name="rep-type">
                <xsl:value-of select="$repType"/>
            </xsl:attribute>
            <xsl:attribute name="sequence">
                <xsl:value-of select="$object/number[@key='sequenceNumber']"/>
            </xsl:attribute>

            <xsl:call-template name="addressBook">
                <xsl:with-param name="object" select="$object"/>
                <xsl:with-param name="config" select="$config"/>
            </xsl:call-template>
        </ep-agent>
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
                        <xsl:with-param name="state">
                            <xsl:value-of select="''"/>
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
                        <xsl:with-param name="fax">
                            <xsl:value-of select="''"/>
                        </xsl:with-param>
                        <xsl:with-param name="email">
                            <xsl:value-of select="current()/map[@key='correspondenceAddress']/string[@key='email']"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </addressbook>
            </xsl:for-each>
        </correspondence-address>
    </xsl:template>

    <xsl:template name="priority-claims">
        <xsl:param name="priorities" />

        <priority-claims>
            <xsl:for-each select="$priorities/map">
                <xsl:call-template name="priority">
                    <xsl:with-param name="object" select="current()"/>
                </xsl:call-template>
            </xsl:for-each>
        </priority-claims>
    </xsl:template>

    <xsl:template name="priority">
        <xsl:param name="object" />

        <ep-priority-claim>
            <xsl:attribute name="sequence">
                <xsl:value-of select="$object/number[@key='sequenceNumber']"/>
            </xsl:attribute>
            <xsl:attribute name="kind">
                <xsl:value-of select="lower-case($object/string[@key='officeType'])"/>
            </xsl:attribute>
            <xsl:attribute name="ep-document-type">
                <xsl:value-of select="lower-case($object/string[@key='applicationKind'])"/>
            </xsl:attribute>

            <country>
                <xsl:value-of select="$object/string[@key='office']"/>
            </country>
            <doc-number>
                <xsl:value-of select="$object/string[@key='applicationNumber']"/>
            </doc-number>
            <date>
                <xsl:value-of select="$object/string[@key='filingDate']"/>
            </date>

        </ep-priority-claim>
    </xsl:template>

    <xsl:template name="check-list">
        <xsl:param name="attachments" />
        <xsl:param name="bioInfo"/>

        <check-list>

            <!-- Combine and description, drawings, claims and abstract must be interpolated -->
            <xsl:variable name="description" select="$attachments/map[string[@key='attachmentType'] = 'DESCRIPTION']"/>
            <xsl:variable name="claims" select="$attachments/map[string[@key='attachmentType'] = 'CLAIMS']"/>
            <xsl:variable name="abstract" select="$attachments/map[string[@key='attachmentType'] = 'ABSTRACT']"/>
            <xsl:variable name="drawings" select="$attachments/map[string[@key='attachmentType'] = 'DRAWINGS']"/>
            <xsl:variable name="seqListing" select="$attachments/map[string[@key='attachmentType'] = 'SEQ_LIST']"/>

            <xsl:variable name="combinedAttachment" select="$attachments/map[string[@key='attachmentType'] = 'COMBINED']"/>
            <xsl:variable name="combinedDescription" select="$combinedAttachment/array[@key='combinedFileTypeScopes']/map[string[@key='type'] = 'DESCRIPTION']"/>
            <xsl:variable name="combinedClaims" select="$combinedAttachment/array[@key='combinedFileTypeScopes']/map[string[@key='type'] = 'CLAIMS']"/>
            <xsl:variable name="combinedAbstract" select="$combinedAttachment/array[@key='combinedFileTypeScopes']/map[string[@key='type'] = 'ABSTRACT']"/>
            <xsl:variable name="combinedDrawings" select="$combinedAttachment/array[@key='combinedFileTypeScopes']/map[string[@key='type'] = 'DRAWINGS']"/>

            <xsl:if test="$description != ''">
                <xsl:call-template name="checklistItem">
                    <xsl:with-param name="checkListTagName" select="'cl-description'"/>
                    <xsl:with-param name="attachment" select="$description"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$combinedDescription != ''">
                <xsl:call-template name="combinedItem">
                    <xsl:with-param name="checkListTagName" select="'cl-description'"/>
                    <xsl:with-param name="attachment" select="$combinedAttachment"/>
                    <xsl:with-param name="typeScope" select="$combinedDescription"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$claims != ''">
                <xsl:call-template name="checklistItem">
                    <xsl:with-param name="checkListTagName" select="'cl-claims'"/>
                    <xsl:with-param name="attachment" select="$claims"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$combinedClaims != ''">
                <xsl:call-template name="combinedItem">
                    <xsl:with-param name="checkListTagName" select="'cl-claims'"/>
                    <xsl:with-param name="attachment" select="$combinedAttachment"/>
                    <xsl:with-param name="typeScope" select="$combinedClaims"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$abstract != ''">
                <xsl:call-template name="checklistItem">
                    <xsl:with-param name="checkListTagName" select="'cl-abstract'"/>
                    <xsl:with-param name="attachment" select="$abstract"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$combinedAbstract != ''">
                <xsl:call-template name="combinedItem">
                    <xsl:with-param name="checkListTagName" select="'cl-abstract'"/>
                    <xsl:with-param name="attachment" select="$combinedAttachment"/>
                    <xsl:with-param name="typeScope" select="$combinedAbstract"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$drawings != ''">
                <xsl:call-template name="checklistItem">
                    <xsl:with-param name="checkListTagName" select="'cl-drawings'"/>
                    <xsl:with-param name="attachment" select="$drawings"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$combinedDrawings != ''">
                <xsl:call-template name="combinedItem">
                    <xsl:with-param name="checkListTagName" select="'cl-drawings'"/>
                    <xsl:with-param name="attachment" select="$combinedAttachment"/>
                    <xsl:with-param name="typeScope" select="$combinedDrawings"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$seqListing != ''">
                <xsl:call-template name="checklistItem">
                    <xsl:with-param name="checkListTagName" select="'cl-sequence-listing'"/>
                    <xsl:with-param name="attachment" select="$seqListing"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:for-each select="$attachments/map">
            <xsl:if test="current()/string[@key='attachmentType'] = 'ELECTRONIC_PRIORITY'">
                    <xsl:call-template name="priorityDocumentChecklistItem">
                        <xsl:with-param name="checkListTagName" select="'cl-priority-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>

            <xsl:if test="$bioInfo != ''">
                <xsl:call-template name="checklistBioItem">
                    <xsl:with-param name="checkListTagName" select="'cl-biological-material'"/>
                    <xsl:with-param name="item" select="$bioInfo"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:for-each select="$attachments/map">
                <xsl:if test="current()/string[@key='attachmentType'] = 'TRANSLATIONS_OF_PRIORITY_DOCUMENTS'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="current()/string[@key='attachmentType'] = 'EXHIBITION'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="current()/string[@key='attachmentType'] = 'POWER_OF_ATTORNEY'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="current()/string[@key='attachmentType'] = 'SEARCH_REPORT'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="current()/string[@key='attachmentType'] = 'RIGHT_TO_FILE'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="current()/string[@key='attachmentType'] = 'INVENTORSHIP'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="current()/string[@key='attachmentType'] = 'INVENTOR_WAIVER'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="current()/string[@key='attachmentType'] = 'TRANSLATION_OF_TECHNICAL_DOCUMENTS'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="current()/string[@key='attachmentType'] = 'PROOF_OF_PAYMENT'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="current()/string[@key='attachmentType'] = 'POWER_OF_REPRESENTATION'">
                    <xsl:call-template name="checklistItemOnlyTotalPages">
                        <xsl:with-param name="checkListTagName" select="'cl-other-document'"/>
                        <xsl:with-param name="attachment" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </check-list>
    </xsl:template>

    <xsl:template name="checklistItem">
        <xsl:param name="checkListTagName" />
        <xsl:param name="attachment" />
        <xsl:element name="{$checkListTagName}">

            <xsl:if test="$attachment/string[@key='attachmentType'] != 'SEQ_LIST'">
                <xsl:attribute name="page-count">
                    <xsl:value-of select="$attachment/number[@key='totalPages']"/>
                </xsl:attribute>
                <xsl:attribute name="ppf">
                    <xsl:value-of select="'1'"/>
                </xsl:attribute>
                <xsl:attribute name="ppl">
                    <xsl:value-of select="$attachment/number[@key='totalPages']"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$attachment/string[@key='attachmentType'] = 'CLAIMS'">
                <xsl:attribute name="number-of-claims">
                    <xsl:value-of select="$attachment/number[@key='numberOfClaims']"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$attachment/string[@key='attachmentType'] = 'SEQ_LIST'">
                <xsl:attribute name="quantity">
                    <xsl:value-of select="count($attachment)"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template name="checklistBioItem">

        <xsl:param name="checkListTagName" />
        <xsl:param name="item" />

        <xsl:element name="{$checkListTagName}">

            <xsl:attribute name="quantity">
                <xsl:value-of select="count($item)"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template name="priorityDocumentChecklistItem">
        <xsl:param name="checkListTagName" />
        <xsl:param name="attachment" />
        <xsl:element name="{$checkListTagName}">
            <xsl:attribute name="quantity">
                <xsl:value-of select="0"/>
            </xsl:attribute>
            <xsl:element name="sequence-number">
                <xsl:value-of select="0"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="checklistItemOnlyTotalPages">
        <xsl:param name="checkListTagName" />
        <xsl:param name="attachment" />
        <xsl:element name="{$checkListTagName}">
            <xsl:attribute name="page-count">
                <xsl:value-of select="$attachment/number[@key='totalPages']"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template name="office-specific-data">
        <xsl:param name="object" />
        <xsl:param name="config" />

        <ep-office-specific-data>
            <xsl:attribute name="office">
                <xsl:value-of select="$config/map[@key='header']/string[@key='country']"/>
            </xsl:attribute>
            <xsl:attribute name="lang">
                <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
            </xsl:attribute>

            <!-- TODO DTD says about an all attribute but is not clear if it is applicable for us  -->
            <ep-designated-states>
                <xsl:attribute name="waiver-communication-and-processing-of-non-designated-states">
                    <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='waiver-communication']"/>
                </xsl:attribute>

                <region>
                    <country>
                        <xsl:value-of select="$config/map[@key='header']/string[@key='country']"/>
                    </country>
                </region>
                <extension-states>
                    <!-- TODO find out if we will have information for that. The DTD does not say much about it -->
                </extension-states>
                <validation-states>
                    <!-- TODO find out if we will have information for that. -->
                </validation-states>
            </ep-designated-states>

            <ep-declarations>
                <!-- TODO find out if we will have information for that. -->
            </ep-declarations>

            <xsl:for-each select="$object/map[@key='seqlBio']/array[@key='biologicalInfos']/map">
                <xsl:call-template name="biological-material">
                    <xsl:with-param name="bioInfo" select="current()/map[@key='bioMaterial']"/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$object/array[@key='attachments']/map">
                <xsl:call-template name="electronic-files">
                    <xsl:with-param name="docType" select="current()/string[@key='docTypeLabel']"/>
                    <xsl:with-param name="applicantFileName" select="current()/string[@key='originalFileName']"/>
                    <xsl:with-param name="epoFileName" select="current()/string[@key='fileName']"/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:call-template name="electronic-files">
                <xsl:with-param name="docType" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request-pdf']/string[@key='annexFDocumentName']"/>
                <xsl:with-param name="applicantFileName" select="''"/>
                <xsl:with-param name="epoFileName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='request-pdf']/string[@key='name']"/>
            </xsl:call-template>

            <xsl:if test="$object/map[@key='parties']/array[@key='inventors'] != ''">
                <xsl:call-template name="electronic-files">
                    <xsl:with-param name="docType" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='inventor']/string[@key='annexFDocumentName']"/>
                    <xsl:with-param name="applicantFileName" select="''"/>
                    <xsl:with-param name="epoFileName" select="$config/map[@key='annexF']/map[@key='blob']/map[@key='inventor']/string[@key='name']"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:call-template name="financial-data">
                <xsl:with-param name="fees" select="$object/map[@key='fees']"/>
                <xsl:with-param name="config" select="$config"/>
            </xsl:call-template>

        </ep-office-specific-data>
    </xsl:template>

    <xsl:template name="parent-doc">
        <xsl:param name="object" />
        <xsl:param name="config" />

        <parent-doc>
            <document-id>
                <xsl:attribute name="lang">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
                </xsl:attribute>
                <country>
                    <xsl:value-of select="$config/map[@key='header']/string[@key='country']"/>
                </country>
                <doc-number>
                    <xsl:value-of select="$object/string[@key='filingNumber']"/>
                </doc-number>
                <date>
                    <xsl:value-of select="$object/string[@key='filingDate']"/>
                </date>
            </document-id>
        </parent-doc>
    </xsl:template>

    <xsl:template name="electronic-files">
        <xsl:param name="docType" />
        <xsl:param name="applicantFileName" />
        <xsl:param name="epoFileName" />

        <ep-electronic-files>
            <xsl:attribute name="doc-type">
                <xsl:value-of select="$docType"/>
            </xsl:attribute>

            <applicant-file-name>
                <xsl:value-of select="$applicantFileName"/>
            </applicant-file-name>
            <epo-file-name>
                <xsl:value-of select="$epoFileName"/>
            </epo-file-name>
        </ep-electronic-files>

    </xsl:template>

    <xsl:template name="biological-material">
        <xsl:param name="bioInfo" />

<!--        fields: country of depositary institution, user identification reference, date of deposit, country of origin are not present in the wipo dtd-->

        <ep-biological-material>
            <depositary>
                <xsl:value-of select="$bioInfo/string[@key='institution']"/>
            </depositary>
            <bio-accno>
                <xsl:value-of select="$bioInfo/string[@key='accession']"/>
            </bio-accno>
            <xsl:if test="$bioInfo/boolean[@key='restricted']">
                <bio-restriction-to-expert/>
            </xsl:if>
        </ep-biological-material>

    </xsl:template>

    <xsl:template name="financial-data">
        <xsl:param name="fees" />
        <xsl:param name="config" />

        <xsl:if test="$fees/map[@key='feesSelection'] != ''">
            <ep-financial-data>
                <xsl:attribute name="curr">
                    <xsl:value-of select="$fees/map[@key='feesSelection']/string[@key='currency']"/>
                </xsl:attribute>
                <xsl:attribute name="fee-amounts-unlocked-by-user">
                    <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='fee-amounts-unlocked-by-user']"/>
                </xsl:attribute>

                <fees>
                    <xsl:attribute name="date">
                        <xsl:value-of select="current-date()"/>
                    </xsl:attribute>
                    <standard-fee>
                        <xsl:call-template name="fee">
                            <xsl:with-param name="fees" select="$fees/map[@key='feesSelection']/array[@key='selectedFees']" />
                            <xsl:with-param name="config" select="$config" />
                        </xsl:call-template>
                    </standard-fee>
                    <fee-total-amount>
                        <xsl:value-of select="$fees/map[@key='feesSelection']/number[@key='total']"/>
                    </fee-total-amount>
                </fees>
            </ep-financial-data>
        </xsl:if>

    </xsl:template>

    <xsl:template name="fee">
        <xsl:param name="fees" />
        <xsl:param name="config" />

        <xsl:for-each select="$fees/map">
            <fee>
                <xsl:attribute name="index">
                    <xsl:value-of select="position() - 1"/>
                </xsl:attribute>
                <xsl:attribute name="topay">
                    <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='to-pay']"/>
                </xsl:attribute>

                <type-of-fee>
                    <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/string[@key='fee-type']" />
                </type-of-fee>
                <fee-factor>
                    <xsl:value-of select="current()/number[@key='quantity']" />
                </fee-factor>
                <fee-schedule>
                    <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/number[@key='fee-schedule']" />
                </fee-schedule>
                <fee-sub-amount>
                    <xsl:value-of select="current()/number[@key='subtotal']" />
                </fee-sub-amount>
                <fee-reduction-factor>
                    <xsl:choose>
                        <xsl:when test="current()/number[@key='discount']">
                            <xsl:value-of select="(100 - (current()/number[@key='discount'])) div 100" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$config/map[@key='xslt']/map[@key='params']/number[@key='fee-reduction-factor']" />
                        </xsl:otherwise>
                    </xsl:choose>
                </fee-reduction-factor>
            </fee>
        </xsl:for-each>


    </xsl:template>

    <xsl:template name="combinedItem">
        <xsl:param name="checkListTagName" />
        <xsl:param name="attachment"/>
        <xsl:param name="typeScope" />

        <xsl:element name="{$checkListTagName}">
            <xsl:attribute name="page-count">
                <xsl:value-of select="($typeScope/number[@key='end'] - $typeScope/number[@key='start']) + 1"/>
            </xsl:attribute>
            <xsl:attribute name="ppf">
                <xsl:value-of select="$typeScope/number[@key='start']"/>
            </xsl:attribute>
            <xsl:attribute name="ppl">
                <xsl:value-of select="$typeScope/number[@key='end']"/>
            </xsl:attribute>
            <xsl:if test="$typeScope/string[@key='type'] = 'CLAIMS'">
                <xsl:attribute name="number-of-claims">
                    <xsl:value-of select="$typeScope/number[@key='numberOfClaims']"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$typeScope/string[@key='type'] = 'SEQ_LIST'">
                <xsl:attribute name="quantity">
                    <xsl:value-of select="1"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template name="addressBook">
        <xsl:param name="object"/>
        <xsl:param name="config"/>

        <addressbook>
            <xsl:attribute name="lang">
                <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
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

            <xsl:if test="$object/map[@key='company']/string[@key='company'] != ''">
                <xsl:call-template name="businessInfo">
                    <xsl:with-param name="orgName">
                        <xsl:value-of select="$object/map[@key='company']/string[@key='company']"/>
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

            <xsl:if test="$object/string[@key='role'] != 'INVENTOR'">
                <xsl:call-template name="contactDetail">
                    <xsl:with-param name="phone">
                        <xsl:value-of select="$object/map[@key='contactDetails']/string[@key='telephone']"/>
                    </xsl:with-param>
                    <xsl:with-param name="fax">
                        <xsl:value-of select="$object/map[@key='contactDetails']/string[@key='fax']"/>
                    </xsl:with-param>
                    <xsl:with-param name="email">
                        <xsl:value-of select="$object/map[@key='contactDetails']/string[@key='email']"/>
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

        <orgname>
            <xsl:value-of select="$orgName"/>
        </orgname>
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