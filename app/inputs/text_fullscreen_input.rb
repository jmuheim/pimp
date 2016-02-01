class TextFullscreenInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    binding.pry
    template.content_tag(:div, class: 'zennable') do
      template.content_tag(:input, id: checkbox_id, type: 'checkbox', tabindex: -1) do
        template.content_tag(:div, class: 'zen-backdrop') do
          super + expander + shrinker
        end
      end
    end
  end

  def expander
    template.content_tag(:label, for: checkbox_id, class: 'expander') do
      'Expand (ctrl+f)'
    end
  end

  def shrinker
    template.content_tag(:label, for: checkbox_id, class: 'shrinker') do
      'Shrink (esc)'
    end
  end

  # We better use the original ID, see http://stackoverflow.com/questions/35130977/simple-form-custom-input-retrieve-inputs-id
  def checkbox_id
    "zen-toggle-#{attribute_name}"
  end
end
