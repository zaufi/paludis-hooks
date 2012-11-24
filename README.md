What is this?
=============

Here is a set of my hooks (plugins) for plaudis I wrote and use few years already.


Autopatch
---------

This plugin used to apply a patch to some package w/o necessity to (re)write an ebuild for it.
Particularly it helps me to test some patches before report a bug to gentoo's bugzilla and/or write
a separate ebuild (to my overlay).

To apply a patch one have to put it into a directory under `${PATCH_DIR}/stage/category/pkg-ver/`,
where the `stage` is one of the following: `ebuild_compile_post`, `ebuild_compile_pre`,
`ebuild_configure_post`, `ebuild_configure_pre`, `ebuild_install_pre` or `ebuild_unpack_post`.

BTW, stupid portage, to "implement" the same feature, forces ebuild developers to add a `epatch_user`
call (defined in the `eutils.eclass`) to the `src_unpack` function! What a fraking smart solution! :(


Filesystem Manager
------------------

This plugin can be used to make some manipulations in a package's image (right after `make install`)
and before it will be actually installed into the system. Particularly it used to make a _permanent_
symlinks to a documentation for some packages I use in my work, so even the package will be updated,
bookmarks and history in my browser (I use it to view particular HTML docs) will be Ok.

Every action required to take place described in terms of XML items of configuration file
`/etc/paludis/hooks/configs/filesystem-manager.conf`.

Here is a few items possible nowadays, but I have plans to extend this list in future
(when it become necessary):

* `symlink` -- used to create a symlink and has attributes:
    * `cd` -- change to this directory before making a symlink
    * `src` -- source for the symlink
    * `dst` -- destination of the symlink
* `rm` -- used to remove smth from the image, so it will not be installed at all.
    * `dst` -- what to remove

### Example

I have `*/* -nls` in my `/etc/paludis/use.conf`, but some packages just don't have that USE flag,
but install localizations anyway (yep, cuz ebuild authors just lazy ppl... most of the time).
So `app-admin/localpurge` was "invented" to cleanup unused locales (ALL in my case). But `localepurge`
will remove `*.mo` files after install, so when uninstall a package, some files will be marked as _gone_.
One simple rule will do the job better:

    <package spec="*/*" descr="locale-cleaner">
        <rm cd="/usr/share/locale/" dst="*/LC_MESSAGES/*.mo" />
    </package>

Because manipulations (delete `*.mo` files) will be done *before* install, all that files even
won't be counted by package manager. And I'm not telling about that you don't need to run smth periodically
(or via cron) -- all your packages will be already clean w/o any external tools :)

TODO
====

* Add more commands! Like `*zip` smth...
* Add ability to glob a package IDs. Like `*/*` or `dev-libs/*`. Possible w/ smth
  like `except` items to specify rule exceptions
* Add ability to find target objects (files, dirs, whatever) by introducing smth
  like `find` item and iterate over results applying some other actions (ls, rm, & etc...)
* Implement commands as plugins... need to think about how to update DTD then.

Changelog
=========

Version 0.7
-----------
* `package` nodes now matched according full featured package specification.
* also package matching was reimplemented, so now it is possible to combine actions
  for different (partial) specs

Version 0.6
-----------
* add remove command, so one may remove some files/directories from an image. If there is
  no more files after removal, empty directory will be removed as well to avoid warnings
  from `cave`
* validate configuration file against DTD

Version 0.5
-----------
* initial commit to github


License
=======

Paludis-hooks is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Paludis-hooks is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
