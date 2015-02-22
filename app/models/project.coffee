mongoose = require 'mongoose'

projectSchema = new mongoose.Schema(
  name:
    type: String
    required: true
  description:
    type: String
  createdAt:
    type: Date
    default: Date.now
  updatedAt:
    type: Date
    default: Date.now
)

exports.projectModel = mongoose.model('Project', projectSchema)