require "facets/string/titlecase"
require "sinatra/base"
require "slim"
require "yaml"

class YoureTheBest < Sinatra::Base
  configure do
    config_file = File.join(__dir__, "config/bestlist.yaml")
    set :map, YAML.load(open(config_file))
  end

  get "/*" do
    lookup, host = request.host.split(".yourethebest")
    hit = settings.map[lookup]
    redirect('http://who-is-awesome.com/') if hit.nil?
    uri = URI([*hit].sample)
    extra = params[:splat].first.tr('/', ' ')

    slim :photo, locals: {
      target: lookup.gsub(/\W+/, " ").titlecase,
      uri: uri,
      extra: extra
    }
  end
end