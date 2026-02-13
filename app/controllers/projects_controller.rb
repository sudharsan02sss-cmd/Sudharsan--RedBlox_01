class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy]

  def index
    if current_user.admin?
      projects = Project.all
    else
      projects = current_user.owned_projects + current_user.projects
      projects.uniq!
    end
    render json: projects
  end

  def show
    unless ProjectPolicy.new(current_user, @project).update? || current_user.admin?
      return render_forbidden
    end

    render json: @project
  end

  def create
    project = Project.new(project_params)
    project.owner = current_user unless current_user.admin?

    unless ProjectPolicy.new(current_user, project).create?
      return render_forbidden
    end

    if project.save
      render json: project, status: :created
    else
      render json: project.errors, status: :unprocessable_entity
    end
  end

  def update
    unless ProjectPolicy.new(current_user, @project).update?
      return render_forbidden
    end

    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless ProjectPolicy.new(current_user, @project).destroy?
      return render_forbidden
    end

    @project.destroy
    head :no_content
  end

  private

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end
end

