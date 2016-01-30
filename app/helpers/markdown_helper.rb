# See http://stackoverflow.com/questions/30018652/slim-template-doesnt-render-markdown-stored-in-a-variable
module MarkdownHelper
  def markdown(string)
    PandocRuby.convert(string, to: :html).strip.html_safe
  end
end
