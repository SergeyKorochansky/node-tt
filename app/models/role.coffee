mongoose = require 'mongoose'

roleSchema = new mongoose.Schema(
  name:
    type: String
    required: true
)

exports.roleModel = mongoose.model('City', roleSchema)