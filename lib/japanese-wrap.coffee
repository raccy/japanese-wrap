JapaneseWrapManager = require './japanese-wrap-manager'

module.exports =
  japaneseWrapManager: null

  config:
    #'全角句読点ぶら下げ':
    #  type: 'boolean'
    #  default: true
    #'半角句読点ぶら下げ':
    #  type: 'boolean'
    #  default: true
    #'全角ピリオド/コンマぶら下げ':
    #  type: 'boolean'
    #  default: false
    #'半角ピリオド/コンマぶら下げ':
    #  type: 'boolean'
    #  default: false
    'ギリシャ文字及びコプト文字の幅':
      type: 'integer'
      default: 2
      minimum: 1
      maximum: 2
    'キリル文字の幅':
      type: 'integer'
      default: 2
      minimum: 1
      maximum: 2
    #'ASCII文字を禁則処理に含める':
    #  type: 'boolean'
    #  default: false
    '半角カタカナ(JIS X 0201 片仮名図形文字集合)を禁則処理に含める':
      type: 'boolean'
      default: true
    '和文間隔(U+3000)を空白文字に含める':
      type: 'boolean'
      default: false

  activate: (state) ->
    @japaneseWrapManager = new JapaneseWrapManager
    atom.workspaceView.eachEditorView (editorView) =>
      editor = editorView.getEditor()
      @japaneseWrapManager.overwriteFindWrapColumn(editor.displayBuffer)

  deactivate: ->
    atom.workspaceView.eachEditorView (editorView) =>
      editor = editorView.getEditor()
      @japaneseWrapManager.restoreFindWrapColumn(editor.displayBuffer)
