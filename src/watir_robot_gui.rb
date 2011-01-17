$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'java'
require 'watir_robot_gui/main_frame'
require 'watir_robot_gui/worker/edit_button'
require 'watir_robot_gui/worker/remote_server'
require 'watir_robot_gui/worker/run_button'
require 'watir_robot_gui/worker/html_button'
require 'watir_robot_gui/worker/xml_button'
require 'lib/java/miglayout'
require 'lib/ruby/wr-gems'

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
f.run_remote_server
f.set_size(280, 280)
f.pack
f.visible = true