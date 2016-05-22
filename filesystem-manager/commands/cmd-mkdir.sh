#!/bin/bash
#
# Plugin to implement the `mkdir` command of the config file
#

# @param cd  -- directory to change to before making a directory (can be empty)
# @param dst... -- directory name(s) to make
#
function cmd_mkdir()
{
    local cd="$1"
    shift 1

    if ! verify_dir "${cd}"; then
        eerror "Package image dir is undefined! Skip any actions..."
        return 0
    fi

    if [ -d "${D}/${cd}" ]; then
        cd "${D}/${cd}" \
          && mkdir -vp "$@" \
          && schedule_a_warning_after_all \
          && cd - >/dev/null
    fi

    return 0
}
