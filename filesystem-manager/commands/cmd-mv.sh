#!/bin/bash
#
# Plugin to implement an `mv` command of the config file
#

#
# Function to move smth in a given directory
#
# @param cd  -- directory to change to, before remove
# @param dst -- destination: directory or new file name
# @param src... -- what to move (possible w/ wildcards)
function cmd_mv()
{
    local cd="$1"
    local dst="$2"
    shift 2

    if ! verify_dir "${cd}"; then
        eerror "Package image dir is undefined! Skip any actions..."
        return
    fi

    if [ -z "$*" ]; then
        # NOTE This shouldn't happened! Config file will be validated with DTD...
        eerror "No source to move has specified"
        return
    fi

    if [ -d "${D}/${cd}" ]; then
        cd "${D}/${cd}"
        ebegin "Moving [$cd]: $* --> $dst"
        mv -vf "$@" ${dst} 2>/dev/null && schedule_a_warning_after_all
        eend $?
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
    return 0
}
