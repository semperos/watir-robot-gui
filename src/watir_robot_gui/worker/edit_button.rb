module WatirRobotGui

  module Worker

    class EditButton < javax.swing.SwingWorker
      attr_accessor :editor, :test_path
      
      def doInBackground
        if self.editor == 'ride'
          if self.test_path == ''
            IO.popen("ride.py")
          else
            IO.popen("ride.py #{self.test_path}")
          end
        elsif self.editor == 'system default'
          # Desktop API here
        end
      end
    end
  end
end