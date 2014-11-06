# This script will install the native extension locally in a bundler-compatible way
# without one having to check in -> push -> bundle update constantly.
#
# When you run this, it will compile the extension, then copy the result it into the lib directory
# like a good gem.
#
# The only other thing you need to do is manually declare this gem to be the gem's local directory
# in the Gemfile of your Rails project.

install_files_in = "ruby-2.0.0-p247@bonz-imagetools"

require 'ruby-debug'
require 'rubygems'

puts "Building extconf..."
build_dir = "./ext/opencv"
system("cd #{build_dir} && #{Gem.ruby} extconf.rb")

# Co-opting builder.rb from bundler
dest_path = ::File.expand_path('lib/',  File.dirname(__FILE__))
mf = File.read("#{build_dir}/Makefile")
mf = mf.gsub(/^RUBYARCHDIR\s*=\s*\$[^$]*/, "RUBYARCHDIR = #{dest_path}")
mf = mf.gsub(/^RUBYLIBDIR\s*=\s*\$[^$]*/, "RUBYLIBDIR = #{dest_path}")

File.open("#{build_dir}/Makefile", 'wb') {|f| f.print mf}
success = system("cd #{build_dir} && make")
if success
  if system("cd #{build_dir} && make install")
    puts "Build seems legit."
  else
    puts "Make install returned a non-zero errorcode."
  end
else
  puts "Error running makefile. See above."
end

if install_files_in

end