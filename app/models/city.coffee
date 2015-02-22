mongoose = require 'mongoose'

citySchema = new mongoose.Schema(
  name:
    type: String
    required: true
)

exports.cityModel = mongoose.model('City', citySchema)