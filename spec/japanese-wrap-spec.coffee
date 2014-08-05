{WorkspaceView} = require 'atom'
JapaneseWrap = require '../lib/japanese-wrap'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "JapaneseWrap", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('japanese-wrap')

  describe "when the japanese-wrap:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.japanese-wrap')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'japanese-wrap:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.japanese-wrap')).toExist()
        atom.workspaceView.trigger 'japanese-wrap:toggle'
        expect(atom.workspaceView.find('.japanese-wrap')).not.toExist()
