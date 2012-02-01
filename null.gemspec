Gem::Specification.new do |s|
  s.name        = 'null'
  s.version     = '0.1'
  s.author      = 'katmagic'
  s.email       = 'the.magical.kat@gmail.com'
  s.homepage    = 'https://github.com/katmagic/null'
  s.summary     = 'null is a Null Object.'
  s.description = 'null is null.'

  s.files = ['lib/null.rb']
  s.test_files = ['test/null.rb']

	if ENV['GEM_SIG_KEY']
		s.signing_key = ENV['GEM_SIG_KEY']
		s.cert_chain = ENV['GEM_CERT_CHAIN'].split(",") if ENV['GEM_CERT_CHAIN']
	else
		warn "environment variable $GEM_SIG_KEY unspecified; not signing gem"
	end
end
