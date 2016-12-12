# When this gem is vendored and referenced by :path in the Gemfile, this module can be used to ensure that the 
# correct version of the native extension is built and installed, as well as checking that the version of OpenCV that
# ruby-opencv has been built against matches the expected version
# 
# e.g. in a rails application, with the gem vendored in vendor/gems/ruby-opencv, add this to application.rb:
#
#   require_relative '../vendor/gems/ruby-opencv/bootstrapper'
#   RubyOpenCVBootstrapper.bootstrap('2.4.10')
#
# make sure to add these lines before the Bundler.require line that will (presumably) require ruby-opencv, but after
# boot.rb is required (so bundler/setup has been required by the time these lines are executed).
#
# You can also use check_opencv_version to check that the version of opencv is what you expect it to be:
#
#   RubyOpenCVBootstrapper.check_opencv_version('2.4.10')
# 
module RubyOpenCVBootstrapper
  extend self
  
  def bootstrap(expected_opencv_version)
    gem_spec = Gem::Specification.find_by_name 'bonanza-ruby-opencv'
    
    library_path = File.join(gem_spec.extension_dir, library_filename)
    if !File.exists?(library_path)
      puts "=> #{ library_filename } doesn't exist; building"
      build(gem_spec, expected_opencv_version)
    else
      source_files = gem_spec.extensions + gem_spec.files.grep(/\.(cpp|c|h)\Z/)
      source_files.map! { |source_file| File.join(gem_spec.gem_dir, source_file) }
      
      unless FileUtils.uptodate?(library_path, source_files)
        puts "=> #{ library_filename } out of date; building"
        build(gem_spec, expected_opencv_version)
      end
    end
  end


  def check_opencv_version(expected_opencv_version, error: false)
    opencv_core_lib = File.realpath(opencv_core_library_path)

    actual_version = opencv_core_lib[/libopencv_core(?:\.so)?\.([\d\.]+)(?:$|\.dylib$)/, 1]

    return if opencv_core_lib =~ /#{ Regexp.escape expected_opencv_version }/

    puts "#{ error ? 'ERROR' : 'WARNING' }: Installed opencv version is #{ actual_version }, not #{ expected_opencv_version }"
    exit(1) if error
  end
  
  private
  
  def build(gem_spec, expected_opencv_version, debug: false)
    # Make sure we're building against the correct OpenCV version
    check_opencv_version(expected_opencv_version)

    # Copied from Gem::Specification#build_extensions, with all the conditions that prevent the extension from being
    # built removed
    begin
      # We need to require things in $LOAD_PATH without looking for the
      # extension we are about to build.
      unresolved_deps = Gem::Specification.unresolved_deps.dup
      Gem::Specification.unresolved_deps.clear

      require 'rubygems/config_file'
      require 'rubygems/ext'
      require 'rubygems/user_interaction'

      Gem::DefaultUserInteraction.use_ui Gem::ConsoleUI.new do
        build_args = gem_spec.build_args
        build_args << '--enable-debug' if debug

        builder = Gem::Ext::Builder.new gem_spec, build_args
        builder.build_extensions
      end
    ensure
      Gem::Specification.unresolved_deps.replace unresolved_deps
    end
    
    puts "=> Copying #{ library_filename } to #{ gem_spec.extension_dir }"
    `cp #{ gem_spec.gem_dir }/lib/#{ library_filename } #{ gem_spec.extension_dir }/#{ library_filename }`
  end
  
  def library_filename
    if RUBY_PLATFORM =~ /darwin|mac os/
      'opencv.bundle'
    else
      'opencv.so'
    end
  end
  
  def opencv_core_library_path
    extension = if RUBY_PLATFORM =~ /darwin|mac os/
      'dylib'
    else
      'so'
    end

    "/usr/local/lib/libopencv_core.#{ extension }"
  end
end