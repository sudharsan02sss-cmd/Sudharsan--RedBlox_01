class ProjectMembershipsController < ApplicationController
  before_action :set_project

  def create
    unless MembershipPolicy.new(current_user, @project).add_member?
      return render_forbidden
    end

    user = User.find(params[:user_id])
    membership = ProjectMembership.new(project: @project, user: user, role: params[:role])

    if membership.save
      render json: membership, status: :created
    else
      render json: membership.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless MembershipPolicy.new(current_user, @project).remove_member?
      return render_forbidden
    end

    membership = ProjectMembership.find_by!(project: @project, user_id: params[:user_id])
    membership.destroy
    head :no_content
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
