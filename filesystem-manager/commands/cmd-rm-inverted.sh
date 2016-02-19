#!/bin/bash
#
# Plugin to implement an `rm` command of the config file
# which would remove everything except target(s)
#

#
# Function to remove everything except a specified list in a given directory
#
# @param cd  -- directory to change to, before remove
# @param dst -- targets what must stay
#
function cmd_rm_inverted()
{
    local cd="$1"
    local dst="$2"

    if ! verify_dir "${cd}"; then
        eerror "Package image dir is undefined! Skip any actions..."
        return
    fi
    if [ -z "${T}" ]; then
        eerror "Package temp dir is undefined! Skip any actions..."
        return
    fi

    if [ -d "${D}/${cd}" ]; then
        cd "${D}/${cd}"
        eval find ${dst} 2>/dev/null | sed 's,^\./,,' | sort > ${T}/rm_except.lst
        find | sed 's,^\./,,' | sort | comm -3 ${T}/rm_except.lst - >${T}/rm.lst
        if [ -s ${T}/rm.lst ]; then
            rm -vrf `cat ${T}/rm.lst` 2>/dev/null && schedule_a_warning_after_all
        fi
        cd - >/dev/null
        # Walk through whole image and try to remove possible empty dirs
        # ATTENTION According EAPI it is incorrect to install empty directories!
        # If a package need some, then its ebuild must use `keepdir` for this!
        # So this action also can be considered as sanitize an image before install :)
        find ${D} -type d -a -empty -exec rmdir -p --ignore-fail-on-non-empty {} +
        # Sometimes (if u really don't want a WHOLE package, but have to install it,
        # like boring kde-wallpapers) the last command may delete even ${D} directory,
        # so paludis will complain about broken image :) -- Ok, lets restore it!
        test ! -e "${D}" && mkdir -p "${D}"
    fi
}
