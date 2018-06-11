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
* Add `debug` attribute to command(s) to show `pwd` and contents of a directory before apply some action
* Add sync post hook to update a repo with auto patches
* <del>Make it possible to remove by Ant-like wildcard `**/some` (hint: bash has `shopt globstar`)</del>
* Case insensitive glob expressions match, so `announce*`, `ANNOUNCE*` and `Announce*` can be replaced
  with only one rule
* Allow loops?

    <for-each>
        <items>
            <item>notepad</item>
            <item>winefile</item>
            ...
        </items>
        <do>
            <rm cd="/usr/lib32/${P}/wine/fakedlls" dst="${item}.exe" />
            <rm cd="/usr/lib32/${P}/wine" dst="${item}.exe.so" />
            <rm cd="/usr/lib64/${P}/bin" dst="${item}" />
            <rm cd="/usr/bin" dst="${item}-vanilla-${PV}" />
        </do>
    </for-each>
