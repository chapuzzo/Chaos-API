require "chaos/api/version"

require 'faraday'
require 'awesome_print'
require 'json'

module Chaos
  class API

    URLS = {
      local: 'http://localhost:3000',
      staging: 'http://chaosgame.herokuapp.com'
    }

    ACTIONS = {
      get_available_games: {
        route: '/games/available'
      },
      create_game: {
        route: '/games/create'
      },
      game_ready: {
        route: '/games/ready'
      },
      join_game: {
        route: '/games/join'
      },
      get_stats: {
        route: '/games/get-stats'
      },
      send_actions: {
        route: '/actions/send-selected'
      },
      get_game_locations: {
        route: '/games/locations'
      },
      team_mates:{
        route: '/games/team-mates'
      },
      start_game: {
        route: '/games/start'
      }
    }

    def initialize env = :local
      env = URLS[env.to_sym] if URLS.keys.include? env.to_sym

      @connection = Faraday.new(
        url: env,
        ssl: {
          ca_path: '/usr/lib/ssl/certs',
          verify: false
        }
      )
    end

    def call command, params = {}, as_json = false
      method = ACTIONS[command][:verb] || :post
      route = ACTIONS[command][:route]

      response = @connection.send(method, route, params)
      return JSON(response.body) if as_json
      response
    end

    def debug command, params = {}, as_json = false
      response = call(command, params, as_json)

      if as_json
        ap response
        return response
      end

      ap response.status
      parsed = (JSON.parse(response.body) rescue response.body)
      ap parsed
      response
    end

    # def authenticate token
    #   @connection.headers['Authorization'] = "Bearer #{token}"
    # end

    # def login params
    #   response = debug :login, params: params
    #   return false unless response.status == 200

    #   token = JSON.parse(response.body)['access_token']
    #   authenticate token
    # end


    ACTIONS.keys.each do |command|
      # ap command
      define_method(command) { |params = {}, as_json = false|
        # ap params
        debug command, params, as_json
      }
    end
  end
end

