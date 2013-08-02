define [
  'ba-debug',
  'domReady',
  'jquery-adapter',
  'foundation',
  'alerts', 'clearing', 'cookie', 'dropdown', 'forms', 'joyride', 'magellan', 'orbit',
  'placeholder', 'reveal', 'section', 'tooltips', 'topbar'
], (console, domReady, $) ->

  domReady ->
    $(document).foundation('orbit', timer_speed: 0, animation_speed: 200)
    $(document).foundation('reveal', {
      closeOnBackgroundClick: false,
      animationSpeed: 250,
    })

    console.log 'foundation loaded!'
  $
