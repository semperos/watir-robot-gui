module WatirRobotGui

  module Worker

    class RemoteServer < javax.swing.SwingWorker
      attr_accessor :host, :port, :yardoc_cache

      def doInBackground
        RobotRemoteServer.new(WatirRobot::KeywordLibrary.new,
                              host = self.host,
                              port = self.port,
                              yardoc_file = self.yardoc_cache,
                              yardoc_options = [[:docstring, ''], [:file, 'File'], [:source, 'Source Code']])
      end

    end

  end
end