module LearnDoctor
  class HealthCheck
    def self.diagnose
      new.diagnose
    end

    def diagnose
      # get step list from learn-web
      # run checks of all steps (output result at the same time)
      # hold on to failed checks
      # prompt user to try and auto-fix
      #   if user says no -> exit
      #   if user says yes -> run appropriate install commands
      #     rerun checks and output
      #       all passes? -> exit
      #       failures? -> give user support@learn.co email address
    end
  end
end
