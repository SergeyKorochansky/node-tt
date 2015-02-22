mongoose = require 'mongoose'

noteSchema = new mongoose.Schema(
  content:
    type: String
    required: true
  milestoneId:
    type: ObjectId
    required: true
  userId:
    type: ObjectId
    required: true
  createdAt:
    type: Date
    default: Date.now
  updatedAt:
    type: Date
    default: Date.now
)

exports.noteModel = mongoose.model('Note', noteSchema)