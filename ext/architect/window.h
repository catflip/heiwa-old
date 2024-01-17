#pragma once

#include <ruby.h>
#include <GLFW/glfw3.h>

#include "util.h"

// Creates a GLFW window.
VALUE create_window(VALUE self, VALUE options);
