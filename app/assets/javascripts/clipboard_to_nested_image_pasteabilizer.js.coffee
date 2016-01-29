# Adds the features of paste.js to all textareas of the given element.
#
# Be sure you have https://github.com/layerssss/paste.js available.
class App.ClipboardToNestedImagePasteabilizer
  constructor: (el) ->
    $el = $(el)

    @$input = $el

    @removeWhitespace()
    @makePastable()

  # We need to do this because of this problem: https://github.com/nathanvda/cocoon/issues/323
  removeWhitespace: ->
    if @$input.val().trim() == ''
      @$input.val('')

  makePastable: ->
    @$input.pastableTextarea()
    @$input.on('pasteImage', (ev, data) =>
      @$input.val(data.dataURL)
      return
    ).on 'pasteText', (ev, data) ->
      return
