#
# Get full ebuild path for package spec
#
function ebuild-for()
{
    cave print-ebuild-path $1
}

function _pkg_meta_diff_impl()
{
    local op="$1"
    local pkg="$2"
    local i
    for i in `ebuild-for -i "${pkg}"`; do
        p=`ebuild-for "${op}\`basename '$i' .ebuild\`"`
        diff ${PKG_META_DIFF_OPTIONS} "$i" "$p"
    done
}

#
# Show difference between installed package and the same in the portage tree
#
function pkg-meta-diff()
{
    _pkg_meta_diff_impl '=' $*
}

#
# Show difference between installed ebuild and the next best available version
#
function pkg-next-diff()
{
    _pkg_meta_diff_impl '>' $*
}
