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

  describe "UnicodeUtil.getRangeListByName()", ->
    it "Latin", ->
      rangeList = UnicodeUtil.getRangeListByName("Latin")
      test_chars = ["a", "B", "À", "Đ", "ƒ"]
      ok_count = 0
      for r in rangeList
        for c in test_chars
          if c.charCodeAt() in r
            ok_count += 1
      expect(ok_count).toEqual(test_chars.length)

    it "Greek", ->
      rangeList = UnicodeUtil.getRangeListByName("Greek")
      test_chars = ["α", "Β", "ὰ"]
      ok_count = 0
      for r in rangeList
        for c in test_chars
          if c.charCodeAt() in r
            ok_count += 1
      expect(ok_count).toEqual(test_chars.length)

    it "CJK", ->
      rangeList = UnicodeUtil.getRangeListByName("CJK")
      test_chars = ["漢", "寝", "𠮷"]
      ok_count = 0
      for r in rangeList
        for c in test_chars
          charCode = c.charCodeAt()
          if charCode in UnicodeUtil.highSurrogateRange
            charCodeHigh = charCode
            charCodeLow = c.charCodeAt(1)
            if charCodeLow in UnicodeUtil.lowSurrogateRange
              charCode = 0x10000 + (charCodeHigh - 0xD800) * 0x400 +
              (charCodeLow - 0xDC00);
          if charCode in r
            ok_count += 1
      expect(ok_count).toEqual(test_chars.length)

  describe "UnicodeUtil.unicodeCharCodeAt()", ->
    it "nonesurrogate", ->
      text = "aB漢"
      expect(UnicodeUtil.unicodeCharCodeAt(text)).toEqual(text.charCodeAt())
      expect(UnicodeUtil.unicodeCharCodeAt(text, 0)).toEqual(text.charCodeAt(0))
      expect(UnicodeUtil.unicodeCharCodeAt(text, 1)).toEqual(text.charCodeAt(1))
      expect(UnicodeUtil.unicodeCharCodeAt(text, 2)).toEqual(text.charCodeAt(2))
    it "surrogate", ->
      text = "𠮷田"
      expect(UnicodeUtil.unicodeCharCodeAt(text)).toEqual(
          0x10000 + (text.charCodeAt(0) - 0xD800) * 0x400 +
          (text.charCodeAt(1) - 0xDC00))
      expect(UnicodeUtil.unicodeCharCodeAt(text, 0)).toEqual(
          0x10000 + (text.charCodeAt(0) - 0xD800) * 0x400 +
          (text.charCodeAt(1) - 0xDC00))
      expect(UnicodeUtil.unicodeCharCodeAt(text, 1)).toEqual(text.charCodeAt(2))

    text = "𠮷田𠮷田𠮷田𠮷田𠮷田"
    expect(UnicodeUtil.unicodeCharCodeAt(text), 4).toEqual(
        0x10000 + (text.charCodeAt(6) - 0xD800) * 0x400 +
        (text.charCodeAt(7) - 0xDC00))
    expect(UnicodeUtil.unicodeCharCodeAt(text, 5)).toEqual(text.charCodeAt(8))
    expect(UnicodeUtil.unicodeCharCodeAt(text, 7)).toEqual(text.charCodeAt(11))
