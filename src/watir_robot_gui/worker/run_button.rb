module WatirRobotGui

  module Worker

    class RunButton < javax.swing.SwingWorker
      attr_accessor :button, :original_text, :test_path

      def doInBackground
        self.original_text = self.button.text
        self.button.text = "Tests Running"
        self.button.set_enabled(false)

        # Don't know if/how we can start RF tests via a class,
        # so for now we're just running it command-line style
        rf_jar = '/lib/java/robotframework.jar'
        # @TODO get some kind of logging in place
        results = IO.popen("java -jar #{rf_jar} -T -d #{self.test_path} #{self.test_path}")
      end

      def done
        self.button.text = self.original_text
        self.button.set_enabled(true)
      end
    end

  end
end