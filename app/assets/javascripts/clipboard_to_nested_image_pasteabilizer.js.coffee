# Adds the features of paste.js to all textareas of the given element.
#
# Be sure you have https://github.com/layerssss/paste.js available.
class App.ClipboardToNestedImagePasteabilizer
  constructor: (el) ->
    $el = $(el)
    @$input = $el.find 'textarea#document_content'
    @$add_image_link = $el.find 'a.add_fields'
    @alt_prompt = @$input.data('pasteable-image-alt-prompt')
    @identifier_prompt = @$input.data('pasteable-image-identifier-prompt')

    @makePastable()

  makePastable: ->
    @$input.pastableTextarea()
    @$input.on('pasteImage', (ev, data) =>
      alternative_text = prompt(@alt_prompt)
      return if alternative_text == null
      identifier = prompt(@identifier_prompt, slugify(alternative_text))

      @$add_image_link.click() # Add another file input field
      $nested_fields = $('.nested-fields:last')
      $file_field = $nested_fields.find(':input[id$="_file"]')
      $temporary_identifier_field = $nested_fields.find(':input[id$="_identifier"]')
      identifier = [identifier, $file_field.attr('id').match(/_(\d+)_file$/)[1]].join '-'

      $file_field.val(data.dataURL)
      $temporary_identifier_field.val(identifier)

      caret_position = @$input.caret()
      value_before = @$input.val().substring(0, caret_position)
      value_after = @$input.val().substring(caret_position)
      image_text = "![#{alternative_text}](#{identifier})"

      @$input.val(value_before + image_text + value_after)

      @$input.caret(caret_position + image_text.length)
      return
    ).on 'pasteText', (ev, data) ->
      return

  # https://gist.github.com/mathewbyrne/1280286
  slugify = (text) ->
    text.toString().toLowerCase().replace(/\s+/g, '-').replace(/[^\w\-]+/g, '').replace(/\-\-+/g, '-').replace(/^-+/, '').replace /-+$/, ''
