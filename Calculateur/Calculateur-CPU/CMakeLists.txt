cmake_minimum_required (VERSION 3.8)

project("gravity-simulator-gpu")


#file(GLOB_RECURSE SRC_FILES ${CMAKE_SOURCE_DIR}/*.c)
#${SRC_FILES}

add_executable(maincpu "main.c" "${CMAKE_SOURCE_DIR}/model/planete.c" "${CMAKE_SOURCE_DIR}/model/simu.c" "${CMAKE_SOURCE_DIR}/utils/to_json.c")

target_include_directories(maincpu PUBLIC ${CMAKE_SOURCE_DIR}/model)

target_include_directories(maincpu PUBLIC ${CMAKE_SOURCE_DIR}/utils)

target_link_libraries(maincpu PRIVATE m)
