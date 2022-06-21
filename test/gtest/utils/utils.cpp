/// @file test/gtest/utils/utils.cpp
/// @author DeqiTang
/// Mail: deqitang@gmail.com 
/// Created Time: Sun 27 Mar 2022 08:08:54 PM CST

#include <gtest/gtest.h>

#include "atomsciml/utils.h"

TEST(utils, version) {
    EXPECT_EQ(atomsciml::version(), "0.0.0");
}