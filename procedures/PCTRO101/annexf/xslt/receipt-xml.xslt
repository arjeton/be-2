<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xal="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
    <xsl:param name="submissionJson"/>
    <xsl:param name="configJson"/>

    <xsl:variable name="submissionXml" select="json-to-xml($submissionJson)"/>
    <xsl:variable name="configXml" select="json-to-xml($configJson)"/>

    <xsl:output
            encoding="utf-8"
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

        <xsl:result-document doctype-system="{$config/map[@key='annexF']/map[@key='receipt']/map[@key='receipt']/string[@key='dtd']}">
            <xmit-receipt>
                <xsl:attribute name="dtd-version">
                    <xsl:value-of select="$config/map[@key='annexF']/map[@key='receipt']/map[@key='receipt']/string[@key='version']"/>
                </xsl:attribute>
                <xsl:attribute name="lang">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
                </xsl:attribute>
                <xsl:attribute name="status">
                    <xsl:value-of select="$config/map[@key='xslt']/map[@key='receipt']/string[@key='status']"/>
                </xsl:attribute>
                <xsl:attribute name="file">
                    <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='userReference']"/>
                </xsl:attribute>

                <xsl:call-template name="document-id">
                    <xsl:with-param name="language" select="$config/map[@key='header']/string[@key='language']"/>
                    <xsl:with-param name="country" select="$config/map[@key='header']/string[@key='country']"/>
                    <xsl:with-param name="docNumber" select="$submission/map[@key='receipt']/string[@key='applicationNumber']"/>
                    <xsl:with-param name="docName" select="$config/map[@key='receipt']/string[@key='name']"/>
                    <xsl:with-param name="nameType" select="$config/map[@key='receipt']/string[@key='name-type']"/>
                </xsl:call-template>

                <receipt-id>
                    <xsl:value-of select="$submission/map[@key='receipt']/string[@key='id']"/>
                </receipt-id>

                <received-on>
                    <date>
                        <xsl:value-of select="concat(substring($submission/map[@key='receipt']/string[@key='senderDate'],1,4), substring($submission/map[@key='receipt']/string[@key='senderDate'],6,2), substring($submission/map[@key='receipt']/string[@key='senderDate'],9,2))"/>
                    </date>
                    <time>
                        <xsl:value-of select="concat(substring($submission/map[@key='receipt']/string[@key='senderDate'],12,2), substring($submission/map[@key='receipt']/string[@key='senderDate'],15,2))"/>
                    </time>
                </received-on>

                <from>
                    <country>
                        <xsl:value-of select="$config/map[@key='header']/string[@key='country']"/>
                    </country>
                </from>

                <wad-message-digest>
                    <xsl:value-of select="$submission/map[@key='packageData']/map[@key='packageFile']/string[@key='digest']"/>
                </wad-message-digest>

                <!-- TODO see what include here -->
                <response>
                    <code>
                        <xsl:value-of select="'Test'"/>
                    </code>
                    <message>
                        <xsl:value-of select="'Test'"/>
                    </message>
                </response>

                <wasp-signer>
                    <!-- TODO Is it the user in the certificate?  value in the example receipt= CN=TCS test user 9979 -->
                    <name>
                        <xsl:value-of select="'certificate'"/>
                    </name>
                </wasp-signer>

                <invention-title>
                    <xsl:attribute name="lang">
                        <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
                    </xsl:attribute>

                    <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='titleOfInvention']"/>
                </invention-title>

                <xsl:call-template name="first-named-applicant">
                    <xsl:with-param name="applicants" select="$submission/map[@key='parties']/array[@key='applicants']"/>
                </xsl:call-template>


                <file-reference-id>
                    <xsl:value-of select="$submission/map[@key='basicFilingInfo']/string[@key='userReference']"/>
                </file-reference-id>

                <xsl:call-template name="file-list">
                    <xsl:with-param name="attachments" select="$submission/array[@key='attachments']"/>
                </xsl:call-template>

                <receipt-copy>
                    <xsl:attribute name="file">
                        <xsl:value-of select="$config/map[@key='annexF']/map[@key='receipt']/map[@key='receipt-pdf']/string[@key='name']"/>
                    </xsl:attribute>
                </receipt-copy>
            </xmit-receipt>
        </xsl:result-document>

    </xsl:template>

    <xsl:template name="document-id">
        <xsl:param name="language"/>
        <xsl:param name="country"/>
        <xsl:param name="docNumber"/>
        <xsl:param name="docName"/>
        <xsl:param name="nameType"/>
        <document-id>
            <xsl:attribute name="lang">
                <xsl:value-of select="$language"/>
            </xsl:attribute>

            <country>
                <xsl:value-of select="$country"/>
            </country>
            <doc-number>
                <xsl:value-of select="$docNumber"/>
            </doc-number>
            <name>
                <xsl:attribute name="name-type">
                    <xsl:value-of select="$nameType"/>
                </xsl:attribute>

                <xsl:value-of select="$docName"/>
            </name>
        </document-id>
    </xsl:template>

    <xsl:template name="first-named-applicant">
        <xsl:param name="applicants"/>
        <xsl:for-each select="$applicants/map[map[@key='personalDetails'] != ''][1]">
            <first-named-applicant>
                <last-name>
                    <xsl:value-of select="current()/map[@key='personalDetails']/string[@key='lastName']"/>
                </last-name>
                <first-name>
                    <xsl:value-of select="current()/map[@key='personalDetails']/string[@key='firstName']"/>
                </first-name>
            </first-named-applicant>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="file-list">
        <xsl:param name="attachments"/>
        <filelist>
            <xsl:for-each select="$attachments/map">
                <file-content>
                    <xsl:attribute name="doc-name">
                        <xsl:value-of select="current()/string[@key='docTypeLabel']"/>
                    </xsl:attribute>
                    <xsl:attribute name="file-name">
                        <xsl:value-of select="current()/string[@key='fileName']"/>
                    </xsl:attribute>
                    <xsl:attribute name="size">
                        <xsl:value-of select="current()/number[@key='bytes']"/>
                    </xsl:attribute>
                </file-content>
            </xsl:for-each>
        </filelist>
    </xsl:template>

</xsl:stylesheet>