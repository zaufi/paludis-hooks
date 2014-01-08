#
# A bunch of helper functions to investigate some troubles
#

#
# Get full ebuild path for package spec
#
function ebuild-for()
{
    cave print-ebuild-path $* || exit 1
}

function _pkg_ebuilds_diff()
{
    local op="$1"
    local pkg="$2"
    if [ -z "${pkg}" ]; then
        return
    fi
    local i
    for i in `ebuild-for -i "${pkg}"`; do
        p=`ebuild-for "${op}\`basename \"${i}\" .ebuild\`"`
        if [ -n "${p}" ]; then
            diff ${PKG_META_DIFF_OPTIONS} "${i}" "${p}"
        else
            return
        fi
    done
}

#
# Show difference between installed package and the same in the portage tree
#
# TODO Better name?
#
function pkg-meta-diff()
{
    _pkg_ebuilds_diff '=' $*
}

#
# Show difference between installed ebuild and the next best available version
#
# TODO Better name?
#
function pkg-ebuild-diff()
{
    _pkg_ebuilds_diff '>' $*
}
