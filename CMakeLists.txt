cmake_minimum_required(VERSION 2.6)
project(paludis-hooks)

set(PH_VERSION "0.6")

# Setup package paths
# TODO Nowadays all paths are hardcoded and I'm not sure that there is a reason to do it flexible...
set(PH_PALUDISCONFDIR "/etc/paludis")
set(PH_HOOKSDIR       "/usr/share/paludis/hooks")
set(PH_HOOKSCONFDIR   "${PH_PALUDISCONFDIR}/hooks/configs")
set(PH_LOCALSTATEDIR  "/var")
set(PH_DATAROOTDIR    "/usr/share/paludis-hooks")
set(PH_DOCSDIR        "/usr/share/doc/paludis-hooks")

# Autopatch hook
configure_file(auto-patch/auto-patch.bash.in auto-patch/auto-patch.bash @ONLY)
configure_file(auto-patch/auto-patch.conf.in auto-patch/auto-patch.conf @ONLY)
install(
    PROGRAMS ${CMAKE_BINARY_DIR}/auto-patch/auto-patch.bash
    DESTINATION ${PH_HOOKSDIR}
  )
install(
    FILES ${CMAKE_BINARY_DIR}/auto-patch/auto-patch.conf
    DESTINATION ${PH_HOOKSCONFDIR}
  )

# Symlinks maintainer hook
set(FILESYSTEM_MANAGER_DTD "${PH_DATAROOTDIR}/filesystem-manager/filesystem-manager.dtd")
set(FILESYSTEM_MANAGER_XSL "${PH_DATAROOTDIR}/filesystem-manager/filesystem-manager.xsl")
configure_file(filesystem-manager/filesystem-manager.conf.in filesystem-manager/filesystem-manager.conf @ONLY)
configure_file(filesystem-manager/filesystem-manager.bash.in filesystem-manager/filesystem-manager.bash @ONLY)
install(
    PROGRAMS ${CMAKE_BINARY_DIR}/filesystem-manager/filesystem-manager.bash
    DESTINATION ${PH_HOOKSDIR}
  )
install(
    FILES ${CMAKE_BINARY_DIR}/filesystem-manager/filesystem-manager.conf
    DESTINATION ${PH_HOOKSCONFDIR}
  )
install(
    FILES ${CMAKE_SOURCE_DIR}/filesystem-manager/filesystem-manager.xsl
    DESTINATION ${PH_DATAROOTDIR}/filesystem-manager
  )
install(
    FILES ${CMAKE_SOURCE_DIR}/filesystem-manager/filesystem-manager.dtd
    DESTINATION ${PH_DATAROOTDIR}/filesystem-manager
  )
install(
    DIRECTORY ${CMAKE_SOURCE_DIR}/filesystem-manager/commands
    DESTINATION ${PH_DATAROOTDIR}/filesystem-manager/commands
  )
install(
    FILES ${CMAKE_SOURCE_DIR}/README.md
    DESTINATION ${PH_DOCSDIR}
  )
