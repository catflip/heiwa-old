#include "geometry.h"

VALUE rb_geometry_rectangle(VALUE _self, VALUE options)
{
	float x1 = (float)NUM2DBL(rb_hash_aref(options, sym("x1")));
	float y1 = (float)NUM2DBL(rb_hash_aref(options, sym("y1")));
	float x2 = (float)NUM2DBL(rb_hash_aref(options, sym("x2")));
	float y2 = (float)NUM2DBL(rb_hash_aref(options, sym("y2")));

	float verts[] = {
		x2, y1, 0.0f, // top right
		x2, y2, 0.0f, // bottom right
		x1, y2, 0.0f, // bottom left
		x1, y1, 0.0f, // top left
	};

	GLuint indices[] = {
		0, 1, 3,
		1, 2, 3};

	GLuint VBO, VAO, EBO;

	glGenVertexArrays(1, &VAO);
	glGenBuffers(1, &VBO);
	glGenBuffers(1, &EBO);

	glBindVertexArray(VAO);

	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(verts), verts, GL_DYNAMIC_DRAW);

	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_DYNAMIC_DRAW);

	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
	glEnableVertexAttribArray(0);

	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);

	VALUE hash = rb_hash_new();
	rb_hash_aset(hash, sym("vbo"), Data_Wrap_Struct(rb_cObject, 0, NULL, VBO));
	rb_hash_aset(hash, sym("vao"), Data_Wrap_Struct(rb_cObject, 0, NULL, VAO));
	rb_hash_aset(hash, sym("ebo"), Data_Wrap_Struct(rb_cObject, 0, NULL, EBO));

	return hash;
}
