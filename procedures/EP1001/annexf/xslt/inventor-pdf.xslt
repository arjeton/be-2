<xsl:stylesheet
        version="3.0"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ext="http://org.epo.eolf.integration"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" >

    <xsl:import href="/procedures/common/annexf/xslt/common/pdf-basic-fields.xslt" />

    <xsl:param name="submissionJson"/>
    <xsl:param name="configJson"/>
    <xsl:param name="signatureImage"/>

    <xsl:variable name="submissionXml" select="json-to-xml($submissionJson)"/>
    <xsl:variable name="configXml" select="json-to-xml($configJson)/map"/>

    <xsl:variable name="pdfLanguage" select="$configXml/map[@key='header']/string[@key='language']"/>
    <xsl:variable name="configVersion" select="$submissionXml/map/string[@key='configurationVersion']"/>

    <xsl:output
        method="xhtml"
        encoding="utf-8"
        indent="yes"
    />

    <xsl:template name="header">
        <html>
            <head>
                <xsl:copy-of select="$headTags" />
                <title>
                    <xsl:value-of select="ext:translate('inventor.pdf.title', $pdfLanguage, $configVersion)" />
                </title>
            </head>
            <body>
                <xsl:apply-templates select="$submissionXml" />
            </body>
        </html>

    </xsl:template>

    <xsl:template match="map">

        <xsl:call-template name="title">
            <xsl:with-param name="userReference" select="map[@key='basicFilingInfo']/string[@key='userReference']"/>
        </xsl:call-template>

        <xsl:call-template name="main">
            <xsl:with-param name="inventors" select="map[@key='parties']/array[@key='inventors']"/>
            <xsl:with-param name="signature" select="map[@key='signature']"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="title">
        <xsl:param name="userReference" />

        <header>
            <div>
                <xsl:attribute name="class">
                    <xsl:value-of select="'title'"/>
                </xsl:attribute>
                <h1>
                    <xsl:value-of select="ext:translate('inventor.pdf.title', $pdfLanguage, $configVersion)"/>
                </h1>
                <h2>
                    <xsl:value-of select="ext:translate('inventor.pdf.designation', $pdfLanguage, $configVersion)"/>
                </h2>
                <div>
                    <xsl:attribute name="class">
                        <xsl:value-of select="'application'"/>
                    </xsl:attribute>
                    <table>
                        <xsl:attribute name="cellpadding">
                            <xsl:value-of select="'10'" />
                        </xsl:attribute>
                        <tbody>
                            <tr>
                                <td>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'table-type'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="ext:translate('inventor.pdf.user.reference', $pdfLanguage, $configVersion)"/>
                                </td>
                                <td>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'table-value'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="$userReference"/>
                                </td>
                            </tr>
                            <tr>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'table-type'"/>
                                </xsl:attribute>
                                <xsl:value-of select="ext:translate('inventor.pdf.application.number', $pdfLanguage, $configVersion)"/>
                                <td>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'table-value'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="' '"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </header>

    </xsl:template>

    <xsl:template name="main">
        <xsl:param name="inventors" />
        <xsl:param name="signature" />

        <main>
            <xsl:call-template name="inventors">
                <xsl:with-param name="inventors" select="$inventors"/>
            </xsl:call-template>

            <xsl:call-template name="signature">
                <xsl:with-param name="signature" select="$signature"/>
            </xsl:call-template>
        </main>

        <footer>
            <p><xsl:value-of select="ext:translate('inventor.pdf.facsimile', $pdfLanguage, $configVersion)" /></p>
        </footer>

    </xsl:template>

    <xsl:template name="signature">
        <xsl:param name="signature"/>

        <div class="signature">
            <table>
                <thead>
                    <tr>
                        <th>
                            <xsl:attribute name="colspan">
                                <xsl:value-of select="2"/>
                            </xsl:attribute>
                            <b>
                                <xsl:value-of select="ext:translate('inventor.pdf.signatures', $pdfLanguage, $configVersion)" />
                            </b>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-type'"/>
                            </xsl:attribute>

                            <xsl:value-of select="ext:translate('inventor.pdf.place', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-value'"/>
                            </xsl:attribute>
                            <b><xsl:value-of select="' '" /></b>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-type'"/>
                            </xsl:attribute>
                            <xsl:value-of select="ext:translate('inventor.pdf.date', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-value'"/>
                            </xsl:attribute>
                            <b><xsl:value-of select="$signature/string[@key='signatureDate']" /></b>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-type'"/>
                            </xsl:attribute>
                            <xsl:value-of select="ext:translate('inventor.pdf.signed.by', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-value'"/>
                            </xsl:attribute>
                            <b><xsl:value-of select="$signature/string[@key='signerFullName']" /></b>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:attribute name="colspan">
                                <xsl:value-of select="2" />
                            </xsl:attribute>

                            <xsl:choose>
                                <xsl:when test="$signature/string[@key='signatureType'] = 'FACSIMILE'">
                                    <div>
                                        <img>
                                            <xsl:attribute name="src">
                                                <xsl:value-of select="concat('data:image/png;base64,', $signatureImage)"/>
                                            </xsl:attribute>

                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="'Signature image'"/>
                                            </xsl:attribute>
                                        </img>
                                    </div>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$signature/string[@key='signatureText']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-type'"/>
                            </xsl:attribute>
                            <xsl:value-of select="ext:translate('inventor.pdf.capacity', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-value'"/>
                            </xsl:attribute>
                            <b><xsl:value-of select="$signature/string[@key='signerCapacity']" /></b>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-type'"/>
                            </xsl:attribute>
                            <xsl:value-of select="ext:translate('inventor.pdf.function.of.signer', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-value'"/>
                            </xsl:attribute>
                            <b><xsl:value-of select="$signature/string[@key='signerFunction']" /></b>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="inventors">
        <xsl:param name="inventors" />
        <div class="inventor">
            <table>
                <thead>
                    <tr>
                        <td>
                            <xsl:attribute name="colspan">
                                <xsl:value-of select="3"/>
                            </xsl:attribute>
                            <xsl:value-of select="ext:translate('inventor.pdf.public', $pdfLanguage, $configVersion)" />
                        </td>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="$inventors/map" >
                        <xsl:call-template name="inventor">
                            <xsl:with-param name="inventor" select="current()" />
                        </xsl:call-template>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="inventor">
        <xsl:param name="inventor" />

        <tr>
            <td>
                <xsl:attribute name="class">
                    <xsl:value-of select="'table-empty'"/>
                </xsl:attribute>
            </td>
            <td>
                <xsl:attribute name="class">
                    <xsl:value-of select="'table-type'"/>
                </xsl:attribute>
                <div>
                    <span><b>
                        <xsl:value-of select="ext:translate('inventor.pdf.inventor', $pdfLanguage, $configVersion)" />
                    </b></span>
                    <p>
                        <xsl:value-of select="ext:translate('inventor.pdf.name', $pdfLanguage, $configVersion)" />
                    </p>
                    <p>
                        <xsl:value-of select="ext:translate('inventor.pdf.address', $pdfLanguage, $configVersion)" />
                    </p>
                    <p>
                        <xsl:value-of select="ext:translate('inventor.pdf.acquirance', $pdfLanguage, $configVersion)" />
                    </p>
                </div>
            </td>
            <td>
                <xsl:attribute name="class">
                    <xsl:value-of select="'table-value'"/>
                </xsl:attribute>
                <div>
                    <span />
                    <p>
                        <xsl:value-of select="concat(
                            $inventor/map[@key='personalDetails']/string[@key='firstName'],
                            ' ',
                            $inventor/map[@key='personalDetails']/string[@key='lastName'])"
                        />
                    </p>
                    <p>
                        <xsl:value-of select="concat(
                                        $inventor/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='streetAddress'],
                                        ' ',
                                        $inventor/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='postalCode'],
                                        ' ',
                                        $inventor/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='city'],
                                        ' ',
                                        $inventor/map[@key='contactDetails']/map[@key='residenceAddress']/string[@key='country']
                                        )" />
                    </p>
                    <p>
                        <xsl:value-of select="$inventor/string[@key='declarationOfRights']" />
                    </p>
                </div>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>