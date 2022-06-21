/// @file test/gtest/torch/torch.cpp
/// @author DeqiTang
/// Mail: deqitang@gmail.com 
/// Created Time: Sun 27 Mar 2022 08:19:48 PM CST

#include <gtest/gtest.h>
#include <torch/torch.h>

TEST(torch, simple) {
    auto tensor = torch::ones({3, 3});
    EXPECT_EQ(tensor[0][0].item<int>(), 1);
}
