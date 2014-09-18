UnicodeUtil = require '../lib/unicode-util'

describe "UnicodeUtil", ->
  describe "UnicodeUtil.getBlockName()", ->
    it "BlockName", ->
      expect(UnicodeUtil.getBlockName("a")).toEqual("C0 Controls and Basic Latin")
      expect(UnicodeUtil.getBlockName("α")).toEqual("Greek and Coptic")
      expect(UnicodeUtil.getBlockName("д")).toEqual("Cyrillic")
      expect(UnicodeUtil.getBlockName("あ")).toEqual("Hiragana")
      expect(UnicodeUtil.getBlockName("ア")).toEqual("Katakana")
      expect(UnicodeUtil.getBlockName("一")).toEqual("CJK Unified Ideographs")
      expect(UnicodeUtil.getBlockName("ｱ")).toEqual("Halfwidth and Fullwidth Forms")
      expect(UnicodeUtil.getBlockName("Ａ")).toEqual("Halfwidth and Fullwidth Forms")
      expect(UnicodeUtil.getBlockName("𠮷")).toEqual("CJK Unified Ideographs Extension B")
      # " サロゲートペアが色つけがあるとおかしくなる様子、Atomのバグか？
