$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
# Add local gem repository created from extracted
# JAR archive of gems
ENV['GEM_PATH'] = File.join(File.expand_path(File.dirname(__FILE__)), '../lib/ruby/wr-gems')

require 'java'
require 'watir_robot_gui/main_frame'
require 'watir_robot_gui/worker/edit_button'
require 'watir_robot_gui/worker/remote_server'
require 'watir_robot_gui/worker/run_button'
require 'watir_robot_gui/worker/html_button'
require 'watir_robot_gui/worker/xml_button'
require 'lib/java/miglayout'

require 'rubygems'
require 'robot_remote_server'
require 'watir_robot'

java_import 'javax.swing.BorderFactory'
java_import 'javax.swing.border.TitledBorder'
java_import 'javax.swing.JButton'
java_import 'javax.swing.JFileChooser'
java_import 'javax.swing.JFrame'
java_import 'javax.swing.JLabel'
java_import 'javax.swing.JPanel'
java_import 'javax.swing.JSeparator'
java_import 'javax.swing.JTextField'
java_import 'javax.swing.UIManager'
java_import 'net.miginfocom.swing.MigLayout'

# Run the GUI
f = WatirRobotGui::MainFrame.new
# @TODO: Add yardoc_options hash as well
yardoc_cache = File.join(File.expand_path(File.dirname(__FILE__)), '../lib/ruby/watir_robot_yardoc')
yardoc_options = [[:docstring, ''], [:file, 'File'], [:source, 'Source Code']]
f.run_remote_server('localhost', 8270, yardoc_cache, yardoc_options)
f.set_size(280, 280)
f.pack
f.visible = true