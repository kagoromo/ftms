class Task < ActiveRecord::Base
  belongs_to :course_subject
  has_many :user_tasks, dependent: :destroy
  belongs_to :assigned_trainee, class_name: User.name
  belongs_to :owner, class_name: User.name
  mount_uploader :image, ImageUploader

  ATTRIBUTES_PARAMS = [
    :name, :description, :content, :image, :owner_id,
    :assigned_trainee_id, :course_subject_id, :create_by_trainee
  ]

  scope :not_assigned_trainee, -> do
    where assigned_trainee_id: nil, task_master_id: nil, create_by_trainee: true
  end

  scope :not_created_by_trainee, -> do 
    where create_by_trainee: false, task_master_id: nil
  end

  scope :has_task_master, ->{where.not task_master_id: nil}

  after_create :create_user_task

  def assign_trainees_to_task
    user_subjects = course_subject.user_subjects
    user_subjects.each do |user_subject|
      user_tasks.create user_subject: user_subject
    end
  end

  def change_user_task old_assigned_trainee
    user_task = UserTask.find_by user: old_assigned_trainee, task: self
    if user_task.nil?
      self.user_tasks.create user: assigned_trainee,
        user_subject: user_subject
    else
      user_task.update_attributes user: assigned_trainee,
        user_subject: user_subject
    end
  end

  private
  def create_user_task
    return if assigned_trainee.nil?
    self.user_tasks.create user: assigned_trainee,
      user_subject: user_subject
  end

  def user_subject
    self.course_subject.user_subjects.find_by user: assigned_trainee
  end
end
