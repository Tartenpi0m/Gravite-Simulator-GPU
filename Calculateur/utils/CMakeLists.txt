cmake_minimum_required (VERSION 3.8)

project("gravity-simulator-gpu")

add_executable(utils "to_json.c" "to_json.h")

target_include_directories(utils PUBLIC ${CMAKE_SOURCE_DIR}/model)
