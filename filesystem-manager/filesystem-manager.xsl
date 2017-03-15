<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version = "1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fsmh="https://github.com/zaufi/paludis-hooks/#filesystem-management-hook"
  >
<!--
    Transform a config file into a shell script
    Copyright (c), 2010-2014 by Alex Turbov <i.zaufi@gmail.com>
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
</xsl:call-template>#!/bin/sh
#
# ATTENTION: This script produced by filesystem-manager paludis hook
# on installing <xsl:value-of select="concat($CATEGORY,'/',$PN,'-',$PV,'-',$PR,':',$SLOT,'::',$REPOSITORY)" /> package
#
source ${PALUDIS_EBUILD_DIR}/echo_functions.bash
for cmd in /usr/share/paludis-hooks/filesystem-manager/commands/*.sh; do
    source $cmd
done

# Save some shell options status
_fsm_shopt_globstar=$(shopt -p globstar)
_fsm_shopt_nullglob=$(shopt -p nullglob)

# Enable some shell options
shopt -qs globstar
shopt -qs nullglob

<!-- Initiate package spec pattern matching starting from highest priority -->
<xsl:call-template name="dispatch-by-priority">
    <xsl:with-param name="priority" select="number(24)" />
</xsl:call-template>

<xsl:call-template name="debug">
    <xsl:with-param name="message">&lt;   Rendering done for <xsl:value-of select="concat($CATEGORY,'/',$PF,':',$SLOT,'::',$REPOSITORY)" /></xsl:with-param>
</xsl:call-template>
# Restore saved shell options
eval "${_fsm_shopt_globstar}"
eval "${_fsm_shopt_nullglob}"
</xsl:template>

<!--
    Select `package' nodes according specification priority and call
    `handle-spec' w/ selected set (possible empty).

    p   spec
    ..................................
    24  cat/package-ver-rv:slot::repo
    23  cat/package-ver-rv:slot
    22  cat/package-ver-rv::repo
    21  cat/package-ver-rv
    20  cat/package:slot::repo
    19  cat/package:slot
    18  cat/package::repo
    17  cat/package
    16  package-ver-rv:slot::repo
    15  package-ver-rv:slot
    14  package-ver-rv:repo
    13  package-ver-rv
    12  package:slot::repo
    11  package:slot
    10  package:repo
    9   package
    8   cat/*:slot::repo
    7   cat/*:slot
    6   cat/*::repo
    5   cat/*
    4   */*:slot::repo
    3   */*:slot
    2   */*::repo
    1   */*
  -->
<xsl:template name="dispatch-by-priority">
    <xsl:param name="priority" />

    <xsl:call-template name="debug">
        <xsl:with-param name="message">&gt;&gt;  Dispatching by priority <xsl:value-of select="$priority" /></xsl:with-param>
    </xsl:call-template>

    <xsl:choose>
        <xsl:when test="$priority = 24">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PF,':',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
    <xsl:when test="$priority = 23">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PF,':',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 22">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PF,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 21">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PF)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 20">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PN,':',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 19">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PN,':',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 18">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PN,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 17">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/',$PN)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 16">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PF,':',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 15">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PF,':',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 14">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PF,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 13">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = $PF]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 12">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PN,':',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 11">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PN,':',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 10">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($PN,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 9">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = $PN]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 8">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/*:',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 7">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/*:',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 6">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/*::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 5">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat($CATEGORY,'/*')]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 4">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat('*/*:',$SLOT,'::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 3">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat('*/*:',$SLOT)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 2">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = concat('*/*::',$REPOSITORY)]" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$priority = 1">
            <xsl:call-template name="handle-spec">
                <xsl:with-param name="packages-set"
                    select="/fsmh:commands/fsmh:package[@spec = '*/*']" />
                <xsl:with-param name="priority" select="$priority" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="$priority = 0">
            <xsl:call-template name="debug">
                <xsl:with-param name="message">==== Recursion terminated ===</xsl:with-param>
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

    <!-- Show some SPAM (in stript's runtime) -->
    einfo "Filesystem Management Hook: Apply actions<xsl:if test="@descr"> '<xsl:value-of
        select="@descr" />'</xsl:if> for <xsl:value-of select="@spec" />"

    <!-- Modify USE if pretend-use attribute is here -->
    <xsl:if test="@pretend-use">
        cmd_pretend_use <xsl:value-of select="@pretend-use" />
    </xsl:if>

    <!-- Render script for given package -->
    <xsl:apply-templates select="*" />

    <!-- Continue if no `stop' attribute -->
    <xsl:if test="@stop != 'true' and $priority &gt; 0">
        <xsl:call-template name="debug">
            <xsl:with-param name="message">==== continue matching packages w/ lower priority ...</xsl:with-param>
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
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `symlink`: cd=<xsl:value-of select="@cd" />, src=<xsl:value-of select="@src" />, dst=<xsl:value-of select="@dst" /></xsl:with-param>
    </xsl:call-template>

# Make a symlink <xsl:value-of select="@src" /> --&gt; <xsl:value-of select="@dst" /> @ <xsl:value-of select="@cd" />
cmd_symlink \
    "<xsl:value-of select="@cd" />" \
    "<xsl:value-of select="@src" />" \
    "<xsl:value-of select="@dst" />"
</xsl:template>

<!--
    Matching `symlink` nodes w/ only `cd' attribute
  -->
<xsl:template match="fsmh:symlink[@cd][not(@src)][not(@dst)]">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `symlink`: cd=<xsl:value-of select="@cd" />, src=none, dst=none</xsl:with-param>
    </xsl:call-template>
# Symlink a bunch of items in <xsl:value-of select="@cd" />
<xsl:variable name="cd" select="@cd" />
<xsl:if test="count(fsmh:item/@src) &gt; 0 and count(fsmh:item/@dst) &gt; 0">
    <xsl:for-each select="fsmh:item[@src][@dst]">
cmd_symlink \
    "<xsl:value-of select="$cd" />" \
    "<xsl:value-of select="@src" />" \
    "<xsl:value-of select="@dst" />"
    </xsl:for-each>
</xsl:if>
</xsl:template>

<!--
    Matching `symlink` nodes w/ `cd' and `src' attribute
  -->
<xsl:template match="fsmh:symlink[@cd][@src][not(@dst)]">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `symlink`: cd=<xsl:value-of select="@cd" />, src=<xsl:value-of select="@src" />, dst=none</xsl:with-param>
    </xsl:call-template>
# Symlink a bunch of items in <xsl:value-of select="@cd" /> to <xsl:value-of select="@src" />
<xsl:variable name="cd" select="@cd" />
<xsl:variable name="src" select="@src" />
<xsl:if test="count(fsmh:item/@dst) &gt; 0">
    <xsl:for-each select="fsmh:item[@dst]">
cmd_symlink \
    "<xsl:value-of select="$cd" />" \
    "<xsl:value-of select="$src" />" \
    "<xsl:value-of select="@dst" />"
    </xsl:for-each>
</xsl:if>
</xsl:template>

<!--
    Matching `rm` nodes w/ all parameters given to remove everything
    except target(s) specified
  -->
<xsl:template match="fsmh:rm[@cd][@dst][@negate='true']">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `rm`: cd=<xsl:value-of select="@cd" />, dst=<xsl:value-of select="@dst" />, negate=true</xsl:with-param>
    </xsl:call-template>
# Remove everything except <xsl:value-of select="@dst" /> @ <xsl:value-of select="@cd" />
cmd_rm_inverted "<xsl:value-of select="@cd" />" "<xsl:value-of select="@dst" />"
</xsl:template>

<!--
    Matching `rm` nodes w/ all parameters given to remove specified target(s)
  -->
<xsl:template match="fsmh:rm[@cd][@dst][@negate='false']">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `rm`: cd=<xsl:value-of select="@cd" />, dst=<xsl:value-of select="@dst" />, negate=false</xsl:with-param>
    </xsl:call-template>
# Remove <xsl:value-of select="@dst" /> @ <xsl:value-of select="@cd" />
cmd_rm "<xsl:value-of select="@cd" />" "<xsl:value-of select="@dst" />"
</xsl:template>

<!--
    Matching `rm` nodes w/ only `cd' attribute
  -->
<xsl:template match="fsmh:rm[@cd][not(@dst)]">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `rm`: cd=<xsl:value-of select="@cd" />, dst=none</xsl:with-param>
    </xsl:call-template>
# Remove a bunch of items in <xsl:value-of select="@cd" />
<xsl:variable name="cd" select="@cd" />
<xsl:if test="count(fsmh:item/@dst) &gt; 0">
    <xsl:for-each select="fsmh:item[@dst]">
cmd_rm "<xsl:value-of select="$cd" />" "<xsl:value-of select="@dst" />"
    </xsl:for-each>
</xsl:if>
</xsl:template>

<!--
    Matching `mv` nodes w/ all parameters given to move specified target(s)
  -->
<xsl:template match="fsmh:mv[@cd][@src][@dst]">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `mv`: cd=<xsl:value-of select="@cd" />, dst=<xsl:value-of select="@dst" />, src=<xsl:value-of select="@src" /></xsl:with-param>
    </xsl:call-template>
# Move <xsl:value-of select="@src" /> to <xsl:value-of select="@dst" /> @ <xsl:value-of select="@cd" />
cmd_mv "<xsl:value-of select="@cd" />" "<xsl:value-of select="@dst" />" "<xsl:value-of select="@src" />"
</xsl:template>

<!--
    Matching `mv` nodes w/ `cd' and `dst` attributes
  -->
<xsl:template match="fsmh:mv[@cd][@dst][not(@src)]">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `mv`: cd=<xsl:value-of select="@cd" />, dst=<xsl:value-of select="@dst" />, src=none</xsl:with-param>
    </xsl:call-template>
<xsl:variable name="cd" select="@cd" />
<xsl:variable name="dst" select="@cd" />
<xsl:if test="count(fsmh:item/@src) &gt; 0">
    <xsl:for-each select="fsmh:item[@src]">
# Move <xsl:value-of select="@src" /> to <xsl:value-of select="$dst" /> @ <xsl:value-of select="$cd" />
cmd_mv "<xsl:value-of select="$cd" />" "<xsl:value-of select="$dst" />" "<xsl:value-of select="@src" />"
    </xsl:for-each>
</xsl:if>
</xsl:template>

<!--
    Matching `if` nodes
  -->
<xsl:template match="fsmh:if[@use][@negate='false']">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `if`: use=<xsl:value-of select="@use" />, negate=false</xsl:with-param>
    </xsl:call-template>
# Check use flags: <xsl:value-of select="@use" />
if cmd_use "<xsl:value-of select="@use" />"; then
    einfo "'<xsl:value-of select="@use" />' found in USE flags!"
    <!-- Execute nested code -->
    <xsl:apply-templates select="*" />
fi
</xsl:template>
<xsl:template match="fsmh:if[@use][@negate='true']">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `if`: use=<xsl:value-of select="@use" />, negate=true</xsl:with-param>
    </xsl:call-template>
# Check use flags: <xsl:value-of select="@use" />
if cmd_use "<xsl:value-of select="@use" />"; then
    true
else
    einfo "'<xsl:value-of select="@use" />' not found in USE flags!"
    <!-- Execute nested code -->
    <xsl:apply-templates select="*" />
fi
</xsl:template>

<!--
    Matching `mkdir` nodes w/ all parameters given
  -->
<xsl:template match="fsmh:mkdir[@cd][@dst]">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `mkdir`: cd=<xsl:value-of select="@cd" />, dst=<xsl:value-of select="@dst" /></xsl:with-param>
    </xsl:call-template>
# Make directory <xsl:value-of select="@dst" /> @ <xsl:value-of select="@cd" />
cmd_mkdir "<xsl:value-of select="@cd" />" <xsl:value-of select="@dst" />
</xsl:template>

<!--
    Matching `mkdir` nodes w/ only `cd` attribute
  -->
<xsl:template match="fsmh:mkdir[@cd][not(@dst)]">
    <xsl:call-template name="debug">
        <xsl:with-param name="message">==== rendering `mkdir`: cd=<xsl:value-of select="@cd" />, dst=none</xsl:with-param>
    </xsl:call-template>
<xsl:variable name="cd" select="@cd" />
<xsl:if test="count(fsmh:item/@dst) &gt; 0">
    <xsl:for-each select="fsmh:item[@src]">
# Make directory <xsl:value-of select="@dst" /> @ <xsl:value-of select="@cd" />
cmd_mkdir "<xsl:value-of select="$cd" />" "<xsl:value-of select="@dst" />"
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
