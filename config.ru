require 'bundler/setup'
require 'compare_with_wikidata'
require 'sinatra'

Sinatra::Application.include CompareWithWikidata

get '/' do
  mediawiki_site = params[:mediawiki_site]
  page_title = params[:page_title]

  halt "Please provide ?mediawiki_site and ?page_title GET parameters" unless mediawiki_site && page_title

  begin
    compare_with_wikidata(mediawiki_site, page_title)
  rescue => e
    halt "Error: #{e.message}"
  end

  # FIXME: This should probably use something more robust than string interpolation
  redirect("https://#{mediawiki_site}/wiki/#{page_title}")
end

run Sinatra::Application
