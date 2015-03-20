acl = require 'acl'

module.exports = ->
  acl = new acl(new acl.memoryBackend())

  acl.allow [
    {
      roles: 'admin'
      allows: [
        {
          resources: 'users'
          permissions: ['read', 'update', 'destroy']
        }
        {
          resources: ['projects', 'milestones']
          permissions: ['read', 'destroy']
        }
        {
          resources: 'note'
          permissions: 'read'
        }
        {
          resources: 'cities'
          permissions: ['create', 'read', 'update', 'destroy']
        }
      ]
    }
    {
      roles: 'manager'
      allows: [
        resources: ['projects', 'milestones', 'notes']
        permissions: ['create', 'read', 'update', 'destroy']
      ]
    }
    {
      roles: 'user'
      allows: [
        {
          resources: 'projects'
          permissions: ['read', 'update']
        }
        {
          resources: ['milestones', 'notes']
          permissions: ['create','read', 'update']
        }
      ]
    }
  ]