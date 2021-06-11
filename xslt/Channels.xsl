<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ome="http://www.openmicroscopy.org/Schemas/OME/2016-06">

    <!-- /Metadata/DisplaySetting/Channels/Channel/IlluminationType => /OME/Image/Channel/IlluminationType -->
    <xsl:template match="IlluminationType">
        <xsl:attribute name="IlluminationType">
            <xsl:choose>
                <xsl:when test=".='Fluorescence'">
                    <xsl:text>Epifluorescence</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="ExcitationWavelength">
        <xsl:attribute name="ExcitationWavelength">
            <xsl:value-of select="."/>
        </xsl:attribute>
        <xsl:attribute name="ExcitationWavelengthUnit">
            <xsl:text>nm</xsl:text>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="EmissionWavelength">
        <xsl:attribute name="EmissionWavelength">
            <xsl:value-of select="."/>
        </xsl:attribute>
        <xsl:attribute name="EmissionWavelengthUnit">
            <xsl:text>nm</xsl:text>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="Intensity">
        <xsl:variable name="inten" select="substring( ., 0, string-length(.)-1) div 100.0"/>
        <xsl:if test="$inten &gt; 0.29">
            <xsl:element name="ome:LightSourceSettings">
                <xsl:attribute name="ID">
                    <xsl:text>LightSource:</xsl:text>
                    <xsl:value-of select="position()"/>
                </xsl:attribute>
                <xsl:attribute name="Attenuation">
                    <xsl:choose>
                        <xsl:when test="contains(.,'%')">
                            <xsl:value-of select="substring( ., 0, string-length(.)-1) div 100.0"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="DetectorSettings">
        <xsl:element name="ome:DetectorSettings">
            <xsl:attribute name="ID">
                <xsl:choose>
                    <xsl:when test="substring(Detector/@Id, 0, 17)='Detector:Camera '">
                        <xsl:text>Detector:</xsl:text>
                        <xsl:value-of select="substring(Detector/@Id, 17, 1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="Detector/@Id"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="Binning">
                <xsl:choose>
                    <xsl:when test="Binning='other'">
                        <xsl:value-of select="Binning"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="substring(Binning, 0, 2)"/>
                <xsl:text>x</xsl:text>
                <xsl:value-of select="substring(Binning, 0, 2)"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <!-- /Metadata/DisplaySetting/Channels/Channel => /OME/Image/Channel -->
    <!-- /Metadata/DisplaySetting/Channels/Channel/DyeName => /OME/Image/Channel@Name -->
    <!-- /Metadata/DisplaySetting/Channels/Channel/DyeName => /OME/Image/Channel@Fluor (if IlluminationType = 'Fluorescence') -->
    <!-- /ImageDocument/Metadata/Information/Image/Dimensions/Channels/Channel/ExcitationWavelength => /Ome/Image/Channel@ExcitationWavelength  -->
    <!-- /ImageDocument/Metadata/Information/Image/Dimensions/Channels/Channel/EmissionWavelength => /Ome/Image/Channel@EmissionWavelength  -->
    <xsl:template match="Channel">
        <xsl:param name="info_channel"/>
        <xsl:param name="idx"/>
        <xsl:element name="ome:Channel">
            <xsl:attribute name="ID">
                <xsl:value-of select="$info_channel/@Id"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="$idx"/>
            </xsl:attribute>
            <xsl:attribute name="Name">
                <xsl:value-of select="@Name"/>
            </xsl:attribute>
            <xsl:attribute name="AcquisitionMode">
                <xsl:value-of select="$info_channel/AcquisitionMode"/>
            </xsl:attribute>
            <xsl:apply-templates select="IlluminationType"/>
            <xsl:apply-templates select="$info_channel/ExcitationWavelength"/>
            <xsl:apply-templates select="$info_channel/EmissionWavelength"/>
            <xsl:if test="IlluminationType = 'Fluorescence'">
                <xsl:attribute name="Fluor">
                    <xsl:value-of select="DyeName"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:apply-templates select="$info_channel/LightSourcesSettings/LightSourceSettings/Intensity"/>
            <xsl:apply-templates select="$info_channel/DetectorSettings"/>

        </xsl:element>
    </xsl:template>

    <xsl:template match="Channels">
        <xsl:param name="idx"/>
        <xsl:for-each select="Channel">
            <xsl:variable name="channel" select="."/>
            <xsl:for-each select="/ImageDocument/Metadata/Information/Image/Dimensions/Channels/Channel">
                <xsl:if test="$channel/@Id = ./@Id">
                    <xsl:apply-templates select="$channel">
                        <xsl:with-param name="info_channel" select="."/>
                        <xsl:with-param name="idx" select="$idx"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:for-each>

        </xsl:for-each>
    </xsl:template>



</xsl:stylesheet>
