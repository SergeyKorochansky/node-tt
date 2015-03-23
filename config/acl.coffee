module.exports =
  admin: [
    {
      resources: ['users']
      permissions: ['read', 'update', 'destroy']
    }
    {
      resources: ['projects', 'milestones']
      permissions: ['read', 'destroy']
    }
    {
      resources: ['note']
      permissions: ['read']
    }
    {
      resources: ['cities']
      permissions: ['create', 'read', 'update', 'destroy']
    }
  ]
  manager: [
    resources: ['projects', 'milestones', 'notes']
    permissions: ['create', 'read', 'update', 'destroy']
  ]
  client: [
    {
      resources: ['projects']
      permissions: ['read', 'update']
    }
    {
      resources: ['milestones', 'notes']
      permissions: ['create', 'read', 'update']
    }
  ]
