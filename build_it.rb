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
  # e.g., /home/bill/.rvm/rubies/ruby-2.0.0-p247/lib/ruby/gems/2.0.0
  default_gem_dir = Gem.default_dir

  gem_spec = Gem::Specification.load("ruby-opencv.gemspec")

  # TODO: how to derive the 'x86_64-linux/2.0.0' bit?
  # e.g., /home/bill/.rvm/gems/ruby-2.0.0-p247@bonz-imagetools/bundler/gems/extensions/x86_64-linux/2.0.0/ruby-opencv-0.0.13.20140330211753
  build_to = default_gem_dir.sub(/rubies.*/, "gems/#{install_files_in}/bundler/gems/extensions/x86_64-linux/2.0.0/") + "#{gem_spec.name}-#{gem_spec.version}"

  copy_line = "cp #{build_dir}/opencv.so #{build_to}"
  puts "Copying opencv.so: '#{copy_line}'"
  system(copy_line)
end