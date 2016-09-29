# Adds the features of paste.js to all textareas of the given element.
#
# Be sure you have https://github.com/layerssss/paste.js available.
class App.ClipboardToTextareaPasteabilizer
  constructor: (el) ->
    $el = $(el)

    @$input            = $el.find('textarea')
    @$previewContainer = $el.find('.thumbnail')
    @$previewImage     = @$previewContainer.find('img')

    @removeWhitespace()
    @makePastable()
    @makeResettable()

  # We need to do this because of this problem: https://github.com/nathanvda/cocoon/issues/323
  removeWhitespace: ->
    if @$input.val().trim() == ''
      @$input.val('')

  makeResettable: ->
    @$previewContainer.on 'click', (ev, data) =>
      @setValue('')
      @$input.focus()
      ev.preventDefault()

  makePastable: ->
    @$input.pastableTextarea()
    @$input.on('pasteImage', (ev, data) =>
      @setValue(data)
      return
    ).on 'pasteText', (ev, data) ->
      return

  setValue: (data) ->
    dataUrl = data.dataUrl # TODO: Shouldn't this be dataURL??
    blobUrl = URL.createObjectURL(data.blob)
    @$input.val(dataUrl)                # Set blob string to textarea
    @$previewImage.attr('src', blobUrl) # Set image preview

    @$previewContainer.toggle() # Show the image preview
    @$input.toggle()            # Hide the textarea
