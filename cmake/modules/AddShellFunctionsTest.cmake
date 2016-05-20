#
# Helper function to add OnixS shell functions tests
#

set(_ASFT_BASE_DIR "${CMAKE_CURRENT_LIST_DIR}")

function(add_shell_functions_test)
    set(_options)
    set(_one_value_args NAME PASS_REGULAR_EXPRESSION)
    set(_multi_value_args AUX_FILES_TO_RENDER)
    cmake_parse_arguments(_add_shell_functions_test "${_options}" "${_one_value_args}" "${_multi_value_args}" ${ARGN})

    if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${_add_shell_functions_test_NAME}/run_test.sh")
        if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${_add_shell_functions_test_NAME}/run_test.sh.in")
            message(FATAL_ERROR "No shell script to test found in ${CMAKE_CURRENT_SOURCE_DIR}/${_add_shell_functions_test_NAME}")
        else()
            configure_file(
                "${CMAKE_CURRENT_SOURCE_DIR}/${_add_shell_functions_test_NAME}/run_test.sh.in"
                "${CMAKE_CURRENT_BINARY_DIR}/${_add_shell_functions_test_NAME}/run_test.sh"
                @ONLY
              )
            set(_add_shell_functions_test_RUN_TEST_SH "${CMAKE_CURRENT_BINARY_DIR}/${_add_shell_functions_test_NAME}/run_test.sh")
        endif()
    else()
        set(_add_shell_functions_test_RUN_TEST_SH "${CMAKE_CURRENT_SOURCE_DIR}/${_add_shell_functions_test_NAME}/run_test.sh")
    endif()

    configure_file(
        "${_ASFT_BASE_DIR}/run_shell_test.cmake.in"
        "${_add_shell_functions_test_NAME}/run_shell_test.cmake"
        @ONLY
      )

    # Render aux files needed by test
    foreach(_f ${_add_shell_functions_test_AUX_FILES_TO_RENDER})
        get_filename_component(_name "${_f}" NAME)
        string(REGEX REPLACE ".in$" "" _new_name "${_name}")
        configure_file(
            "${CMAKE_CURRENT_SOURCE_DIR}/${_add_shell_functions_test_NAME}/${_f}"
            "${CMAKE_CURRENT_BINARY_DIR}/${_add_shell_functions_test_NAME}/${_new_name}"
            @ONLY
          )
    endforeach()

    add_test(
        NAME "${_add_shell_functions_test_NAME}"
        COMMAND "${CMAKE_COMMAND}" -P run_shell_test.cmake
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${_add_shell_functions_test_NAME}"
      )

    if(_add_shell_functions_test_PASS_REGULAR_EXPRESSION)
        set_property(
            TEST "${_add_shell_functions_test_NAME}"
            PROPERTY PASS_REGULAR_EXPRESSION "${_add_shell_functions_test_PASS_REGULAR_EXPRESSION}"
          )
    endif()
endfunction()
