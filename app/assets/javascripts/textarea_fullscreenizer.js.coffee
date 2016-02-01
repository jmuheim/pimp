# Allows textareas to be maximized (Zen View)

class App.TextareaFullscreenizer
  constructor: (textarea) ->
    @$textarea = $(textarea)
    @$background = @$textarea.parent()
    @$toggler = @$background.find('.toggler')

    @$toggler.click (e) =>
      console.log 123
      @toggleFullscreen()

    @$textarea.keyup (e) =>
      if e.keyCode == 27
        @toggleFullscreen()

    @$textarea.on 'focus', =>
      @$background.addClass('focus')

    @$textarea.on 'blur', =>
      @$background.removeClass('focus')

      if @$background.hasClass('fullscreen')
        @toggleFullscreen(false)

  toggleFullscreen: (setFocus = true) ->
    @$background.toggleClass('fullscreen')
    @$textarea.focus() if setFocus
