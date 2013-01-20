OptiRoute.location_form = {
  setup: function() {
    this.form = $("#location_form")
    if ($(this.form).length > 0) {
      this.bindEvents();
    };
  },

  bindEvents: function() {
    var self = this;

    $(self.form).find('input[type="submit"]').click(function(event) {
      event.preventDefault();
      self.verifyAddresses();
    });

    $(self.form).on('click', '.add_fields', function(event) {
      self.addLocationFields(this, event);
    });

    $(self.form).on('click', '.remove_fields', function(event) {
      self.removeLocationFields(this, event)
    });

    $("#use_verified_addresses").click(function(event) {
      event.preventDefault();
      self.submitVerifiedAddresses();
      $(self.form).submit();
    });
  },

  removeLocationFields: function(elem, event) {
    $(elem).prev('input[type=hidden]').val('1');
    $(elem).closest('div.field').fadeOut();
    event.preventDefault();
  },

  addLocationFields: function(elem, event) {
    var time = new Date().getTime();
    var regexp = new RegExp($(elem).data('id'), 'g');
    $(elem).before($(elem).data('fields').replace(regexp, time));
    event.preventDefault();
  },

  handleVerification: function(locations) {
    var valid_locations = 0;

    $("#change_address p.address").html("");
    jQuery.each(locations, function(index, location) {
      var addressInput = $("#route_locations_attributes_"+location.index+"_address_string");
      if (location.verified) {
        $(addressInput).next("span.verified").html("valid");
        valid_locations++;
      } else {
        $("#change_address p.address").append("<h5>Verified address for "+(location.address_string)+"</h5>");
        $("#change_address p.address").append('<p id="location_'+location.index+'">' +location.verified_address + "</p>");
      }
    });

    return valid_locations == locations.length;
  },

  submitVerifiedAddresses: function() {
    var locations = this.verifiedAddresses;
    jQuery.each(locations, function(index, location) {
      $("#route_locations_attributes_" + location.index + "_address_string").val(location.verified_address);
    });
    $("#change_address").modal('hide');
  },

  verifyAddresses: function() {
    var self = this;
    var data = $(self.form).find('input[name!=_method]').serialize();

    $.ajax({
      url: "/locations/verify_collection",
      type: "post",
      data: data
    }).done(function(data) {
      self.verifiedAddresses = data;
      var valid = self.handleVerification(data);
      if (!valid) {
        $("#change_address").modal('show');
      } else {
        $(self.form).submit();
      };
    });
  }
}

$(function() {
  OptiRoute.location_form.setup();
});