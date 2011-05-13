require "heroku/helpers"
begin
  require "heroku/json"
rescue LoadError
  require "json/pure"
end
require 'digest/sha2'

module HerokuPostgresql
  class Client10
    Version = 10

    include Heroku::Helpers

    def initialize(url)
      @heroku_postgresql_host = ENV["HEROKU_POSTGRESQL_HOST"] || "https://shogun.heroku.com"
      @database_sha = sha(url)
      @heroku_postgresql_resource = RestClient::Resource.new(
        "#{@heroku_postgresql_host}/client/v10/databases",
        :headers => { :heroku_client_version => Version })
    end

    def ingress
      http_put "#{@database_sha}/ingress"
    end

    def reset
      http_put "#{@database_sha}/reset"
    end

    def get_database
      http_get @database_sha
    end

    def untrack
      http_put "#{@database_sha}/untrack"
    end

    protected

    def sha(url)
      Digest::SHA2.hexdigest url
    end

    def sym_keys(c)
      if c.is_a?(Array)
        c.map { |e| sym_keys(e) }
      else
        c.inject({}) do |h, (k, v)|
          h[k.to_sym] = v; h
        end
      end
    end

    def checking_client_version
      begin
        yield
      rescue RestClient::BadRequest => e
        if message = JSON.parse(e.response.to_s)["upgrade_message"]
          abort(message)
        else
          raise e
        end
      end
    end

    def http_get(path)
      checking_client_version do
        retry_on_exception(RestClient::Exception) do
          sym_keys(JSON.parse(@heroku_postgresql_resource[path].get.to_s))
        end
      end
    end

    def http_post(path, payload = {})
      checking_client_version do
        sym_keys(JSON.parse(@heroku_postgresql_resource[path].post(payload.to_json).to_s))
      end
    end

    def http_put(path, payload = {})
      checking_client_version do
        sym_keys(JSON.parse(@heroku_postgresql_resource[path].put(payload.to_json).to_s))
      end
    end
  end
end
