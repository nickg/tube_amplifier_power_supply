cmake_minimum_required(VERSION 3.15)
project(MyProject)

# Include directories
include_directories(${PROJECT_SOURCE_DIR}/cpp_sources)

# Collect source files
set(SOURCES
    ${PROJECT_SOURCE_DIR}/cpp_sources/modulator.hpp
    ${PROJECT_SOURCE_DIR}/cpp_sources/modulator.cpp
    ${PROJECT_SOURCE_DIR}/qspice_ref_models/dpwm.cpp
)

# Create a shared library (DLL) named 'dpwm'
add_library(dpwm SHARED ${SOURCES})

# Define MYLIB_EXPORTS to manage symbol export and import
target_compile_definitions(dpwm PRIVATE MYLIB_EXPORTS)

# Link the shared library with kernel32.dll
target_link_libraries(dpwm PRIVATE kernel32)

