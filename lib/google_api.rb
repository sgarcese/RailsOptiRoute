require 'net/http'
require 'json'

module GoogleAPI
  class GoogleLocation
    #Errors
    class Runtime < RuntimeError; end
    class NoArgumentError < Runtime
      def message
        "Insuficient input arguments"
      end
    end
    class TooManyArgumentError <Runtime
      def message
        "Excesive input arguments"
      end
    end
  end

  class GoogleLocation
    #Accessors
    attr_accessor :name, :address, :formatted_address, :partial_match, :lat, :lng 

    #Methods
    def initialize( *vararg )
      vararg_count = vararg.count
      raise NoArgumentError unless vararg_count > 0
      raise TooManyArgumentError unless vararg_count <3

      if vararg_count == 1 
        self.address = vararg[0].to_s
      elsif vararg_count == 2
        self.name = vararg[0].to_s
        self.address = vararg[1].to_s
      end
    end

    def get_location
      uri = URI('http://maps.googleapis.com/maps/api/geocode/json')
      params = {:address => @address, :sensor => 'false'}
      uri.query = URI.encode_www_form(params)

      response        = Net::HTTP.get_response(uri)

      json_response   = JSON.parse(response.body)

      #insert exceptions if the result is unacceptable
      if json_response["status"] == "OK" && json_response["results"].any?
        self.lat = json_response["results"][0]["geometry"]["location"]["lat"]
        self.lng = json_response["results"][0]["geometry"]["location"]["lng"]
        self.formatted_address = json_response["results"][0]["formatted_address"]
        formatted_address
      else
        nil
      end
    end

    def lat2rad
      @lat * Math::PI / 180
    end

    def lng2rad
      @lng * Math::PI / 180
    end
  end

  class GoogleRoute
    attr_accessor :start, :finish, :waypoints, :distance, :duration, :waypoint_order, :optimized
    #assumes that the input is an array of correctly formatted addresses
    #the first address is @start, the last is @finish
    def initialize(lats_and_lngs)
      @start      = lats_and_lngs.shift
      @finish     = lats_and_lngs.pop
      @waypoints  = [] || lats_and_lngs
      @optimized  = false
    end

    def get_route
      uri     = URI('http://maps.googleapis.com/maps/api/directions/json')
      params  = {origin: start, destination:finish, waypoints:"optimize:true|#{waypoints.join("|")}"}
      uri.query = URI.encode_www_form(params)
      
      response        = Net::HTTP.get_response(uri)
      json_response   = JSON.parse(response.body)
      
      if json_response["status"] == "OK"
        @duration = json_response["routes"][1]["duration"]["value"]
        @distance = json_response["routes"][1]["distance"]["value"]
        @formatted_address = json_response["results"][1]["formatted_address"]
        @partial_match = 1 if json_response["results"][1]["partial_match"]
      end
    end
  end

end