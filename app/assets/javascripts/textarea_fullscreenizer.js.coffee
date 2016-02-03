# Allows textareas to be maximized (Zen View)

class App.TextareaFullscreenizer
  constructor: (textarea) ->
    @$textarea = $(textarea)

    @$textarea.wrap("<div class='textarea-fullscreenizer'></div>")
    @$background = @$textarea.parent()

    @$background.append("<span class='textarea-fullscreenizer-toggler' aria-hidden='true'>#{@$textarea.data('textarea-fullscreenizer-toggler-text')}</span>")
    @$toggler = @$background.find('.textarea-fullscreenizer-toggler')

    @$toggler.click (e) =>
      @toggleFullscreen()

    @$textarea.keyup (e) =>
      if e.keyCode == 27
        @toggleFullscreen()

    @$textarea.on 'focus', =>
      @$background.addClass('textarea-fullscreenizer-focus')

    @$textarea.on 'blur', =>
      @$background.removeClass('textarea-fullscreenizer-focus')

      if @$background.hasClass('textarea-fullscreenizer-fullscreen')
        @toggleFullscreen(false)

  toggleFullscreen: (setFocus = true) ->
    @$background.toggleClass('textarea-fullscreenizer-fullscreen')
    @$textarea.focus() if setFocus
