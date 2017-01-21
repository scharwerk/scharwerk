# Perform Sidekiq jobs immediately in development.
if Rails.env.development?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
