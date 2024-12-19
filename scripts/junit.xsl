<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
		Identity template, 
        provides default behavior that copies all content into the output 
    -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!--
    	More specific template for tescase node that copies all attributes plus 
    	generates the classname attribute from parent testsuite name attribute 
     -->
    <xsl:template match="testcase">
    	<testcase>
    	<xsl:attribute name="name"><xsl:value-of select="./@name"/></xsl:attribute>
    	<xsl:attribute name="time"><xsl:value-of select="./@time"/></xsl:attribute>
    	<xsl:attribute name="classname"><xsl:value-of select="../@name"/></xsl:attribute>
    	</testcase>  
    </xsl:template>
</xsl:stylesheet>

