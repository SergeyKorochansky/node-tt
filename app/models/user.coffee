mongoose = require 'mongoose'
bcrypt = require 'bcrypt'

userSchema = new mongoose.Schema(
  email:
    type: String
    required: true
    unique: true
  hash:
    type: String
    required: true
  salt:
    type: String
    required: true
  firstName:
    type: String
  lastName:
    type: String
  cityId:
    type: ObjectId
  createdAt:
    type: Date
    default: Date.now
  updatedAt:
    type: Date
    default: Date.now
)

exports.userModel = mongoose.model('User', userSchema)