admin = User.create!(name: 'Admin', email: 'admin@test.com', role: 'admin')
manager = User.create!(name: 'Manager', email: 'manager@test.com', role: 'manager')
member = User.create!(name: 'Member', email: 'member@test.com', role: 'member')

project1 = Project.create!(title: 'Project 1', description: 'First project', owner_id: manager.id)

ProjectMembership.create!(user: member, project: project1, role: 'viewer')



