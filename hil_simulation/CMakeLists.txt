cmake_minimum_required(VERSION 3.15)
project(MyProject)

# Create a shared library (DLL) named 'dpwm'
add_library(dpwm
    SHARED
        cpp_sources/modulator.hpp
        cpp_sources/modulator.cpp
        qspice_ref_models/dpwm.cpp
)
 
# Include directories
target_include_directories(dpwm
    PUBLIC
	cpp_sources
)
# Define MYLIB_EXPORTS to manage symbol export and import
target_compile_definitions(dpwm PRIVATE MYLIB_EXPORTS)

# Link the shared library with kernel32.dll
target_link_libraries(dpwm PRIVATE kernel32)

# ----------------------------------------------------------

cmake_minimum_required(VERSION 3.15)
project(MyProject)

# Create a shared library (DLL) named 'dpwm'
add_library(boost_open_loop
    SHARED
        cpp_sources/modulator.hpp
        cpp_sources/modulator.cpp
        qspice_ref_models/boost_simulation/boost_open_loop.cpp
)
 
# Include directories
target_include_directories(boost_open_loop
    PUBLIC
	cpp_sources
)
# Define MYLIB_EXPORTS to manage symbol export and import
target_compile_definitions(boost_open_loop PRIVATE MYLIB_EXPORTS)

# Link the shared library with kernel32.dll
target_link_libraries(boost_open_loop PRIVATE kernel32)

# ----------------------------------------------------------

cmake_minimum_required(VERSION 3.15)
project(MyProject)

# Create a shared library (DLL) named 'dpwm'
add_library(boost_closed_loop
    SHARED
        cpp_sources/modulator.hpp
        cpp_sources/modulator.cpp
        qspice_ref_models/boost_simulation/boost_closed_loop.cpp
)
 
# Include directories
target_include_directories(boost_closed_loop
    PUBLIC
	cpp_sources
)
# Define MYLIB_EXPORTS to manage symbol export and import
target_compile_definitions(boost_closed_loop PRIVATE MYLIB_EXPORTS)

# Link the shared library with kernel32.dll
target_link_libraries(boost_closed_loop PRIVATE kernel32)
