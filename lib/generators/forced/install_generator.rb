# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'

module Forced
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    MYSQL_ADAPTERS = [
      "ActiveRecord::ConnectionAdapters::MysqlAdapter",
      "ActiveRecord::ConnectionAdapters::Mysql2Adapter"
    ].freeze

    source_root File.expand_path('templates', __dir__)

    desc "Generates (but does not run) a migration to add a forced_app_versions table."

    def create_migration_file
      add_paper_trail_migration('create_forced_app_versions')
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def add_paper_trail_migration(template)
      migration_dir = File.expand_path('db/migrate')

      if self.class.migration_exists?(migration_dir, template)
        ::Kernel.warn "Migration already exists: #{template}"
      else
        migration_template(
          "#{template}.rb.erb",
          "db/migrate/#{template}.rb",
          migration_version: migration_version,
          forced_app_versions_table_options: forced_app_versions_table_options
        )
      end
    end

    private

    def migration_version
      major = ActiveRecord::VERSION::MAJOR
      if major >= 5
        "[#{major}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end

    def mysql?
      MYSQL_ADAPTERS.include?(ActiveRecord::Base.connection.class.name)
    end

    def forced_app_versions_table_options
      if mysql?
        ', { options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci" }'
      else
        ""
      end
    end
  end
end