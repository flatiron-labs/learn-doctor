module LearnDoctor
  class HealthCheck
    class StepChecker
      attr_reader   :step
      attr_accessor :file

      def initialize(step)
        @step = step
      end

      def execute
        run_check_for_step
        unlink_file!
      end

      private

      def run_check_for_step
        self.file = LearnDoctor::HealthCheck::File.new(step, :check).file
      end

      def unlink_file!
        file.unlink!
      end
    end
  end
end
