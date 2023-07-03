require 'shellwords'

module Utils
  module YarnWrapper
    def run_yarn(command, *args)
      sh_command = <<~SH
        export PATH='/home/deployer/.rvm/gems/ruby-3.1.2/bin:/home/deployer/.rvm/gems/ruby-3.1.2@global/bin:/home/deployer/.rvm/rubies/ruby-3.1.2/bin:/home/deployer/.rvm/bin:/home/deployer/.nvm/versions/node/v14.21.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin' &&
        cd #{gem_path} && yarn #{Shellwords.escape(command)} #{prepare_args(args)} > /home/deployer/apps/changesync_dev/current/log/yarn.txt   2> /home/deployer/apps/changesync_dev/current/log/yarn_err.txt  
      SH
      Rails.logger.info("YARN: sh_command: #{sh_command}") if defined?(Rails) && Rails.logger
      result = system(sh_command)
      Rails.logger.info("YARN: result: #{result}") if defined?(Rails) && Rails.logger
      result
    end

    def validate_yarn_installation
      raise 'Yarn not installed!' if which_yarn_output.empty?
    end

    private

    def gem_path
      @gem_path ||=
        Shellwords.escape(Gem.loaded_specs['puppet_pdf'].full_gem_path)
    end

    def which_yarn_output
      `which yarn`
    end

    def prepare_args(args)
      args.map { |arg| Shellwords.escape(arg) }.join(' ')
    end
  end
end
