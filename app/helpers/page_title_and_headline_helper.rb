# Helps managing uniform page title, headline, and flash messages.
#
# It assumes that there's always a main `h1` tag (the headline) which identifies the main content of the page (typically this would be the first `h1` tag within the `main` tag), and that this headline should reflect the content of the `title` tag.
#
# It furthermore assumes that flash messages are always related to the main content and therefore are displayed right after the headline.
#
# The `title` tag should consist of the following:
#
# - Flash messages (if there are any)
# - The headline
# - The app's name (except on the home page, which's headline typically already contains the app's name)
module PageTitleAndHeadlineHelper
  # Displays the current headline, followed by flash messages.
  #
  # Accepts parameter for customizing/replacing the headline, or simply looks up `.title` when no parameters given.
  #
  # Examples:
  #
  # - `headline_with_flash` simply translates `.title`
  # - `headline_with_flash(key: 'value')` passes the provided keys to the translation of `.title`
  # - `headline_with_flash('My title')` uses the given string (instead of translating `.title`)
  def headline_with_flash(*args)
    options = args.extract_options!
    heading = args[0]
    raise "You can't provide both a heading and options!" if heading && options.any?

    @headline = heading.nil? ? default_headline(options) : heading

    content_tag :div, class: 'headline' do
      content_tag(:h1, @headline) + render(partial: 'layouts/flash')
    end
  end

  # Generates a title tag, consisting of potential flash messages, the page's headline, and the app's name (except when on root path).
  def title_tag
    content_tag :title do
      parts = []
      parts += flash.map { |key, value| "#{t "flash.#{key}"}: #{value}" } if flash.any?
      parts << headline
      parts << "- #{t('app.name')}" unless current_page?(root_path)
      parts.join ' '
    end
  end

  # Returns the current headline (be sure to call #headline_with_flash first).
  def headline
    @headline or raise 'No page heading provided! Be sure to call #headline_with_flash first.'
  end

  # Returns the default headline (can be overriden in controllers).
  def default_headline(options = {})
    t '.title', options
  end
end