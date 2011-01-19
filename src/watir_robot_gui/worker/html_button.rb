module WatirRobotGui

  module Worker

    class HtmlButton < javax.swing.SwingWorker
      attr_accessor :status_bar, :target_file

      def doInBackground
        self.status_bar.text = "Opening browser to view HTML results..."
        
        if Desktop.is_desktop_supported?
          d = Desktop.get_desktop
          if d.is_supported? Desktop::Action::OPEN
            begin
              name = self.target_file.gsub('\\', '/')
              fh = java.io.File.new(name)
              d.open(fh)
            rescue java.io.IOException => e
              puts "An error occurred. Make sure the file type you are trying to open has a default program associated with it on your operating system. #{e}"
            end
          end
        end
      end
    end
  end
end