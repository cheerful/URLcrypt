Gem::Specification.new do |spec|
  spec.name          = 'urlcrypt'
  spec.version       = "1.0.0"
  spec.authors       = ["Thomas Fuchs"]
  spec.email         = ["thomas@slash7.com"]
  spec.extra_rdoc_files = ["README.md"]

  spec.summary = "Securely encode and decode short pieces of arbitrary binary data in URLs."
  spec.description = "Securely encode and decode short pieces of arbitrary binary data in URLs."
  spec.homepage      = "https://github.com/cheerful/URLcrypt"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cheerful/URLcrypt"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = FileList["Rakefile", "{config,lib,test}/**/*"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.requirements << 'none'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
