#pragma once

#include <ruby.h>
#include <GLFW/glfw3.h>

#include "util.h"

typedef struct ScreenSize
{
    int width;
    int height;
} ScreenSize;

// Returns a `ScreenSize` struct.
ScreenSize *screen_size(GLFWmonitor *monitor);

// Returns a `ScreenSize` struct via a Hash.
VALUE rb_screen_size(VALUE _self, VALUE monitor);

// Returns a `GLFWmonitor` object.
VALUE rb_gl_primary_monitor(VALUE _self);