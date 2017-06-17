#!/bin/bash
#
# Plugin to implement the `rm` command of the config file
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
        if [[ -s ${T}/rm.lst ]]; then
            rm -vrf $(< ${T}/rm.lst) 2>/dev/null && schedule_a_warning_after_all
        fi
        cd - >/dev/null
        cleanup_empty_dirs
    fi
}
