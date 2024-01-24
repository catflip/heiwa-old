module SolidShader
  def self.shader
    return @shader unless @shader.nil?

    @shader = Shader.new(vertex_shader: :solid, fragment_shader: :solid)
  end
end
