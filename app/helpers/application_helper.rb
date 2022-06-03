# Contains application level helpers
# Put controller level controllers in controller_helper.rb
module ApplicationHelper

  # Returns full title on a per-page basis. String interpolation is avoided 
  # because it can produce double escaping. 
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    page_title.empty? ? base_title : page_title + ' | ' + base_title  
  end

end
