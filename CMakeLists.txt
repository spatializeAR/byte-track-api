cmake_minimum_required(VERSION 3.0)

project(bytetrack)

add_definitions(-std=c++11)
add_definitions(-O2 -pthread)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_BUILD_TYPE Release)

include_directories(${PROJECT_SOURCE_DIR}/include)
include_directories(${PROJECT_SOURCE_DIR}/libs/eigen3)
link_directories(${PROJECT_SOURCE_DIR}/include)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Ofast -Wfatal-errors -D_MWAITXINTRIN_H_INCLUDED")

file(GLOB My_Source_Files ${PROJECT_SOURCE_DIR}/src/*.cpp)

# for test
# add_executable(bytetrack ${My_Source_Files})

if(IS_STATIC_LIBRARY)
  add_library(bytetrack STATIC ${My_Source_Files})
else()
  add_library(bytetrack SHARED ${My_Source_Files})
endif()