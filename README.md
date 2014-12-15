[![Dependency Status](https://gemnasium.com/jbenden/hls-streamer.png)](https://gemnasium.com/jbenden/hls-streamer)
[![Code Climate](https://codeclimate.com/github/jbenden/hls-streamer/badges/gpa.svg)](https://codeclimate.com/github/jbenden/hls-streamer)
HLS Streamer
============

HLS Streamer is a node.js project that enables one to browse their multimedia collection
over their iPhone, iPad, or Mac OS X and stream the contents of their collection to their
device using HTTP Live Streaming capabilities.

Installation
------------

Installation is simple for the node.js part. However, a specially compiled version of
FFMpeg is needed to handle the streaming aspects. Installation of FFMpeg is easily
accomplished using [Homebrew](http://brew.sh/), for instance.

    # git clone git@github.com:jbenden/hls-streamer.git
    # cd hls-streamer
    # npm install
    # ./bin/devserver

The available directories are configured inside of `apps/sidewalk/routes.coffee` on line
6. Feel free to modify this line to suite your multimedia collection. This should be
abstracted out to a configuration file, it just hasn't happened yet.

To-Do
-----

* Abstract available paths to a configuration file.
* Include a line to build an optimized FFMpeg from Homebrew.

