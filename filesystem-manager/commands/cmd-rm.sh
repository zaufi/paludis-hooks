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

    if [ -d "${D}/${cd}" ]; then
        cd "${D}/${cd}" \
          && rm -vrf "${@}" 2>/dev/null \
          && schedule_a_warning_after_all \
          && cd - >/dev/null
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
