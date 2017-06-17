#
# A bunch of helper functions to investigate some troubles
#

#
# Get full ebuild path for package spec
#
function ebuild_for()
{
    cave print-ebuild-path $* || exit 1
}

#
# Display ebuild contents for package spec
#
function show_ebuild_for()
{
    ${PAGER:-less} $(ebuild_for $*)
}

function _pkg_ebuilds_diff()
{
    local op="$1"
    local pkg="$2"

    [[ -z ${pkg} ]] && return

    local i
    for i in `ebuild_for -i "${pkg}"`; do
        p=$(ebuild_for "${op}$(basename "${i}" .ebuild)")
        if [[ -n ${p} ]]; then
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
function pkg_meta_diff()
{
    _pkg_ebuilds_diff '=' $*
}

#
# Show difference between installed ebuild and the next best available version
#
# TODO Better name?
#
function pkg_ebuild_diff()
{
    _pkg_ebuilds_diff '>' $*
}
