class MembershipPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def add_member?
    user.admin? || (user.manager? && project.owner_id == user.id)
  end

  def remove_member?
    user.admin? || (user.manager? && project.owner_id == user.id)
  end
end
