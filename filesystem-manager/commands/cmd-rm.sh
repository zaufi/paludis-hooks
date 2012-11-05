#!/bin/sh
#
# Plugin to implement a `rm` command of the config file
#

function _remove_empty_dirs_reqursively()
{
    local cd="$1"

    # Check if there is something else in the `cd` dir?
    local hasSmth=`find "${D}/${cd}" ! -type d`
    if [ -z "${hasSmth}" ]; then
        # NO! Remove an empty dir to avoid warnings!
        rm -rf ${D}/${cd}
        local parent=`dirname "${cd}"`
        if [ "$parent" != "/" ]; then
            _remove_empty_dirs_reqursively "$parent"
        fi
    fi
}

#
# Function to remove smth in a given directory
#
# @param cd  -- directory to change to before remove
# @param dst -- what to remove (possible w/ wildcards)
#
function cmd_rm()
{
    local cd="$1"
    local dst="$2"
    ebegin "Removing the ${cd}/${dst}"
    cd "${D}/${cd}" \
      && rm -rf ${dst} 2>/dev/null \
      && cd -
    result=$?
    _remove_empty_dirs_reqursively "${cd}"
    eend $result
}
