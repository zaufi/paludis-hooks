<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version = "1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fsmh="http://bitbucket.org/zaufi/paludis-hooks/#filesystem-management-hook">

<xsl:output method="text" encoding="UTF-8"/>

<xsl:template match="fsmh:commands">
#!/bin/sh

source ${PALUDIS_EBUILD_DIR}/echo_functions.bash

<xsl:apply-templates select="fsmh:package[@id = $PN]/fsmh:symlink[@cd][@src][@dst]" />
</xsl:template>

<xsl:template match="fsmh:symlink[@cd][@src][@dst]">
einfo &quot;Making the symlink <xsl:value-of select="@src" /> --&gt; <xsl:value-of select="@dst" />&quot;
cd ${D} <xsl:value-of select="@cd" />
# ln -s <xsl:value-of select="@src" /><xsl:text> </xsl:text><xsl:value-of select="@dst" />
cd -
</xsl:template>

<xsl:template match="fsmh:rm[@dst]">
einfo &quot;Removing the <xsl:value-of select="@src" /> --&gt; <xsl:value-of select="@dst" />&quot;
# rm -rf <xsl:value-of select="@dst" />
</xsl:template>

</xsl:stylesheet>
