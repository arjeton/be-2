<xsl:stylesheet
        version="3.0"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ext="http://org.epo.eolf.integration"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" >

    <xsl:import href="/procedures/common/annexf/xslt/common/pdf-basic-fields.xslt" />

    <xsl:param name="submissionJson"/>
    <xsl:param name="configJson"/>

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
                    <xsl:value-of select="ext:translate('fee.pdf.title', $pdfLanguage, $configVersion)" />
                </title>

            </head>
            <body>
                <header>
                    <div>
                        <xsl:attribute name="class">
                            <xsl:value-of select="'title'"/>
                        </xsl:attribute>
                        <h1>
                            <xsl:value-of select="ext:translate('fee.pdf.title', $pdfLanguage, $configVersion)" />
                        </h1>
                    </div>
                </header>
                <main>
                    <div>
                        <span>
                            <xsl:value-of select="ext:translate('fee.pdf.description', $pdfLanguage, $configVersion)" />
                        </span>
                    </div>
                    <xsl:apply-templates select="$submissionXml"/>
                </main>
            </body>
        </html>

    </xsl:template>

    <xsl:template match="map">
        <div>
            <xsl:attribute name="class">
                <xsl:value-of select="'general'"/>
            </xsl:attribute>
            <table>
                <tbody>
                    <tr>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-type'"/>
                            </xsl:attribute>

                            <xsl:value-of select="ext:translate('fee.pdf.parties.reference', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-value'"/>
                            </xsl:attribute>
                            <xsl:value-of select="map[@key='basicFilingInfo']/string[@key='userReference']" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <xsl:call-template name="applicants">
            <xsl:with-param name="applicants" select="map[@key='parties']/array[@key='applicants']"/>
        </xsl:call-template>

        <xsl:call-template name="representatives">
            <xsl:with-param name="representatives" select="map[@key='parties']/array[@key='representatives']"/>
        </xsl:call-template>

        <div>
            <xsl:attribute name="class">
                <xsl:value-of select="'general'"/>
            </xsl:attribute>
            <table>
                <tbody>
                    <tr>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-type'"/>
                            </xsl:attribute>

                            <xsl:value-of select="ext:translate('fee.pdf.title.invention', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-value'"/>
                            </xsl:attribute>
                            <xsl:value-of select="map[@key='basicFilingInfo']/string[@key='titleOfInvention']" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <xsl:call-template name="fees">
            <xsl:with-param name="fees" select="map[@key='fees']/map[@key='feesSelection']"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="applicants">
        <xsl:param name="applicants" />

        <div>
            <xsl:attribute name="class">
                <xsl:value-of select="'general'"/>
            </xsl:attribute>
            <table>
                <tbody>
                    <xsl:for-each select="$applicants/map">
                        <tr>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'table-type'"/>
                                </xsl:attribute>
                                <xsl:variable name="applicantText" select="ext:translate('fee.pdf.applicant', $pdfLanguage, $configVersion)"/>
                                <xsl:value-of select="concat($applicantText, current()/number[@key='sequenceNumber'])" />
                            </td>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'table-value'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="current()/string[@key='role'] = 'APPLICANT_NATURAL_PERSON'">
                                        <xsl:value-of select="concat(current()/map[@key='personalDetails']/string[@key='firstName'], ' ', current()/map[@key='personalDetails']/string[@key='lastName'])" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="current()/map[@key='companyDetails']/string[@key='company']" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="representatives">
        <xsl:param name="representatives" />

        <div>
            <xsl:attribute name="class">
                <xsl:value-of select="'general'"/>
            </xsl:attribute>
            <table>
                <tbody>
                    <xsl:for-each select="$representatives/map">
                        <tr>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'table-type'"/>
                                </xsl:attribute>
                                <xsl:variable name="representativeText" select="ext:translate('fee.pdf.representative', $pdfLanguage, $configVersion)"/>
                                <xsl:value-of select="concat($representativeText, current()/number[@key='sequenceNumber'])" />
                            </td>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'table-value'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="current()/string[@key='role'] = 'ASSOCIATION'">
                                        <xsl:value-of select="current()/map[@key='companyDetails']/string[@key='company']" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat(current()/map[@key='personalDetails']/string[@key='firstName'], ' ', current()/map[@key='personalDetails']/string[@key='lastName'])" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="fees">
        <xsl:param name="fees" />

        <div>
            <xsl:attribute name="class">
                <xsl:value-of select="'fee'"/>
            </xsl:attribute>
            <table>
                <thead>
                    <tr>
                        <th>
                            <xsl:value-of select="ext:translate('fee.pdf.fees', $pdfLanguage, $configVersion)" />
                        </th>
                        <td>
                            <xsl:value-of select="ext:translate('fee.pdf.fee.factor', $pdfLanguage, $configVersion)" />

                        </td>
                        <td>
                            <xsl:value-of select="ext:translate('fee.pdf.fee.schedule', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:value-of select="ext:translate('fee.pdf.fee.amount.to.pay', $pdfLanguage, $configVersion)" />
                        </td>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="$fees/array[@key='selectedFees']/map">
                        <tr>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'table-type'"/>
                                </xsl:attribute>
                                <xsl:value-of select="current()/string[@key='code']" />
                            </td>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'table-value'"/>
                                </xsl:attribute>
                                <xsl:value-of select="current()/number[@key='quantity']" />
                            </td>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'table-value'"/>
                                </xsl:attribute>
                                <xsl:value-of select="format-number(current()/number[@key='price'], '#,###.##')" />
                            </td>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'table-value'"/>
                                </xsl:attribute>
                                <xsl:value-of select="format-number(current()/number[@key='subtotal'], '#,###.##')" />
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
                <tfoot>
                    <tr>
                        <td>
                            <b>
                                <xsl:value-of select="ext:translate('fee.pdf.total', $pdfLanguage, $configVersion)" />
                            </b>
                        </td>
                        <td>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'table-value'"/>
                            </xsl:attribute>
                            <xsl:attribute name="colspan">
                                <xsl:value-of select="'3'"/>
                            </xsl:attribute>
                            <b>
                                <xsl:choose>
                                    <xsl:when test="$fees/number[@key='total']">
                                        <xsl:value-of select="concat($fees/string[@key='currency'], ' ', format-number($fees/number[@key='total'], '#,###.##'))" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="'0'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </b>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </xsl:template>

</xsl:stylesheet>