#pragma once

#include "common.h"
#include "util.h"

// Creates a GLFW window.
VALUE rb_create_window(VALUE self, VALUE options);

// Set the current GL context.
VALUE rb_gl_make_context_current(VALUE _self, VALUE window);
