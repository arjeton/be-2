<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

    <xsl:variable name="headTags">
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="stylesheet" href="pdf/styles/request.css"/>
    </xsl:variable>

    <!-- template for a readonly checkbox field with label when it's only selected -->
    <xsl:template name="nonSelectedCheckBoxWithLabel">
        <xsl:param name="checkboxValue"/>
        <xsl:param name="label"/>

        <xsl:if test="$checkboxValue = true()">
            <xsl:call-template name="checkBoxWithLabel">
                <xsl:with-param name="checkboxValue" select="$checkboxValue"/>
                <xsl:with-param name="label" select="$label"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- template for a readonly checkbox field with label  -->
    <xsl:template name="checkBoxWithLabel">
        <xsl:param name="checkboxValue"/>
        <xsl:param name="label"/>

        <div style="page-break-inside: avoid;">
            <span>
                <xsl:choose>
                    <xsl:when test="$checkboxValue = true()">
                        <xsl:attribute name="class">
                            <xsl:value-of select="'checkbox'"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="class">
                            <xsl:value-of select="'unselectedCheckbox'"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
            <span class="checkboxLabel">
                <xsl:value-of select="$label" />
            </span>
        </div>

        <div class="divider" />
    </xsl:template>

    <!-- template for a text field with label displayed even if the content is empty -->
    <xsl:template name="fieldWithLabel">
        <xsl:param name="label"/>
        <xsl:param name="fieldText"/>
        <xsl:param name="customLabelClass" select="''"/>
        <xsl:param name="customFieldClass" select="''"/>

        <div style="page-break-inside: avoid;">
            <label>
                <xsl:attribute name="class">
                    <xsl:value-of select="$customLabelClass"/>
                </xsl:attribute>
                <xsl:value-of select="$label"/>
            </label>
            <span>
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('input', ' ', $customFieldClass)"/>
                </xsl:attribute>
                <xsl:value-of select="$fieldText"/>
            </span>
        </div>

        <div class="divider" />
    </xsl:template>

    <xsl:template name="fieldWithLabelAndNumber">
        <xsl:param name="label"/>
        <xsl:param name="fieldText"/>
        <xsl:param name="num"/>
        <xsl:param name="customLabelClass" select="''"/>
        <xsl:param name="customFieldClass" select="''"/>

        <div class="numWrapper" style="page-break-inside: avoid;">
            <label>
                <xsl:attribute name="class">
                    <xsl:value-of select="'numReference'"/>
                </xsl:attribute>
                <xsl:value-of select="$num"/>
            </label>
            <label>
                <xsl:attribute name="class">
                    <xsl:value-of select="$customLabelClass"/>
                </xsl:attribute>
                <xsl:value-of select="$label"/>
            </label>
            <span>
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('input', ' ', $customFieldClass)"/>
                </xsl:attribute>
                <xsl:value-of select="$fieldText"/>
            </span>
        </div>

        <div class="divider" />
    </xsl:template>


    <!-- template for a text field with label displayed only if content is available -->
    <xsl:template name="nonEmptyFieldWithLabel">
        <xsl:param name="label"/>
        <xsl:param name="fieldText"/>
        <xsl:param name="customLabelClass" select="''"/>
        <xsl:param name="customFieldClass" select="''"/>

        <xsl:if test="$fieldText and $fieldText != ''">
            <xsl:call-template name="fieldWithLabel">
                <xsl:with-param name="label" select="$label"/>
                <xsl:with-param name="fieldText" select="$fieldText"/>
                <xsl:with-param name="customLabelClass" select="$customLabelClass"/>
                <xsl:with-param name="customFieldClass" select="$customFieldClass"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
