#pragma once

#include "common.h"

// Creates a Ruby symbol from a string.
VALUE sym(const char *symbol);

// Returns a Ruby window ID from a GLFWwindow pointer.
// A user pointer must be set for the window.
VALUE window_id(GLFWwindow *window);
