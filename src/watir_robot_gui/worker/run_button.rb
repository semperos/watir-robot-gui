module WatirRobotGui

  module Worker

    class RunButton < javax.swing.SwingWorker
      attr_accessor :status_bar, :test_path

      def doInBackground
        self.status_bar.text = "Running tests. Wait until all browsers have closed."
        self.test_path = self.test_path.gsub('\\', '/')
        
        # Ensure the parameter to -d below is a directory
        if File.directory? self.test_path
          output_path = self.test_path
        else
          output_path = File.dirname(self.test_path)
        end

        # Don't know if/how we can start RF tests via a class,
        # so for now we're just running it command-line style
        rf_jar = 'lib/standalone/robotframework.jar'
        # @TODO get some kind of logging in place
        results = IO.popen("java -jar #{rf_jar} -T -d \"#{output_path}\" \"#{self.test_path}\"")
      end
    end
  end
end