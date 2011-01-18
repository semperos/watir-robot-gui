require 'fileutils'
require 'net/http'
require 'uri'
require 'zip/zip'

REMOTE_JRUBY_JAR = "http://jruby.org.s3.amazonaws.com/downloads/1.5.6/jruby-complete-1.5.6.jar"
REMOTE_RF_JAR = "http://robotframework.googlecode.com/files/robotframework-2.5.5.jar"
REMOTE_MIGLAYOUT_JAR = "http://www.migcalendar.com/miglayout/versions/3.7.3.1/miglayout-3.7.3.1-swing.jar"

PROJECT_HOME = File.expand_path(File.dirname(__FILE__))
LIB_DIR = File.join(PROJECT_HOME, 'lib')
SRC_DIR = File.join(PROJECT_HOME, 'src')
SUBMODULE_DIR = File.join(PROJECT_HOME, 'submodules')
RESOURCE_DIR = File.join(PROJECT_HOME, 'resources')
JAVA_JAR_DIR = File.join(PROJECT_HOME, 'lib/java')
STANDALONE_JAR_DIR = File.join(PROJECT_HOME, 'lib/standalone')
RUBY_DEP_DIR = File.join(PROJECT_HOME, 'lib/ruby')
YARDOC_CACHE = File.join(RUBY_DEP_DIR, 'watir_robot_yardoc')

PACKAGE_DIR = File.join(PROJECT_HOME, 'package')
WIN_PACKAGE_DIR = File.join(PACKAGE_DIR, 'windows')
OSX_PACKAGE_DIR = File.join(PACKAGE_DIR, 'osx')
LINUX_PACKAGE_DIR = File.join(PACKAGE_DIR, 'linux')

namespace :clean do
  desc "Clean everything"
  task :all do
    Rake::Task['clean:jars'].invoke
    Rake::Task['clean:yardoc'].invoke
    Rake::Task['clean:zip'].invoke
  end

  desc "Clean out dependency jars"
  task :jars do
    Dir.glob(File.join(JAVA_JAR_DIR, '*.jar')).each do |f|
      FileUtils.rm(f)
    end
	Dir.glob(File.join(STANDALONE_JAR_DIR, '*.jar')).each do |f|
      FileUtils.rm(f)
	end
  end

  desc "Delete yardoc cache from resources folder"
  task :yardoc do
    FileUtils.rm_rf(YARDOC_CACHE) if File.exists?(YARDOC_CACHE)
  end

  desc "Delete generated zip files"
  task :zips do
    Dir.glob(File.join(PACKAGE_DIR, '**/*.zip')).each do |f|
      FileUtils.rm(f)
    end
  end
end

namespace :package do

  desc "Build packages for all platforms"
  task :all do
    puts "Setting up package directories..."
    Rake::Task['package:setup:common'].invoke
    puts "Building Windows distribution..."
    Rake::Task['package:setup:windows'].invoke
    puts "Building Mac OSX distribution..."
    Rake::Task['package:setup:osx'].invoke
    puts "Building Linux distribution..."
    Rake::Task['package:setup:linux'].invoke

    puts "Zipping up packages..."
    FileUtils.cd(PACKAGE_DIR)
    ['windows', 'osx', 'linux'].each do |platform|
      temp_dir = "watir-robot-gui-#{platform}"
      zip_file = "watir-robot-gui-#{platform}.zip"

      # Rename folder so zip is platform-dependent
      FileUtils.mv(platform, temp_dir)
      Zip::ZipFile.open(zip_file, true) do |zf|
        Dir.glob("#{temp_dir}/**/*").each do |f|
          zf.add(f, f)
        end
      end
      # Rename folder back to original
      FileUtils.mv(temp_dir, platform)
    end
    puts "Build complete."
  end

  namespace :setup do
    desc "Setup common to all packages"
    task :common do
      # Clean and create directories
      FileUtils.rm_rf(PACKAGE_DIR) if File.exists? PACKAGE_DIR
      [WIN_PACKAGE_DIR, OSX_PACKAGE_DIR, LINUX_PACKAGE_DIR].each do |d|
        FileUtils.mkdir_p(d) unless File.exists? d
        FileUtils.mkdir_p(File.join(d, 'resources'))

        # Copy over component parts
        FileUtils.cp_r(SRC_DIR, d)
        FileUtils.cp_r(LIB_DIR, d)
      end
    end

    desc "Package Windows version of Watir Robot GUI"
    task :windows do
      # Start batch file
      FileUtils.cp(File.join(RESOURCE_DIR, 'windows/start.bat'), WIN_PACKAGE_DIR)

        # Setup batch file
      FileUtils.cp(File.join(RESOURCE_DIR, 'windows/setup.bat'), WIN_PACKAGE_DIR)
      FileUtils.cp(File.join(RESOURCE_DIR, 'windows/create_shortcuts.vbs'), File.join(WIN_PACKAGE_DIR, 'resources'))

      # Windows-format icon
      FileUtils.cp(File.join(RESOURCE_DIR, 'windows/watir_robot_gui.ico'), File.join(WIN_PACKAGE_DIR, 'resources/watir_robot_gui.ico'))
    end

    desc "Package Mac OSX version of Watir Robot GUI"
    task :osx do
      # Start shell file
      FileUtils.cp(File.join(RESOURCE_DIR, 'linux/start.sh'), OSX_PACKAGE_DIR)
        # Setup shell file
      FileUtils.cp(File.join(RESOURCE_DIR, 'linux/setup.sh'), OSX_PACKAGE_DIR)

      # Mac-format icon
      FileUtils.cp(File.join(RESOURCE_DIR, 'osx/watir_robot_gui.icns'), File.join(OSX_PACKAGE_DIR, 'resources/watir_robot_gui.icns'))
    end

    desc "Package Linux version of Watir Robot GUI"
    task :linux do
      # Start shell file
      FileUtils.cp(File.join(RESOURCE_DIR, 'linux/start.sh'), LINUX_PACKAGE_DIR)
      # Setup shell file
      FileUtils.cp(File.join(RESOURCE_DIR, 'linux/setup.sh'), LINUX_PACKAGE_DIR)

      # PNG-format icon
      FileUtils.cp(File.join(RESOURCE_DIR, 'linux/watir_robot_gui.png'), File.join(LINUX_PACKAGE_DIR, 'resources/watir_robot_gui.png'))
    end
  end
end

namespace :retrieve do
  desc "Pull down all dependencies"
  task :all do
    puts "Retrieving jar dependencies..."
    Rake::Task['retrieve:jars'].invoke
    puts "Retrieving gem dependencies..."
    Rake::Task['retrieve:gem_repo'].invoke
    puts "Retrieving yardoc cache..."
    Rake::Task['retrieve:yardoc'].invoke
    puts "Complete. All dependencies are satisfied."
  end

  desc "Create local repo of gems and package in jar file"
  task :gem_repo do
    # we'll use jruby-complete to run everything, so ensure it's there
    Rake::Task['retrieve:jruby_complete'].invoke

    FileUtils.mkdir_p RUBY_DEP_DIR unless File.exists?(RUBY_DEP_DIR)
    FileUtils.cd LIB_DIR
    FileUtils.mkdir 'wr-gems' unless File.exists?('wr-gems')
    system("java -jar standalone/jruby-complete.jar -S gem install -i ./wr-gems --no-ri --no-rdoc watir_robot")
    system("jar cf wr-gems.jar -C wr-gems .")
    FileUtils.mv('wr-gems.jar', RUBY_DEP_DIR)
  end

  desc "Retrieve jruby-complete.jar from Github downloads (custom build)"
  task :jruby_complete do
    jruby_jar = File.join(STANDALONE_JAR_DIR, 'jruby-complete.jar')
    unless File.exists?(jruby_jar)
      uri = URI.parse(REMOTE_JRUBY_JAR)
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Get.new(uri.request_uri)
      resp = http.request(req)

      open(jruby_jar, 'wb') do |file|
        file.write(resp.body)
      end
    end
  end

  desc "Retrieve Robot Framework from Google Code"
  task :robotframework do
    robotframework_jar = File.join(STANDALONE_JAR_DIR, 'robotframework.jar')
    unless File.exists?(robotframework_jar)
      uri = URI.parse(REMOTE_RF_JAR)
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Get.new(uri.request_uri)
      resp = http.request(req)

      open(robotframework_jar, 'wb') do |file|
        file.write(resp.body)
      end
    end

  end

  desc "Retrieve MigLayout from its home site"
  task :miglayout do
    miglayout_jar = File.join(JAVA_JAR_DIR, 'miglayout.jar')
    unless File.exists?(miglayout_jar)
      uri = URI.parse(REMOTE_MIGLAYOUT_JAR)
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Get.new(uri.request_uri)
      resp = http.request(req)

      open(miglayout_jar, 'wb') do |file|
        file.write(resp.body)
      end
    end
  end

  desc "Retrieve jar dependencies from various locations"
  task :jars do
    Rake::Task['clean:jars'].invoke
    FileUtils.mkdir_p(JAVA_JAR_DIR) unless File.exists?(JAVA_JAR_DIR)
    FileUtils.mkdir_p(STANDALONE_JAR_DIR) unless File.exists?(STANDALONE_JAR_DIR)
    
    puts "Please wait, downloading jars. This could take a while..."
    Rake::Task['retrieve:jruby_complete'].invoke
    if File.exists?(File.join(STANDALONE_JAR_DIR, 'jruby-complete.jar'))
      puts "Jar 'jruby-complete.jar' added successfully."
    else
      raise(StandardError, "Jar 'jruby-complete.jar' could not be added.")
    end

    Rake::Task['retrieve:robotframework'].invoke
    if File.exists?(File.join(STANDALONE_JAR_DIR, 'robotframework.jar'))
      puts "Jar 'robotframework.jar' added successfully."
    else
      raise(StandardError, "Jar 'robotframework.jar' could not be added.")
    end

    Rake::Task['retrieve:miglayout'].invoke
    if File.exists?(File.join(JAVA_JAR_DIR, 'miglayout.jar'))
      puts "Jar 'miglayout.jar' added successfully."
    else
      raise(StandardError, "Jar 'miglayout.jar' could not be added.")
    end
  end

  desc "Generate yardoc file from Watir Robot submodule and move into resources folder"
  task :yardoc do
    raise(StandardError, "You must run 'git submodule init' and/or 'git submodule update' to retrieve Watir Robot's code in order to generate the yardoc.") unless
      File.exists?(File.join(SUBMODULE_DIR, 'watir-robot/.git'))

    Rake::Task['clean:yardoc'].invoke
    FileUtils.cd(File.join(SUBMODULE_DIR, 'watir-robot'))
    system("yardoc")
    FileUtils.cd(PROJECT_HOME)
    original_file = File.join(SUBMODULE_DIR, 'watir-robot/.yardoc')
    FileUtils.mv(original_file, YARDOC_CACHE)
  end

end