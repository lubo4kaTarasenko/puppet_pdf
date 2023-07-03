require 'shellwords'

module Utils
  module YarnWrapper
    def run_yarn(command, *args)
      sh_command = <<~SH
        cd #{gem_path} && yarn #{Shellwords.escape(command)} #{prepare_args(args)}
      SH
      Rails.logger.info("YARN: sh_command: #{sh_command}") if defined?(Rails)
      result = system(sh_command)
      Rails.logger.info("YARN: result: #{result}") if defined?(Rails)
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
