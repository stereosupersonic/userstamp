module Ddb
  module Userstamp
    class Railtie < Rails::Railtie

      initializer "userstamp.model_extensions" do
        ActiveRecord::Base.send(:include, Ddb::Userstamp::Stamper)
        ActiveRecord::Base.send(:include, Ddb::Userstamp::Stampable)
      end

      initializer "userstamp.load_migrations_helper" do
        ActiveRecord::Migration.send(:include, Ddb::Userstamp::MigrationHelper)
      end

      initializer "userstamp.contoller_extensions"  do |app|
        ActionController::Base.send(:include, Ddb::Controller)
      end

    end
  end
end
