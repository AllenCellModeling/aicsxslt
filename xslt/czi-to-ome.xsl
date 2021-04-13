<?xml version="1.0" encoding="UTF-8"?>
<!--
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Comments in this template will generally be pointers from spec to spec
# Example:
#   Get Instrument Info
#   zisraw/Instrument.xsd: 45
#   ome/ome.xsd: 979
#
# This means that for more details on how this section of the template was created
# view line 45 of the zisraw/Instrument.xsd file and view line 979 of the ome/ome.xsd file.
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->

<xsl:stylesheet version="1.1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ome="http://www.openmicroscopy.org/Schemas/OME/2016-06"
                ome:schemaLocation="http://www.openmicroscopy.org/Schemas/OME/2016-06/ome.xsd"
                exclude-result-prefixes="xsl xs">

    <!-- Output format -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8"/>

    <!-- Includes -->
    <xsl:include href="DocumentUser.xsl"/>
    <xsl:include href="Image.xsl"/>
    <xsl:include href="Plate.xsl"/>
    <xsl:include href="StructuredAnnotations.xsl"/>

    <!-- CZI Subblocks -->
    <xsl:variable name="subblocks" select="/ImageDocument/Subblocks" />
    <xsl:variable name="schema_name" select="'http://www.openmicroscopy.org/Schemas/OME/2016-06'" /> 
    <xsl:variable name="schema_value" select="'http://www.openmicroscopy.org/Schemas/OME/2016-06/ome.xsd'" />


    <!-- Begin Template -->
    <xsl:template match="/">
        <xsl:element name="ome:OME">
            <!-- Plate -->
            <xsl:apply-templates select="/ImageDocument/Metadata/Information/Image/Dimensions"/>
            <xsl:apply-templates select="/ImageDocument/Metadata/Information"/>
            <!-- Image -->
            <xsl:apply-templates select="/ImageDocument/Metadata/Information/Image/Dimensions/S/Scenes/Scene"/>
            <!-- StructuredAnnotations  -->
            <xsl:apply-templates select="/ImageDocument/Metadata/Information/Application"/>
            <!--        </OME>-->
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
