<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version = "1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fsmh="https://github.com/zaufi/paludis-hooks/#filesystem-management-hook">
<!--
    Transform a config file into a shell script
    Copyright (c), 2010-2012 by Alex Turbov <i.zaufi@gmail.com>
  -->

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
for cmd in /usr/share/paludis-hooks/filesystem-manager/commands/*.sh; do
    source $i
done
<xsl:apply-templates select="fsmh:package[@id = $PN]/*" />
</xsl:template>

<!--
    Matching `symlink` nodes w/ all required parameters given
  -->
<xsl:template match="fsmh:symlink[@cd][@src][@dst]">
cmd_symlink \
    '<xsl:value-of select="@cd" />' \
    '<xsl:value-of select="@src" />' \
    '<xsl:value-of select="@dst" />'
</xsl:template>

<!--
    Matching `rm` nodes w/ all required parameters given
  -->
<xsl:template match="fsmh:rm[@dst]">
cmd_rm '<xsl:value-of select="@dst" />'
</xsl:template>

</xsl:stylesheet>
