Changelog
=========

Unreleased
----------

* Autopatch: Do not apply same patch twice, if found in multiple directories;
* Review bash code and replace backticks with `$(...)`, also `[` has replaced with `[[` and
  cleaned from redundant quotes. Replace some external program calls w/ bash built-in equivalent.
  Some optimizations and code deduplication has been done as well ;-)

Version 1.2
-----------

* Add a runtime option to the filesystem management hook to suppress a warning;
* Rename `reverse` attribute of the Filesystem Manager's config to `negate`;
* Better docs and a bunch of fixes (thanks to Kapshuna Alexander, @kapsh);
* Fix for issue #11;
* A bunch of improvements in the environment manager: now it is possible to use
  functions from `flag-o-matic.eclss` to manage compiler/linker options;
* Add `pretend-use` attribute to `package` element of the Filesystem Manager hook config;
* Introduce `mv` element to Filesystem Manager hook config.

Version 1.1
-----------

* Few improvements to `auto-patch` (thanks to Julian Ospald);
* Remove the autoconf cache hook.. that was a bad idea! ;-)

Version 1.0
-----------
* Add a hook to clean a "shared" autotools' `config.cache` before build (see rationale and the hook
  description of a project's homepage);
* Add a hook to make it possible to build packages (smoothly) in a RAM (disk)
* Little refactorings in some other hooks.

Version 0.9
-----------
* Add the `if` element to Filesystem Manager and the only, nowadays, expression type to check presence of some `USE`;
* Add `config-cache-clear` hook to remove some harmful cached values from a `config.cache`
  shared among packages.

Version 0.8
-----------
* Add a boolean attribute `reverse` (w/ values `true` or `false` (default)) to allow removal
  of everything except selected targets.

Version 0.7
-----------
* `package` nodes now matched according full featured package specification;
* Also package matching was rewritten, so now it is possible to combine actions
  for different (partial) specs.

Version 0.6
-----------
* Add remove command, so one may remove some files/directories from an image. If there is
  no files remain, empty directories will be removed as well, to avoid warnings from `cave`;
* Validate configuration file against DTD.

Version 0.5
-----------
* Initial commit to github
