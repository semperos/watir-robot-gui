module WatirRobotGui

  #
  # Main frame of Watir Robot's GUI
  #
  class MainFrame < javax.swing.JFrame
    def initialize
      # Set native look and feel instead of default Metal
      native_lf = UIManager.get_system_look_and_feel_class_name
      begin
        UIManager.set_look_and_feel(native_lf)
      rescue InstantiationException => e
      rescue ClassNotFoundException => e
      rescue UnsupportedLookAndFeelException => e
      rescue IllegalAccessException => e
      end

      # Title the JFrame
      super "Watir Robot Testing Tool"
      self.set_default_close_operation EXIT_ON_CLOSE

      # Overall MigLayout parameters
      layout = MigLayout.new("wrap 2", "[pref!]15[fill,grow]")
      pane = JPanel.new(layout)


      ### File/Directory Buttons ###

      # Definition #
      file_label = JLabel.new "Choose File(s)"
      file_button = JButton.new "Open File"
      dir_button = JButton.new "Open Directory"
      test_path_field = JTextField.new "Enter full path manually or use buttons above..."

      # Action Listeners #
      file_button.add_action_listener do |event|
        chooser = JFileChooser.new
        chooser.set_dialog_title "Choose a File with Robot Framework Tests"
        chooser.set_multi_selection_enabled(false)

        return_val = chooser.show_open_dialog(self)
        if return_val == JFileChooser::APPROVE_OPTION
          test_path_field.text = chooser.selected_file.get_absolute_file.to_s
        end
      end

      dir_button.add_action_listener do |event|
        chooser = JFileChooser.new
        chooser.set_dialog_title "Choose a Directory with Robot Framework Tests"
        chooser.set_file_selection_mode(JFileChooser::DIRECTORIES_ONLY)

        return_val = chooser.show_open_dialog(self)
        if return_val == JFileChooser::APPROVE_OPTION
          test_path_field.text = chooser.selected_file.get_absolute_file.to_s
        end
      end


      ### Action Buttons ###

      # Definition #
      action_label = JLabel.new "Edit/Run Tests"
      edit_button = JButton.new "Edit Tests"

      editor_rbutton_group = ButtonGroup.new
      editor_rbutton_ride = JRadioButton.new("RIDE", true)
      editor_rbutton_ride.set_action_command(:editor_ride)
      editor_rbutton_default = JRadioButton.new("System Default", false)
      editor_rbutton_default.set_action_command(:editor_default)
      editor_buttons = [editor_rbutton_ride, editor_rbutton_default]
      editor_buttons.each { |b| editor_rbutton_group.add b }
      
      run_button = JButton.new "Run Tests"

      # Action Listeners #
      edit_button.add_action_listener do |event|
        editor = nil
        editor_buttons.each { |b| editor = b.text.downcase if b.selected? }
        sw = WatirRobotGui::Worker::EditButton.new
        sw.test_path = test_path_field.text
        sw.editor = editor
        sw.execute
      end

      run_button.add_action_listener do |event|
        sw = WatirRobotGui::Worker::RunButton.new
        sw.button = run_button
        sw.test_path = test_path_field.text
        sw.execute
      end

      ### Results Buttons ###

      # Definition #
      result_label = JLabel.new "View Results"
      html_button = JButton.new "HTML"
      xml_button = JButton.new "XML"
      # We'll enable these after a test has run
      html_button.set_enabled false
      xml_button.set_enabled false


      ### Add elements to pane and finish layout ###

      pane.add(file_label, "split, span")
      pane.add(JSeparator.new, "growx, wrap")
      pane.add(file_button, "sg button")
      pane.add(dir_button, "sg button")
      pane.add(test_path_field, "span,grow, gaptop 8")

      pane.add(action_label, "split, span, gaptop 15")
      pane.add(JSeparator.new, "growx, wrap, gaptop 15")
      pane.add(edit_button, "sg button")
      pane.add(run_button, "sg button")
      pane.add(editor_rbutton_ride, "wrap")
      pane.add(editor_rbutton_default, "wrap")

      pane.add(result_label, "split, span, gaptop 15")
      pane.add(JSeparator.new, "growx, wrap, gaptop 15")
      pane.add(html_button, "sg button")
      pane.add(xml_button, "sg button")

      self.set_content_pane(pane)
    end

    def run_remote_server(host, port, yardoc_cache, yardoc_options)
      # Run Robot Remote Server
      sw_remote_server = WatirRobotGui::Worker::RemoteServer.new
      sw_remote_server.host = host
      sw_remote_server.port = port
      sw_remote_server.yardoc_cache = yardoc_cache
      sw_remote_server.yardoc_options = yardoc_options
      sw_remote_server.execute
    end
  end

end