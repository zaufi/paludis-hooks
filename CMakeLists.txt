# vim:ts=4:expandtab:
# "Build" script for my paludis-hooks package
# Copyright 2012-2016 by Alex Turbov <i.zaufi@gmail.com>
#

cmake_minimum_required(VERSION 3.4)
project(paludis-hooks VERSION 1.3 LANGUAGES NONE)

# seek for xmllint to validate our XML files
find_program(XMLLINT_EXECUTABLE xmllint)
# check if xsltproc is even installed
find_program(XSLTPROC_EXECUTABLE xsltproc)
if(NOT XSLTPROC_EXECUTABLE)
  message(FATAL_ERROR "xsltproc executable required for this package")
endif()
if(NOT XMLLINT_EXECUTABLE)
  message(FATAL_ERROR "xmllint executable required for this package")
endif()
find_package(PythonInterp)
if(NOT PYTHONINTERP_FOUND)
    message(STATUS "Python scripts will not be installed")
endif()

# Define install destination dirs
# ATTENTION Define CMAKE_SIZEOF_VOID_P to some not important value
# to suppress a warning from GNUInstallDirs...
set(CMAKE_SIZEOF_VOID_P 8)
include(GNUInstallDirs)

# Foe tests
include(CTest)

option(WITH_AUTOPATCH "Install autopatch hook" ON)
option(WITH_FS_MANAGER "Install filesystem manager hook" ON)
option(WITH_PACKAGE_ENV "Install per package environment manager" ON)

# Autopatch hook
if(WITH_AUTOPATCH)
    configure_file(auto-patch/auto-patch.bash.in auto-patch/auto-patch.bash @ONLY)
    configure_file(auto-patch/auto-patch.conf.in auto-patch/auto-patch.conf @ONLY)
    install(
        PROGRAMS "${CMAKE_BINARY_DIR}/auto-patch/auto-patch.bash"
        DESTINATION "${CMAKE_INSTALL_FULL_DATAROOTDIR}/paludis-hooks"
        )
    install(
        FILES "${CMAKE_BINARY_DIR}/auto-patch/auto-patch.conf"
        DESTINATION "${CMAKE_INSTALL_FULL_SYSCONFDIR}/paludis/hooks/configs"
        )
endif()

# Filesystem manager hook
if(WITH_FS_MANAGER)
    add_subdirectory(filesystem-manager)
endif()

# Package environment configurator
if(WITH_PACKAGE_ENV)
    configure_file(package.env/setup_pkg_env.bash.in package.env/setup_pkg_env.bash @ONLY)
    install(
        FILES "${CMAKE_BINARY_DIR}/package.env/setup_pkg_env.bash"
        DESTINATION "${CMAKE_INSTALL_FULL_LIBEXECDIR}/paludis-hooks"
      )
    install(
        FILES
            package.env/default-deps-trk.conf
            package.env/default-silent-rules.conf
            package.env/extra-optimize.conf
            package.env/lto.conf
            package.env/max-debug.conf
            package.env/no-debug.conf
            package.env/no-modern-c++.conf
            package.env/no-gnu-tls.conf
            package.env/no-gc-sections.conf
            package.env/no-lto.conf
            package.env/spam.conf
            package.env/use-bfd-linker.conf
            package.env/use-gold-linker.conf
            package.env/use-latest-gcc.conf
            package.env/use-modern-c++.conf
        DESTINATION "${CMAKE_INSTALL_FULL_SYSCONFDIR}/paludis/env.conf.d"
      )
endif()

# In Memory Build hook
if(WITH_WORKDIR_TMPFS)
    configure_file(workdir-tmpfs/workdir-tmpfs.bash.in workdir-tmpfs/workdir-tmpfs.bash @ONLY)
    configure_file(workdir-tmpfs/workdir-tmpfs.conf.in workdir-tmpfs/workdir-tmpfs.conf @ONLY)

    install(
        PROGRAMS "${CMAKE_BINARY_DIR}/workdir-tmpfs/workdir-tmpfs.bash"
        DESTINATION "${CMAKE_INSTALL_FULL_DATAROOTDIR}/paludis-hooks"
      )
    install(
        FILES "${CMAKE_BINARY_DIR}/workdir-tmpfs/workdir-tmpfs.conf"
        DESTINATION "${CMAKE_INSTALL_FULL_SYSCONFDIR}/paludis/hooks/configs"
      )
endif()

# Some other helpers...
install(
    FILES profile.d/00-make-completion-wrapper.sh profile.d/cave-aliases.sh
    DESTINATION "${CMAKE_INSTALL_FULL_SYSCONFDIR}/profile.d"
  )
install(
    FILES env.d/90cave
    DESTINATION "${CMAKE_INSTALL_FULL_SYSCONFDIR}/env.d"
  )

if(PYTHONINTERP_FOUND)
    install(
        PROGRAMS print-ebuild-path
        DESTINATION "${CMAKE_INSTALL_FULL_LIBEXECDIR}/cave/commands"
      )
    install(
        FILES profile.d/cave-addons.sh
        DESTINATION "${CMAKE_INSTALL_FULL_SYSCONFDIR}/profile.d"
      )
endif()

# Docs (not much)
install(
    FILES README.md
    DESTINATION "${CMAKE_INSTALL_FULL_DOCDIR}"
  )
