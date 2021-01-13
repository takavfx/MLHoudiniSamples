cmake_minimum_required( VERSION 3.6 )

project( PyTorchTest )

# CMAKE_PREFIX_PATH must contain the path to the toolkit/cmake subdirectory of
# the Houdini installation. See the "Compiling with CMake" section of the HDK
# documentation for more details, which describes several options for
# specifying this path.
list( APPEND CMAKE_PREFIX_PATH "$ENV{HFS}/toolkit/cmake" )

# Locate Houdini's libraries and header files.
# Registers an imported library target named 'Houdini'.
find_package( Houdini REQUIRED )
find_package( Torch REQUIRED )

set( library_name SOP_PyTorchTest )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}" )

# Code generation for the embedded DS file in SOP_PyTorchTest.C.
houdini_generate_proto_headers( FILES SOP_PyTorchTest.C )

# Add a library and its source files.
add_library( ${library_name} SHARED
SOP_PyTorchTest.C
SOP_PyTorchTest.h
)

# Link against the Houdini libraries, and add required include directories and
# compile definitions.
target_link_libraries( ${library_name} Houdini "${TORCH_LIBRARIES}")

set_property(TARGET ${library_name} PROPERTY CXX_STANDARD 14)

# Include ${CMAKE_CURRENT_BINARY_DIR} for the generated header.
target_include_directories( ${library_name} PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
)

# Sets several common target properties, such as the library's output directory.
houdini_configure_target( ${library_name} )

if (MSVC)
    file(GLOB TORCH_DLLS "${TORCH_INSTALL_PREFIX}/lib/*.dll")
    add_custom_command(TARGET ${library_name}
                        POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -E copy_if_different
                        ${TORCH_DLLS}
                        $<TARGET_FILE_DIR:${library_name}>)
endif (MSVC)