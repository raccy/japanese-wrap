JapaneseWrapManager = require './japanese-wrap-manager'

module.exports =
  japaneseWrapManager: null

  activate: (state) ->
    @japaneseWrapManager = new JapaneseWrapManager
    japaneseWrapManager = @japaneseWrapManager
    atom.workspaceView.eachEditorView (editorView) ->
      editor = editorView.getEditor()
      japaneseWrapManager.overwriteFindWrapColumn(editor.displayBuffer)

  deactivate: ->
    japaneseWrapManager = @japaneseWrapManager
    atom.workspaceView.eachEditorView (editorView) ->
      editor = editorView.getEditor()
      japaneseWrapManager.restoreFindWrapColumn(editor.displayBuffer)
