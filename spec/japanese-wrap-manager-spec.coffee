JapaneseWrapManager = require '../lib/japanese-wrap-manager'
JapaneseWrap = require '../lib/japanese-wrap'

describe "JapaneseWrapManager", ->
  jwm = undefined
  beforeEach ->
    jwm = new JapaneseWrapManager
    # 設定デフォルト
    # TODO: 2階層までです
    for name, value of JapaneseWrap["config"]
      if value["type"] == "object"
        for subname, subvalue of value["properties"]
          atom.config.set("japanese-wrap." + name + "." + subname,
              subvalue["default"])
      else
        atom.config.set("japanese-wrap." + name, value["default"])


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
      list = ["、", "。", "，", "．", "：", "；", "］", "）", "｝", "！", "？", "」", "〜", "ァ"]
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
      list = ["､", "｡", "｣", "･", "ｰ", "ｧ"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(1)
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
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)

    it "複雑な組み合わせ: 空白の後の行頭禁止", ->
      text = "前文  」空白の後の行頭禁止"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(1) # 前
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 7)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(5) # 前文  」
      expect(jwm.findJapaneseWrapColumn(text, 9)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(6) # 前文  」空
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(6)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(7)

    it "複雑な組み合わせ: 行末禁止の後の空白", ->
      text = "前文「  行末禁止の後の空白"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(1) # 前
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(2) # 前文
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 7)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 9)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(6) # 前文「  行
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(6)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(7)

    it "複雑な組み合わせ: 囲まれた空白", ->
      text = "前文「    」囲まれた空白"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(1) # 前
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(2) # 前文
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 7)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 9)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(8) # 前文「    」

    it "複雑な組み合わせ: 囲まれた単語", ->
      text = "前文「word」囲まれた単語"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(1) # 前
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(2) # 前文
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 7)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 9)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(8) # 前文「word」

    it "複雑な組み合わせ: 始まり括弧の連続", ->
      text = "前文「「「「始まり括弧の連続"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(1) # 前
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(2) # 前文
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 7)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 9)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 13)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 14)).toEqual(7) # 前文「「「「括
      expect(jwm.findJapaneseWrapColumn(text, 15)).toEqual(7) # 前文「「「「括

    it "複雑な組み合わせ: 終わり括弧の連続", ->
      text = "前文」」」」括弧の連続"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(1) # 前
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(1) # 前
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 7)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 9)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(6) # 前文」」」」
      expect(jwm.findJapaneseWrapColumn(text, 13)).toEqual(6)
      expect(jwm.findJapaneseWrapColumn(text, 14)).toEqual(7) # 前文」」」」括
      expect(jwm.findJapaneseWrapColumn(text, 15)).toEqual(7)

    it "複雑な組み合わせ: 括弧の連続", ->
      text = "前文「」「」括弧の連続"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(1) # 前
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(2) # 前文
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 7)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(4) # 前文「」
      expect(jwm.findJapaneseWrapColumn(text, 9)).toEqual(4)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(4)
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(4)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(6) # 前文「」「」
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(6)
      expect(jwm.findJapaneseWrapColumn(text, 14)).toEqual(7) # 前文「」「」括
      expect(jwm.findJapaneseWrapColumn(text, 15)).toEqual(7) # 前文「」「」括

    it "強制切断", ->
      text = "abcdefghijklmnopqrstvwxyz0123456789"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(4)
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(6)

      text = "「「「「「「「「「「「「「「「「「「"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(3)

      text = "」」」」」」」」」」」」」」」」」」」"
      expect(jwm.findJapaneseWrapColumn(text, 2)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 3)).toEqual(1)
      expect(jwm.findJapaneseWrapColumn(text, 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(3)

  describe "japanese-wrap.lineBreakingRule.ideographicSpaceAsWihteSpace", ->
    it "default", ->
      text = "あいう　　あいう"
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(4)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(6)

    it "true", ->
      atom.config.set('japanese-wrap.lineBreakingRule.ideographicSpaceAsWihteSpace', true)
      text = "あいう　　あいう"
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(6)

    it "false", ->
      atom.config.set('japanese-wrap.lineBreakingRule.ideographicSpaceAsWihteSpace', false)
      text = "あいう　　あいう"
      expect(jwm.findJapaneseWrapColumn(text, 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn(text, 8)).toEqual(4)
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(6)

  describe "japanese-wrap.lineBreakingRule.halfwidthKatakana", ->
    it "default", ->
      # 半角文字
      list = ["､", "｡", "｣", "･", "ｰ", "ｧ"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(1)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)
      # 半角文字
      list = ["｢"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)

    it "true", ->
      atom.config.set('japanese-wrap.lineBreakingRule.halfwidthKatakana', true)
      # 半角文字
      list = ["､", "｡", "｣", "･", "ｰ", "ｧ"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(1)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)
      # 半角文字
      list = ["｢"]
      for char in list
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(2)
        expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)

    it "false", ->
      atom.config.set('japanese-wrap.lineBreakingRule.halfwidthKatakana', false)
      # 半角文字
      list = ["､", "｡", "｣", "･", "ｰ", "ｧ"]
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

  # TODO
  # 実装するには禁則処理においてnotStartかつword、notEndかつwordの
  # 処理を考慮した実装をする必要がある。
  # 簡単にはできなさそうなので、0.3.0あたりでがんばりたい。
  #describe "japanese-wrap.ASCII文字を禁則処理に含める", ->
  #  it "default", ->
  #    # ASCII記号の例外。
  #    list = [".", ",", ":", ";", "]", ")", "}", "!", "?"]
  #    for char in list
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)
  #    # ASCII記号の例外。
  #    list = ["[", "(", "{"]
  #    for char in list
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)

  #  it "true", ->
  #    atom.config.set('japanese-wrap.ASCII文字を禁則処理に含める', true)
  #    # ASCII記号の例外。
  #    list = [".", ",", ":", ";", "]", ")", "}", "!", "?"]
  #    for char in list
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(1)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)
  #    # ASCII記号の例外。
  #    list = ["[", "(", "{"]
  #    for char in list
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(2)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(2)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)

  #  it "false", ->
  #    atom.config.set('japanese-wrap.ASCII文字を禁則処理に含める', false)
  #    # ASCII記号の例外。
  #    list = [".", ",", ":", ";", "]", ")", "}", "!", "?"]
  #    for char in list
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)
  #    # ASCII記号の例外。
  #    list = ["[", "(", "{"]
  #    for char in list
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 4)).toEqual(2)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 5)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 6)).toEqual(3)
  #      expect(jwm.findJapaneseWrapColumn("前文#{char}後文", 7)).toEqual(4)

  describe "japanese-wrap.characterWidth.greekAndCoptic", ->
    it "default", ->
      expect(jwm.findJapaneseWrapColumn("前文α後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 7)).toEqual(3)
    it "0", ->
      atom.config.set('japanese-wrap.characterWidth.greekAndCoptic', 0)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 7)).toEqual(3)
    it "1", ->
      atom.config.set('japanese-wrap.characterWidth.greekAndCoptic', 1)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 5)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 7)).toEqual(4)
    it "2", ->
      atom.config.set('japanese-wrap.characterWidth.greekAndCoptic', 2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 7)).toEqual(3)
    it "3", ->
      atom.config.set('japanese-wrap.characterWidth.greekAndCoptic', 3)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文α後文", 7)).toEqual(3)

  describe "japanese-wrap.characterWidth.cyrillic", ->
    it "default", ->
      expect(jwm.findJapaneseWrapColumn("前文д後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 7)).toEqual(3)
    it "0", ->
      atom.config.set('japanese-wrap.characterWidth.cyrillic', 0)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 7)).toEqual(3)
    it "1", ->
      atom.config.set('japanese-wrap.characterWidth.cyrillic', 1)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 5)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 7)).toEqual(4)
    it "2", ->
      atom.config.set('japanese-wrap.characterWidth.cyrillic', 2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 7)).toEqual(3)
    it "3", ->
      atom.config.set('japanese-wrap.characterWidth.cyrillic', 3)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 4)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 5)).toEqual(2)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 6)).toEqual(3)
      expect(jwm.findJapaneseWrapColumn("前文д後文", 7)).toEqual(3)

  describe "japanese-wrap.lineBreakingRule.japanese", ->
    it "Engrish not lbrj", ->
      atom.config.set('japanese-wrap.lineBreakingRule.japanese', false)
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

    it "日本語 not lbrj", ->
      atom.config.set('japanese-wrap.lineBreakingRule.japanese', false)
      text = "君達のパッケージは、全てGitHubがいただいた。"
      expect(jwm.findJapaneseWrapColumn(text, 10)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 11)).toEqual(5)
      expect(jwm.findJapaneseWrapColumn(text, 12)).toEqual(6) # 行頭禁則文字「ッ」無効
      expect(jwm.findJapaneseWrapColumn(text, 13)).toEqual(6) # 行頭禁則文字「ッ」無効
      expect(jwm.findJapaneseWrapColumn(text, 14)).toEqual(7)
      expect(jwm.findJapaneseWrapColumn(text, 15)).toEqual(7)
      expect(jwm.findJapaneseWrapColumn(text, 16)).toEqual(8)
      expect(jwm.findJapaneseWrapColumn(text, 17)).toEqual(8)
      expect(jwm.findJapaneseWrapColumn(text, 18)).toEqual(9) # 行頭禁則文字「、」無効
      expect(jwm.findJapaneseWrapColumn(text, 19)).toEqual(9) # 行頭禁則文字「、」無効
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

  describe "issues 5", ->
    # invalid column: -1, 0 , 0.9, null , undefined
    it "  ・", ->
      text = "  ・"
      expect(jwm.findJapaneseWrapColumn(text, -1)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0.9)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, null)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, undefined)).toEqual(undefined)
    it "  」", ->
      text = "  ・"
      expect(jwm.findJapaneseWrapColumn(text, -1)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0.9)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, null)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, undefined)).toEqual(undefined)
    it "\t・", ->
      text = "\t・"
      expect(jwm.findJapaneseWrapColumn(text, -1)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0.9)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, null)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, undefined)).toEqual(undefined)
    it "  ・ not lprj", ->
      atom.config.set('japanese-wrap.lineBreakingRule.japanese', false)
      text = "  ・"
      expect(jwm.findJapaneseWrapColumn(text, -1)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0.9)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, null)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, undefined)).toEqual(undefined)
    it "  」 not lprj", ->
      atom.config.set('japanese-wrap.lineBreakingRule.japanese', false)
      text = "  ・"
      expect(jwm.findJapaneseWrapColumn(text, -1)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0.9)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, null)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, undefined)).toEqual(undefined)
    it "\t・ not lprj", ->
      atom.config.set('japanese-wrap.lineBreakingRule.japanese', false)
      text = "\t・"
      expect(jwm.findJapaneseWrapColumn(text, -1)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, 0.9)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, null)).toEqual(undefined)
      expect(jwm.findJapaneseWrapColumn(text, undefined)).toEqual(undefined)
