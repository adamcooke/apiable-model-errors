Gem::Specification.new do |s|
  s.name        = "apiable_model_errors"
  s.version     = Moonrope::VERSION
  s.authors     = ["Adam Cooke"]
  s.email       = ["adam@atechmedia.com"]
  s.homepage    = "http://adamcooke.io"
  s.licenses    = ['MIT']
  s.summary     = "Provide ActiveModel errors in an format suitable for API consumers"
  s.description = "Avoid sending plain text messages to API consumers by sending them more detailed information about validation errors."
  s.files = Dir["**/*"]
  s.add_dependency "active_model", ">= 4.0", "< 5.0"
end
