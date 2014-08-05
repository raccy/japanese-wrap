{View} = require 'atom'

module.exports =
class JapaneseWrapView extends View
  @content: ->
    @div class: 'japanese-wrap overlay from-top', =>
      @div "The JapaneseWrap package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "japanese-wrap:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "JapaneseWrapView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
