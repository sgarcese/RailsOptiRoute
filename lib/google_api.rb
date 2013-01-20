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
  end

  class GoogleLocation
    #Accessors
    attr_accessor :name, :address, :formatted_address, :partial_match, :lat, :lng, :json_response

    #Methods
    def initialize( *vararg )
      vararg_count = vararg.count
      raise NoArgumentError if vararg_count == 0
      raise TooManyArgumentError if vararg_count >= 3

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
    attr_accessor :start, :finish, :waypoints, :distance, :duration, :waypoint_index, :optimized, :json_response, :summary
    #assumes that the input is an array of correctly formatted addresses
    #the first address is @start, the last is @finish
    def initialize(lats_and_lngs)
      @lats_and_lngs      = lats_and_lngs
      @start              = lats_and_lngs.shift
      @finish             = lats_and_lngs.pop
      @waypoints          = [] || lats_and_lngs
      @waypoint_index     = []
      @ordered_waypoints  = []
      @optimized          = false
      @json_response      = build_response
      @summary            = []
      DefaultMapZoom      = 12
      DefaultMapSize      = "400x350"
      @apiKey             = "AIzaSyCk3z5kIzi65WoATUBPbJ7h3i5fyY7DlaQ"
    end
    
    def get_route  
      if @json_response["status"] == "OK"
        self.duration          = @json_response["routes"][0]["duration"]["value"]
        self.distance          = @json_response["routes"][0]["distance"]["value"]
        self.waypoint_index    = @json_response["routes"][0]["waypoint_index"]
        
        @waypoint_index.each do |index|
          @ordered_waypoints << @waypoints[index]
        end
        self.optimized          = true
      end
    end
    
    def print_summary
      return @summary unless @summary.empty?
      steps = @json_response["routes"][0]["steps"]
      steps.each do |step|
        @summary << "From: #{step["start_address"]}  To: #{step["end_address"]} Via: #{"summary"} Distance: #{step["distance"]["text"]} Duration: #{step["duration"]["text"]}"
      end
    end
    
    def unoptimized_map_url
       uri        = URI('http://maps.googleapis.com/maps/api/staticmap')
       map_center = find_map_center
       params     = {center: map_center, zoom: DefaultMapZoom, size: DefaultMapSize}
    end
    def optimized_map_url
       uri        = URI('http://maps.googleapis.com/maps/api/staticmap')
       map_center = find_map_center
       params     = {center: map_center, zoom: DefaultMapZoom, size: DefaultMapZoom}
    end
    def find_map_center
        @lats_and_lngs.each do |lat_and_lng|
          lats << lat_and_lng[0]
          lngs << lat_and_lng[1]
        end
        lats_center = (lats.max - lats.min) /2
        lngs_center = (lngs.max - lngs.min) /2
        return "#{lats_center},#{lngs_center}"
    end
    private
    def build_response
        uri       = URI('http://maps.googleapis.com/maps/api/directions/json')
        params    = {:origin => start, :destination => finish, :waypoints => "optimize:true|#{waypoints.join("|")}"}
        uri.query = URI.encode_www_form(params)

        response  = Net::HTTP.get_response(uri)
        if response.is_a?(Net::HTTPSuccess)
          JSON.parse(response.body)
        else
          raise UnsuccessfullConnection
        end
      end
  end
end