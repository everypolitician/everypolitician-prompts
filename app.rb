require 'bundler/setup'
require 'yaml'

begin
  secrets = YAML.load_file('secrets.yml')
  ENV['WIKI_USERNAME'] = secrets['WIKI_USERNAME']
  ENV['WIKI_PASSWORD'] = secrets['WIKI_PASSWORD']
rescue Errno::ENOENT
  abort "Please run 'cp secrets.yml-example secrets.yml' and then fill out secrets.yml"
end

require 'compare_with_wikidata'
require 'sinatra'

get '/' do
  redirect to('/prompter')
end

get '/prompter/?' do
  mediawiki_site = params[:mediawiki_site]
  page_title = params[:page_title]

  halt "Please provide ?mediawiki_site and ?page_title GET parameters" unless mediawiki_site && page_title

  diff_output_generator = CompareWithWikidata::DiffOutputGenerator.new(
    mediawiki_site: mediawiki_site,
    page_title: page_title,
    header_template: params[:header_template],
    footer_template: params[:footer_template],
    row_added_template: params[:row_added_template],
    row_removed_template: params[:row_removed_template],
    row_modified_template: params[:row_modified_template]
  )

  begin
    diff_output_generator.run!
  rescue MediawikiApi::LoginError
    halt "Please set WIKI_USERNAME and WIKI_PASSWORD environment variables"
  rescue => e
    halt "Error: #{e.message}"
  end

  # FIXME: This should probably use something more robust than string interpolation
  redirect("https://#{mediawiki_site}/wiki/#{page_title}")
end
