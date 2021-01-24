# Find TensorFlow
#------
# This will define the following variables:
#
#   TENSORFLOW_INCLUDE_DIRS   -- The include directories for tensorflow
#   TENSORFLOW_LIBRARIES        -- Libraries to link against
#   TENSORFLOW_INSTALL_PREFIX -- Path to library root
#
# and the following imported targets:
#
#   tensorflow

if(DEFINED ENV{TENSORFLOW_INSTALL_PREFIX})
    set(TENSORFLOW_INSTALL_PREFIX $ENV{TENSORFLOW_INSTALL_PREFIX})
else()
    get_filename_component(CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
    get_filename_component(TENSORFLOW_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../" ABSOLUTE)
endif()

# Include directories
if(EXISTS "${TENSORFLOW_INSTALL_PREFIX}/include")
    set(TENSORFLOW_INCLUDE_DIRS ${TENSORFLOW_INSTALL_PREFIX}/include)
    message("-- Tensorflow include directries: ${TENSORFLOW_INCLUDE_DIRS}")
endif()

# Library dependencies.
add_library(tensorflow STATIC IMPORTED)
set(TENSORFLOW_LIBRARIES tensorflow)

find_library(TENSORFLOW_LIBRARY tensorflow PATHS "${TENSORFLOW_INSTALL_PREFIX}/lib")
list(APPEND TENSORFLOW_LIBRARIES ${TENSORFLOW_LIBRARY}) # Append TensorFlow lib
message("-- TensorFlow libraries: ${TENSORFLOW_LIBRARIES}")


set_target_properties(tensorflow PROPERTIES
    IMPORTED_LOCATION "${TENSORFLOW_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${TENSORFLOW_INCLUDE_DIRS}"
)