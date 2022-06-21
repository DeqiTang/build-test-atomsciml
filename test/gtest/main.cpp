/// @file test/gtest/main.cpp
/// @author DeqiTang
/// Mail: deqitang@gmail.com 
/// Created Time: Sun 27 Mar 2022 08:08:45 PM CST

#include <gtest/gtest.h>

int main(int argc, char** argv) {
    ::testing::InitGoogleTest(&argc, argv);

    return RUN_ALL_TESTS();
}
