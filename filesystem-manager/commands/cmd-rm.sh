#!/bin/bash
#
# Plugin to implement the `rm` command of the config file
#

#
# Function to remove smth in a given directory
#
# @param cd     -- directory to change to, before remove
# @param dst... -- what to remove (possible w/ wildcards)
function cmd_rm()
{
    local cd="$1"
    shift 1

    if ! verify_dir "${cd}"; then
        eerror "Package image dir is undefined! Skip any actions..."
        return 0
    fi

    if [[ -d ${D}/${cd} ]]; then
        cd "${D}/${cd}"
        local -r files=( ${@} )
        [[ -n ${files} ]] && rm -vrf ${files[@]} && schedule_a_warning_after_all
        cd - >/dev/null
        cleanup_empty_dirs
    fi

    return 0
}
