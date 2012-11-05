<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version = "1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fsmh="https://github.com/zaufi/paludis-hooks/#filesystem-management-hook">

<xsl:output method="text" encoding="UTF-8"/>

<!--
    Write a script header when meet a root node
  -->
<xsl:template match="fsmh:commands">
#!/bin/sh
#
# ATTENTION: This script produced by filesystem-manager paludis hook
# on installing <xsl:value-of select="$PN" /> package
#
source ${PALUDIS_EBUILD_DIR}/echo_functions.bash
<xsl:apply-templates select="fsmh:package[@id = $PN]/fsmh:symlink[@cd][@src][@dst]" />
</xsl:template>

<!--
    Matching symlink nodes w/ all parameters given
  -->
<xsl:template match="fsmh:symlink[@cd][@src][@dst]">
ebegin &quot;Making the symlink <xsl:value-of select="@src" /> --&gt; <xsl:value-of select="@dst" />&quot;
cd ${D} <xsl:value-of select="@cd" />
# ln -s <xsl:value-of select="@src" /><xsl:text> </xsl:text><xsl:value-of select="@dst" />
cd -
eend $?
</xsl:template>

<!--
    Matching rm nodes w/ all parameters given
  -->
<xsl:template match="fsmh:rm[@dst]">
ebegin &quot;Removing the <xsl:value-of select="@dst" />&quot;
# rm -rf <xsl:value-of select="@dst" />
eend 0
</xsl:template>

</xsl:stylesheet>
