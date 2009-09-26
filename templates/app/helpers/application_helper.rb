module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}_#{controller.action_name}"
  end
end