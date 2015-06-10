module LearnDoctor
  class HealthCheck
    class StepInstaller
      attr_reader   :step, :title
      attr_accessor :file, :result

      def initialize(step)
        @step = step
        @title = step[:title]
      end

      def execute
        set_file
        run_install_for_step
        print_result
        unlink_file!

        self
      end

      private

      def set_file
        self.file = LearnDoctor::HealthCheck::File.new(step, :install)
      end

      def run_install_for_step
        print "Installing #{title}..."
        self.result = Open3.popen3('bash', file.path)[1].read.strip
      end

      def print_result
        if result.match(/Done/)
          puts 'done'.green
        else
          puts 'error'.red
        end
      end

      def unlink_file!
        file.unlink!
      end
    end
  end
end
