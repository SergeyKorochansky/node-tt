mongoose = require 'mongoose'

userToProjectSchema = new mongoose.Schema(
  userId:
    type: ObjectId
    required: true
  projectId:
    type: ObjectId
    required: true
)

exports.userToProjectModel = mongoose.model('UserToProject', userToProjectSchema)