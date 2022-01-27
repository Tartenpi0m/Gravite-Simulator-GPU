cmake_minimum_required (VERSION 3.8)

project("gravity-simulator-gpu")

set (CMAKE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

add_subdirectory ("Calculateur-CPU")
#add_subdirectory("Calculateur-GPU")
add_subdirectory ("model")
add_subdirectory ("utils")
