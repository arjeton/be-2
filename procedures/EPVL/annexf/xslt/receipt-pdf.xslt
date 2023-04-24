<xsl:stylesheet
    version="3.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ext="http://org.epo.eolf.integration"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

    <xsl:import href="/procedures/common/annexf/xslt/common/pdf-basic-fields.xslt" />
    
    <xsl:param name="submissionJson"/>
    <xsl:param name="configJson"/>
    <xsl:param name="signatureImage"/>
    <xsl:param name="dateProduced"/>
    
    
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
                    Acknowledgement of receipt
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
                                Acknowledgement of receipt
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
            
            <xsl:call-template name="adminTable">
                <xsl:with-param name="config" select="$configXml/map"/>
            </xsl:call-template>
            
            <div class="sectionDivider"/>
            
            <xsl:call-template name="generatedFiles"/>
            
            <div class="sectionDivider"/>
            
            <xsl:call-template name="attachments">
                <xsl:with-param name="attachments" select="array[@key='attachments']"/>
            </xsl:call-template>

            <div class="sectionDivider"/>

            <div class="sectionDivider"/>

            <div class="sectionDivider"/>

            <xsl:call-template name="extraTable">
                <xsl:with-param name="config" select="$configXml/map"/>
                <xsl:with-param name="submission" select="$submissionXml/map"/>
            </xsl:call-template>
            
        </main>
    </xsl:template>
    
    <xsl:template name="adminTable">
     <xsl:param name="config"/>
        <p><h3>We hereby acknowledge receipt of your request for grant of a European patent as follows</h3></p>
        <table>
            <thead>
                <tr>
                    <th colspan="2"  class="adminTableCell">
                        
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td width="50%"  class="adminTableCell">
                        Submission number
                        <!--<xsl:value-of select="ext:translate('request.pdf.application.number', $pdfLanguage, $configVersion)" />-->
                    </td>
                    <td>
                        <xsl:value-of select="string[@key='id']" />
                    </td>
                </tr>
                <tr>
                    <td width="50%"  class="adminTableCell">
                        Application number
                        <!--<xsl:value-of select="ext:translate('request.pdf.application.number', $pdfLanguage, $configVersion)" />-->
                    </td>
                    <td>
                        <xsl:value-of select="map[@key='receipt']/string[@key='applicationNumber']" />
                    </td>
                </tr>
                <tr>
                    <td width="50%"  class="adminTableCell">
                        File No. to be used for priority declarations
                        <!--<xsl:value-of select="ext:translate('request.pdf.application.number', $pdfLanguage, $configVersion)" />-->
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
                        <xsl:value-of select="substring($dateProduced,1,10)" />
                    </td>
                </tr>
                <tr>
                    <td class="adminTableCell">
                        Your reference
                    </td>
                    <td>
                        <xsl:value-of select="map[@key='basicFilingInfo']/string[@key='userReference']" />
                    </td>
                </tr>
                <tr>
                    <td class="adminTableCell">
                        Applicant
                    </td>
                    <td>
                        <xsl:call-template name="first-named-applicant">
                            <xsl:with-param name="applicants" select="map[@key='parties']/array[@key='applicants']"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td class="adminTableCell">
                        Country
                    </td>
                    <td>
                        <xsl:value-of select="$config/map[@key='header']/string[@key='country']"/>
                    </td>
                </tr>
                <tr>
                    <td class="adminTableCell">
                        Title
                    </td>
                    <td>
                        <xsl:value-of select="map[@key='basicFilingInfo']/string[@key='titleOfInvention']"/>
                    </td>
                </tr>
            </tbody>
        </table>    
    </xsl:template>

    <xsl:template name="extraTable">
     <xsl:param name="config"/>
    <xsl:param name="submission" />
        <table>
            <thead>
                <tr>
                    <th colspan="2"  class="adminTableCell">
                
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td width="50%"  class="adminTableCell">
                        Submited by
                        <!--<xsl:value-of select="ext:translate('request.pdf.application.number', $pdfLanguage, $configVersion)" />-->
                    </td>
                    <td>
                        CN=TCS test user 99791
                    </td>
                </tr>
                <tr>
                    <td width="50%"  class="adminTableCell">
                        Method
                        <!--<xsl:value-of select="ext:translate('request.pdf.application.number', $pdfLanguage, $configVersion)" />-->
                    </td>
                    <td>
                        Online
                    </td>
                </tr>
                <tr>
                    <td width="50%"  class="adminTableCell">
                        Date and Time
                        <!--<xsl:value-of select="ext:translate('request.pdf.application.number', $pdfLanguage, $configVersion)" />-->
                    </td>
                    <td>
                        <xsl:value-of select="$dateProduced" />
                    </td>
                </tr>
                <tr>
                    <td class="adminTableCell">
                        Message Digest
                    </td>
                    <td>
                        <xsl:value-of select="$submission/map[@key='packageData']/map[@key='signedPackageFile']/string[@key='digest']"/>
                    </td>
                </tr>
            </tbody>
        </table>    
    </xsl:template>
    
    <xsl:template name="first-named-applicant">
        <xsl:param name="applicants"/>
        <xsl:for-each select="$applicants/map[map[@key='personalDetails'] != ''][1]">
                    <xsl:value-of select="concat(current()/map[@key='personalDetails']/string[@key='firstName'], ' ',current()/map[@key='personalDetails']/string[@key='lastName'])"/>
        </xsl:for-each>
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
                            <xsl:value-of select="$configXml/map[@key='annexF']/map[@key='blob']/map[@key='inventor']/string[@key='name']" />
                        </td>
                        <td>
                            <xsl:value-of select="ext:translate('request.pdf.the.inventor.pdf', $pdfLanguage, $configVersion)"/>
                        </td>
                        <td>
                            <xsl:value-of select="$configXml/map[@key='annexF']/map[@key='blob']/map[@key='inventor']/string[@key='name']" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:value-of select="$configXml/map[@key='annexF']/map[@key='blob']/map[@key='feePdf']/string[@key='name']" />
                        </td>
                        <td>
                            <xsl:value-of select="ext:translate('request.pdf.fee.pdf', $pdfLanguage, $configVersion)" />
                        </td>
                        <td>
                            <xsl:value-of select="$configXml/map[@key='annexF']/map[@key='blob']/map[@key='feePdf']/string[@key='name']" />
                        </td>
                    </tr>
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
                                                    <xsl:when test="current()/string[@key='type'] = 'CLAIMS' and current()/number[@key='numberOfClaims']">
                                                        <xsl:value-of select="concat(ext:translate('request.pdf.attachment.no.of.claims', $pdfLanguage, $configVersion), ': ', current()/number[@key='numberOfClaims'], ';')" />
                                                    </xsl:when>
                                                    <xsl:when test="current()/string[@key='type'] = 'ABSTRACT' and current()/string[@key='figureToBePublished']!=''">
                                                        <xsl:value-of select="concat(ext:translate('request.pdf.attachment.figure.to.be.published', $pdfLanguage, $configVersion), ': ', current()/string[@key='figureToBePublished'],';')" />
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:when test="current()/string[@key='attachmentType'] = 'CLAIMS' and current()/number[@key='numberOfClaims']">
                                            <xsl:value-of select="concat(ext:translate('request.pdf.attachment.no.of.claims', $pdfLanguage, $configVersion), ': ', current()/number[@key='numberOfClaims'])" />
                                        </xsl:when>
                                        <xsl:when test="current()/string[@key='attachmentType'] = 'DRAWINGS' and current()/number[@key='numberOfDrawings']">
                                            <xsl:value-of select="concat(ext:translate('request.pdf.attachment.number.of.drawings', $pdfLanguage, $configVersion), ': ', current()/number[@key='numberOfDrawings'])" />
                                        </xsl:when>
                                        <xsl:when test="current()/string[@key='attachmentType'] = 'ABSTRACT' and current()/string[@key='figureToBePublished']!=''">
                                            <xsl:value-of select="concat(ext:translate('request.pdf.attachment.figure.to.be.published', $pdfLanguage, $configVersion), ': ', current()/string[@key='figureToBePublished'])" />
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
                        <xsl:if test="not($attachments/map/string[@key='attachmentType'] = ('SPECIFIC', 'GENERAL', 'ELECTRONIC_PRIORITY', 'TRANSLATIONS_OF_TECHNICAL_DOCUMENTS', 'TRANSLATIONS_OF_PRIORITY_DOCUMENTS', 'INVENTOR_WAIVER',  'OTHER'))">
                            <tr>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                                <td><xsl:text>&#160;</xsl:text></td>
                            </tr>
                        </xsl:if>
                        <xsl:for-each select="$attachments/map">
                            <xsl:if test="current()/string[@key='attachmentType'] = ('SPECIFIC', 'GENERAL', 'ELECTRONIC_PRIORITY', 'TRANSLATIONS_OF_TECHNICAL_DOCUMENTS', 'TRANSLATIONS_OF_PRIORITY_DOCUMENTS', 'INVENTOR_WAIVER',  'OTHER')">
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
    
</xsl:stylesheet>