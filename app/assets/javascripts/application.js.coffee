# Don't change order of the blocks (for turbolink to play nicely)!
#
# Add more scripts to the block between `require_self` and `require init`!
#
#= require jquery
#= require jquery_ujs
#= require jquery-ui
#
#= require jquery-ui-bootstrap-bridge
#
#= require bootstrap
#= require bootstrap-formhelpers
#= require cocoon
#= require jasny-bootstrap
#= require fancybox
#= require zen-textarea
#
#= require_self
#
# --- Add custom requires under here! ---
#= require example_script
#= require form_accessibilizer
#= require textarea_fullscreenizer
# --- Add custom requires above here! ---
#
#= require init
#= require callbacks

@App = {}
