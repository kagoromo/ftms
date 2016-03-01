class Admin::CoursesController < ApplicationController
  load_and_authorize_resource

  def index
    @courses = @courses.recent
  end

  def create
    @course = Course.new course_params
    if @course.save
      @course.create_course_owner current_user
      flash[:success] = flash_message "created"
      redirect_to admin_courses_path
    else
      flash[:failed] = flash_message "not created"
      render :new
    end
  end

  def show
    @subjects = @course.subjects
  end

  private

  def course_params
    params.require(:course).permit :name, :description, :start_date, :end_date
  end
end
