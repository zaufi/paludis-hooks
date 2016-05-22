set(FILESYSTEM_MANAGER_DTD "${PROJECT_SOURCE_DIR}/filesystem-manager/filesystem-manager.dtd")
set(FILESYSTEM_MANAGER_XSL "${PROJECT_SOURCE_DIR}/filesystem-manager/filesystem-manager.xsl")
set(FILESYSTEM_CMD_DIR "${PROJECT_SOURCE_DIR}/filesystem-manager/commands")
# TODO Get rid of hardcoded path. Replace w/ stub.
set(PALUDIS_EBUILD_DIR "/etc/init.d/functions.sh")

include(AddFSMTest)

if(DIFF_EXECUTABLE)
    add_fsm_test(matching)
    add_fsm_test(matching-partial)
    add_fsm_test(commands-renderer)
else()
    message(STATUS "WARNING: `diff` was not found. Do not add FSM unit tests...")
endif()

add_shell_functions_test(
    NAME cmd-rm-not-existed-target
    PASS_REGULAR_EXPRESSION "Passed"
  )
add_shell_functions_test(
    NAME cmd-rm-dummy-dir
    PASS_REGULAR_EXPRESSION "removed directory 'dummy'.*Going to leave a warning.*Passed"
  )

add_shell_functions_test(
    NAME cmd-symlink-not-existed-base
    PASS_REGULAR_EXPRESSION "Passed"
  )
add_shell_functions_test(
    NAME cmd-symlink-test-1
    PASS_REGULAR_EXPRESSION "Making the symlink.*Going to leave a warning.*Passed"
  )
add_shell_functions_test(
    NAME cmd-symlink-test-2
    PASS_REGULAR_EXPRESSION "Making the symlink.*Going to leave a warning.*Passed"
  )

add_shell_functions_test(
    NAME cmd-mkdir-test-1
    PASS_REGULAR_EXPRESSION "Passed"
  )
