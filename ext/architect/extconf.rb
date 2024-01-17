require 'mkmf'

have_header 'ruby.h' or missing 'ruby.h'

# Compile with GLFW
$LDFLAGS << ' -lGL'

create_makefile 'heiwa/architect'
