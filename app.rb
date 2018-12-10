#!/usr/bin/env ruby

require 'pi-lights-control'
require 'ruby_home'

$pin = 12

# Monkey patch in custom port for ruby_home so it
# doesn't conflict with other service on this Pi

module RubyHome
  class << self
    def hap_server
      @_hap_server ||= HAP::Server.new('0.0.0.0', 5567)
    end
  end
end

hc_lights = RubyHome::ServiceFactory.create(:lightbulb,
    on: false,
    manufacturer: "Home Collection",
    model: "151-3478-6",
    name: "Christmas Lights"
    )

controller = PiLightsControl::Command.new($pin)

hc_lights.characteristic(:on).after_update do |char|
  if char.value
    controller.power_on
  else
    controller.power_off
  end
end

RubyHome.run
