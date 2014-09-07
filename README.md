What is this?
=============

Here is a set of my hooks (plugins) for [plaudis](http://paludis.exherbo.org) I wrote and use few years already.

Briefly this package consists of:
* __Autopatch__ hook -- an easy way to apply patches
* __Filesystem Manager__ hook -- a better way to avoid installation of some files than `INSTALL_MASK` +
  some other interesting usage practices w/o direct analogues in the portage
* A smart way to build packages in a RAM disk with `workdir-tmpfs` hook
* A bunch of helper functions usable in a daily work w/ paludis

TODO
====

* Add more commands! Like `*zip` smth...
* Add ability to find target objects (files, dirs, whatever) by introducing smth
  like `find` item and iterate over results applying some other actions (`ln`, `rm`, & etc...)
* Implement FSM commands as **real** plugins... need to think about how to update (merge) DTD then.

Changelog
=========

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
