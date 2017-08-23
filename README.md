# Prompter

Generates prompts for users to update Wikidata by comparing external CSVs to what's in Wikidata.

## Installation

Install the gem dependencies.

    gem install bundler foreman

Clone the code from GitHub.

    git clone https://github.com/everypolitician/prompter.git
    cd prompter

Install required gems with Bundler.

    bundle install

Add secrets file and fill it out.

    cp secrets.yml-example secrets.yml
    $EDITOR secrets.yml

Finally, start the webserver

    foreman start

You should now be able to see the application running by visiting <http://localhost:5000>.
