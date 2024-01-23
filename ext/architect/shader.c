#include "shader.h"

void compile_shader(GLuint shader, const char *source)
{
	glShaderSource(shader, 1, (const GLchar *const *)&source, NULL);
	glCompileShader(shader);

	int success;
	char infoLog[512];
	glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(shader, 512, NULL, infoLog);
		rb_raise(rb_eStandardError, infoLog);
	}
}

VALUE rb_compile_vertex_shader(VALUE _self, VALUE source)
{
	const char *shader_source = StringValueCStr(source);

	GLuint vertex_shader = glCreateShader(GL_VERTEX_SHADER);
	compile_shader(vertex_shader, shader_source);

	return Data_Wrap_Struct(rb_cObject, 0, NULL, vertex_shader);
}

VALUE rb_compile_fragment_shader(VALUE _self, VALUE source)
{
	const char *shader_source = StringValueCStr(source);

	GLuint fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);
	compile_shader(fragment_shader, shader_source);

	return Data_Wrap_Struct(rb_cObject, 0, NULL, fragment_shader);
}

VALUE rb_delete_shader(VALUE _self, VALUE shader_obj)
{
	GLuint shader;
	Data_Get_Struct(shader_obj, GLuint, shader);
	glDeleteShader(shader);

	return Qnil;
}

VALUE rb_create_shader_program(VALUE _self)
{
	GLuint shader_program = glCreateProgram();
	return Data_Wrap_Struct(rb_cObject, 0, NULL, shader_program);
}

VALUE rb_attach_shader_to(VALUE _self, VALUE program_obj, VALUE shader_obj)
{
	GLuint program;
	GLuint shader;
	Data_Get_Struct(program_obj, GLuint, program);
	Data_Get_Struct(shader_obj, GLuint, shader);

	glAttachShader(program, shader);

	return Qnil;
}

VALUE rb_link_shader_program(VALUE _self, VALUE program_obj)
{
	GLuint program;
	Data_Get_Struct(program_obj, GLuint, program);
	glLinkProgram(program);

	return Qnil;
}

VALUE rb_use_shader_program(VALUE _self, VALUE program_obj)
{
	GLuint program;
	Data_Get_Struct(program_obj, GLuint, program);
	glUseProgram(program);

	return Qnil;
}
