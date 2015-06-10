require 'learn_doctor/health_check/file'
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
      install_failures!
    end

    private

    def get_setup_step_list!
      puts 'Getting latest environment environment setup data from Learn...'
      self.setup_step_list = client.environment_setup_list
    end

    def run_checks!
      setup_step_list.steps.each do |key, step|
        step_check = LearnDoctor::HealthCheck::StepChecker.new(step).execute

        case step_check.result
        when 1
          self.passed_steps << step
        when 0
          self.failed_steps << step
        end
      end
    end

    def install_failures!
      if failed_steps.any?
        response = prompt_to_fix

        if response
          run_installations!
      #   if user says yes -> run appropriate install commands
      #     rerun checks and output
      #       all passes? -> exit
      #       failures? -> give user support@learn.co email address
      #
        else
          exit
        end
      end
    end

    def prompt_to_fix
      failed_checks = failed_steps.map{|s| s[:title] }.join(', ')

      puts "It looks like the following things aren't configured correctly: #{failed_checks}"
      print "Automatically try to fix? [yN]: "

      response = gets.chomp.downcase

      ['yes', 'y'].include?(response) ? true : false
    end

    def run_installations!
      failed_steps.each do |step|
        step_install = LearnDoctor::HealthCheck::StepInstaller.new(step).execute
      end
    end
  end
end
