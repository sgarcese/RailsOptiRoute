Rails.application.config.generators do |g|
  g.test_framework = :rspec
  g.stylesheets    = false
  g.javascripts    = false
  g.fixture_replacement :factory_girl
end