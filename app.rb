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
    lookup = request.host.split(".yourethe.best").first
    hit = settings.map[lookup]
    redirect("http://you.yourethe.best/") if hit.nil?
    uri = URI([*hit].sample)
    extra = params[:splat].first.tr('/', ' ')

    view = uri.scheme == "view" ? uri.host.to_sym : :photo

    slim view, locals: { target: lookup.gsub(/\W+/, " ").titlecase, uri: uri, extra: extra}
  end
end