#pragma once

#include "common.h"

//
// Shaders
//

VALUE rb_compile_vertex_shader(VALUE _self, VALUE shader_source);
VALUE rb_compile_fragment_shader(VALUE _self, VALUE shader_source);
VALUE rb_delete_shader(VALUE _self, VALUE shader);

//
// Shader Programs
//

VALUE rb_create_shader_program(VALUE _self);
VALUE rb_attach_shader_to(VALUE _self, VALUE program, VALUE shader);
VALUE rb_link_shader_program(VALUE _self, VALUE program);
VALUE rb_use_shader_program(VALUE _self, VALUE program);
