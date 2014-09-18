CharacterRegexpUtil = require '../lib/character-regexp-util'

describe "CharacterRegexpUtil", ->
  describe "CharacterRegexpUtil.range2string()", ->
    it "range", ->
      expect(CharacterRegexpUtil.range2string([0x20..0x40])).toEqual("\\u0020-\\u0040")
      expect(CharacterRegexpUtil.range2string([0x300..0x600])).toEqual("\\u0300-\\u0600")
      expect(CharacterRegexpUtil.range2string([0x4000..0x8000])).toEqual("\\u4000-\\u8000")
      expect(CharacterRegexpUtil.range2string([0x12AB..0x34CD])).toEqual("\\u12AB-\\u34CD")
  describe "CharacterRegexpUtil.range2regexp()", ->
    it "range", ->
      expect(CharacterRegexpUtil.range2regexp([0x20..0x40])).toEqual(/[\u0020-\u0040]/)
      expect(CharacterRegexpUtil.range2regexp([0x300..0x600])).toEqual(/[\u0300-\u0600]/)
      expect(CharacterRegexpUtil.range2regexp([0x4000..0x8000])).toEqual(/[\u4000-\u8000]/)
      expect(CharacterRegexpUtil.range2regexp([0x12AB..0x34CD])).toEqual(/[\u12AB-\u34CD]/)
  describe "CharacterRegexpUtil.string2regexp()", ->
    it "single char", ->
      expect(CharacterRegexpUtil.string2regexp("a")).toEqual(/[a]/)
      expect(CharacterRegexpUtil.string2regexp("あ")).toEqual(/[あ]/)
    it "word", ->
      expect(CharacterRegexpUtil.string2regexp("abc")).toEqual(/[abc]/)
      expect(CharacterRegexpUtil.string2regexp("あア亜")).toEqual(/[あア亜]/)
    it "char range", ->
      expect(CharacterRegexpUtil.string2regexp("a-z")).toEqual(/[a-z]/)
    it "unicode range", ->
      expect(CharacterRegexpUtil.string2regexp("\\u0020-\\u0040")).toEqual(/[\u0020-\u0040]/)
      expect(CharacterRegexpUtil.string2regexp("\\u0300-\\u0600")).toEqual(/[\u0300-\u0600]/)
      expect(CharacterRegexpUtil.string2regexp("\\u4000-\\u8000")).toEqual(/[\u4000-\u8000]/)
    it "complex", ->
      expect(CharacterRegexpUtil.string2regexp("\\u0020-\\u0040abc")).toEqual(/[\u0020-\u0040abc]/)
      expect(CharacterRegexpUtil.string2regexp("\\u0020-\\u0040a-cあ")).toEqual(/[\u0020-\u0040a-cあ]/)
    it "multi", ->
      expect(CharacterRegexpUtil.string2regexp("a", "b")).toEqual(/[ab]/)
      expect(CharacterRegexpUtil.string2regexp("\\u0020-\\u0040", "a-c", "あ")).toEqual(/[\u0020-\u0040a-cあ]/)
