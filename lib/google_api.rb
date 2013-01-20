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
    class UnsuccessfullConnection <Runtime
      def message
        "The connection to the address validation server was unsuccsesful"
      end
  end

  class GoogleLocation
    #Accessors
    attr_accessor :name, :address, :formatted_address, :partial_match, :lat, :lng, :json_response

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
      self.json_response = build_response
    end

    def get_location
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
    private
    def build_response
      uri = URI('http://maps.googleapis.com/maps/api/geocode/json')
      params = {:address => @address, :sensor => 'false'}
      uri.query = URI.encode_www_form(params)
      
      response  = Net::HTTP.get_response(uri)
      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        raise UnsuccessfullConnection
      end
    end
  end
  class GoogleRoute
    class Runtime < RuntimeError; end
    class UnsuccessfullConnection < Runtime
      def message
        "The connection to the route optimization server was unsuccsesful"
      end
    end
  end
  class GoogleRoute
    attr_accessor :start, :finish, :waypoints, :distance, :duration, :waypoint_order, :optimized, :json_response
    #assumes that the input is an array of correctly formatted addresses
    #the first address is @start, the last is @finish
    def initialize(lats_and_lngs)
      @start         = lats_and_lngs.shift
      @finish        = lats_and_lngs.pop
      @waypoints     = [] || lats_and_lngs
      @optimized     = false  
      @json_response = build_response
    end
    
    def get_route
      
      if @json_response["status"] == "OK"
        self.duration = @json_response["routes"][0]["duration"]["value"]
        self.distance = @json_response["routes"][0]["distance"]["value"]
        self.formatted_address = @json_response["results"][0]["formatted_address"]
        self.partial_match = 1 if @json_response["results"][0]["partial_match"]
      end
    end
    
    private
    def build_response
        uri     = URI('http://maps.googleapis.com/maps/api/directions/json')
        params  = {origin: start, destination:finish, waypoints:"optimize:true|#{waypoints.join("|")}"}
        uri.query = URI.encode_www_form(params)

        response                  = Net::HTTP.get_response(uri)
        if response.is_a?(Net::HTTPSuccess)
          JSON.parse(response.body)
        else
          raise UnsuccessfullConnection
        end
      end
  end
end