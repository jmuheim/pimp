# Adds the features of paste.js to all textareas of the given element.
#
# Be sure you have https://github.com/layerssss/paste.js available.
class App.ClipboardToNestedImagePasteabilizer
  constructor: (el) ->
    $el = $(el)
    @$input = $el.find 'textarea#document_content'
    @$add_image_link = $el.find 'a.add_fields'

    @makePastable()

  makePastable: ->
    @$input.pastableTextarea()
    @$input.on('pasteImage', (ev, data) =>
      @$add_image_link.click() # Add another file input field
      $nested_fields = $('.nested-fields:last')
      console.log $file_field = $nested_fields.find(':input[id$="_file"]')
      console.log $temporary_identifier_field = $nested_fields.find(':input[id$="_identifier"]')
      temporary_id = $file_field.attr('id').match(/_(\d+)_file$/)[1]

      $file_field.val(data.dataURL)
      $temporary_identifier_field.val(temporary_id)

      alternative_text = prompt('Please enter an alternative text for the pasted field.', 'Screenshot')
      @$input.val("#{@$input.val()}![#{alternative_text}](#{temporary_id})")
      return
    ).on 'pasteText', (ev, data) ->
      return
