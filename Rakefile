require 'rake/testtask'
require 'rake/extensiontask'

Rake::ExtensionTask.new 'architect' do |ext|
  ext.lib_dir = 'lib/architect'
  ext.config_script = ENV['ARCHITECT_CONFIG_SCRIPT'] || 'extconf.rb'
end

task default: :compile
