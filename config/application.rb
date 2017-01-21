require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scharwerk
  # add top-level class documentation
  class Application < Rails::Application
    # Settings in config/environments/* take precedence
    # over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make
    # Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    # Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations
    # from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path +=
    # Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :uk

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Path to git repository with text and tex files
    config.x.data.git_path = Rails.root.join('db', 'git')

    # Fonder in repo
    config.x.data.text_folder = 'text'

    # Path to scanned images etc.
    config.x.data.files_path = Rails.root.join('public', 'files')

    # Folder in files
    config.x.data.images_folder = 'images'

    # Path to scanned images etc.
    config.x.data.images_url = '/files/images/'
  end
end
