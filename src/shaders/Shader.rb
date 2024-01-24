class Shader
  attr_reader :program

  # Creates a new shader.
  # @param [Symbol] vertex_shader The name of the vertex shader inside of
  #   the `glsl` directory. The file's name must end with `.vertex.glsl`.
  # @param [Symbol] fragment_shader The name of the fragment shader insode of
  #   the `glsl` directory. The file's name must end with `.fragment.glsl`.
  def initialize(vertex_shader: nil, fragment_shader: nil)
    @program = Architect.create_shader_program

    vertex_shader = process_shader("#{vertex_shader}.vertex.glsl", Architect.method(:compile_vertex_shader))
    fragment_shader = process_shader("#{fragment_shader}.fragment.glsl", Architect.method(:compile_fragment_shader))

    Architect.link_shader_program(@program)
    Architect.delete_shader(vertex_shader) unless vertex_shader.nil?
    Architect.delete_shader(fragment_shader) unless fragment_shader.nil?
  end

  private

  def process_shader(shader, method)
    return if shader.nil?

    path = File.join(__dir__, '..', 'glsl', shader)
    return unless File.exist?(path)

    shader = File.read(path)
    shader = method.call(shader)
    Architect.attach_shader_to(@program, shader)

    shader
  end
end
