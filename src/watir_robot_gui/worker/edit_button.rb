module WatirRobotGui

  module Worker

    class EditButton < javax.swing.SwingWorker
      attr_accessor :status_bar, :editor, :test_path
      
      def doInBackground
        self.status_bar.text = "Opening editor to edit tests..."
        
        if self.editor == 'ride'
          if self.test_path == ''
            IO.popen("ride.py")
          else
            puts self.test_path
            IO.popen("ride.py #{self.test_path}")
          end
        elsif self.editor == 'system default'
          if Desktop.is_desktop_supported?
            d = Desktop.get_desktop
            if d.is_supported? Desktop::Action::OPEN
              begin
                name = self.test_path.gsub('\\', '/')
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
end