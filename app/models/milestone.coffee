mongoose = require 'mongoose'

milestoneSchema = new mongoose.Schema(
  name:
    type: String
    required: true
  complete:
    type: Number
    min: 0
    max: 100
  number:
    type: Number
  projectId:
    type: ObjectId
  createdAt:
    type: Date
    default: Date.now
  updatedAt:
    type: Date
    default: Date.now
)

exports.milestoneModel = mongoose.model('Milestone', milestoneSchema)