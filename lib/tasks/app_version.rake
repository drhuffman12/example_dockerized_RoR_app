# frozen_string_literal: true

desc "I am short, but comprehensive description for my cool task"
task :app_version do
  require File.join(Rails.root, "config/initializers/version.rb")

  puts Myapp::Application::VERSION
end
