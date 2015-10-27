# Dependencies
victorica= require './victorica'
objectAssign= require 'object-assign'

# singleton & constructor
API= objectAssign victorica.beautify,victorica
API.version= process.env.npm_package_version

module.exports= API
