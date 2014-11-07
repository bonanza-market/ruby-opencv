# This script will install the native extension locally in a bundler-compatible way
# without one having to check in -> push -> bundle update constantly.
#
# When you run this, it will compile the extension, then copy the result it into the lib directory
# like a good gem.
#
# The only other thing you need to do is manually declare this gem to be the gem's local directory
# in the Gemfile of your Rails project.

target_gemset_name = 'bonz-imagetools'

require 'ruby-debug'
require 'rubygems'

puts 'Building extconf...'
build_dir = './ext/opencv'
system("cd #{ build_dir } && ruby extconf.rb")

# Co-opting builder.rb from bundler
dest_path = ::File.expand_path('lib/',  File.dirname(__FILE__))
makefile_contents = File.read("#{ build_dir }/Makefile")
makefile_contents = makefile_contents.gsub(/^RUBYARCHDIR\s*=\s*\$[^$]*/, "RUBYARCHDIR = #{ dest_path }")
makefile_contents = makefile_contents.gsub(/^RUBYLIBDIR\s*=\s*\$[^$]*/, "RUBYLIBDIR = #{ dest_path }")
File.write("#{ build_dir }/Makefile", makefile_contents, mode: 'wb')

success = system("cd #{ build_dir } && make")
if success
  if system("cd #{ build_dir } && make install")
    puts 'Build seems legit.'
  else
    puts 'Make install returned a non-zero errorcode.'
  end
else
  puts 'Error running makefile. See above.'
end

# Copy dynamic library to target RVM gemset
target_gemset_path = ENV['GEM_HOME'].gsub(/@ruby\-opencv/, "@#{ target_gemset_name }")
gem_spec = Gem::Specification.load('ruby-opencv.gemspec')
copy_to = "#{ target_gemset_path }/bundler/gems/extensions/#{ ENV['_system_arch'].downcase }-#{ ENV['_system_type'].downcase }/2.0.0/#{ gem_spec.name }-#{ gem_spec.version }"
copy_command = "cp #{ build_dir }/opencv.so #{ copy_to }"
puts "Copying opencv.so: '#{ copy_command }'"
system(copy_command)