require (File.dirname(__FILE__) + '/opencv/version')

if RUBY_PLATFORM =~ /mingw|mswin/
  major, minor, subminor = RUBY_VERSION.split('.')
  begin
    require "#{major}.#{minor}/opencv.so"
  rescue LoadError
    require 'opencv.so'
  end
else
  require 'opencv.so'
end
