<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version = "1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fsmh="https://github.com/zaufi/paludis-hooks/#filesystem-management-hook"
  >
<!--
    Transform a config file into a shell script
    Copyright (c), 2010-2012 by Alex Turbov <i.zaufi@gmail.com>
  -->

<xsl:output method="text" encoding="UTF-8"/>

<!-- Template paremeters -->
<xsl:param name="PF" />
<xsl:param name="PN" />
<xsl:param name="PR" />
<xsl:param name="PVR" />
<xsl:param name="PV" />
<xsl:param name="CATEGORY" />
<xsl:param name="REPOSITORY" />
<xsl:param name="SLOT" />
<xsl:param name="debug" />

<!--
    Write a script header when meet a root node
  -->
<xsl:template match="fsmh:commands">
<xsl:call-template name="debug">
    <xsl:with-param name="message">&gt;   Render a shell script for <xsl:value-of select="concat($CATEGORY,'/',$PF,':',$SLOT,'::',$REPOSITORY)" /></xsl:with-param>
</xsl:call-template>
#!/bin/sh
#
# ATTENTION: This script produced by filesystem-manager paludis hook
# on installing <xsl:value-of select="$PN" /> package
#
source ${PALUDIS_EBUILD_DIR}/echo_functions.bash
for cmd in /usr/share/paludis-hooks/filesystem-manager/commands/*.sh; do
    source $cmd
done
isSomeActionsWereTakePlace=no

<!-- Initiate package spec pattern matching starting from highest priority -->
<xsl:call-template name="dispatch-by-priority">
    <xsl:with-param name="priority" select="number(17)" />
</xsl:call-template>

if [ "$isSomeActionsWereTakePlace" != "no" ]; then
    ewarn "WARNING: <xsl:value-of select="$PN" /> was installed w/ modified image!"
    ewarn "WARNING: In case of troubles make sure that you installed an unmodified package, before report a bug"
fi

<xsl:call-template name="debug">
    <xsl:with-param name="message">&lt;   Rendering done for <xsl:value-of select="concat($CATEGORY,'/',$PF,':',$SLOT,'::',$REPOSITORY)" /></xsl:with-param>
</xsl:call-template>
</xsl:template>

<!--
    Select `package' nodes according specification priority and call
    `handle-spec' w/ selected set (possible empty).

    p   spec
    ..................................
    16  cat/package-ver-rv:slot::repo
    15  cat/package-ver-rv:slot
    14  cat/package-ver-rv::repo
    13  cat/package-ver-rv
    12  cat/package:slot::repo
    11  cat/package:slot
    10  cat/package::repo
    9   cat/package
    8   package-ver-rv:slot::repo
    7   package-ver-rv:slot
    6   package-ver-rv:repo
    5   package-ver-rv
    4   package:slot::repo
    3   package:slot
    2   package:repo
    1   cat/*
    0   */*
  -->
<xsl:template name="dispatch-by-priority">
    <xsl:param name="priority" />

    <xsl:call-template name="debug">
        <xsl:with-param name="message">&gt;&gt;  Dispatching by priority <xsl:value-of select="$priority" /></xsl:with-param>
    </xsl:call-template>

    <xsl:choose>
        <xsl:when test="$priority = 17">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PF,':',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 16">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PF,':',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 15">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PF,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 14">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PF)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 13">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PF,':',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 12">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PF,':',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 11">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PF,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 10">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = $PF]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 9">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PN,':',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 8">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PN,':',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 7">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PN,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 6">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PN)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 5">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PN,':',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 4">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PN,':',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 3">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PN,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 2">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = $PN]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 1">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/*')]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 0">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = '*/*']" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:message terminate="yes">*** ERROR: unexpected priority</xsl:message>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="debug">
        <xsl:with-param name="message">&lt;&lt;  Dispatching done <xsl:value-of select="$priority" /></xsl:with-param>
    </xsl:call-template>
</xsl:template>

<!--
    Template to handle matched `package' nodes.
    Called from `dispatch-by-priority' and receives a matched packages set
    and current priority.

    Iterate over all matched nodes and render actions. Otherwise, if no matched nodes,
    try to select packages w/ less priority specification (untill priority is not 0 (lowest)).
  -->
<xsl:template name="handle-spec">
    <xsl:param name="packages-set" />
    <xsl:param name="priority" />

    <xsl:choose>
        <xsl:when test="count($packages-set) != 0">
            <xsl:call-template name="debug">
                <xsl:with-param name="message">==== Matched <xsl:value-of select="count($packages-set)" /> package nodes w/ priority <xsl:value-of select="$priority" /></xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates select="$packages-set">
                <xsl:with-param name="priority" select="$priority" />
            </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="count($packages-set) = 0 and $priority &gt; 0">
            <xsl:call-template name="debug">
                <xsl:with-param name="message">==== ... nothing matched: trying lower priority ... </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="dispatch-by-priority">
                <xsl:with-param name="priority" select="$priority - 1" />
            </xsl:call-template>
        </xsl:when>
    </xsl:choose>
</xsl:template>

<!--
    Matching `package` nodes w/ package spec attribute
  -->
<xsl:template match="fsmh:package[@spec]">
    <xsl:param name="priority" />
    <xsl:call-template name="debug">
        <xsl:with-param name="message">&gt;&gt;&gt; Package matched: <xsl:value-of select="@spec" /> (priority=<xsl:value-of select="$priority" />, stop=<xsl:value-of select="@stop" />)</xsl:with-param>
    </xsl:call-template>
    <!-- Render script for given package -->
    einfo &quot;Filesystem Management Hook: Apply actions<xsl:if test="@descr"> '<xsl:value-of
        select="@descr" />'</xsl:if> for <xsl:value-of select="@spec" />&quot;
    <xsl:apply-templates select="*" />

    <!-- Continue if no `stop' attribute -->
    <xsl:if test="@stop != 'true' and $priority &gt; 0">
        <xsl:call-template name="debug">
            <xsl:with-param name="message">==== continue matching packages w/ lower priority ... </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="dispatch-by-priority">
            <xsl:with-param name="priority" select="$priority - 1" />
        </xsl:call-template>
    </xsl:if>
    <xsl:call-template name="debug">
        <xsl:with-param name="message">&lt;&lt;&lt; Matching done: <xsl:value-of select="@spec" /> (priority=<xsl:value-of select="$priority" />)</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<!--
    Matching `symlink` nodes w/ all required parameters given
  -->
<xsl:template match="fsmh:symlink[@cd][@src][@dst]">
# Make a symlink <xsl:value-of select="@src" /> --&gt; <xsl:value-of select="@dst" /> @ <xsl:value-of select="@cd" />
cmd_symlink \
    "<xsl:value-of select="@cd" />" \
    "<xsl:value-of select="@src" />" \
    "<xsl:value-of select="@dst" />"
</xsl:template>

<!--
    Matching `rm` nodes w/ all required parameters given
  -->
<xsl:template match="fsmh:rm[@cd][@dst]">
# Remove <xsl:value-of select="@dst" /> @ <xsl:value-of select="@cd" />
cmd_rm "<xsl:value-of select="@cd" />" "<xsl:value-of select="@dst" />"
</xsl:template>

<!--
    Matching `rm` nodes w/ only `cd' attribute
  -->
<xsl:template match="fsmh:rm[@cd][not(@dst)]">
# Remove a bunch of items in <xsl:value-of select="@cd" />
<xsl:variable name="cd" select="@cd" />
<xsl:if test="count(fsmh:item/@dst) &gt; 0">
    <xsl:for-each select="fsmh:item[@dst]">
cmd_rm "<xsl:value-of select="$cd" />" "<xsl:value-of select="@dst" />"
    </xsl:for-each>
</xsl:if>
</xsl:template>

<!--
    SPAM if debug turned ON
  -->
<xsl:template name="debug">
    <xsl:param name="message" />
    <xsl:if test="$debug = 'yes'">
        <xsl:message><xsl:value-of select="$message" /></xsl:message>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
