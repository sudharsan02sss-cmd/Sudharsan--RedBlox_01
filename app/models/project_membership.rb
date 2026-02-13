class ProjectMembership < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :role, inclusion: { in: %w[viewer editor] }
end

