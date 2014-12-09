# Millisami Base Dockerfile

This Dockerfile builds:

* Ruby 2.1.2 installed from Brightbox ruby apt and bundler gem
* Postgres 9.3 client and development headers
* Git
* Nodejs
* ImageMagick
* Supervisord

A real app's Dockerfile should:

* inherit from this image
* add an application user
* add a source checkout and bundle install
* add a supervisord config for running the application code with puma or unicorn

## License
MIT License
