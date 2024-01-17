require 'mkmf'

have_header 'ruby.h' or missing 'ruby.h'

# Compile with GLFW
$LDFLAGS << ' -lGL -lglfw'

create_makefile 'heiwa/architect'
