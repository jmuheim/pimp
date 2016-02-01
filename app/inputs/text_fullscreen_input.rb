class TextFullscreenInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    template.content_tag(:div, class: 'background') do
      super + toggler
    end
  end

  def toggler
    template.content_tag(:span, class: 'toggler label label-primary', 'aria-hidden' => true) do
      I18n.t('simple_form.inputs.text_fullscreen.toggle')
    end
  end
end
