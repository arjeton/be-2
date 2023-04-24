<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xal="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
    <xsl:param name="submissionJson"/>
    <xsl:param name="configJson"/>
    <xsl:param name="dateProduced"/>

    <xsl:variable name="submissionXml" select="json-to-xml($submissionJson)"/>
    <xsl:variable name="configXml" select="json-to-xml($configJson)"/>

    <xsl:output
            encoding="ISO-8859-1"
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

        <xsl:result-document doctype-system="{$config/map[@key='annexF']/map[@key='filing']/map[@key='submission-transfer']/string[@key='dtd']}">
            <SUBMISSION_WAD>
                <!-- TODO Do we need to transform it to timestamp ? -->
                <xsl:attribute name="creationtimestamp">
                    <xsl:value-of select="$dateProduced"/>
                </xsl:attribute>
                <xsl:attribute name="version">
                    <xsl:value-of select="$config/map[@key='annexF']/map[@key='filing']/map[@key='submission-transfer']/string[@key='version']"/>
                </xsl:attribute>
                <xsl:attribute name="submissionid">
                    <xsl:value-of select="$submission/string[@key='id']"/>
                </xsl:attribute>

                <xsl:call-template name="submission-info">
                    <xsl:with-param name="submission" select="$submission"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>

                <xsl:call-template name="state-history">
                </xsl:call-template>

                <xsl:call-template name="additional-data">
                    <xsl:with-param name="submission" select="$submission"/>
                    <xsl:with-param name="config" select="$config"/>
                </xsl:call-template>

                <xsl:call-template name="submission-files">
                    <xsl:with-param name="attachments" select="$submission/array[@key='attachments']"/>
                    <xsl:with-param name="packageData" select="$submission/map[@key='packageData']"/>
                    <xsl:with-param name="receipt" select="$submission/map[@key='receipt']"/>
                </xsl:call-template>

            </SUBMISSION_WAD>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="submission-info">
        <xsl:param name="submission"/>
        <xsl:param name="config"/>
        <SUBMISSIONINFO>
            <SUBMISSIONID>
                <xsl:value-of select="$submission/string[@key='id']"/>
            </SUBMISSIONID>
            <APPLNR>
                <xsl:value-of select="$submission/map[@key='receipt']/string[@key='applicationNumber']"/>
            </APPLNR>

            <!-- TODO get the certificate(s) user -->
            <CN_LOADER/>
            <CN_SENDER/>
            <CN_SIGNER/>

            <EPOLINE_ID>
                <xsl:value-of select="$config/map[@key='wad']/map[@key='submission-transfer']/string[@key='epo-line-id']"/>
            </EPOLINE_ID>
            <FORM_TYPE>
                <xsl:value-of select="$config/map[@key='header']/string[@key='form-type']"/>
            </FORM_TYPE>
            <FORM_VERSION>
                <xsl:value-of select="$config/map[@key='header']/string[@key='software-version']"/>
            </FORM_VERSION>

            <HASHCODE>
                <xsl:value-of select="$submission/map[@key='packageData']/map[@key='signedPackageFile']/string[@key='digest']"/>
            </HASHCODE>

            <ORIGINAL_SUBMID>
                <xsl:value-of select="$config/map[@key='wad']/map[@key='submission-transfer']/string[@key='original-submission-id']"/>
            </ORIGINAL_SUBMID>
            <RECEIPT_TS>
                <xsl:value-of select="$submission/map[@key='receipt']/string[@key='senderDate']"/>
            </RECEIPT_TS>
            <RO_DESIGNATION>
                <xsl:value-of select="$submission/string[@key='receivingOffice']"/>
            </RO_DESIGNATION>
            <RO_INITIAL>
                <xsl:value-of select="$config/map[@key='wad']/map[@key='submission-transfer']/string[@key='receiving-office-initial']"/>
            </RO_INITIAL>
            <START_TS>
                <xsl:value-of select="$submission/string[@key='createdDate']"/>
            </START_TS>
            <STATE_CODE>
                <xsl:value-of select="$config/map[@key='wad']/map[@key='submission-transfer']/string[@key='state-code']"/>
            </STATE_CODE>
            <STATE_TS>
                <xsl:value-of select="$config/map[@key='wad']/map[@key='submission-transfer']/string[@key='state-ts']"/>
            </STATE_TS>
            <USER_NAME/>
            <WASP_SIZE>
                <xsl:value-of select="$submission/map[@key='packageData']/map[@key='signedPackageFile']/number[@key='bytes']"/>
            </WASP_SIZE>
        </SUBMISSIONINFO>
    </xsl:template>

    <xsl:template name="state-history">
        <STATEHISTORY>
            <xsl:attribute name="count">
                <xsl:value-of select="'0'"/>
            </xsl:attribute>
        </STATEHISTORY>
    </xsl:template>

    <xsl:template name="additional-data">
        <xsl:param name="submission"/>
        <xsl:param name="config"/>

        <ADDITIONALDATA>
            <xsl:attribute name="count">
                <xsl:value-of select="$config/map[@key='wad']/map[@key='submission-transfer']/string[@key='additional-data-count']"/>
            </xsl:attribute>

            <ADDITIONALDATAOCCURENCE>
                <xsl:attribute name="attributename">
                    <xsl:value-of select="'CLIENT_SOFTWARE_NAME'"/>
                </xsl:attribute>
                <xsl:attribute name="attributedomain">
                    <xsl:value-of select="'STRING'"/>
                </xsl:attribute>
                <xsl:attribute name="attributevalue">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='software-name']"/>
                </xsl:attribute>
                <!-- TODO find out which user name to use here example value is SYSTEM@luu316t.internal.epo.org -->
                <xsl:attribute name="username">
                    <xsl:value-of select="'user name'"/>
                </xsl:attribute>
                <!-- TODO find out how to fill here example value is 20220202143338813 -->
                <xsl:attribute name="change_ts">
                    <xsl:value-of select="'20220202143338813'"/>
                </xsl:attribute>
            </ADDITIONALDATAOCCURENCE>

            <ADDITIONALDATAOCCURENCE>
                <xsl:attribute name="attributename">
                    <xsl:value-of select="'CLIENT_SOFTWARE_VERSION'"/>
                </xsl:attribute>
                <xsl:attribute name="attributedomain">
                    <xsl:value-of select="'STRING'"/>
                </xsl:attribute>
                <xsl:attribute name="attributevalue">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='software-version']"/>
                </xsl:attribute>
                <!-- TODO find out which user name to use here example value is SYSTEM@luu316t.internal.epo.org -->
                <xsl:attribute name="username">
                    <xsl:value-of select="'user name'"/>
                </xsl:attribute>
                <!-- TODO find out how to fill here example value is 20220202143338813 -->
                <xsl:attribute name="change_ts">
                    <xsl:value-of select="'20220202143338813'"/>
                </xsl:attribute>
            </ADDITIONALDATAOCCURENCE>

            <ADDITIONALDATAOCCURENCE>
                <xsl:attribute name="attributename">
                    <xsl:value-of select="'CLIENT_SOFTWARE_MESSAGE'"/>
                </xsl:attribute>
                <xsl:attribute name="attributedomain">
                    <xsl:value-of select="'STRING'"/>
                </xsl:attribute>
                <xsl:attribute name="attributevalue">
                    <xsl:value-of select="concat('formType=', $config/map[@key='header']/string[@key='form-type'], ';formVersion=001')" />
                </xsl:attribute>
                <!-- TODO find out with BAs POs which user name to use here example value is SYSTEM@luu316t.internal.epo.org -->
                <xsl:attribute name="username">
                    <xsl:value-of select="'user name'"/>
                </xsl:attribute>
                <!-- TODO find out with BAs POs  how to fill here example value is 20220202143338813 -->
                <xsl:attribute name="change_ts">
                    <xsl:value-of select="'20220202143338813'"/>
                </xsl:attribute>
            </ADDITIONALDATAOCCURENCE>

            <ADDITIONALDATAOCCURENCE>
                <xsl:attribute name="attributename">
                    <xsl:value-of select="'USER_REFERENCE'"/>
                </xsl:attribute>
                <xsl:attribute name="attributedomain">
                    <xsl:value-of select="'STRING'"/>
                </xsl:attribute>
                <xsl:attribute name="attributevalue">
                    <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='userReference']" />
                </xsl:attribute>
                <!-- TODO find out which user name to use here example value is SYSTEM@luu316t.internal.epo.org -->
                <xsl:attribute name="username">
                    <xsl:value-of select="'user name'"/>
                </xsl:attribute>
                <!-- TODO find out how to fill here example value is 20220202143338813 -->
                <xsl:attribute name="change_ts">
                    <xsl:value-of select="'20220202143338813'"/>
                </xsl:attribute>
            </ADDITIONALDATAOCCURENCE>

            <!-- TODO find out with BAs POs how to fill this entire section -->
            <ADDITIONALDATAOCCURENCE>
                <xsl:attribute name="attributename">
                    <xsl:value-of select="'ELECTRONIC_SIGNATURE_PKCS7'"/>
                </xsl:attribute>
                <xsl:attribute name="attributedomain">
                    <xsl:value-of select="'int'"/>
                </xsl:attribute>
                <xsl:attribute name="attributevalue">
                    <xsl:value-of select="'1'" />
                </xsl:attribute>
                <xsl:attribute name="username">
                    <xsl:value-of select="'user name'"/>
                </xsl:attribute>
                <xsl:attribute name="change_ts">
                    <xsl:value-of select="'20220202143338813'"/>
                </xsl:attribute>
            </ADDITIONALDATAOCCURENCE>


        </ADDITIONALDATA>
    </xsl:template>

    <xsl:template name="submission-files">
        <xsl:param name="attachments"/>
        <xsl:param name="packageData"/>
        <xsl:param name="receipt"/>

        <xsl:variable name="attachmentsTotalFiles" select="count($attachments/map)"/>

        <SUBMISSIONFILES>
            <xsl:attribute name="count">
                <xsl:value-of select="$attachmentsTotalFiles + 5"/>
            </xsl:attribute>

            <!-- HEADER.dat  -->
            <xsl:call-template name="file">
                <xsl:with-param name="object" select="$packageData/map[@key='signedHeaderFile']"/>
            </xsl:call-template>
            <!-- pkgheader.xml  -->
            <xsl:call-template name="file">
                <xsl:with-param name="object" select="$packageData/map[@key='pkgHeaderFile']"/>
            </xsl:call-template>
            <!-- BLOB.dat  -->
            <xsl:call-template name="file">
                <xsl:with-param name="object" select="$packageData/map[@key='signedPackageFile']"/>
            </xsl:call-template>
            <!-- Receipt.dat  -->
            <xsl:call-template name="file">
                <xsl:with-param name="object" select="$packageData/map[@key='signedReceiptPackageFile']"/>
            </xsl:call-template>

            <!-- Attachments -->
            <xsl:for-each select="$attachments/map">
                <xsl:call-template name="file">
                    <xsl:with-param name="object" select="current()"/>
                </xsl:call-template>
            </xsl:for-each>

            <!-- TODO add the file pdfoverview -->

            <!-- receipt.pdf  -->
            <xsl:call-template name="file">
                <xsl:with-param name="object" select="$receipt/map[@key='receiptFile']"/>
            </xsl:call-template>

            <!-- receipt.xml  -->
            <xsl:call-template name="file">
                <xsl:with-param name="object" select="$receipt/map[@key='receiptXmlFile']"/>
            </xsl:call-template>


        </SUBMISSIONFILES>
    </xsl:template>

    <xsl:template name="file">
        <xsl:param name="object"/>
        <FILE>
            <!-- TODO find out what is backenddoccode -->
            <xsl:attribute name="backenddoccode">
                <xsl:value-of select="'backenddoccode'"/>
            </xsl:attribute>
            <xsl:attribute name="format">
                <xsl:value-of select="$object/string[@key='mimeType']"/>
            </xsl:attribute>
            <xsl:attribute name="name">
                <xsl:value-of select="$object/string[@key='fileName']"/>
            </xsl:attribute>
            <xsl:attribute name="size">
                <xsl:value-of select="$object/number[@key='bytes']"/>
            </xsl:attribute>
            <xsl:attribute name="typecode">
                <xsl:value-of select="$object/string[@key='docTypeLabel']"/>
            </xsl:attribute>
            <!-- TODO find out what is typedescription -->
            <xsl:attribute name="typedescription">
                <xsl:value-of select="'typedescription'"/>
            </xsl:attribute>
        </FILE>
    </xsl:template>
</xsl:stylesheet>