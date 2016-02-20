#!/bin/bash
#
# Plugin to implement an `mv` command of the config file
#

#
# Function to move smth in a given directory
#
# @param cd  -- directory to change to, before remove
# @param dst -- destination: directory or new file name
# @param mkdst -- assert that destination is a directory and must be created if absent yet
# @param src... -- what to move (possible w/ wildcards)
function cmd_mv()
{
    local cd="$1"
    local mkdst="$2"
    local st="$3"
    shift 3

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
        # If asked, make sure destination exists
        if [ x"${mkdst}" = 'xtrue' -a ! -d "${dst}" ]; then
            mkdir -p "${dst}"
        fi
        ebegin "Moving [$cd]: $* --> $dst"
        mv -vf "$@" ${dst} 2>/dev/null && schedule_a_warning_after_all
        eend $?
        cd - >/dev/null
        # Walk through whole image and try to remove possible empty dirs
        # ATTENTION According EAPI it is incorrect to install empty directories!
        # If a package need some, then its ebuild must use `keepdir` for this!
        # So this action also can be considered as sanitize an image before install :)
        find ${D} -type d -a -empty -exec rmdir -p --ignore-fail-on-non-empty {} +
    fi
}
