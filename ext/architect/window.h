#pragma once

#include "event.h"
#include "common.h"
#include "util.h"

// Creates a GLFW window.
VALUE rb_create_window(VALUE self, VALUE options);

// Returns the window size.
VALUE rb_window_size(VALUE _self, VALUE window);

// Set the current GL context.
VALUE rb_gl_make_context_current(VALUE _self, VALUE window);
