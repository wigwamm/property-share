module ApplicationHelper
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def current_agency
    current_agent ? agency = current_agent.agency : agency = false
    return agency
  end

end
