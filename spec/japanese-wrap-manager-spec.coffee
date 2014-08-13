JapaneseWrapManager = require '../lib/japanese-wrap-manager'

describe "JapaneseWrapManager", ->
  jwm = undefined
  beforeEach ->
    jwm = new JapaneseWrapManager

  describe "JapaneseWrapManager#findeWrapcolumn()", ->

    it "Engrish", ->
      text = "All your package are belong to us."
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(9)
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(9)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(9)
      expect(jwm.findJapaneseWrapColumn(text, 13)).toEqual(9)
      expect(jwm.findJapaneseWrapColumn(text, 14)).toEqual(9)
      expect(jwm.findJapaneseWrapColumn(text, 15)).toEqual(9)
      expect(jwm.findJapaneseWrapColumn(text, 16)).toEqual(17)
      expect(jwm.findJapaneseWrapColumn(text, 17)).toEqual(17)
      expect(jwm.findJapaneseWrapColumn(text, 18)).toEqual(17)
      expect(jwm.findJapaneseWrapColumn(text, 19)).toEqual(17)
      expect(jwm.findJapaneseWrapColumn(text, 20)).toEqual(21)
      expect(jwm.findJapaneseWrapColumn(text, 80)).toEqual(undefined)

    it "日本語", ->
      text = "君達のパッケージは、全てGitHubがいただいた。"
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(5) # 行頭禁則文字「ッ」
      expect(jwm.findJapaneseWrapColumn(text, 13)).toEqual(5) # 行頭禁則文字「ッ」
      expect(jwm.findJapaneseWrapColumn(text, 14)).toEqual(7)
      expect(jwm.findJapaneseWrapColumn(text, 15)).toEqual(7)
      expect(jwm.findJapaneseWrapColumn(text, 16)).toEqual(8)
      expect(jwm.findJapaneseWrapColumn(text, 17)).toEqual(8)
      expect(jwm.findJapaneseWrapColumn(text, 18)).toEqual(8) # 行頭禁則文字「、」
      expect(jwm.findJapaneseWrapColumn(text, 19)).toEqual(8) # 行頭禁則文字「、」
      expect(jwm.findJapaneseWrapColumn(text, 20)).toEqual(10)
      expect(jwm.findJapaneseWrapColumn(text, 21)).toEqual(10)
      expect(jwm.findJapaneseWrapColumn(text, 22)).toEqual(11)
      expect(jwm.findJapaneseWrapColumn(text, 23)).toEqual(11)
      expect(jwm.findJapaneseWrapColumn(text, 24)).toEqual(12) # 英単語
      expect(jwm.findJapaneseWrapColumn(text, 25)).toEqual(12) # 英単語
      expect(jwm.findJapaneseWrapColumn(text, 26)).toEqual(12) # 英単語
      expect(jwm.findJapaneseWrapColumn(text, 27)).toEqual(12) # 英単語
      expect(jwm.findJapaneseWrapColumn(text, 28)).toEqual(12)
      expect(jwm.findJapaneseWrapColumn(text, 29)).toEqual(12)
      expect(jwm.findJapaneseWrapColumn(text, 30)).toEqual(18)
      expect(jwm.findJapaneseWrapColumn(text, 31)).toEqual(18)
      expect(jwm.findJapaneseWrapColumn(text, 32)).toEqual(19)
      expect(jwm.findJapaneseWrapColumn(text, 80)).toEqual(undefined)

    it "1倍幅サロゲートペア", ->
      # 「𠮷」は2文字分の長さがある。
      text = "𠮷田の𠮷は土に口です。"
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(4)
      expect(jwm.findJapaneseWrapColumn(text, 7)).toEqual(4)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(6)
      expect(jwm.findJapaneseWrapColumn(text, 9)).toEqual(6)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(7)
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(7)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(8)
      expect(jwm.findJapaneseWrapColumn(text, 13)).toEqual(8)
      expect(jwm.findJapaneseWrapColumn(text, 80)).toEqual(undefined)

    it "行頭禁止", ->
      # 禁止される文字
      list = ["、", "。", "，", "．", "：", "；", "］", "）", "｝", "！", "？", "」", "〜", ]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(1)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(1)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 8)).toEqual(4)

      # ASCII記号の例外。
      list = [".", ",", ":", ";", "]", ")", "}", "!", "?"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)

      # 半角文字
      list = ["､", "｡", "｣", "･", "ｰ", "ﾞ", "ﾟ"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)

    it "行末禁止", ->
      # 禁止される文字
      list = ["［", "（", "｛", "「"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 8)).toEqual(4)

      # ASCII記号の例外。
      list = ["[", "(", "{"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)

      # 半角文字
      list = ["｢"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)
