<xsl:stylesheet
    version="3.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ext="http://org.epo.eolf.integration"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

    <xsl:import href="/procedures/common/annexf/xslt/common/pdf-basic-fields.xslt" />
    <xsl:import href="/procedures/common/annexf/xslt/common/fees.xslt" />
    
    <xsl:param name="submissionJson"/>
    <xsl:param name="configJson"/>
    <xsl:param name="signatureImage"/>
    
    <xsl:variable name="submissionXml" select="json-to-xml($submissionJson)"/>
    <xsl:variable name="configXml" select="json-to-xml($configJson)/map"/>
    
    <xsl:variable name="pdfLanguage" select="$configXml/map[@key='header']/string[@key='language']"/>
    <xsl:variable name="configVersion" select="$submissionXml/map/string[@key='configurationVersion']"/>
    <xsl:variable name="procedure" select="$submissionXml/map/string[@key='procedure']"/>
    
    <xsl:output
        method="xhtml"
        encoding="utf-8"
        indent="yes"
    />
    
    <xsl:decimal-format name="dec" decimal-separator="," grouping-separator="."/>
    
    <!--initial template -->
    <xsl:template name="html">
        <html>
            <head>
                <xsl:copy-of select="$headTags" />
                <!--visible as title of the PDF preview renderer-->
                <title>
                    <xsl:value-of select="ext:translate('request.pdf.main.title', $pdfLanguage, $configVersion)" />
                </title>
            </head>
            <body>
                <xsl:apply-templates select="$submissionXml" />
            </body>
        </html>
    </xsl:template>
    
    <!--this template matches the 'map' node produced by the 'json-to-xml' function-->
    <xsl:template match="map">
        <header>
            <table class="content">
                <tr>
                    <td class="logoCell">
                        <div class="logo">
                            <svg width="97" height="64" viewBox="0 0 97 64" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M80.6534 32C80.6534 14.3269 66.2854 3.77925e-06 48.5616 3.77925e-06C30.8377 3.77925e-06 16.4697 14.3269 16.4697 32C16.4697 49.6731 30.8377 64 48.5616 64C66.2854 64 80.6534 49.6731 80.6534 32Z" fill="#DFE5E9"/>
                                <path d="M12.8837 38.909H9.45612L3.92332 29.315H3.84503C3.95522 31.0094 4.01031 32.218 4.01031 32.9409V38.909H1.60059V26.2269H5.00204L10.5261 35.7254H10.587C10.5 34.0773 10.4566 32.912 10.4566 32.2296V26.2269H12.8837V38.909Z" fill="#21252C"/>
                                <path d="M18.7906 32.1949H19.6779C20.5072 32.1949 21.1278 32.033 21.5396 31.7091C21.9513 31.3795 22.1572 30.9024 22.1572 30.2778C22.1572 29.6475 21.9832 29.182 21.6353 28.8812C21.2931 28.5805 20.7537 28.4302 20.0172 28.4302H18.7906V32.1949ZM24.8801 30.1824C24.8801 31.5472 24.451 32.591 23.5926 33.3139C22.7401 34.0368 21.5251 34.3982 19.9476 34.3982H18.7906V38.909H16.0937V26.2269H20.1564C21.699 26.2269 22.8706 26.5594 23.6709 27.2244C24.477 27.8837 24.8801 28.8697 24.8801 30.1824Z" fill="#21252C"/>
                                <path d="M38.8252 32.5506C38.8252 34.6498 38.3033 36.2632 37.2593 37.3909C36.2154 38.5186 34.7191 39.0824 32.7705 39.0824C30.8218 39.0824 29.3255 38.5186 28.2816 37.3909C27.2377 36.2632 26.7157 34.644 26.7157 32.5332C26.7157 30.4224 27.2377 28.8119 28.2816 27.7015C29.3313 26.5854 30.8334 26.0273 32.7879 26.0273C34.7423 26.0273 36.2357 26.5883 37.268 27.7102C38.3062 28.8321 38.8252 30.4455 38.8252 32.5506ZM29.543 32.5506C29.543 33.9674 29.8127 35.0344 30.352 35.7514C30.8914 36.4685 31.6975 36.8271 32.7705 36.8271C34.9221 36.8271 35.9979 35.4016 35.9979 32.5506C35.9979 29.6938 34.9279 28.2654 32.7879 28.2654C31.7149 28.2654 30.9059 28.6268 30.3607 29.3497C29.8156 30.0668 29.543 31.1337 29.543 32.5506Z" fill="#21252C"/>
                                <path d="M46.0892 38.909V26.2269H48.786V36.6883H53.9447V38.909H46.0892Z" fill="#21252C"/>
                                <path d="M67.7072 32.5506C67.7072 34.6498 67.1852 36.2632 66.1413 37.3909C65.0973 38.5186 63.6011 39.0824 61.6524 39.0824C59.7037 39.0824 58.2074 38.5186 57.1635 37.3909C56.1196 36.2632 55.5976 34.644 55.5976 32.5332C55.5976 30.4224 56.1196 28.8119 57.1635 27.7015C58.2132 26.5854 59.7153 26.0273 61.6698 26.0273C63.6242 26.0273 65.1176 26.5883 66.15 27.7102C67.1881 28.8321 67.7072 30.4455 67.7072 32.5506ZM58.4249 32.5506C58.4249 33.9674 58.6946 35.0344 59.234 35.7514C59.7733 36.4685 60.5795 36.8271 61.6524 36.8271C63.804 36.8271 64.8799 35.4016 64.8799 32.5506C64.8799 29.6938 63.8098 28.2654 61.6698 28.2654C60.5969 28.2654 59.7878 28.6268 59.2427 29.3497C58.6975 30.0668 58.4249 31.1337 58.4249 32.5506Z" fill="#21252C"/>
                                <path d="M75.1712 31.7872H80.2169V38.3625C79.3991 38.6285 78.6278 38.8135 77.9028 38.9176C77.1837 39.0275 76.4471 39.0824 75.6932 39.0824C73.7735 39.0824 72.3062 38.5215 71.2913 37.3996C70.2822 36.2719 69.7776 34.6556 69.7776 32.5506C69.7776 30.5034 70.3634 28.9073 71.5349 27.7622C72.7122 26.6172 74.3419 26.0447 76.4239 26.0447C77.7288 26.0447 78.9874 26.3049 80.1995 26.8254L79.3034 28.9767C78.3755 28.514 77.4099 28.2827 76.4065 28.2827C75.2408 28.2827 74.3071 28.6731 73.6053 29.4538C72.9036 30.2345 72.5527 31.2841 72.5527 32.6026C72.5527 33.979 72.834 35.0315 73.3966 35.7601C73.9649 36.483 74.7885 36.8444 75.8672 36.8444C76.4297 36.8444 77.001 36.7866 77.581 36.6709V34.0252H75.1712V31.7872Z" fill="#21252C"/>
                                <path d="M94.797 32.5506C94.797 34.6498 94.2751 36.2632 93.2311 37.3909C92.1872 38.5186 90.6909 39.0824 88.7423 39.0824C86.7936 39.0824 85.2973 38.5186 84.2534 37.3909C83.2094 36.2632 82.6875 34.644 82.6875 32.5332C82.6875 30.4224 83.2094 28.8119 84.2534 27.7015C85.3031 26.5854 86.8052 26.0273 88.7597 26.0273C90.7141 26.0273 92.2075 26.5883 93.2398 27.7102C94.278 28.8321 94.797 30.4455 94.797 32.5506ZM85.5148 32.5506C85.5148 33.9674 85.7845 35.0344 86.3238 35.7514C86.8632 36.4685 87.6693 36.8271 88.7423 36.8271C90.8939 36.8271 91.9697 35.4016 91.9697 32.5506C91.9697 29.6938 90.8997 28.2654 88.7597 28.2654C87.6867 28.2654 86.8777 28.6268 86.3325 29.3497C85.7874 30.0668 85.5148 31.1337 85.5148 32.5506Z" fill="#21252C"/>
                            </svg>
                        </div>
                    </td>
                    <td>
                        <div class="verticalSeparator"/>
                    </td>
                    <td>
                        <div class="title">
                            <h2>
                                <xsl:value-of select="ext:translate('request.pdf.main.title', $pdfLanguage, $configVersion)" />
                            </h2>
                        </div>
                    </td>
                </tr>
            </table>
        </header>
        
        <div class="headerDivider" />
        
        <!--  footer has to be above main in order to generate it for each page  -->
        <div id="footer-right">
            <xsl:value-of select="ext:translate('request.pdf.page', $pdfLanguage, $configVersion)" />
            <span id="page-number"/>
            <xsl:value-of select="ext:translate('request.pdf.page.of', $pdfLanguage, $configVersion)" />
            <span id="page-count"/>
        </div>
        
        <main>
            
            <div class="sectionDivider"/>
            
            <xsl:call-template name="adminTable"/>
            
            <div class="sectionDivider"/>
            
            <xsl:call-template name="basicFilingInfo"/>
            
            <div class="sectionDivider"/>
            
            <xsl:call-template name="parties"/>
            
            <div class="sectionDivider"/>
            
            <xsl:if test="map[@key='declaration']/array[@key='priorities']">
                <xsl:call-template name="priorities">
                    <xsl:with-param name="priorities" select="map[@key='declaration']/array[@key='priorities']" />
                </xsl:call-template>
            </xsl:if>
            
            <xsl:call-template name="divisional">
                <xsl:with-param name="divisional" select="map[@key='declaration']/array[@key='divisionals']" />
            </xsl:call-template>
            
            <div class="sectionDivider"/>
            
            <xsl:call-template name="claims"/>
            
            <div class="sectionDivider"/>
            
            <xsl:call-template name="fees">
                <xsl:with-param name="fees" select="map[@key='fees']"/>
            </xsl:call-template>
            
            <div class="sectionDivider"/>

            <xsl:call-template name="gdprAcceptance">
                <xsl:with-param name="gdprAcceptance" select="map[@key='basicFilingInfo']/boolean[@key='gdprAcceptance']"/>
            </xsl:call-template>

            <div class="sectionDivider"/>
            
            <xsl:call-template name="generatedFiles"/>
            
            <div class="sectionDivider"/>
            
            <xsl:call-template name="attachments">
                <xsl:with-param name="attachments" select="array[@key='attachments']"/>
            </xsl:call-template>
            
            <div class="sectionDivider"/>
            
            <xsl:call-template name="signatures">
                <xsl:with-param name="signature" select="map[@key='signature']"/>
            </xsl:call-template>
            
        </main>
    </xsl:template>
    
    <xsl:template name="applicants">
        <xsl:param name="applicants" />
        
        <div class="container">
            <xsl:for-each select="$applicants/map" >
                <table class="content">
                    <tr>
                        <td class="referenceCell">
                            <div class="reference">
                                <xsl:text>71</xsl:text>
                            </div>
                        </td>
                        <td>
                            <h3>
                                <xsl:value-of select="concat(ext:translate('request.pdf.applicant', $pdfLanguage, $configVersion), ' ', current()/number[@key='sequenceNumber'])"/>
                            </h3>
                        </td>
                    </tr>
                    <tr>
                        <td/>
                        <td>
                            <xsl:call-template name="applicant">
                                <xsl:with-param name="applicant" select="current()"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </table>
                <xsl:if test="position() != last()">
                    <div class="subSectionDivider"/>
                </xsl:if>
            </xsl:for-each>
        </div>
        
    </xsl:template>

    <xsl:template name="gdprAcceptance">
        <xsl:param name="gdprAcceptance"/>

        <div style="page-break-inside: avoid;">
            <table>
                <xsl:attribute name="class">
                    <xsl:value-of select="'content'"/>
                </xsl:attribute>
                <tr>
                    <td>
                        <xsl:attribute name="class">
                            <xsl:value-of select="'referenceCell'"/>
                        </xsl:attribute>
                    </td>
                    <td>
                        <h1>
                            <xsl:value-of select="ext:translate('gdpr-acceptance', $pdfLanguage, $configVersion)"/>
                        </h1>
                    </td>
                </tr>
                <tr>
                  <td>
                     <xsl:attribute name="class">
                         <xsl:value-of select="'referenceCell'"/>
                     </xsl:attribute>
                  </td>
                  <td>
                     <xsl:call-template name="checkBoxWithLabel">
                         <xsl:with-param name="checkboxValue" select="map[@key='basicFilingInfo']/boolean[@key='gdprAcceptance']" />
                         <xsl:with-param name="label" select="ext:translate('basic-filing.gdprAcceptance-without-link', $pdfLanguage, $configVersion)" />
                     </xsl:call-template>
                  </td>
               </tr>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template name="employees">
        <xsl:param name="employees" />
        <xsl:for-each select="$employees/map">
            <div>
                <h2>
                    <xsl:value-of select="ext:translate('request.pdf.employee', $pdfLanguage, $configVersion)"/>
                </h2>
                <div>
                    <label>
                        <xsl:value-of select="ext:translate('request.pdf.name', $pdfLanguage, $configVersion)"/>
                    </label>
                    <span class="input">
                        <xsl:value-of select="concat(
                                current()/map[@key='personalDetails']/string[@key='firstName'],
                                ' ',
                                current()/map[@key='personalDetails']/string[@key='lastName'])"/>
                    </span>
                </div>
                <div>
                    <label>
                        <xsl:value-of select="ext:translate('request.pdf.general.authorisation', $pdfLanguage, $configVersion)"/>
                    </label>
                    <span class="input">
                        <xsl:value-of select="current()/map[@key='personalDetails']/string[@key='generalAuthorization']"/>
                    </span>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="representatives">
        <xsl:param name="representatives" />

        <xsl:for-each select="$representatives/map" >
            <table style="page-break-inside: avoid;" class="content">
                <tr>
                    <td class="referenceCell">
                        <div class="reference">
                            <xsl:text>74</xsl:text>
                        </div>
                    </td>
                    <td>
                        <h3>
                            <xsl:value-of select="concat(ext:translate('request.pdf.representative', $pdfLanguage, $configVersion),' ', current()/number[@key='sequenceNumber'])"/>
                        </h3>
                    </td>
                </tr>
            </table>
            <table class="content">
                <tr>
                    <td class="referenceCell"/>
                    <td>
                        <xsl:if test="current()/string[@key='role'] = ('AGENT_NATURAL_PERSON', 'REPRESENTATIVE_NATURAL_PERSON', 'REPRESENTATIVE_EMPLOYEE')">
                            <xsl:call-template name="personalDetails">
                                <xsl:with-param name="role" select="current()/string[@key='role']"/>
                                <xsl:with-param name="personalDetails" select="current()/map[@key='personalDetails']"/>
                            </xsl:call-template>
                        </xsl:if>

                        <xsl:if test="current()/string[@key='role'] = ('AGENT_LEGAL_ENTITY', 'REPRESENTATIVE_LEGAL_ENTITY')">
                            <xsl:call-template name="companyDetails">
                                <xsl:with-param name="role" select="current()/string[@key='role']"/>
                                <xsl:with-param name="companyDetails" select="current()/map[@key='companyDetails']"/>
                            </xsl:call-template>
                        </xsl:if>

                        <xsl:call-template name="address">
                            <xsl:with-param name="addressFields" select="current()/map[@key='contactDetails']/map[@key='residenceAddress']"/>
                        </xsl:call-template>

                        <xsl:call-template name="phoneDetails">
                            <xsl:with-param name="contactDetails" select="current()/map[@key='contactDetails']"/>
                        </xsl:call-template>

                        <xsl:call-template name="nonEmptyFieldWithLabel">
                            <xsl:with-param name="label" select="ext:translate('request.pdf.email.address', $pdfLanguage, $configVersion)"/>
                            <xsl:with-param name="fieldText" select="current()/map[@key='contactDetails']/string[@key='email']"/>
                        </xsl:call-template>

                        <xsl:if test="current()/string[@key='role'] = ('REPRESENTATIVE_NATURAL_PERSON')">
                            <xsl:call-template name="preferredMeansOfNotification">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.preferred.notification', $pdfLanguage, $configVersion)" />
                                <xsl:with-param name="fieldText" select="current()/map[@key='contactDetails']/string[@key='preferredMeansOfNotification']" />
                            </xsl:call-template>
                        </xsl:if>

                        <xsl:call-template name="powerRepresentation">
                            <xsl:with-param name="powerRepresentationMap" select="current()/map[@key='powerRepresentation']"/>
                        </xsl:call-template>
                    </td>
                </tr>
            </table>

            <xsl:if test="position() != last()">
                <div class="subSectionDivider"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="inventors">
        <xsl:param name="inventors" />
        
        <xsl:for-each select="$inventors/map">
            <table class="content" style="page-break-inside: avoid;">
                <tr>
                    <td class="referenceCell">
                        <div class="reference">
                            <xsl:text>72</xsl:text>
                        </div>
                    </td>
                    <td>
                        <h3>
                            <xsl:value-of select="concat(ext:translate('request.pdf.inventor', $pdfLanguage, $configVersion), ' ', current()/number[@key='sequenceNumber'])"/>
                        </h3>
                    </td>
                </tr>
            </table>
            <table class="content">
                <tr>
                    <td class="referenceCell"/>
                    <td>
                        <xsl:call-template name="personalDetails">
                            <xsl:with-param name="role" select="current()/string[@key='role']"/>
                            <xsl:with-param name="personalDetails" select="current()/map[@key='personalDetails']"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="nonSelectedCheckBoxWithLabel">
                            <xsl:with-param name="checkboxValue" select="current()/boolean[@key='isWaiver']" />
                            <xsl:with-param name="label" select="ext:translate('request.pdf.waive.right.to.be.mentioned', $pdfLanguage, $configVersion)" />
                        </xsl:call-template>
                        
                        <xsl:call-template name="optionalSingleLineAddress">
                            <xsl:with-param name="addressFields" select="current()/map[@key='contactDetails']"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="phoneDetails">
                            <xsl:with-param name="contactDetails" select="current()/map[@key='contactDetails']"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="nonEmptyFieldWithLabel">
                            <xsl:with-param name="label" select="ext:translate('request.pdf.email', $pdfLanguage, $configVersion)"/>
                            <xsl:with-param name="fieldText" select="current()/map[@key='contactDetails']/string[@key='email']"/>
                        </xsl:call-template>
                    </td>
                </tr>
            </table>
            
            <xsl:if test="position() != last()">
                <div class="subSectionDivider"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="communicationAddress">
        <xsl:param name="communicationAddress" />

        <div class="container">
            <xsl:for-each select="$communicationAddress/map">
                <table class="content">
                    <tr>
                        <td class="referenceCell">
                            <div class="reference">
                                <xsl:text>76</xsl:text>
                            </div>
                        </td>
                        <td>
                            <h3>
                                <xsl:value-of select="ext:translate('spc.parties.communicationAddress', $pdfLanguage, $configVersion)"/>
                            </h3>
                        </td>
                    </tr>
                </table>
                <table class="content">
                    <tr>
                        <td class="referenceCell"/>
                        <td>
                            <xsl:call-template name="fieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.preferred.notification', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="ext:translate_enum(current()/string[@key='preferredMeansOfNotification'], 'procedures-common-form-parties.jsonschema-definitions-preferredMeansOfNotification', $pdfLanguage, $configVersion, $procedure)"/>
                            </xsl:call-template>

                            <xsl:if test="current()/string[@key='role'] = ('COMMUNICATION_ADDRESS_NATURAL_PERSON')">
                                <xsl:call-template name="fieldWithLabel">
                                    <xsl:with-param name="label" select="ext:translate('request.pdf.first.name', $pdfLanguage, $configVersion)"/>
                                    <xsl:with-param name="fieldText" select="current()/string[@key='firstName']"/>
                                </xsl:call-template>

                                <xsl:call-template name="fieldWithLabel">
                                    <xsl:with-param name="label" select="ext:translate('request.pdf.last.name', $pdfLanguage, $configVersion)"/>
                                    <xsl:with-param name="fieldText" select="current()/string[@key='lastName']"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:if test="current()/string[@key='role'] = ('COMMUNICATION_ADDRESS_LEGAL_ENTITY')">
                                <xsl:call-template name="fieldWithLabel">
                                    <xsl:with-param name="label" select="ext:translate('request.pdf.company', $pdfLanguage, $configVersion)"/>
                                    <xsl:with-param name="fieldText" select="current()/string[@key='company']"/>
                                </xsl:call-template>
                            </xsl:if>

                            <xsl:call-template name="fieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.street.address', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="current()/map[@key='correspondenceAddress']/string[@key='streetAddress']"/>
                            </xsl:call-template>

                            <xsl:call-template name="nonEmptyFieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.po.box', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="current()/map[@key='correspondenceAddress']/string[@key='poBox']"/>
                            </xsl:call-template>

                            <xsl:call-template name="fieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.postal.code', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="current()/map[@key='correspondenceAddress']/string[@key='postalCode']"/>
                            </xsl:call-template>

                            <xsl:call-template name="fieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.city', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="current()/map[@key='correspondenceAddress']/string[@key='city']"/>
                            </xsl:call-template>

                            <xsl:call-template name="fieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.country', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="ext:translate_enum(current()/map[@key='correspondenceAddress']/string[@key='country'], 'procedures-common-form-geo.jsonschema-definitions-country', $pdfLanguage, $configVersion, $procedure)"/>
                            </xsl:call-template>

                            <xsl:call-template name="nonEmptyFieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.telephone', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="current()/map[@key='correspondenceAddress']/string[@key='telephone']"/>
                            </xsl:call-template>

                            <xsl:call-template name="fieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.email.address', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="current()/map[@key='correspondenceAddress']/string[@key='email']"/>
                            </xsl:call-template>

                        </td>
                    </tr>
                </table>
                <xsl:if test="position() != last()">
                    <div class="subSectionDivider"/>
                </xsl:if>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template name="priorities">
        <xsl:param name="priorities" />
        
        <table style="page-break-inside: avoid;">
            <tr>
                <td class="referenceCell"/>
                <td>
                    <h1>
                        <xsl:value-of select="ext:translate('request.pdf.declaration.priority', $pdfLanguage, $configVersion)"/>
                    </h1>
                    <p>
                        <xsl:value-of select="ext:translate('request.pdf.declaration.hereby', $pdfLanguage, $configVersion)" />
                    </p>
                </td>
            </tr>
        </table>
        
        <table style="page-break-inside: avoid;">
            <thead>
                <tr>
                    <th>
                        <xsl:value-of select="ext:translate('request.pdf.priority', $pdfLanguage, $configVersion)"/>
                    </th>
                    <th>
                        <xsl:value-of select="ext:translate('request.pdf.state', $pdfLanguage, $configVersion)"/>
                    </th>
                    <th>
                        <xsl:value-of select="ext:translate('request.pdf.filing.date', $pdfLanguage, $configVersion)"/>
                    </th>
                    <th>
                        <xsl:value-of select="ext:translate('request.pdf.kind', $pdfLanguage, $configVersion)"/>
                    </th>
                    <th>
                        <xsl:value-of select="ext:translate('request.pdf.application.number', $pdfLanguage, $configVersion)"/>
                    </th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="$priorities/map">
                    <tr>
                        <td>
                            <xsl:value-of select="concat('request.pdf.priority ', current()/number[@key='sequenceNumber'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="current()/string[@key='office']"/>
                        </td>
                        <td>
                            <xsl:value-of select="current()/string[@key='filingDate']"/>
                        </td>
                        <td>
                            <xsl:value-of select="ext:translate_enum(current()/string[@key='applicationKind'], 'procedures-common-form-geo.jsonschema-definitions-country', $pdfLanguage, $configVersion, $procedure)" />
                        </td>
                        <td>
                            <xsl:value-of select="current()/string[@key='applicationNumber']"/>
                        </td>
                    </tr>
                </xsl:for-each>
                
            </tbody>
        </table>
        
        <div class="sectionDivider"/>

        <table class="content" style="page-break-inside: avoid;">
            <tr>
                <td class="referenceCell"/>
                <td>
                    <h1>
                        <xsl:value-of select="ext:translate('request.pdf.rights', $pdfLanguage, $configVersion)"/>
                    </h1>
                    <p>
                        <xsl:value-of select="ext:translate('request.pdf.rights.description', $pdfLanguage, $configVersion)"/>
                    </p>
                    <span class="input">
                        <xsl:value-of select="' '"/>
                    </span>
                    <p>
                        <xsl:value-of select="ext:translate('request.pdf.npo.informative', $pdfLanguage, $configVersion)"/>
                    </p>
                </td>
            </tr>
        </table>
        
        <table>
            <thead>
                <tr>
                    <th>
                        <xsl:value-of select="ext:translate('request.pdf.request', $pdfLanguage, $configVersion)"/>
                    </th>
                    <th>
                        <xsl:value-of select="ext:translate('request.pdf.application.number', $pdfLanguage, $configVersion)"/>
                    </th>
                    <th>
                        
                        <xsl:value-of select="ext:translate('request.pdf.access.code', $pdfLanguage, $configVersion)"/>
                    </th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="$priorities/map">
                    <tr>
                        <td>
                            <input type="checkbox"/>
                        </td>
                        <td>
                            <xsl:value-of select="current()/string[@key='applicationNumber']"/>
                        </td>
                        <td>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
        
        <div class="sectionDivider"/>
        
    </xsl:template>
    
    <xsl:template name="divisional">
        <xsl:param name="divisional"/>
        
        <table class="content">
            <tr>
                <td class="referenceCell"/>
                <td>
                    <xsl:for-each select="$divisional/map" >
                        <div>
                            <h2>
                                <xsl:value-of select="ext:translate('request.pdf.previous.application', $pdfLanguage, $configVersion)" />
                            </h2>
                            <xsl:call-template name="checkBoxWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.divisional.application', $pdfLanguage, $configVersion)" />
                                <xsl:with-param name="checkboxValue" select="false()" />
                            </xsl:call-template>
                            <xsl:if test="current()/string[@key='filingNumber']">
                                <div>
                                    <label>
                                        <xsl:value-of select="ext:translate('request.pdf.earlier.application', $pdfLanguage, $configVersion)" />
                                    </label>
                                    <span class="input">
                                        <xsl:value-of select="current()/string[@key='filingNumber']" />
                                    </span>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="current()/string[@key='filingDate']">
                                <div>
                                    <label>
                                        <xsl:value-of select="ext:translate('request.pdf.filing.date', $pdfLanguage, $configVersion)" />
                                    </label>
                                    <span class="input">
                                        <xsl:value-of select="current()/string[@key='filingDate']" />
                                    </span>
                                </div>
                            </xsl:if>
                        </div>
                    </xsl:for-each>
                </td>
            </tr>
        </table>
        
        
    </xsl:template>
    
    <xsl:template name="adminTable">
        <table>
            <thead>
                <tr>
                    <th colspan="2"  class="adminTableCell">
                        <xsl:value-of select="ext:translate('request.pdf.oficial.use', $pdfLanguage, $configVersion)" />
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td width="50%"  class="adminTableCell">
                        <xsl:value-of select="ext:translate('request.pdf.application.number', $pdfLanguage, $configVersion)" />
                    </td>
                    <td>
                        <xsl:value-of select="map[@key='receipt']/string[@key='applicationNumber']" />
                    </td>
                </tr>
                <tr>
                    <td class="adminTableCell">
                        <xsl:value-of select="ext:translate('request.pdf.date.filing', $pdfLanguage, $configVersion)" />
                    </td>
                    <td>
                        <xsl:value-of select="map[@key='receipt']/string[@key='senderDate']" />
                    </td>
                </tr>
            </tbody>
        </table>
        
    </xsl:template>
    
    <xsl:template name="basicFilingInfo">
        <table class="content">
            <tr>
                <td class="referenceCell"/>
                <td>
                    
                    <xsl:call-template name="checkBoxWithLabel">
                        <xsl:with-param name="label" select="ext:translate('request.pdf.grant.national.patent', $pdfLanguage, $configVersion)" />
                        <xsl:with-param name="checkboxValue" select="map[@key='basicFilingInfo']/boolean[@key='acceleratedPatentGrantProcedure']" />
                    </xsl:call-template>
                    
                    <div class="subSectionDivider"/>
                    
                    <div>
                        <div class="input-item"> 
                            <xsl:call-template name="fieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.procedure.language', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="map[@key='basicFilingInfo']/string[@key='language']"/>
                                <xsl:with-param name="customFieldClass" select="'input-tiny'"/>
                            </xsl:call-template>
                        </div>
                        <div class="input-item">
                            <xsl:call-template name="fieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.filing.language', $pdfLanguage, $configVersion)"/>
                                <xsl:with-param name="fieldText" select="$pdfLanguage"/>
                                <xsl:with-param name="customFieldClass" select="'input-tiny uppercase'"/>
                            </xsl:call-template>
                        </div>
                    </div>
                    
                    <xsl:call-template name="fieldWithLabel">
                        <xsl:with-param name="label" select="ext:translate('request.pdf.partie.reference', $pdfLanguage, $configVersion)"/>
                        <xsl:with-param name="fieldText" select="map[@key='basicFilingInfo']/string[@key='userReference']"/>
                    </xsl:call-template>

                    <xsl:call-template name="fieldWithLabel">
                        <xsl:with-param name="label" select="ext:translate('request.pdf.partie.caseId', $pdfLanguage, $configVersion)"/>
                        <xsl:with-param name="fieldText" select="map[@key='basicFilingInfo']/string[@key='caseId']"/>
                    </xsl:call-template>
                </td>
            </tr>
        </table>
        
        <div class="sectionDivider"/>
        
        <table class="content">
            <tr>
                <td class="referenceCell"/>
                <td>
                    <h1>
                        <xsl:value-of select="ext:translate('request.pdf.basic.filing.info', $pdfLanguage, $configVersion)"/>
                    </h1>
                </td>
            </tr>
        </table>
        
        <table class="content">
            <tr>
                <td class="referenceCell">
                    <div  class="reference">
                        <xsl:text>54</xsl:text>
                    </div>
                </td>
                <td>
                    
                    <xsl:call-template name="fieldWithLabel">
                        <xsl:with-param name="label" select="ext:translate('request.pdf.title.invention', $pdfLanguage, $configVersion)"/>
                        <xsl:with-param name="fieldText" select="map[@key='basicFilingInfo']/string[@key='titleOfInvention']"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="checkBoxWithLabel">
                        <xsl:with-param name="label" select="ext:translate('request.pdf.request.to.publish', $pdfLanguage, $configVersion)" />
                        <xsl:with-param name="checkboxValue" select="map[@key='basicFilingInfo']/boolean[@key='fastTrack']" />
                    </xsl:call-template>
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template name="parties">
        
        <div>
            <table class="content" style="page-break-inside: avoid;">
                <tr>
                    <td class="referenceCell"/>
                    <td>
                        <h1>
                            <xsl:value-of select="ext:translate('request.pdf.parties', $pdfLanguage, $configVersion)"/>
                        </h1>
                        <xsl:if test="not(map[@key='parties']/array[@key='applicants'] != '' or map[@key='parties']/array[@key='representatives'] != '' or map[@key='parties']/array[@key='inventors'] = '')" >
                            <xsl:value-of select="ext:translate('request.pdf.data.not.entered', $pdfLanguage, $configVersion)"/>
                        </xsl:if>
                    </td>
                </tr>
            </table>
            <xsl:if test="map[@key='parties']/array[@key='applicants'] != ''" >
                <div class="subSectionDivider"/>
                <xsl:call-template name="applicants">
                    <xsl:with-param name="applicants" select="map[@key='parties']/array[@key='applicants']"/>
                </xsl:call-template>
            </xsl:if>
        </div>
        
        <xsl:if test="map[@key='parties']/array[@key='employees'] != ''" >
            <div class="subSectionDivider"/>
            <xsl:call-template name="employees">
                <xsl:with-param name="employees" select="map[@key='parties']/array[@key='employess']"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="map[@key='parties']/array[@key='representatives'] != ''" >
            <div class="subSectionDivider"/>
            <xsl:call-template name="representatives">
                <xsl:with-param name="representatives" select="map[@key='parties']/array[@key='representatives']"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="map[@key='parties']/array[@key='inventors'] != ''" >
            <div class="subSectionDivider"/>
            <xsl:call-template name="inventors">
                <xsl:with-param name="inventors" select="map[@key='parties']/array[@key='inventors']"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="map[@key='parties']/array[@key='communicationAddress'] != ''" >
            <div class="subSectionDivider"/>
            <xsl:call-template name="communicationAddress">
                <xsl:with-param name="communicationAddress" select="map[@key='parties']/array[@key='communicationAddress']"/>
            </xsl:call-template>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template name="claims">
        <xsl:variable name="translationClaimAttachment" select="array[@key='attachments']/map[string[@key='attachmentType'] = 'TRANSLATION_CLAIMS']"/>
        <xsl:variable name="translationClaimCombined" select="array[@key='attachments']/map[string[@key='attachmentType'] = 'COMBINED']"/>
        <table class="content">
            <tr>
                <td class="referenceCell"/>
                <td>
                    <h1>
                        <xsl:value-of select="ext:translate('request.pdf.claims', $pdfLanguage, $configVersion)" />
                    </h1>
                    <label>
                        <xsl:value-of select="ext:translate('request.pdf.number.claims', $pdfLanguage, $configVersion)" />
                    </label>
                    <span class="input">
                        <xsl:choose>
                            <xsl:when test="$translationClaimAttachment != ''">
                                <xsl:value-of select="$translationClaimAttachment/number[@key='numberOfClaims']" />
                            </xsl:when>

<!--                            and ($translationClaimCombined/array[@key='combinedFileTypeScopes']/map[string[@key='type'] = 'TRANSLATION_CLAIMS'] != '')-->
                            <xsl:when test="$translationClaimCombined != ''">
                                <xsl:value-of select="$translationClaimCombined/array[@key='combinedFileTypeScopes']/map[string[@key='type'] = 'TRANSLATION_CLAIMS']/number[@key='numberOfClaims']" />
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:value-of select="'0'" />
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </span>
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template name="fees">
        <xsl:param name="fees"/>
        
        <div style="page-break-inside: avoid;">
            
            <table class="content">
                <tr>
                    <td class="referenceCell"/>
                    <td>
                        <h1>
                            <xsl:value-of select="ext:translate('request.pdf.payment', $pdfLanguage, $configVersion)" />
                        </h1>
                        
                        <xsl:call-template name="fieldWithLabel">
                            <xsl:with-param name="label" select="ext:translate('request.pdf.payment.method', $pdfLanguage, $configVersion)" />
                            <xsl:with-param name="fieldText" select="ext:translate_enum($fees/string[@key='methodOfPayment'], 'procedures-common-form-geo.jsonschema-definitions-country', $pdfLanguage, $configVersion, $procedure)" />
                        </xsl:call-template>

                        <xsl:if test="$fees/string[@key='methodOfPayment'] = ('depositAccount')">
                            <xsl:call-template name="nonEmptyFieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.payment.deposit.account.number', $pdfLanguage, $configVersion)" />
                                <xsl:with-param name="fieldText" select="$fees/map[@key='accountInformation']/string[@key='accountNumber']" />
                            </xsl:call-template>

                            <xsl:call-template name="nonEmptyFieldWithLabel">
                                <xsl:with-param name="label" select="ext:translate('request.pdf.payment.account.holder', $pdfLanguage, $configVersion)" />
                                <xsl:with-param name="fieldText" select="$fees/map[@key='accountInformation']/string[@key='accountHolder']" />
                            </xsl:call-template>
                        </xsl:if>
                        
                    </td>
                </tr>
            </table>
            
            <table>
                <thead>
                    <tr>
                        <th>
                            <xsl:value-of select="ext:translate('request.pdf.fee.code', $pdfLanguage, $configVersion)" />
                        </th>
                        <th>
                            <xsl:value-of select="ext:translate('request.pdf.fee.text', $pdfLanguage, $configVersion)" />
                        </th>
                        <th>
                            <xsl:value-of select="ext:translate('request.pdf.fee.price', $pdfLanguage, $configVersion)" />
                        </th>
                        <th>
                            <xsl:value-of select="ext:translate('request.pdf.fee.quantity', $pdfLanguage, $configVersion)" />
                        </th>
                        <th>
                            <xsl:value-of select="ext:translate('request.pdf.fee.discount', $pdfLanguage, $configVersion)" />
                        </th>
                        <th>
                            <xsl:value-of select="ext:translate('request.pdf.fee.subtotal', $pdfLanguage, $configVersion)" />
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:choose>
                        <xsl:when test="$fees/map[@key='feesSelection']/array[@key='selectedFees'] != ''">
                            <xsl:for-each select="$fees/map[@key='feesSelection']/array[@key='selectedFees']/map">
                                <tr>
                                    <td>
                                        <xsl:value-of select="current()/string[@key='code']" />
                                    </td>
                                    <td>
                                        <xsl:call-template name="feeDescription">
                                            <xsl:with-param name="feeCode" select="current()/string[@key='code']"/>
                                            <xsl:with-param name="pdfLanguage" select="$pdfLanguage"/>
                                            <xsl:with-param name="configVersion" select="$configVersion"/>
                                        </xsl:call-template>
                                    </td>
                                    <td>
                                        <xsl:value-of select="concat($fees/map[@key='feesSelection']/string[@key='currency'], ' ', format-number(current()/number[@key='price'], '#.###,00', 'dec'))" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="current()/number[@key='quantity']" />
                                    </td>
                                    <td>
                                        <xsl:if test="current()/number[@key='discount']">
                                            <xsl:value-of select="concat(current()/number[@key='discount'],'%')" />
                                        </xsl:if>
                                    </td>
                                    <td class="tableCellRight">
                                        <xsl:value-of select="concat($fees/map[@key='feesSelection']/string[@key='currency'], ' ', format-number(current()/number[@key='subtotal'], '#.###,00', 'dec'))" />
                                    </td>
                                </tr>
                            </xsl:for-each>
                            <tr>
                                <td colspan="6" class="tableCellBottomRight">
                                    <xsl:choose>
                                        <xsl:when test="$fees/map[@key='feesSelection']/number[@key='total'] != ''">
                                            <xsl:value-of select="concat(ext:translate('request.pdf.total', $pdfLanguage, $configVersion),' ', $fees/map[@key='feesSelection']/string[@key='currency'], ' ', format-number($fees/map[@key='feesSelection']/number[@key='total'], '#.###,00', 'dec'))" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>&#160;</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:otherwise>
                            <tr>
                                <td colspan="6"><xsl:text>&#160;</xsl:text></td>
                            </tr>
                        </xsl:otherwise>
                    </xsl:choose>
                </tbody>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template name="generatedFiles">
        <div style="page-break-inside: avoid;">
            <table class="content">
                <tr>
                    <td class="referenceCell"/>
                    <td>
                        <h1>
                            <xsl:value-of select="ext:translate('request.pdf.forms', $pdfLanguage, $configVersion)" />
                        </h1>
                    </td>
                </tr>
            </table>
            <table>
                <thead>
                    <tr>
                        <th>
                            <xsl:value-of select="ext:translate('request.pdf.form', $pdfLanguage, $configVersion)" />
                        </th>
                        <th>
                            <xsl:value-of select="ext:translate('request.pdf.details', $pdfLanguage, $configVersion)" />
                        </th>
                        <th>
                            <xsl:value-of select="ext:translate('request.pdf.system.file.name', $pdfLanguage, $configVersion)" />
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <xsl:value-of select="$configXml/map[@key='annexF']/map[@key='blob']/map[@key='request-pdf']/string[@key='name']" />
                        </td>
                        <td>
                            <xsl:value-of select="ext:translate('request.pdf.request.pdf', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:value-of select="$configXml/map[@key='annexF']/map[@key='blob']/map[@key='request-pdf']/string[@key='name']" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="attachments">
        <xsl:param name="attachments"/>
        
        <div style="page-break-inside: avoid;">
            <!--Title and subtitle for Attachments + Technical documents-->
            <table class="content">
                <tr>
                    <td class="referenceCell">
                    </td>
                    <td>
                        <h1>
                            <xsl:value-of select="ext:translate('request.pdf.documents', $pdfLanguage, $configVersion)"/>
                        </h1>
                        <h3>
                            <xsl:value-of select="ext:translate('request.pdf.technical.documents', $pdfLanguage, $configVersion)"/>
                        </h3>
                    </td>
                </tr>
            </table>
            
            <!--Technical documents table-->
            <div class="attachmentsTable">
                <table>
                    <thead>
                        <tr>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.document.type', $pdfLanguage, $configVersion)" />
                            </th>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.file.name', $pdfLanguage, $configVersion)" />
                            </th>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.system.file.name', $pdfLanguage, $configVersion)" />
                            </th>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.page.number', $pdfLanguage, $configVersion)" />
                            </th>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.other.information', $pdfLanguage, $configVersion)" />
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:if test="not($attachments/map[string[@key='attachmentSubType'] = 'TECHNICAL'])">
                            <tr>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                            </tr>
                        </xsl:if>
                        <!-- loop only technical documents -->
                        <xsl:for-each select="$attachments/map[string[@key='attachmentSubType'] = 'TECHNICAL']">
                                <tr>
                                    <td>
                                        <xsl:value-of select="ext:translate(concat('request.pdf.attachment.type.', lower-case(current()/string[@key='attachmentType'])), $pdfLanguage, $configVersion)" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="current()/string[@key='originalFileName']" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="current()/string[@key='fileName']" />
                                    </td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="current()/string[@key='attachmentType'] = 'PRE-CONVERSION'">
                                                <xsl:value-of select="''" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="current()/number[@key='totalPages']" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td>
                                        <!-- Additional data for the attachment documents -->
                                        <xsl:choose>
                                            <xsl:when test="current()/string[@key='attachmentType'] = 'COMBINED'">
                                                <xsl:for-each select="current()/array[@key='combinedFileTypeScopes']/map" >
                                                    <xsl:choose>
                                                        <xsl:when test="current()/string[@key='type'] = 'TRANSLATION_CLAIMS' and current()/number[@key='numberOfClaims']">
                                                            <xsl:value-of select="concat(ext:translate('request.pdf.attachment.no.of.claims', $pdfLanguage, $configVersion), ': ', current()/number[@key='numberOfClaims'], ';')" />
                                                        </xsl:when>
                                                        <xsl:when test="current()/string[@key='type'] = 'TRANSLATION_ABSTRACT' and current()/string[@key='figureToBePublished']!=''">
                                                            <xsl:value-of select="concat(ext:translate('request.pdf.attachment.figure.to.be.published', $pdfLanguage, $configVersion), ': ', current()/string[@key='figureToBePublished'],';')" />
                                                        </xsl:when>
                                                        <xsl:when test="current()/string[@key='type'] = 'TRANSLATION_DRAWINGS' and current()/number[@key='numberOfDrawings']!=''">
                                                            <xsl:value-of select="concat(ext:translate('request.pdf.attachment.number.of.drawings', $pdfLanguage, $configVersion), ': ', current()/number[@key='numberOfDrawings'],';')" />
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="current()/string[@key='attachmentType'] = 'TRANSLATION_CLAIMS' and current()/number[@key='numberOfClaims']">
                                                <xsl:value-of select="concat(ext:translate('request.pdf.attachment.no.of.claims', $pdfLanguage, $configVersion), ': ', current()/number[@key='numberOfClaims'])" />
                                            </xsl:when>
                                            <xsl:when test="current()/string[@key='attachmentType'] = 'TRANSLATION_ABSTRACT' and current()/string[@key='figureToBePublished']!=''">
                                                <xsl:value-of select="concat(ext:translate('request.pdf.attachment.figure.to.be.published', $pdfLanguage, $configVersion), ': ', current()/string[@key='figureToBePublished'])" />
                                            </xsl:when>
                                            <xsl:when test="current()/string[@key='attachmentType'] = 'TRANSLATION_DRAWINGS' and current()/number[@key='numberOfDrawings']!=''">
                                                <xsl:value-of select="concat(ext:translate('request.pdf.attachment.number.of.drawings', $pdfLanguage, $configVersion), ': ', current()/number[@key='numberOfDrawings'])" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="''" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="subSectionDivider"/>
        
        <div style="page-break-inside: avoid;">
            <!--Additional documents subtitle-->
            <table class="content">
                <tr>
                    <td class="referenceCell"/>
                    <td>
                        <h3>
                            <xsl:value-of select="ext:translate('request.pdf.additional.documents', $pdfLanguage, $configVersion)"/>
                        </h3>
                    </td>
                </tr>
            </table>
            
            <!--Additional documents table-->
            <div class="attachmentsTable">
                <table>
                    <thead>
                        <tr>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.document.type', $pdfLanguage, $configVersion)" />
                            </th>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.file.name', $pdfLanguage, $configVersion)" />
                            </th>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.system.file.name', $pdfLanguage, $configVersion)" />
                            </th>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.page.number', $pdfLanguage, $configVersion)" />
                            </th>
                            <th>
                                <xsl:value-of select="ext:translate('request.pdf.attachment.other.information', $pdfLanguage, $configVersion)" />
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:if test="not($attachments/map[string[@key='attachmentSubType'] != 'TECHNICAL'])">
                            <tr>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                            </tr>
                        </xsl:if>
                        <!-- loop only additional documents -->
                        <xsl:for-each select="$attachments/map">
                            <xsl:if test="not(current()/string[@key='attachmentSubType'] = 'TECHNICAL')" >
                                <tr>
                                    <td>
                                        <xsl:value-of select="ext:translate_enum(current()/string[@key='attachmentType'], 'procedures-common-form-geo.jsonschema-definitions-country', $pdfLanguage, $configVersion, $procedure)" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="current()/string[@key='originalFileName']" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="current()/string[@key='fileName']" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="current()/number[@key='totalPages']" />
                                    </td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="current()/string[@key='attachmentType'] = 'OTHER' and current()/string[@key='documentType']">
                                                <xsl:value-of select="current()/string[@key='documentType']" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="''" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:for-each>
                    </tbody>
                </table>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="signatures">
        <xsl:param name="signature" />
        <xsl:if test="not(map[@key='signature']  != '')">
            <table class="content" style="page-break-inside: avoid;">
                <tr>
                    <td class="referenceCell"/>
                    <td>
                        <h1>
                            <xsl:value-of select="ext:translate('request.pdf.signatures', $pdfLanguage, $configVersion)" />
                        </h1>
                        <xsl:if test="not(map[@key='signature']  != '')">
                            <xsl:value-of select="ext:translate('request.pdf.data.not.entered', $pdfLanguage, $configVersion)"/>
                        </xsl:if>
                    </td>
                </tr>
            </table>
        </xsl:if>
        
        <xsl:if test="map[@key='signature']  != ''">
            <table class="content" style="page-break-inside: avoid;">
                <tr>
                    <td class="referenceCell"></td>
                    <td>
                        <h1>
                            <xsl:value-of select="ext:translate('request.pdf.signatures', $pdfLanguage, $configVersion)" />
                        </h1>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td class="signatureLabel">
                        <label><xsl:value-of select="ext:translate('request.pdf.date', $pdfLanguage, $configVersion)" /></label>
                    </td>
                    <td>
                        <xsl:value-of select="ext:translate('request.pdf.signature.date', $pdfLanguage, $configVersion)"/>
                        <xsl:if test="$signature/string[@key='signatureDate'] != '' ">
                            <xsl:value-of select="format-dateTime($signature/string[@key='signatureDate'], '[Y]-[M]-[D] [H].[m] [PN,2-2]') " />
                        </xsl:if>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td class="signatureLabel">
                        <label><xsl:value-of select="ext:translate('request.pdf.signed.by', $pdfLanguage, $configVersion)" /></label>
                    </td>
                    <td>
                        <xsl:value-of select="$signature/string[@key='signingUserName']" />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td class="signatureLabel">
                        <label><xsl:value-of select="ext:translate('request.pdf.capacity', $pdfLanguage, $configVersion)" /></label>
                    </td>
                    <td>
                        <xsl:value-of select="$signature/string[@key='signerCapacity']" />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td class="signatureLabel">
                        <label><xsl:value-of select="ext:translate('request.pdf.signature', $pdfLanguage, $configVersion)" /></label>
                    </td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="$signature/string[@key='signatureType'] = 'FACSIMILE'">
                                <img class="signatureImage">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="concat('data:image/png;base64,', $signatureImage)"/>
                                    </xsl:attribute>
                                    
                                    <xsl:attribute name="alt">
                                        <xsl:value-of select="ext:translate('request.pdf.signature.image', $pdfLanguage, $configVersion)"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <span>
                                    <xsl:value-of select="$signature/string[@key='signatureText']" />
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
            </table>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="applicant">
        <xsl:param name="applicant" />
        <div class="container">
            
            <xsl:if test="$applicant/string[@key='role'] = ('APPLICANT_NATURAL_PERSON')">
                <xsl:call-template name="personalDetails">
                    <xsl:with-param name="role" select="$applicant/string[@key='role']"/>
                    <xsl:with-param name="personalDetails" select="$applicant/map[@key='personalDetails']"/>
                </xsl:call-template>

                <xsl:call-template name="nonSelectedCheckBoxWithLabel">
                    <xsl:with-param name="checkboxValue" select="$applicant/boolean[@key='isInventor']" />
                    <xsl:with-param name="label" select="ext:translate('request.pdf.applicant.is.inventor', $pdfLanguage, $configVersion)" />
                </xsl:call-template>
            </xsl:if>
            
            <xsl:if test="$applicant/string[@key='role'] = ('APPLICANT_LEGAL_ENTITY')">
                <xsl:call-template name="companyDetails">
                    <xsl:with-param name="role" select="$applicant/string[@key='role']"/>
                    <xsl:with-param name="companyDetails" select="$applicant/map[@key='companyDetails']"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:call-template name="address">
                <xsl:with-param name="addressFields" select="current()/map[@key='contactDetails']/map[@key='residenceAddress']"/>
            </xsl:call-template>
            
            <xsl:call-template name="phoneDetails">
                <xsl:with-param name="contactDetails" select="$applicant/map[@key='contactDetails']"/>
            </xsl:call-template>
            
            <xsl:call-template name="fieldWithLabel">
                <xsl:with-param name="label" select="ext:translate('request.pdf.email', $pdfLanguage, $configVersion)"/>
                <xsl:with-param name="fieldText" select="$applicant/map[@key='contactDetails']/string[@key='email']"/>
            </xsl:call-template>

            <xsl:call-template name="additionalDetails">
                <xsl:with-param name="role" select="$applicant/string[@key='role']"/>
                <xsl:with-param name="additionalDetails" select="$applicant/map[@key='additionalDetails']"/>
            </xsl:call-template>

            <xsl:if test="$applicant/string[@key='role'] = ('APPLICANT_NATURAL_PERSON')">
                <xsl:call-template name="nonEmptyFieldWithLabel">
                    <xsl:with-param name="label" select="ext:translate('request.pdf.applicant.category', $pdfLanguage, $configVersion)"/>
                    <xsl:with-param name="fieldText" select="ext:translate_enum(current()/string[@key='category'], 'procedures-common-form-parties.jsonschema-definitions-applicantCategory', $pdfLanguage, $configVersion, $procedure)"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:call-template name="declarationOfRights">
                <xsl:with-param name="declarationOfRightsSection" select="$applicant/map[@key='declarationOfRights']" />
            </xsl:call-template>
        </div>
        
    </xsl:template>

    <xsl:template name="personalDetails">
        <xsl:param name="role"/>
        <xsl:param name="personalDetails"/>

        <xsl:if test="$role = ('AGENT_NATURAL_PERSON', 'REPRESENTATIVE_NATURAL_PERSON', 'REPRESENTATIVE_EMPLOYEE')">
            <xsl:call-template name="fieldWithLabel">
                <xsl:with-param name="label" select="ext:translate('request.pdf.registration.number', $pdfLanguage, $configVersion)"/>
                <xsl:with-param name="fieldText" select="$personalDetails/string[@key='registrationNumber']"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.first.name', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$personalDetails/string[@key='firstName']"/>
        </xsl:call-template>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.last.name', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$personalDetails/string[@key='lastName']"/>
        </xsl:call-template>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.identification.number', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$personalDetails/string[@key='idNumber']"/>
        </xsl:call-template>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.nationality', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="ext:translate_enum($personalDetails/string[@key='nationality'], 'procedures-common-form-geo.jsonschema-definitions-country', $pdfLanguage, $configVersion, $procedure)"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="companyDetails">
        <xsl:param name="role"/>
        <xsl:param name="companyDetails"/>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.registration.number', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$companyDetails/string[@key='registrationNumber']"/>
        </xsl:call-template>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.id.number', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$companyDetails/string[@key='idNumber']"/>
        </xsl:call-template>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.company', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$companyDetails/string[@key='company']"/>
        </xsl:call-template>

        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.department', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$companyDetails/string[@key='department']"/>
        </xsl:call-template>

        <xsl:if test="$role = ('PROFESSIONAL_REPRESENTATIVE', 'ASSOCIATION', 'LEGAL_PRACTITIONER')">
            <xsl:call-template name="nonEmptyFieldWithLabel">
                <xsl:with-param name="label" select="ext:translate('request.pdf.general.authorisation', $pdfLanguage, $configVersion)"/>
                <xsl:with-param name="fieldText" select="$companyDetails/string[@key='generalAuthorization']"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$role = ('APPLICANT_LEGAL_ENTITY', 'ASSOCIATION')">
            <xsl:call-template name="fieldWithLabel">
                <xsl:with-param name="label" select="ext:translate('request.pdf.place.of.business', $pdfLanguage, $configVersion)"/>
                <xsl:with-param name="fieldText" select="ext:translate_enum($companyDetails/string[@key='placeOfBusiness'], 'procedures-common-form-geo.jsonschema-definitions-country', $pdfLanguage, $configVersion, $procedure)"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$role = ('ASSOCIATION')">
            <xsl:call-template name="fieldWithLabel">
                <xsl:with-param name="label" select="ext:translate('request.pdf.association.number', $pdfLanguage, $configVersion)"/>
                <xsl:with-param name="fieldText" select="$companyDetails/string[@key='associationNumber']"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="phoneDetails">
        <xsl:param name="contactDetails"/>
        
        <xsl:if test="$contactDetails">
            <xsl:if test="$contactDetails/string[@key='telephone'] or $contactDetails/string[@key='fax']">
                <div>
                    <div class="input-item-close">
                        <xsl:call-template name="nonEmptyFieldWithLabel">
                            <xsl:with-param name="label" select="ext:translate('request.pdf.telephone', $pdfLanguage, $configVersion)"/>
                            <xsl:with-param name="fieldText" select="$contactDetails/string[@key='telephone']"/>
                            <xsl:with-param name="customFieldClass" select="'input-medium'" />
                        </xsl:call-template>
                    </div>
                    <div class="input-item">
                        <xsl:call-template name="nonEmptyFieldWithLabel">
                            <xsl:with-param name="label" select="ext:translate('request.pdf.fax', $pdfLanguage, $configVersion)"/>
                            <xsl:with-param name="fieldText" select="$contactDetails/string[@key='fax']"/>
                            <xsl:with-param name="customFieldClass" select="'input-medium'" />
                        </xsl:call-template>
                    </div>
                </div>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="additionalDetails">
        <xsl:param name="role"/>
        <xsl:param name="additionalDetails"/>

        <xsl:call-template name="ownershipPercentage">
            <xsl:with-param name="label" select="ext:translate('request.pdf.ownership', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$additionalDetails/number[@key='ownershipPercentage']"/>
        </xsl:call-template>

        <xsl:if test="$role = ('APPLICANT_NATURAL_PERSON')">
            <xsl:call-template name="nonSelectedCheckBoxWithLabel">
                <xsl:with-param name="checkboxValue" select="$additionalDetails/boolean[@key='isInventor']" />
                <xsl:with-param name="label" select="ext:translate('request.pdf.applicant.is.inventor', $pdfLanguage, $configVersion)" />
            </xsl:call-template>

            <xsl:call-template name="nonSelectedCheckBoxWithLabel">
                <xsl:with-param name="checkboxValue" select="$additionalDetails/boolean[@key='waiver']" />
                <xsl:with-param name="label" select="ext:translate('request.pdf.applicant.waiver', $pdfLanguage, $configVersion)" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="powerRepresentation">
        <xsl:param name="powerRepresentationMap"/>

        <xsl:variable name="isPowerRepresentationAttached" select="$powerRepresentationMap/boolean[@key='isPowerRepresentationAttached']" />
        <xsl:variable name="isGeneralAuthorisationGranted" select="$powerRepresentationMap/boolean[@key='isGeneralAuthorisationGranted']" />

        <xsl:if test="$isPowerRepresentationAttached = true() or $isGeneralAuthorisationGranted = true()" >
            <div style="page-break-inside: avoid;">
                <label>
                    <xsl:value-of select="ext:translate('request.pdf.power.of.representation', $pdfLanguage, $configVersion)"/>
                </label>
                <div class="divider"/>
                <xsl:call-template name="nonSelectedCheckBoxWithLabel">
                    <xsl:with-param name="checkboxValue" select="$isPowerRepresentationAttached" />
                    <xsl:with-param name="label" select="ext:translate('request.pdf.power.of.representation.attached', $pdfLanguage, $configVersion)" />
                </xsl:call-template>
                <xsl:call-template name="nonSelectedCheckBoxWithLabel">
                    <xsl:with-param name="checkboxValue" select="$isGeneralAuthorisationGranted" />
                    <xsl:with-param name="label" select="ext:translate('request.pdf.general.authorisation.granted', $pdfLanguage, $configVersion)" />
                </xsl:call-template>
                <xsl:if test="$isGeneralAuthorisationGranted = true()">
                    <xsl:call-template name="nonEmptyFieldWithLabel">
                        <xsl:with-param name="label" select="ext:translate('request.pdf.general.authorisation', $pdfLanguage, $configVersion)"/>
                        <xsl:with-param name="fieldText" select="$powerRepresentationMap/string[@key='generalAuthorisation']"/>
                        <xsl:with-param name="customFieldClass" select="'input-medium'" />
                    </xsl:call-template>
                </xsl:if>
            </div>
        </xsl:if>

    </xsl:template>
    
    <xsl:template name="availabilityDetails">
        <xsl:param name="contactDetails"/>
        
        <div class="container">
            <xsl:if test="$contactDetails/string[@key='telephone']">
                <div>
                    <label>
                        <xsl:value-of select="ext:translate('request.pdf.telephone:', $pdfLanguage, $configVersion)"/>
                    </label>
                    <span class="input">
                        <xsl:value-of select="$contactDetails/string[@key='telephone']"/>
                    </span>
                </div>
            </xsl:if>
            
            <xsl:if test="$contactDetails/string[@key='fax']">
                <div>
                    <label>
                        <xsl:value-of select="ext:translate('request.pdf.fax', $pdfLanguage, $configVersion)"/>
                    </label>
                    <span class="input">
                        <xsl:value-of select="$contactDetails/string[@key='fax']"/>
                    </span>
                </div>
            </xsl:if>
            
            <xsl:if test="$contactDetails/string[@key='email']">
                <div>
                    <label>
                        <xsl:value-of select="ext:translate('request.pdf.email', $pdfLanguage, $configVersion)"/>
                    </label>
                    <span class="input">
                        <xsl:value-of select="$contactDetails/string[@key='email']"/>
                    </span>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
    <!--template for a text area with label displayed even if the content is empty -->
    <xsl:template name="areaWithLabel">
        <xsl:param name="label"/>
        <xsl:param name="fieldText"/>
        
        <div style="page-break-inside: avoid;">
            <label>
                <xsl:value-of select="$label"/>
            </label>
            <span class="textarea">
                <xsl:value-of select="$fieldText"/>
            </span>
        </div>
        
        <div class="divider" />
    </xsl:template>

    <xsl:template name="declarationOfRights">
        <xsl:param name="declarationOfRightsSection"/>
        
        <xsl:if test="$declarationOfRightsSection">
            
            <xsl:variable name="declarationOfRights" select="$declarationOfRightsSection/string[@key='declarationOfRights']" />
            <xsl:variable name="otherReason" select="$declarationOfRightsSection/string[@key='otherAcquiredRightType']" />
            <xsl:variable name="dateOfEntry" select="$declarationOfRightsSection/string[@key='dateOfEntry']" />
            
            <xsl:variable name="declarationOfRightsLabel">
                <xsl:choose>
                    <xsl:when test="$declarationOfRights = 'none'">
                        <xsl:value-of select="ext:translate('request.pdf.rights.none', $pdfLanguage, $configVersion)"/>
                    </xsl:when>
                    <xsl:when test="$declarationOfRights = 'employer'">
                        <xsl:value-of select="ext:translate('request.pdf.rights.employer', $pdfLanguage, $configVersion)"/>
                    </xsl:when>
                    <xsl:when test="$declarationOfRights = 'successor'">
                        <xsl:value-of select="ext:translate('request.pdf.rights.successor', $pdfLanguage, $configVersion)"/>
                    </xsl:when>
                    <xsl:when test="$declarationOfRights = 'agreement'">
                        <xsl:value-of select="ext:translate('request.pdf.rights.agreement', $pdfLanguage, $configVersion)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="ext:translate('request.pdf.rights.other', $pdfLanguage, $configVersion)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <label>
                <xsl:value-of select="ext:translate('request.pdf.declaration.rights', $pdfLanguage, $configVersion)" />
            </label>
            
            <div class="divider" />
            
            <label class="label-light">
                <xsl:value-of select="ext:translate('request.pdf.rights.aquired.by', $pdfLanguage, $configVersion)" />
            </label>
            
            <div class="divider" />
            
            <xsl:call-template name="checkBoxWithLabel">
                <xsl:with-param name="checkboxValue" select="true()" />
                <xsl:with-param name="label" select="$declarationOfRightsLabel" />
            </xsl:call-template>
            <xsl:call-template name="nonEmptyFieldWithLabel">
                <xsl:with-param name="label" select="ext:translate('request.pdf.rights.other.type', $pdfLanguage, $configVersion)"/>
                <xsl:with-param name="fieldText" select="$otherReason"/>
            </xsl:call-template>
            <xsl:call-template name="nonEmptyFieldWithLabel">
                <xsl:with-param name="label" select="ext:translate('request.pdf.date.of.entry', $pdfLanguage, $configVersion)"/>
                <xsl:with-param name="fieldText" select="$dateOfEntry"/>
                <xsl:with-param name="customFieldClass" select="'input-tiny'" />
            </xsl:call-template>
            
        </xsl:if>
    </xsl:template>

    <xsl:template name="address">
        <xsl:param name="addressFields"/>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.street.address', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$addressFields/string[@key='streetAddress']"/>
        </xsl:call-template>

        <div>
            <xsl:if test="$addressFields/string[@key='poBox'] != ''">
                <div class="input-item-close">
                    <xsl:call-template name="nonEmptyFieldWithLabel">
                        <xsl:with-param name="label" select="ext:translate('request.pdf.po.box', $pdfLanguage, $configVersion)"/>
                        <xsl:with-param name="fieldText" select="$addressFields/string[@key='poBox']"/>
                        <xsl:with-param name="customFieldClass" select="'input-medium'" />
                    </xsl:call-template>
                </div>
            </xsl:if>
            <div class="input-item">
                <xsl:call-template name="fieldWithLabel">
                    <xsl:with-param name="label" select="ext:translate('request.pdf.postal.code', $pdfLanguage, $configVersion)"/>
                    <xsl:with-param name="fieldText" select="$addressFields/string[@key='postalCode']"/>
                    <xsl:with-param name="customFieldClass" select="'input-medium'" />
                </xsl:call-template>
            </div>
        </div>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.city', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$addressFields/string[@key='city']"/>
        </xsl:call-template>

        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.country', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="ext:translate_enum(
                    $addressFields/string[@key='country'],
                    'procedures-common-form-geo.jsonschema-definitions-country',
                    $pdfLanguage,
                    $configVersion,
                    $procedure)"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="optionalSingleLineAddress">
        <xsl:param name="addressFields"/>
        
        <xsl:variable name="region">
            <xsl:value-of select="$addressFields/string[@key='region']" />
        </xsl:variable>
        
        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.country', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="ext:translate_enum(
                    $addressFields/string[@key='country'],
                    'procedures-common-form-geo.jsonschema-definitions-country',
                    $pdfLanguage,
                    $configVersion,
                    $procedure)"/>
        </xsl:call-template>
        
        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.region', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$region"/>
        </xsl:call-template>
        
        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.postal.code', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$addressFields/string[@key='postalCode']"/>
            <xsl:with-param name="customFieldClass" select="'input-medium'" />
        </xsl:call-template>
        
        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.city', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$addressFields/string[@key='city']"/>
        </xsl:call-template>
        
        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.street.address', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$addressFields/string[@key='streetAddress']"/>
        </xsl:call-template>
        
    </xsl:template>
    
    <xsl:template name="communicationLineAddress">
        <xsl:param name="addressFields"/>
        <!-- this enum does not exist in EPVL schema.jsonschema local or external definitions -->
        <xsl:variable name="region" select="ext:translate_enum(
                $addressFields/string[@key='region'],
                'regionES',
                $pdfLanguage,
                $configVersion,
                $procedure)" />
        
        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.country', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="ext:translate_enum(
                    $addressFields/string[@key='country'],
                    'procedures-common-form-geo.jsonschema-definitions-country',
                    $pdfLanguage,
                    $configVersion,
                    $procedure)"/>
        </xsl:call-template>
        
        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.region', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$region"/>
        </xsl:call-template>
        
        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.postal.code', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$addressFields/string[@key='postalCode']"/>
            <xsl:with-param name="customFieldClass" select="'input-medium'" />
        </xsl:call-template>
        
        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.city', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$addressFields/string[@key='city']"/>
        </xsl:call-template>
        
        <xsl:call-template name="nonEmptyFieldWithLabel">
            <xsl:with-param name="label" select="ext:translate('request.pdf.street.address', $pdfLanguage, $configVersion)"/>
            <xsl:with-param name="fieldText" select="$addressFields/string[@key='streetAddress']"/>
        </xsl:call-template>
        
    </xsl:template>
    
    <xsl:template name="category">
        <xsl:param name="label"/>
        <xsl:param name="fieldText"/>
        <xsl:param name="role"/>
        <xsl:param name="nationality"/>
        
        <xsl:variable name="categoryValue">
            <xsl:choose>
                <xsl:when test="$role = 'APPLICANT_NATURAL_PERSON'">
                    <!-- this enum does not exist in EPVL schema.jsonschema local or external definitions -->
                    <xsl:value-of select="ext:translate_enum(
                            $fieldText,
                            'categoriesNP',
                            $pdfLanguage,
                            $configVersion,
                            $procedure)" />
                </xsl:when>
                <xsl:when test="$role = 'APPLICANT_LEGAL_ENTITY'">
                    <!-- this enum does not exist in EPVL schema.jsonschema local or external definitions -->
                    <xsl:value-of select="ext:translate_enum(
                            $fieldText,
                            'categoriesLE',
                            $pdfLanguage,
                            $configVersion,
                            $procedure)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$nationality = 'ES' and $role = 'APPLICANT_LEGAL_ENTITY'">
                <xsl:call-template name="fieldWithLabel">
                    <xsl:with-param name="label" select="$label"/>
                    <xsl:with-param name="fieldText" select="$categoryValue"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="nonEmptyFieldWithLabel">
                    <xsl:with-param name="label" select="$label"/>
                    <xsl:with-param name="fieldText" select="$categoryValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="organisation">
        <xsl:param name="label"/>
        <xsl:param name="fieldText"/>
        <xsl:param name="categoryValue"/>
        
        <xsl:variable name="organisationValue">
            <xsl:choose>
                <xsl:when test="$categoryValue = '5'">
                    <!-- this enum does not exist in EPVL schema.jsonschema local or external definitions -->
                    <xsl:value-of select="ext:translate_enum(
                            $fieldText,
                            'publicUniversityES',
                            $pdfLanguage,
                            $configVersion,
                            $procedure)" />
                </xsl:when>
                <xsl:when test="$categoryValue = '6'">
                    <!-- this enum does not exist in EPVL schema.jsonschema local or external definitions -->
                    <xsl:value-of select="ext:translate_enum(
                            $fieldText,
                            'publicResearchCenterES',
                            $pdfLanguage,
                            $configVersion,
                            $procedure)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$fieldText" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="$label"/>
            <xsl:with-param name="fieldText" select="$organisationValue"/>
        </xsl:call-template>
        
    </xsl:template>
    
    <xsl:template name="title">
        <xsl:param name="label"/>
        <xsl:param name="fieldText"/>
        
        <xsl:variable name="titleValue">
            <xsl:value-of select="ext:translate_enum(
                    $fieldText,
                    'procedures-common-form-parties.jsonschema-definitions-title',
                    $pdfLanguage,
                    $configVersion,
                    $procedure)" />
        </xsl:variable>
        
        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="$label"/>
            <xsl:with-param name="fieldText" select="$titleValue"/>
            <xsl:with-param name="customFieldClass" select="'input-tiny'" />
        </xsl:call-template>
        
    </xsl:template>
    
    <xsl:template name="identity">
        <xsl:param name="nationality"/>
        <xsl:param name="role"/>
        <xsl:param name="NIF"/>
        <xsl:param name="otherIdentityDocument"/>
        
        <xsl:choose>
            <xsl:when test="not($role = ('AGENT_NATURAL_PERSON', 'AGENT_LEGAL_ENTITY', 'INVENTOR'))">
                <xsl:call-template name="nonEmptyFieldWithLabel">
                    <xsl:with-param name="label" select="ext:translate('request.pdf.nif', $pdfLanguage, $configVersion)"/>
                    <xsl:with-param name="fieldText" select="$NIF"/>
                </xsl:call-template>
                <xsl:call-template name="nonEmptyFieldWithLabel">
                    <xsl:with-param name="label" select="ext:translate('request.pdf.other.identity.document', $pdfLanguage, $configVersion)"/>
                    <xsl:with-param name="fieldText" select="$otherIdentityDocument"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$role = ('AGENT_NATURAL_PERSON', 'AGENT_LEGAL_ENTITY')">
                <xsl:call-template name="nonEmptyFieldWithLabel">
                    <xsl:with-param name="label" select="ext:translate('request.pdf.nif', $pdfLanguage, $configVersion)"/>
                    <xsl:with-param name="fieldText" select="$NIF"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="nonEmptyFieldWithLabel">
                    <xsl:with-param name="label" select="ext:translate('request.pdf.nif', $pdfLanguage, $configVersion)"/>
                    <xsl:with-param name="fieldText" select="$NIF"/>
                </xsl:call-template>
                <xsl:call-template name="nonEmptyFieldWithLabel">
                    <xsl:with-param name="label" select="ext:translate('request.pdf.other.identity.document', $pdfLanguage, $configVersion)"/>
                    <xsl:with-param name="fieldText" select="$otherIdentityDocument"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="office">
        <xsl:param name="officeType"/>
        <xsl:param name="office"/>
        
        <xsl:variable name="officeLabel">
            <xsl:choose>
                <xsl:when test="$officeType = 'NATIONAL'">
                    <xsl:value-of select="ext:translate('request.pdf.national.office', $pdfLanguage, $configVersion)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ext:translate('request.pdf.office', $pdfLanguage, $configVersion)" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="officeValue">
            <xsl:choose>
                <xsl:when test="$officeType = 'NATIONAL'">
                    <!-- this enum does not exist in EPVL schema.jsonschema local or external definitions -->
                    <xsl:value-of select="ext:translate_enum(
                            $office,
                            'nationalOffice',
                            $pdfLanguage,
                            $configVersion,
                            $procedure)" />
                </xsl:when>
                <xsl:when test="$officeType = 'REGIONAL'">
                    <!-- this enum does not exist in EPVL schema.jsonschema local or external definitions -->
                    <xsl:value-of select="ext:translate_enum(
                            $office,
                            'regionalOffice',
                            $pdfLanguage,
                            $configVersion,
                            $procedure)" />
                </xsl:when>
                <xsl:when test="$officeType = 'INTERNATIONAL'">
                    <!-- this enum does not exist in EPVL schema.jsonschema local or external definitions -->
                    <xsl:value-of select="ext:translate_enum(
                            $office,
                            'internationalOffice',
                            $pdfLanguage,
                            $configVersion,
                            $procedure)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="$officeLabel"/>
            <xsl:with-param name="fieldText" select="$officeValue"/>
        </xsl:call-template>
        
    </xsl:template>

    <xsl:template name="ownershipPercentage">
        <xsl:param name="label"/>
        <xsl:param name="fieldText"/>

        <xsl:variable name="ownershipPercentageFormatted">
            <xsl:choose>
                <xsl:when test="$fieldText">
                    <xsl:value-of select="format-number($fieldText, '#00,00%')" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:call-template name="fieldWithLabel">
            <xsl:with-param name="label" select="$label"/>
            <xsl:with-param name="fieldText" select="$ownershipPercentageFormatted"/>
            <xsl:with-param name="customFieldClass" select="'input-medium'" />
        </xsl:call-template>

    </xsl:template>
    
    <xsl:template name="preferredMeansOfNotification">
        <xsl:param name="label"/>
        <xsl:param name="fieldText"/>
        
        <label class="label-light">
            <xsl:value-of select="$label" />
        </label>
        
        <div class="divider" />
        
        <xsl:call-template name="checkBoxWithLabel">
            <xsl:with-param name="checkboxValue" select="$fieldText = 'EMAIL'" />
            <xsl:with-param name="label" select="ext:translate('request.pdf.email.address', $pdfLanguage, $configVersion)" />
        </xsl:call-template>
        
        <xsl:call-template name="checkBoxWithLabel">
            <xsl:with-param name="checkboxValue" select="$fieldText = 'POST_MAIL'" />
            <xsl:with-param name="label" select="ext:translate('request.pdf.postal.address', $pdfLanguage, $configVersion)" />
        </xsl:call-template>
        
    </xsl:template>
    
</xsl:stylesheet>