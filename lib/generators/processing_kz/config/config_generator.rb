module ProcessingKz
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_config
        copy_file 'processing_kz.rb', 'config/initializers/processing_kz.rb'
      end
    end
  end
end