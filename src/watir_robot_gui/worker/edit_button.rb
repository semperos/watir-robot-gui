module WatirRobotGui

  module Worker

    class EditButton < javax.swing.SwingWorker
      attr_accessor :test_path
      
      def doInBackground
        if self.test_path == ''
          IO.popen("ride.py")
        else
          IO.popen("ride.py #{self.test_path}")
        end
      end
    end
  end
end