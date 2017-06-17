#!/bin/bash
#
# Plugin to implement the `symlink` command of the config file
#

# @param cd  -- directory to change to before making a symlink
# @param src -- source name
# @param dst -- destination name
#
function cmd_symlink()
{
    local cd="$1"
    local src="$2"
    local dst="$3"

    if ! verify_dir "${cd}"; then
        eerror "Package image dir is undefined! Skip any actions..."
        return 0
    fi

    [[ -d ${D}/$cd && -e ${D}/${cd}/${src} ]] \
      && cd "${D}/${cd}" \
      && ln -vs ${src} ${dst} \
      && schedule_a_warning_after_all \
      && cd - >/dev/null

    return 0
}
