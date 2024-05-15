# Create a shared library (DLL) named 'mylib'
add_library(dpwm SHARED dpwm.cpp constants.hpp)

# Define MYLIB_EXPORTS to manage symbol export and import
target_compile_definitions(dpwm PRIVATE MYLIB_EXPORTS)
target_link_libraries(dpwm PRIVATE kernel32)
