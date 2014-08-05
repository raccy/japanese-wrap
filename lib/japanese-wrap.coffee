JapaneseWrapView = require './japanese-wrap-view'

module.exports =
  japaneseWrapView: null

  activate: (state) ->
    @japaneseWrapView = new JapaneseWrapView(state.japaneseWrapViewState)

  deactivate: ->
    @japaneseWrapView.destroy()

  serialize: ->
    japaneseWrapViewState: @japaneseWrapView.serialize()
