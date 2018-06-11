What is this?
=============

Here is a set of my hooks (plugins) for [paludis](http://paludis.exherbo.org) I wrote and use few years already.

Briefly this package consists of:
* __Autopatch__ hook -- an easy way to apply patches ([here](https://github.com/zaufi/paludis-autopatches) is my set of patches)
* __Filesystem Manager__ hook -- a better way to avoid installation of some files than `INSTALL_MASK` +
  some other interesting usage practices w/o direct analogues in the portage
* A smart way to build packages in a RAM disk with `workdir-tmpfs` hook
* A bunch of helper functions usable in a daily work w/ Paludis
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

For using this hook add to Paludis' `bashrc` line:

    [ -e /usr/libexec/paludis-hooks/setup_pkg_env.bash ] && source /usr/libexec/paludis-hooks/setup_pkg_env.bash

and to `/etc/paludis/package_env.conf`:

    category/some_package some_env another_env ...

So, at build time of `category/some_package`, all lines from the mentioned env files (`/etc/paludis/env.conf.d/some_env.conf` and
`/etc/paludis/env.conf.d/another_env.conf`) will be sourced at `init` ebuild phase. Hence, changing compiler/linker flags
or setting another compiler would affect the build process only for given package.


Workdir-tmpfs
-------------

Most important boolean parameter in `/etc/paludis/hooks/configs/workdir-tmpfs.conf` is `IN_MEMORY_BUILD_ENABLED`.
