OptiRoute.mapAndDirections = {
  renderUnoptimized: function(locations, addresses) {
    var directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();
    var map;
    var australia = new google.maps.LatLng(-25.274398, 133.775136);

    function initialize() {
      var mapOptions = {
        zoom: 7,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }

      var map = new google.maps.Map(document.getElementById("unoptimized_map_canvas"), mapOptions);
      directionsDisplay.setMap(map);
      directionsDisplay.setPanel(document.getElementById("unoptimized_directions_panel"));
      calcRoute();
    }

    function calcRoute() {
      var request = {
        origin: addresses[0],
        destination: addresses[addresses.length-1],
        waypoints: [],
        optimizeWaypoints: false,
        travelMode: google.maps.TravelMode.DRIVING
      };

      jQuery.each(addresses, function(index, address) {
        request.waypoints.push({location: address});
      });

      directionsService.route(request, function(response, status) {
        if (status == google.maps.DirectionsStatus.OK) {
          directionsDisplay.setDirections(response);
          computeTotalDistance(response);
        }
      });
    }

    function computeTotalDistance(result) {
      var total = 0;
      var myroute = result.routes[0];
      for (i = 0; i < myroute.legs.length; i++) {
        total += myroute.legs[i].distance.value;
      }
      total = total / 1000.
      document.getElementById("unoptimized_distance").innerHTML = total + " km";
    }

    google.maps.event.addDomListener(window, 'load', initialize);
  },

  renderOptimized: function(locations, addresses) {
    var directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();
    var map;

    function initialize() {
      var mapOptions = {
        zoom: 7,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }

      var map = new google.maps.Map(document.getElementById("optimized_map_canvas"), mapOptions);
      directionsDisplay.setMap(map);
      directionsDisplay.setPanel(document.getElementById("optimized_directions_panel"));
      calcRoute();
    }

    function calcRoute() {
      var request = {
        origin: addresses[0],
        destination: addresses[addresses.length-1],
        waypoints: [],
        optimizeWaypoints: true,
        travelMode: google.maps.TravelMode.DRIVING
      };

      jQuery.each(addresses, function(index, address) {
        request.waypoints.push({location: address});
      });

      directionsService.route(request, function(response, status) {
        if (status == google.maps.DirectionsStatus.OK) {
          directionsDisplay.setDirections(response);
          computeTotalDistance(response);
        }
      });
    }

    function computeTotalDistance(result) {
      var total = 0;
      var myroute = result.routes[0];
      for (i = 0; i < myroute.legs.length; i++) {
        total += myroute.legs[i].distance.value;
      }
      total = total / 1000.
      document.getElementById("optimized_distance").innerHTML = total + " km";
    }

    google.maps.event.addDomListener(window, 'load', initialize);  
  }
}