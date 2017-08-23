require 'bundler/setup'
require_relative 'lib/load_environment_from_yaml'

require 'compare_with_wikidata'
require 'sinatra'

get '/' do
  redirect to('/prompter')
end

get '/prompter/?' do
  mediawiki_site = params[:mediawiki_site]
  page_title = params[:page_title]

  return erb(:homepage) unless mediawiki_site && page_title

  unless mediawiki_site =~ /^(www\.)?wikidata.org|[a-z]{2}.wikipedia.org$/
    halt "Disallowed mediawiki_site"
  end

  diff_output_generator = CompareWithWikidata::DiffOutputGenerator.new(
    mediawiki_site: mediawiki_site,
    page_title: page_title
  )

  begin
    diff_output_generator.run!
  rescue MediawikiApi::LoginError
    halt "Please set WIKI_USERNAME and WIKI_PASSWORD environment variables"
  rescue => e
    halt "Error: #{e.message}"
  end

  redirect("https://#{mediawiki_site}/wiki/#{page_title}")
end
