require 'bundler/setup'
require 'compare_with_wikidata'
require 'sinatra'

get '/' do
  mediawiki_site = params[:mediawiki_site]
  page_title = params[:page_title]

  page = CompareWithWikidata::MediawikiPage.new(mediawiki_site: mediawiki_site, page_title: page_title)
  wikitext = CompareWithWikidata::MediawikiText.new(mediawiki_page: page)
  page.replace_output(wikitext)

  # FIXME: This should probably use something more robust than string interpolation
  redirect("https://#{mediawiki_site}/wiki/#{page_title}")
end

run Sinatra::Application
