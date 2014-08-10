JapaneseWrapManager = require '../lib/japanese-wrap-manager'

describe "JapaneseWrapManager", ->
  jwm = undefined
  beforeEach ->
    jwm = new JapaneseWrapManager

  describe "JapaneseWrapManager#findeWrapcolumn()", ->

    it "Engrish", ->
      text = "All your package are belong to us."
      expect(jwm.findWrapColumn(text, 10)).toEqual(9)
      expect(jwm.findWrapColumn(text, 11)).toEqual(9)
      expect(jwm.findWrapColumn(text, 12)).toEqual(9)
      expect(jwm.findWrapColumn(text, 13)).toEqual(9)
      expect(jwm.findWrapColumn(text, 14)).toEqual(9)
      expect(jwm.findWrapColumn(text, 15)).toEqual(9)
      expect(jwm.findWrapColumn(text, 16)).toEqual(17)
      expect(jwm.findWrapColumn(text, 17)).toEqual(17)
      expect(jwm.findWrapColumn(text, 18)).toEqual(17)
      expect(jwm.findWrapColumn(text, 19)).toEqual(17)
      expect(jwm.findWrapColumn(text, 20)).toEqual(21)
      expect(jwm.findWrapColumn(text, 80)).toEqual(undefined)

    it "日本語", ->
      text = "君達のパッケージは、全てGitHubがいただいた。"
      expect(jwm.findWrapColumn(text, 10)).toEqual(5)
      expect(jwm.findWrapColumn(text, 11)).toEqual(5)
      expect(jwm.findWrapColumn(text, 12)).toEqual(5) # 行頭禁則文字「ッ」
      expect(jwm.findWrapColumn(text, 13)).toEqual(5) # 行頭禁則文字「ッ」
      expect(jwm.findWrapColumn(text, 14)).toEqual(7)
      expect(jwm.findWrapColumn(text, 15)).toEqual(7)
      expect(jwm.findWrapColumn(text, 16)).toEqual(8)
      expect(jwm.findWrapColumn(text, 17)).toEqual(8)
      expect(jwm.findWrapColumn(text, 18)).toEqual(8) # 行頭禁則文字「、」
      expect(jwm.findWrapColumn(text, 19)).toEqual(8) # 行頭禁則文字「、」
      expect(jwm.findWrapColumn(text, 20)).toEqual(10)
      expect(jwm.findWrapColumn(text, 21)).toEqual(10)
      expect(jwm.findWrapColumn(text, 22)).toEqual(11)
      expect(jwm.findWrapColumn(text, 23)).toEqual(11)
      expect(jwm.findWrapColumn(text, 24)).toEqual(12) # 英単語
      expect(jwm.findWrapColumn(text, 25)).toEqual(12) # 英単語
      expect(jwm.findWrapColumn(text, 26)).toEqual(12) # 英単語
      expect(jwm.findWrapColumn(text, 27)).toEqual(12) # 英単語
      expect(jwm.findWrapColumn(text, 28)).toEqual(12)
      expect(jwm.findWrapColumn(text, 29)).toEqual(12)
      expect(jwm.findWrapColumn(text, 30)).toEqual(18)
      expect(jwm.findWrapColumn(text, 31)).toEqual(18)
      expect(jwm.findWrapColumn(text, 32)).toEqual(19)
      expect(jwm.findWrapColumn(text, 80)).toEqual(undefined)

    it "1倍幅サロゲートペア", ->
      # 「𠮷」は2文字分の長さがある。
      text = "𠮷田の𠮷は土に口です。"
      expect(jwm.findWrapColumn(text, 4)).toEqual(3)
      expect(jwm.findWrapColumn(text, 5)).toEqual(3)
      expect(jwm.findWrapColumn(text, 6)).toEqual(4)
      expect(jwm.findWrapColumn(text, 7)).toEqual(4)
      expect(jwm.findWrapColumn(text, 8)).toEqual(6)
      expect(jwm.findWrapColumn(text, 9)).toEqual(6)
      expect(jwm.findWrapColumn(text, 10)).toEqual(7)
      expect(jwm.findWrapColumn(text, 11)).toEqual(7)
      expect(jwm.findWrapColumn(text, 12)).toEqual(8)
      expect(jwm.findWrapColumn(text, 13)).toEqual(8)
      expect(jwm.findWrapColumn(text, 80)).toEqual(undefined)
