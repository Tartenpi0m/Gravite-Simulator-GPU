cmake_minimum_required (VERSION 3.8)

project("gravity-simulator-gpu")

add_executable(model "planete.c" "planete.h" "simu.c" "simu.h")

target_include_directories(model PUBLIC ${CMAKE_SOURCE_DIR}/utils)

target_link_libraries(model PUBLIC m)
