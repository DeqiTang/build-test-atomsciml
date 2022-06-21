find_package(GTest REQUIRED)

file(GLOB ATOMSCIML_TEST_SOURCES
    "utils/*.cpp"
    "torch/*.cpp"
)

add_executable(atomsciml-unit-test.x
    "main.cpp"
    ${ATOMSCIML_TEST_SOURCES}
)
target_link_libraries(atomsciml-unit-test.x
    atomsciml
    GTest::gtest
    GTest::gtest_main
)

install(
    TARGETS atomsciml-unit-test.x
    RUNTIME DESTINATION bin
)
