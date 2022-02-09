# frozen_string_literal: true

module Myapp
  class Application
    GIT_COMMIT = `git log --oneline | head -1`.freeze
    VERSION = "0.1.2(#{GIT_COMMIT.split.first})".freeze
  end
end
