JapaneseWrapManager = require './japanese-wrap-manager'

module.exports =
  japaneseWrapManager: null

  #configDefaults:
  #  'ぶら下げ':
  #    '全角句読点': true
  #    '半角句読点': true
  #    '全角ピリオド/コンマ': false
  #    '半角ピリオド/コンマ': false
  #  '文字幅':
  #    'ギリシャ文字及びコプト文字': 2
  #    'キリル文字': 2
  #  '禁則処理':
  #    'ASCII文字を含める': false
  #    '半角カタカナ(JIS X 0201 片仮名図形文字集合)を含める': true
  #  '空白文字':
  #    '和文間隔(U+3000)を含める': false

  activate: (state) ->
    @japaneseWrapManager = new JapaneseWrapManager
    atom.workspaceView.eachEditorView (editorView) =>
      editor = editorView.getEditor()
      @japaneseWrapManager.overwriteFindWrapColumn(editor.displayBuffer)

  deactivate: ->
    atom.workspaceView.eachEditorView (editorView) =>
      editor = editorView.getEditor()
      @japaneseWrapManager.restoreFindWrapColumn(editor.displayBuffer)
