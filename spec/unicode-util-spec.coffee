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

  describe "UnicodeUtil.range2string()", ->
    it "range", ->
      expect(UnicodeUtil.range2string([0x20..0x40])).toEqual("\\u0020-\\u0040")
      expect(UnicodeUtil.range2string([0x300..0x600])).toEqual("\\u0300-\\u0600")
      expect(UnicodeUtil.range2string([0x4000..0x8000])).toEqual("\\u4000-\\u8000")
      expect(UnicodeUtil.range2string([0x12AB..0x34CD])).toEqual("\\u12AB-\\u34CD")
  describe "UnicodeUtil.range2regexp()", ->
    it "range", ->
      expect(UnicodeUtil.range2regexp([0x20..0x40])).toEqual(/[\u0020-\u0040]/)
      expect(UnicodeUtil.range2regexp([0x300..0x600])).toEqual(/[\u0300-\u0600]/)
      expect(UnicodeUtil.range2regexp([0x4000..0x8000])).toEqual(/[\u4000-\u8000]/)
      expect(UnicodeUtil.range2regexp([0x12AB..0x34CD])).toEqual(/[\u12AB-\u34CD]/)
  describe "UnicodeUtil.string2regexp()", ->
    it "single char", ->
      expect(UnicodeUtil.string2regexp("a")).toEqual(/[a]/)
      expect(UnicodeUtil.string2regexp("あ")).toEqual(/[あ]/)
    it "word", ->
      expect(UnicodeUtil.string2regexp("abc")).toEqual(/[abc]/)
      expect(UnicodeUtil.string2regexp("あア亜")).toEqual(/[あア亜]/)
    it "char range", ->
      expect(UnicodeUtil.string2regexp("a-z")).toEqual(/[a-z]/)
    it "unicode range", ->
      expect(UnicodeUtil.string2regexp("\\u0020-\\u0040")).toEqual(/[\u0020-\u0040]/)
      expect(UnicodeUtil.string2regexp("\\u0300-\\u0600")).toEqual(/[\u0300-\u0600]/)
      expect(UnicodeUtil.string2regexp("\\u4000-\\u8000")).toEqual(/[\u4000-\u8000]/)
    it "complex", ->
      expect(UnicodeUtil.string2regexp("\\u0020-\\u0040abc")).toEqual(/[\u0020-\u0040abc]/)
      expect(UnicodeUtil.string2regexp("\\u0020-\\u0040a-cあ")).toEqual(/[\u0020-\u0040a-cあ]/)
    it "multi", ->
      expect(UnicodeUtil.string2regexp("a", "b")).toEqual(/[ab]/)
      expect(UnicodeUtil.string2regexp("\\u0020-\\u0040", "a-c", "あ")).toEqual(/[\u0020-\u0040a-cあ]/)
