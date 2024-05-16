cmake_minimum_required(VERSION 3.15)
project(MyProject)

# Function to create a shared library
function(create_shared_library lib_name source_files)
    add_library(${lib_name} SHARED ${source_files})
    
    target_include_directories(${lib_name}
        PUBLIC
            cpp_sources
    )

    target_compile_definitions(${lib_name} PRIVATE MYLIB_EXPORTS)
    
    target_link_libraries(${lib_name} PRIVATE kernel32)
endfunction()

# Common source files
set(common_sources
    cpp_sources/modulator.hpp
    cpp_sources/modulator.cpp
)

# Specific source files for each library
set(dpwm_sources
    ${common_sources}
    qspice_ref_models/dpwm.cpp
)

set(boost_open_loop_sources
    ${common_sources}
    qspice_ref_models/boost_simulation/boost_open_loop.cpp
)

set(boost_closed_loop_sources
    ${common_sources}
    qspice_ref_models/boost_simulation/boost_closed_loop.cpp
)

# Create shared libraries
create_shared_library(dpwm "${dpwm_sources}")
create_shared_library(boost_open_loop "${boost_open_loop_sources}")
create_shared_library(boost_closed_loop "${boost_closed_loop_sources}")
