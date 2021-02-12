require 'securerandom'
require "language_pack"
require "language_pack/rails5"

class LanguagePack::Rails6 < LanguagePack::Rails5
  # @return [Boolean] true if it's a Rails 6.x app
  def self.use?
    instrument "rails6.use" do
      rails_version = bundler.gem_version('railties')
      return false unless rails_version
      is_rails = rails_version >= Gem::Version.new('6.x') &&
        rails_version < Gem::Version.new('7.0.0')
      return is_rails
    end
  end

  def compile
    instrument "rails6.compile" do
      FileUtils.mkdir_p("tmp/pids")
      super
    end
  end

  private
  def db_prepare_test_rake_tasks
    schema_load    = rake.task("db:schema:load")
    db_migrate     = rake.task("db:migrate")

    return [] if db_migrate.not_defined?
    return [db_migrate] if schema_load.not_defined?

    [schema_load, db_migrate]
  end
end
