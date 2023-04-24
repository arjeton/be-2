<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

    <xsl:param name="submissionJson"/>
    <xsl:param name="configJson"/>

    <xsl:variable name="submissionXml" select="json-to-xml($submissionJson)/map"/>
    <xsl:variable name="configXml" select="json-to-xml($configJson)/map"/>

    <xsl:output
        encoding="utf-8"
        indent="yes"
    />

    <xsl:template name="initial">
        <xsl:call-template name="main">
            <xsl:with-param name="submission" select="$submissionXml"/>
            <xsl:with-param name="config" select="$configXml"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="main">
        <xsl:param name="submission"/>
        <xsl:param name="config"/>
        <xsl:result-document doctype-system="{$config/map[@key='annexF']/map[@key='blob']/map[@key='application']/string[@key='dtd']}">
            <application-body>
                <xsl:attribute name="lang">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='language']"/>
                </xsl:attribute>
                <xsl:attribute name="dtd-version">
                    <xsl:value-of select="$config/map[@key='annexF']/map[@key='blob']/map[@key='application']/string[@key='version']"/>
                </xsl:attribute>
                <xsl:attribute name="country">
                    <xsl:value-of select="$config/map[@key='header']/string[@key='country']"/>
                </xsl:attribute>
                <xsl:call-template name="body">
                    <xsl:with-param name="submission" select="$submission"/>
                </xsl:call-template>
            </application-body>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="body">
        <xsl:param name="submission"/>
        <xsl:for-each select="$submission/array[@key='attachments']">
            <xsl:choose>

                <xsl:when test="map[string[@key='attachmentType']='DESCRIPTION']">
                    <xsl:call-template name="description">
                        <xsl:with-param name="object" select="map[string[@key='attachmentType']='DESCRIPTION']"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="((map[string[@key='attachmentType']='COMBINED']) and (map/array[@key='combinedFileTypeScopes']/map[string[@key='type']='DESCRIPTION']))">
                            <xsl:call-template name="combined">
                                <xsl:with-param name="object" select="map[string[@key='attachmentType']='COMBINED']"/>
                                <xsl:with-param name="attachmentType">description</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="generic">
                                <xsl:with-param name="attachmentType">description</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="map[string[@key='attachmentType']='CLAIMS']">
                    <xsl:call-template name="claims">
                        <xsl:with-param name="object" select="map[string[@key='attachmentType']='CLAIMS']"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>

                    <xsl:choose>
                        <xsl:when test="((map[string[@key='attachmentType']='COMBINED']) and (map/array[@key='combinedFileTypeScopes']/map[string[@key='type']='CLAIMS']))">
                            <xsl:call-template name="combined">
                                <xsl:with-param name="object" select="map[string[@key='attachmentType']='COMBINED']"/>
                                <xsl:with-param name="attachmentType">claims</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="generic">
                                <xsl:with-param name="attachmentType">claims</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="map[string[@key='attachmentType']='ABSTRACT']">
                    <xsl:call-template name="abstract">
                        <xsl:with-param name="object" select="map[string[@key='attachmentType']='ABSTRACT']"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>

                    <xsl:choose>
                        <xsl:when test="((map[string[@key='attachmentType']='COMBINED']) and (map/array[@key='combinedFileTypeScopes']/map[string[@key='type']='ABSTRACT']))">
                            <xsl:call-template name="combined">
                                <xsl:with-param name="object" select="map[string[@key='attachmentType']='COMBINED']"/>
                                <xsl:with-param name="attachmentType">abstract</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="generic">
                                <xsl:with-param name="attachmentType">abstract</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="map[string[@key='attachmentType']='DRAWINGS']">
                    <xsl:call-template name="drawings">
                        <xsl:with-param name="object" select="map[string[@key='attachmentType']='DRAWINGS']"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>

                    <xsl:choose>
                        <xsl:when test="((map[string[@key='attachmentType']='COMBINED']) and (map/array[@key='combinedFileTypeScopes']/map[string[@key='type']='DRAWINGS']))">
                            <xsl:call-template name="combined">
                                <xsl:with-param name="object" select="map[string[@key='attachmentType']='COMBINED']"/>
                                <xsl:with-param name="attachmentType">drawings</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="generic">
                                <xsl:with-param name="attachmentType">drawings</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="description">
        <xsl:param name="object" />
        <description>
            <xsl:call-template name="doc-page">
                <xsl:with-param name="id">DESC1</xsl:with-param>
                <xsl:with-param name="type" select="substring-after($object/string[@key='mimeType'], '/')" />
                <xsl:with-param name="totalPages" select="$object/number[@key='totalPages']" />
                <xsl:with-param name="firstPage">1</xsl:with-param>
                <xsl:with-param name="lastPage" select="$object/number[@key='totalPages']" />
                <xsl:with-param name="fileName" select="$object/string[@key='fileName']" />
            </xsl:call-template>
        </description>
    </xsl:template>

    <xsl:template name="claims">
        <xsl:param name="object" />
        <claims>
            <xsl:call-template name="doc-page">
                <xsl:with-param name="id">CLMS1</xsl:with-param>
                <xsl:with-param name="type" select="substring-after($object/string[@key='mimeType'], '/')" />
                <xsl:with-param name="totalPages" select="$object/number[@key='totalPages']" />
                <xsl:with-param name="firstPage">1</xsl:with-param>
                <xsl:with-param name="lastPage" select="$object/number[@key='totalPages']" />
                <xsl:with-param name="fileName" select="$object/string[@key='fileName']" />
            </xsl:call-template>
        </claims>
    </xsl:template>

    <xsl:template name="abstract">
        <xsl:param name="object" />
        <abstract>
            <xsl:call-template name="doc-page">
                <xsl:with-param name="id">ABST1</xsl:with-param>
                <xsl:with-param name="type" select="substring-after($object/string[@key='mimeType'], '/')" />
                <xsl:with-param name="totalPages" select="$object/number[@key='totalPages']" />
                <xsl:with-param name="firstPage">1</xsl:with-param>
                <xsl:with-param name="lastPage" select="$object/number[@key='totalPages']" />
                <xsl:with-param name="fileName" select="$object/string[@key='fileName']" />
            </xsl:call-template>
        </abstract>
    </xsl:template>

    <xsl:template name="drawings">
        <xsl:param name="object" />
        <drawings>
            <xsl:call-template name="doc-page">
                <xsl:with-param name="id">DRAW1</xsl:with-param>
                <xsl:with-param name="type" select="substring-after($object/string[@key='mimeType'], '/')" />
                <xsl:with-param name="totalPages" select="$object/number[@key='totalPages']" />
                <xsl:with-param name="firstPage">1</xsl:with-param>
                <xsl:with-param name="lastPage" select="$object/number[@key='totalPages']" />
                <xsl:with-param name="fileName" select="$object/string[@key='fileName']" />
            </xsl:call-template>
        </drawings>
    </xsl:template>

    <xsl:template name="combined">
        <xsl:param name="object" />
        <xsl:param name="attachmentType" />

        <xsl:if test="$attachmentType='description'">
            <xsl:call-template name="combinedScope" >
                <xsl:with-param name="object" select="$object/array[@key='combinedFileTypeScopes']/map[string[@key='type']='DESCRIPTION']"/>
                <xsl:with-param name="id">DESC1</xsl:with-param>
                <xsl:with-param name="attachmentType" select="$attachmentType"/>
                <xsl:with-param name="type" select="substring-after($object/string[@key='mimeType'], '/')" />
                <xsl:with-param name="fileName" select="$object/string[@key='fileName']" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$attachmentType='claims'">
            <xsl:call-template name="combinedScope" >
                <xsl:with-param name="object" select="$object/array[@key='combinedFileTypeScopes']/map[string[@key='type']='CLAIMS']"/>
                <xsl:with-param name="id">CLMS1</xsl:with-param>
                <xsl:with-param name="attachmentType" select="$attachmentType"/>
                <xsl:with-param name="type" select="substring-after($object/string[@key='mimeType'], '/')" />
                <xsl:with-param name="fileName" select="$object/string[@key='fileName']" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$attachmentType='abstract'">
            <xsl:call-template name="combinedScope" >
                <xsl:with-param name="object" select="$object/array[@key='combinedFileTypeScopes']/map[string[@key='type']='ABSTRACT']"/>
                <xsl:with-param name="id">ABST1</xsl:with-param>
                <xsl:with-param name="attachmentType" select="$attachmentType"/>
                <xsl:with-param name="type" select="substring-after($object/string[@key='mimeType'], '/')" />
                <xsl:with-param name="fileName" select="$object/string[@key='fileName']" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$attachmentType='drawings'">
            <xsl:call-template name="combinedScope" >
                <xsl:with-param name="object" select="$object/array[@key='combinedFileTypeScopes']/map[string[@key='type']='DRAWINGS']"/>
                <xsl:with-param name="id">DRAW1</xsl:with-param>
                <xsl:with-param name="attachmentType" select="$attachmentType"/>
                <xsl:with-param name="type" select="substring-after($object/string[@key='mimeType'], '/')" />
                <xsl:with-param name="fileName" select="$object/string[@key='fileName']" />
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <xsl:template name="combinedScope">
        <xsl:param name="object" />
        <xsl:param name="id" />
        <xsl:param name="attachmentType" />
        <xsl:param name="type"/>
        <xsl:param name="fileName"/>

        <xsl:call-template name="generic">
            <xsl:with-param name="id" select="$id"/>
            <xsl:with-param name="attachmentType" select="$attachmentType"/>
            <xsl:with-param name="type" select="$type" />
            <xsl:with-param name="totalPages">
                <xsl:value-of select="(($object/number[@key='end'] - $object/number[@key='start']) +1 )" />
            </xsl:with-param>
            <xsl:with-param name="firstPage" select="$object/number[@key='start']" />
            <xsl:with-param name="lastPage" select="$object/number[@key='end']" />
            <xsl:with-param name="fileName" select="$fileName" />
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="generic">
        <xsl:param name="attachmentType" />
        <xsl:param name="id" select="''"/>
        <xsl:param name="type" select="'pdf'"/>
        <xsl:param name="totalPages" select="''"/>
        <xsl:param name="firstPage" select="''"/>
        <xsl:param name="lastPage" select="''"/>
        <xsl:param name="fileName" select="''"/>

        <xsl:if test="$attachmentType='description'">
            <description>
                <xsl:call-template name="doc-page">
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="type" select="$type" />
                    <xsl:with-param name="totalPages" select="$totalPages" />
                    <xsl:with-param name="firstPage" select="$firstPage" />
                    <xsl:with-param name="lastPage" select="$lastPage" />
                    <xsl:with-param name="fileName" select="$fileName" />
                </xsl:call-template>
            </description>
        </xsl:if>

        <xsl:if test="$attachmentType='claims'">
            <claims>
                <xsl:call-template name="doc-page">
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="type" select="$type" />
                    <xsl:with-param name="totalPages" select="$totalPages" />
                    <xsl:with-param name="firstPage" select="$firstPage" />
                    <xsl:with-param name="lastPage" select="$lastPage" />
                    <xsl:with-param name="fileName" select="$fileName" />
                </xsl:call-template>
            </claims>
        </xsl:if>
        <xsl:if test="$attachmentType='abstract'">
            <abstract>
                <xsl:call-template name="doc-page">
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="type" select="$type" />
                    <xsl:with-param name="totalPages" select="$totalPages" />
                    <xsl:with-param name="firstPage" select="$firstPage" />
                    <xsl:with-param name="lastPage" select="$lastPage" />
                    <xsl:with-param name="fileName" select="$fileName" />
                </xsl:call-template>
            </abstract>
        </xsl:if>

        <xsl:if test="$attachmentType='drawings'">
            <drawings>
                <xsl:call-template name="doc-page">
                    <xsl:with-param name="id" select="$id" />
                    <xsl:with-param name="type" select="$type" />
                    <xsl:with-param name="totalPages" select="$totalPages" />
                    <xsl:with-param name="firstPage" select="$firstPage" />
                    <xsl:with-param name="lastPage" select="$lastPage" />
                    <xsl:with-param name="fileName" select="$fileName" />
                </xsl:call-template>
            </drawings>
        </xsl:if>

    </xsl:template>

    <xsl:template name="doc-page">
        <xsl:param name="id" />
        <xsl:param name="type" />
        <xsl:param name="totalPages" />
        <xsl:param name="firstPage" />
        <xsl:param name="lastPage" />
        <xsl:param name="fileName" />
        <doc-page he="1" wi="1">
            <xsl:if test="$id != ''">
                <xsl:attribute name="id">
                    <xsl:value-of select="$id" />
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="type">
                <xsl:value-of select="$type"/>
            </xsl:attribute>
            <xsl:attribute name="pp">
                <xsl:value-of select="$totalPages"/>
            </xsl:attribute>
            <xsl:attribute name="ppf">
                <xsl:value-of select="$firstPage"/>
            </xsl:attribute>
            <xsl:attribute name="ppl">
                <xsl:value-of select="$lastPage"/>
            </xsl:attribute>
            <xsl:attribute name="file">
                <xsl:value-of select="$fileName"/>
            </xsl:attribute>
        </doc-page>
    </xsl:template>

</xsl:stylesheet>