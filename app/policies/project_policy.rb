class ProjectPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def create?
    user.admin? || user.manager?
  end

  def update?
    user.admin? || (user.manager? && project.owner_id == user.id) || (user.member? && editor_member?)
  end

  def destroy?
    user.admin? || (user.manager? && project.owner_id == user.id)
  end

  def manage_members?
    user.admin? || (user.manager? && project.owner_id == user.id)
  end

  private

  def editor_member?
    membership = project.project_memberships.find_by(user_id: user.id)
    membership&.role == 'editor'
  end
end
