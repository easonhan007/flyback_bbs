#encoding: utf-8
# Helper methods defined here can be accessed in any controller or view in the application
FlybackBbs::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def status_word_for_course(course)
  	return '' unless course.is_a?(Course)
  	course.active? ? '可报名' : '已结束'
  end 

  def to_date_time(t)
  	t.strftime("%Y-%m-%d %H:%M")
  end

end
