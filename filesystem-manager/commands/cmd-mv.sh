#!/bin/bash
#
# Plugin to implement the `mv` command of the config file
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

    if [[ -z $@ ]]; then
        # NOTE This shouldn't happened! Config file will be validated with DTD...
        eerror "No source(s) to move has specified"
        return
    fi

    if [[ -d ${D}/${cd} ]]; then
        cd "${D}/${cd}"
        mv -vf $@ "${dst}" 2>/dev/null && schedule_a_warning_after_all
        cd - >/dev/null
        cleanup_empty_dirs
    fi
    return 0
}
