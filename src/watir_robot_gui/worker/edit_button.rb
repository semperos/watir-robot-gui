module WatirRobotGui

  module Worker

    class EditButton < javax.swing.SwingWorker
      attr_accessor :button, :original_text
      
      def doInBackground
        # @TODO get some kind of logging in place
        IO.popen("ride.py")
      end

    end

  end
end