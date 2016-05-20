What is this?
=============

Here is a set of my hooks (plugins) for [paludis](http://paludis.exherbo.org) I wrote and use few years already.

Briefly this package consists of:
* __Autopatch__ hook -- an easy way to apply patches ([here](https://github.com/zaufi/paludis-autopatches) is my set of patches)
* __Filesystem Manager__ hook -- a better way to avoid installation of some files than `INSTALL_MASK` +
  some other interesting usage practices w/o direct analogues in the portage
* A smart way to build packages in a RAM disk with `workdir-tmpfs` hook
* A bunch of helper functions usable in a daily work w/ paludis
* A hook to organize compiler/linker options into various sets and apply to packages

Configuration details
=====================

Autopatch
---------

The only one option in `/etc/paludis/hooks/configs/auto-patch.conf` is location of patches tree
(default: `/var/paludis/autopatches`).
`.patch` files should be placed under this directory with such hierarchy:
```
autopatches
├── hook_name1
│   └── cate-gory
│       └── package_name
│           └── fix_some_crap.patch
├── hook_name2
│   ├── cate-gory
│   │   └── package-ver
│   │       └── version-specific.patch
│   ├── cate-gory
│   │   └── package-ver_r1
│   │       └── some-cve-hotfix.patch
│   └── cate-gory
│       └── any_spec:SLOT
│           └── slot-specific.patch
```
and so on.

Supported hooks for autopatch are:
`ebuild_install_pre, install_all_post, ebuild_configure_post, ebuild_compile_post, ebuild_configure_pre, ebuild_compile_pre, ebuild_unpack_post`.

This hook is also controlled by this variables in paludis' `bashrc`:
  * `PALUDIS_AUTOPATCH_HOOK_DO_NOTHING="yes"` disables all actions of this hook.
  * `PALUDIS_AUTOPATCH_HOOK_NO_WARNING="yes"` mutes annoying warnings about altered packages.

Filesystem Manager
------------------

`/etc/paludis/hooks/configs/filesystem-manager.conf` is a set of rules in XML which format is explained
by the comments in it or in more details
[here](https://github.com/zaufi/paludis-config/blob/hardware/notebook/MSI-GP60-2PE-Leopard/hooks/configs/filesystem-manager.conf).

This hook is also controlled by this variables in paludis' `bashrc`:
  * `PALUDIS_HOOK_DEBUG="yes"` dumps enviroment variables to file `/tmp/paludis-fsm-hook-env.log`.
  * `PALUDIS_FILESYSTEM_HOOK_DO_NOTHING="yes"` disables all actions of this hook.
  * `PALUDIS_FILESYSTEM_HOOK_NO_WARNING="yes"` mutes annoying warnings about altered packages.

package.env
-----------

For using this hook add to paludis bashrc line:

    [ -e /usr/libexec/paludis-hooks/setup_pkg_env.bash ] && source /usr/libexec/paludis-hooks/setup_pkg_env.bash

and to `/etc/paludis/package_env.conf`:

    category/some_package some_env another_env ...

So, at build time of `category/some_package`, all lines from the mentioned env files (`/etc/paludis/env.conf.d/some_env.conf` and
`/etc/paludis/env.conf.d/another_env.conf`) will be sourced at `init` ebuild phase. Hence, changing compiler/linker flags
or setting another compiler would affect the build process only for given package.

Workdir-tmpfs
-------------

Most important parameter in `/etc/paludis/hooks/configs/workdir-tmpfs.conf` is
`IN_MEMORY_BUILD_ENABLED`.

TODO
====

* Add more commands! Like `*zip` smth...
* Add ability to find target objects (files, dirs, whatever) by introducing smth
  like `find` item and iterate over results applying some other actions (`ln`, `rm`, & etc...).
  For example `dev-python/PyQt5` have a lot of useless `README` files in every `examples/*` directory
* Implement FSM commands as **real** plugins... need to think about how to update (merge) DTD then.
* Predefine some useful entities? Like `&docdir;` for `/usr/share/doc`
* Add option to ignore `SLOT` when build certain packages w/ `wokrdir-tmpfs` hook -- i.e.
  when it is known apriory that required size doesn't change much (like `gentoo-sources`)
* Add element to inject `USE=doc` for packages where it is not defined, so it'll be possible
  to continue processing and avoid rules duplication in FMS hook. (alsmost done)
* Add some command to get last entries for ebuild Changelog

Changelog
=========

Version 1.2
-----------

* Add a runtime option to filesystem management hook to suppress a warning
* Rename `reverse` attribute of Filesystem Manager config to `negate`
* Better docs and a bunch of fixes (thanks to Kapshuna Alexander, @kapsh)
* Fix for issue #11
* A bunch of improvements in environment manager: now it is possible to use
  functions from `flag-o-matic.eclss` to manage compiler/linker options
* Add `pretend-use` attribute to `package` element of Filesystem Manager hoost config
* Introduce `mv` element in Filesystem Manager hoost config

Version 1.1
-----------

* Few improvements to `auto-patch` (thanks to Julian Ospald)
* Remove autoconf cache hook.. that was a bad idea! ;-)

Version 1.0
-----------
* add a hook to clean a "shared" autotools' `config.cache` before build (see rationale and the hook
  description of a project's homepage)
* add a hook to make it possble to build packages (smoothly) in a RAM (disk)
* little refactorings in some other hooks

Version 0.9
-----------
* add a `if` command and the only, nowadays, expression type to check presence of some `USE`
* add `config-cache-clear` hook to remove some harmful cached values from a `config.cache`
  shared among packages

Version 0.8
-----------
* add a boolean attribute `reverse` (w/ values `true` or `false` (default)) to allow removal
of everything except selected targets.

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
