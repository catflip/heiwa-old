#pragma once

#include "common.h"
#include "util.h"

VALUE rb_gl_viewport(VALUE _self, VALUE options);
VALUE rb_gl_swap_buffers(VALUE _self, VALUE window);
VALUE rb_gl_poll_events(VALUE _self);
VALUE rb_gl_clear_color(VALUE _self, VALUE color);
VALUE rb_gl_clear(VALUE _self, VALUE mask);
VALUE rb_gl_bind_vertex_array(VALUE _self, VALUE vao_obj);
VALUE rb_gl_draw_arrays(VALUE _self, VALUE mode_sym, VALUE first, VALUE count);
VALUE rb_gl_draw_elements(VALUE _self, VALUE mode_sym, VALUE count, VALUE type, VALUE indices_obj);
VALUE rb_gl_enable(VALUE _self, VALUE feature);
VALUE rb_gl_disable(VALUE _self, VALUE feature);
VALUE rb_gl_blendfunc(VALUE _self, VALUE sfactor, VALUE dfactor);
