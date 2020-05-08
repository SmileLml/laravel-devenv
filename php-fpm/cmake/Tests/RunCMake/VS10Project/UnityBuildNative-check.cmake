set(unitybuild_c0 "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/tgt.dir/Unity/unity_0.c")
if(NOT EXISTS "${unitybuild_c0}")
  set(RunCMake_TEST_FAILED "Generated unity source files ${unitybuild_c0} does not exist.")
  return()
endif()

set(tgt_project "${RunCMake_TEST_BINARY_DIR}/tgt.vcxproj")
if (NOT EXISTS "${tgt_project}")
  set(RunCMake_TEST_FAILED "Generated project file ${tgt_project} doesn't exist.")
  return()
endif()

file(STRINGS ${tgt_project} tgt_projects_strings)

foreach(line IN LISTS tgt_projects_strings)
  if (line MATCHES "<EnableUnitySupport>true</EnableUnitySupport>")
    set(have_unity_support ON)
  endif()

  if (line MATCHES "<ClCompile Include=.*IncludeInUnityFile=\"false\" CustomUnityFile=\"true\"")
    set(unity_source_line ${line})
  endif()

  if (line MATCHES "<ClCompile Include=.*IncludeInUnityFile=\"true\" CustomUnityFile=\"true\"")
    list(APPEND sources_list ${line})
  endif()
endforeach()

if (NOT have_unity_support)
  set(RunCMake_TEST_FAILED "Generated project should include the <EnableUnitySupport> block.")
  return()
endif()

string(REPLACE "\\" "/" unity_source_line "${unity_source_line}")
string(FIND "${unity_source_line}" "CMakeFiles/tgt.dir/Unity/unity_0.c" unity_source_file_position)
if (unity_source_file_position EQUAL "-1")
  set(RunCMake_TEST_FAILED "Generated project should include the generated unity source file.")
  return()
endif()

list(LENGTH sources_list number_of_sources)
if(NOT number_of_sources EQUAL 8)
  set(RunCMake_TEST_FAILED "Generated project doesn't include the expect number of files.")
  return()
endif()
