#!/bin/bash
#
# Plugin to implement a `symlink` command of the config file
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

    if [ -d "${D}/$cd" ]; then
        ebegin "Making the symlink [$cd]: $src --> $dst"
        cd "${D}/$cd" \
          && ln -s $src $dst \
          && schedule_a_warning_after_all \
          && cd - >/dev/null
        eend $?
    fi

    return 0
}
