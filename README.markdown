# HomeKit Raspberry Pi Lights Controller

A simple app that adds one set of remote-controlled christmas lights as a HomeKit accessory. Only supports "on" and "off" toggle.

## Requirements

* Ruby 2.5
* Raspberry Pi for GPIO
* FS1000A 433MHz Transmitter Module
* Working `avahi-daemon`
* `libsodium-dev` built from source

For instructions on setting up the Transmitter Module, see [Pi Lights Control](https://github.com/openfirmware/pi-lights-control).

I had to install `libavahi-core7` and `libavahi-core-dev` to fix `avahi-daemon` on Raspbian. Also I am running `stretch` instead of `jessie`, as I had wanted newer packages. This may affect some other requirements I may have missed.

The `libsodium-dev` included in `stretch` is too old for [ruby\_home](https://github.com/karlentwistle/ruby_home). Downloading and compiling from source works.

## Usage

Use Bundler to install the dependencies:

```terminal
$ bundle install
```

To start up the app manually:

```terminal
$ ruby app.rb
```

Edit `app.rb` to change the default GPIO pin from 12, if you have connected your FS1000A module in a different configuration.

## Systemd Unit

Install `pi-lights-homekit.service` to `~/.config/systemd/user/pi-lights-homekit.service`. This allows it to run as the current user, probably `pi`. Be sure to add the `pi` user to the `gpio` and `kmem` groups, to ensure the controller can access the GPIO pins:

```terminal
$ sudo usermod -a -G kmem gpio pi
```

Then reload systemd:

```terminal
$ systemctl --user daemon-reload
```

And start the service:

```terminal
$ systemctl --user start pi-lights-homekit
```

And set it to auto start:

```terminal
$ systemctl --user enable pi-lights-homekit
```

And be sure to set the user as able to auto run:

```terminal
$ sudo loginctl enable-linger pi
```

## HomeKit Usage

Add the accessory in HomeKit, using a code instead of the camera. The code should be printed to the screen, or if ran with systemd:

```terminal
$ journalctl --user -u pi-lights-homekit
```

After adding the accessory you should be able to turn the lights on and off. Siri should also work.

You **cannot** currently activate light programs as HomeKit characteristics do not support this level of interaction yet. Same goes for "sync" on multiple light strands. Additionally, if you turn the lights on or off using the original remote or a different program, then HomeKit will have the incorrect on/off state and you will have to double-toggle to get the functionality you want. Nothing can be done about this until HomeKit supports stateless on/off for services.


