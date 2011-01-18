module WatirRobotGui

  module Worker

    class XmlButton < javax.swing.SwingWorker

      def doInBackground
#        if Desktop.is_desktop_supported?
#          d = Desktop.get_desktop
#          if d.is_supported? Desktop::Action::OPEN
#            begin
#              name = self.test_path.gsub('\\', '/')
#              puts name
#              fh = java.io.File.new(name)
#              d.open(fh)
#            rescue java.io.IOException => e
#              puts "An error occurred. Make sure the file type you are trying to open has a default program associated with it on your operating system. #{e}"
#            end
#          end
#        end
      end
    end
  end
end