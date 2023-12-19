require 'mkmf'

have_header 'ruby.h' or missing 'ruby.h'

# Compile with SDL2
$LDFLAGS << ' -lSDL2'
$LDFLAGS << ' -lSDL2_gfx'

create_makefile 'heiwa/architect'
