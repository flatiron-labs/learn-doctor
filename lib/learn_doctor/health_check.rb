module LearnDoctor
  class HealthCheck
    attr_reader   :client
    attr_accessor :setup_step_list

    def self.diagnose
      new.diagnose
    end

    def initialize
      _login, token = Netrc.read['learn-config']

      @client = LearnWeb::Client.new(token: token)
    end

    def diagnose
      get_setup_step_list!
      # get step list from learn-web
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
  end
end
