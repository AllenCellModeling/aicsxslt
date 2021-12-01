<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ome="http://www.openmicroscopy.org/Schemas/OME/2016-06">

    <xsl:import href="ImagingEnvironment.xsl"/>
    <xsl:import href="ObjectiveSettings.xsl"/>
    <xsl:import href="Pixels.xsl"/>

    <!-- /Metadata/Information/Image/AcquisitionDataAndTime => /OME/Image/@AcquisitionDate   -->
    <xsl:template match="AcquisitionDateAndTime">
        <xsl:element name="ome:AcquisitionDate">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>

    <xsl:variable name="img" select="/ImageDocument/Metadata/Information/Image"/>
    <xsl:variable name="chs" select="/ImageDocument/Metadata/DisplaySetting/Channels"/>

    <xsl:template name="common_image_contents">
        <xsl:apply-templates select="$img/AcquisitionDateAndTime"/>
        <xsl:apply-templates select="$img/ObjectiveSettings"/>
        <!-- Imaging Environment -->
        <xsl:apply-templates select="/ImageDocument/Metadata/Information/TimelineTracks/TimelineTrack/TimelineElements/TimelineElement/EventInformation/IncubationRecording"/>
    </xsl:template>

    <!-- For single scene images, manually create top level attributes of the /OME/Image/Image element -->
    <xsl:template name="single_scene_image">
        <xsl:element name="ome:Image">
            <xsl:attribute name="ID">Image:0</xsl:attribute>
            <xsl:call-template name="common_image_contents"/>
            <!--   Pixels  -->
            <xsl:apply-templates select="$img">
                <xsl:with-param name="chs" select="$chs"/>
                <xsl:with-param name="idx">0</xsl:with-param>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <!-- /ImageDocument/Metadata/Information/Image/Dimensions/S/Scenes/Scene => /OME/Image/Image -->
    <xsl:template match="Scene">
        <xsl:element name="ome:Image">
            <xsl:attribute name="ID">
                <xsl:text>Image:</xsl:text>
                <xsl:value-of select="@Index"/>
            </xsl:attribute>
            <xsl:attribute name="Name">
                <xsl:value-of select="@Name"/>
            </xsl:attribute>
            <xsl:call-template name="common_image_contents"/>
            <!--   Pixels  -->
            <xsl:apply-templates select="$img">
                <xsl:with-param name="chs" select="$chs"/>
                <xsl:with-param name="idx" select="@Index"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
