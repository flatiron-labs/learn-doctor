require 'learn_doctor/healt_check/file'
require 'learn_doctor/health_check/step_checker'

module LearnDoctor
  class HealthCheck
    attr_reader   :client, :passed_steps, :failed_steps
    attr_accessor :setup_step_list

    def self.diagnose
      new.diagnose
    end

    def initialize
      _login, token = Netrc.read['learn-config']
      @client       = LearnWeb::Client.new(token: token)
      @passed_steps = []
      @failed_steps = []
    end

    def diagnose
      get_setup_step_list!
      run_checks!
      # run checks of all steps (output result at the same time)
      # hold on to failed checks
      # prompt user to try and auto-fix
      #   if user says no -> exit
      #   if user says yes -> run appropriate install commands
      #     rerun checks and output
      #       all passes? -> exit
      #       failures? -> give user support@learn.co email address
      #
    end

    private

    def get_setup_step_list!
      puts 'Getting latest environment environment setup data from Learn...'
      self.setup_step_list = client.environment_setup_list
    end

    def run_checks!
      setup_step_list.each do |step|
        LearnDoctor::HealthCheck::StepChecker.new(step).execute
      end
    end

  end
end
