require 'yaml'

begin
  secrets = YAML.load_file(File.expand_path(__dir__ + '/../secrets.yml'))
  ENV['WIKI_USERNAME'] = secrets['WIKI_USERNAME']
  ENV['WIKI_PASSWORD'] = secrets['WIKI_PASSWORD']
rescue Errno::ENOENT
  abort "Please run 'cp secrets.yml-example secrets.yml' and then fill out secrets.yml"
end
