module Ddb
  module Userstamp
    class Railtie < Rails::Railtie

      initializer "userstamp.load_migrations_helper" do
        ActiveRecord::Migration.include(Ddb::Userstamp::MigrationHelper)
      end

      initializer "userstamp.contoller_extensions" do
        ActionController::Base.send(:include, Ddb::Controller)
      end

      initializer "userstamp.model_extensions" do
        ActiveRecord::Base.send(:include, Ddb::Userstamp::Stamper)
        ActiveRecord::Base.send(:include, Ddb::Userstamp::Stampable)
      end
    end
  end
end