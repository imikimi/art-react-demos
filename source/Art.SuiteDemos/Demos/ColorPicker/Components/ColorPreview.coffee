{
  defineModule
  log
  Element, RectangleElement, TextInputElement, TextElement, Component
  FluxComponent
  rgbColor
} = require 'art-suite'

defineModule module, class ColorPreview extends FluxComponent
  @subscriptions "currentColor.color"

  selectAll: ({target}) ->
    log "selectAll"
    target.selectAll()

  setColor: (value, hueOffset)->
    c = rgbColor value
    if hueOffset
      c = c.withHue c.hue - hueOffset
    @models.currentColor.setColor c unless c.parseError

  render: ->
    {color} = @state
    fgColor = if color.perceptualLightness < .9 then "white" else "#0007"

    Element
      size: hch:1, ww:1
      childrenLayout: "row"
      for hue in [0...1] by 1/3
        do (hue) =>
          clr = color.withHue color.hue + hue
          Element
            margin: 10
            size: hch:1, ww:1
            RectangleElement inFlow: false, key:"ColorPreview_background#{hue}", color: clr
            TextInputElement
              on: focus: @selectAll
              padding: 10
              size: ww:1, h: 50
              value: clr.getHexString()
              fontFamily: "monaco"
              fontSize: 24
              align: .5
              color: fgColor
              on: enter: ({target}) => @setColor target.value, hue
