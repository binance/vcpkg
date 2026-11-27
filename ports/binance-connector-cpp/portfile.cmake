vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO binance/binance-connector-cpp
    REF "v${VERSION}"
    SHA512 c20353316e1788422f7e2cbdd422ed6054457175914b0fe9a51719c01f45eb7c5857b288ea71826ccd14fd757c6bc59d54992ed90a22b3d7648cee7a73421555
    HEAD_REF main
)

# Every feature but "all" is a connector, named like its product with hyphens.
set(products "")
foreach(feature IN LISTS FEATURES)
    if(feature STREQUAL "core" OR feature STREQUAL "all")
        continue()
    endif()
    string(REPLACE "-" "_" product "${feature}")
    list(APPEND products "${product}")
endforeach()
# Commas: a semicolon list would be split into several options on the way to CMake.
list(JOIN products "," BINANCE_PRODUCTS)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DBINANCE_PRODUCTS=${BINANCE_PRODUCTS}"
        -DBINANCE_BUILD_TESTS=OFF
        -DBINANCE_BUILD_EXAMPLES=OFF
        -DBINANCE_BUILD_C_API=OFF
        -DBINANCE_WARNINGS_AS_ERRORS=OFF
        -DBINANCE_LTO=OFF
        -DBINANCE_INSTALL=ON
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME binance-connector-cpp CONFIG_PATH lib/cmake/binance-connector-cpp)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENCE")
