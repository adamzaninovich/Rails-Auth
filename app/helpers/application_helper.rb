module ApplicationHelper
  def error_messages_for resource
    if resource.errors.any?
      html =  "<div class='error_messages'>"
      html << "<h2>" << (resource.errors.count == 1 ? "A problem" : "Some problems")
      html << " prevented the form from being saved.</h2>"
      html << "<ul>"
      for message in resource.errors.full_messages
        html << "<li>#{message}</li>"
      end
      html << "</ul></div>"
      html.html_safe
    end
  end
end
