#pragma once

#include "common.h"
#include "util.h"

VALUE rb_gl_viewport(VALUE _self, VALUE options);
VALUE rb_gl_swap_buffers(VALUE _self, VALUE window);
VALUE rb_gl_poll_events(VALUE _self);
VALUE rb_gl_clear_color(VALUE _self, VALUE color);
VALUE rb_gl_clear(VALUE _self, VALUE mask);
