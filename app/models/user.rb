class User < ApplicationRecord
  has_many :owned_projects, class_name: 'Project', foreign_key: 'owner_id'
  has_many :project_memberships
  has_many :projects, through: :project_memberships

  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end

  def member?
    role == 'member'
  end
end

