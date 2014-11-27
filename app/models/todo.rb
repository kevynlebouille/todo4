class Todo < ActiveRecord::Base
  acts_as_list :scope => "username = '\#{username}'"

  validates :label, :username, presence: true
end
