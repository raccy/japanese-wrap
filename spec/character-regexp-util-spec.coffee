CharacterRegexpUtil = require '../lib/character-regexp-util'

describe "CharacterRegexpUtil", ->
  describe "CharacterRegexpUtil.range2string()", ->
    it "range", ->
      expect(CharacterRegexpUtil.range2string([0x20..0x40])).
          toEqual("\\u0020-\\u0040")
      expect(CharacterRegexpUtil.range2string([0x300..0x600])).
          toEqual("\\u0300-\\u0600")
      expect(CharacterRegexpUtil.range2string([0x4000..0x8000])).
          toEqual("\\u4000-\\u8000")
      expect(CharacterRegexpUtil.range2string([0x12AB..0x34CD])).
          toEqual("\\u12AB-\\u34CD")
    it "over 0x10000", ->
      expect(CharacterRegexpUtil.range2string([0x10000..0x10FFFF])).
          toEqual("\\uD800-\\uDBFF")
      expect(CharacterRegexpUtil.range2string([0xFF00..0x20000])).
          toEqual("\\uFF00-\\uFFFF\\uD800-\\uD840")
      expect(CharacterRegexpUtil.range2string([0x20000..0xFFFFF])).
          toEqual("\\uD840-\\uDBBF")
      expect(CharacterRegexpUtil.range2string([0x100000..0x10FFFF])).
          toEqual("\\uDBC0-\\uDBFF")
    it "ranges", ->
      expect(CharacterRegexpUtil.range2string(
          [0x20..0x40],
          [0x300..0x600])).
              toEqual("\\u0020-\\u0040\\u0300-\\u0600")
      expect(CharacterRegexpUtil.range2string(
          [0x20..0x40],
          [0x300..0x600],
          [0x4000..0x8000],
          [0x10000..0x10FFFF])).
              toEqual("\\u0020-\\u0040\\u0300-\\u0600\\u4000-\\u8000\\uD800-\\uDBFF")

  describe "CharacterRegexpUtil.range2regexp()", ->
    it "range", ->
      expect(CharacterRegexpUtil.range2regexp([0x20..0x40])).
          toEqual(/[\u0020-\u0040]/)
      expect(CharacterRegexpUtil.range2regexp([0x300..0x600])).
          toEqual(/[\u0300-\u0600]/)
      expect(CharacterRegexpUtil.range2regexp([0x4000..0x8000])).
          toEqual(/[\u4000-\u8000]/)
      expect(CharacterRegexpUtil.range2regexp([0x12AB..0x34CD])).
          toEqual(/[\u12AB-\u34CD]/)
    it "over 0x10000", ->
      expect(CharacterRegexpUtil.range2regexp([0x10000..0x10FFFF])).
          toEqual(/[\uD800-\uDBFF]/)
    it "ranges", ->
      expect(CharacterRegexpUtil.range2regexp(
          [0x20..0x40],
          [0x300..0x600])).
              toEqual(/[\u0020-\u0040\u0300-\u0600]/)

  describe "CharacterRegexpUtil.string2regexp()", ->
    it "single char", ->
      expect(CharacterRegexpUtil.string2regexp("a")).
          toEqual(/[a]/)
      expect(CharacterRegexpUtil.string2regexp("あ")).
          toEqual(/[あ]/)
    it "word", ->
      expect(CharacterRegexpUtil.string2regexp("abc")).
          toEqual(/[abc]/)
      expect(CharacterRegexpUtil.string2regexp("あア亜")).
          toEqual(/[あア亜]/)
    it "char range", ->
      expect(CharacterRegexpUtil.string2regexp("a-z")).
          toEqual(/[a-z]/)
    it "unicode range", ->
      expect(CharacterRegexpUtil.string2regexp("\\u0020-\\u0040")).
          toEqual(/[\u0020-\u0040]/)
      expect(CharacterRegexpUtil.string2regexp("\\u0300-\\u0600")).
          toEqual(/[\u0300-\u0600]/)
      expect(CharacterRegexpUtil.string2regexp("\\u4000-\\u8000")).
          toEqual(/[\u4000-\u8000]/)
    it "complex", ->
      expect(CharacterRegexpUtil.string2regexp("\\u0020-\\u0040abc")).
          toEqual(/[\u0020-\u0040abc]/)
      expect(CharacterRegexpUtil.string2regexp("\\u0020-\\u0040a-cあ")).
          toEqual(/[\u0020-\u0040a-cあ]/)
    it "multi", ->
      expect(CharacterRegexpUtil.string2regexp("a", "b")).
          toEqual(/[ab]/)
      expect(CharacterRegexpUtil.string2regexp("\\u0020-\\u0040", "a-c", "あ")).
          toEqual(/[\u0020-\u0040a-cあ]/)

  describe "CharacterRegexpUtil.combineRegexp()", ->
    it "single", ->
      expect(CharacterRegexpUtil.combineRegexp(/あ/)).
          toEqual(/[あ]/)
      expect(CharacterRegexpUtil.combineRegexp(/[あア亜]/)).
          toEqual(/[あア亜]/)
      expect(CharacterRegexpUtil.combineRegexp(/[\u0020-\u0040]/)).
          toEqual(/[\u0020-\u0040]/)
    it "multi", ->
      expect(CharacterRegexpUtil.combineRegexp(/a/, /[bc]/)).
          toEqual(/[abc]/)
      expect(CharacterRegexpUtil.combineRegexp(/[\u0020-\u0040]/, /[a-c]/, /[あ]/)).
          toEqual(/[\u0020-\u0040a-cあ]/)

  describe "CharacterRegexpUtil.code2uchar()", ->
    it "code < 0x1000", ->
      expect(CharacterRegexpUtil.code2uchar(0x2)).
          toEqual("\\u0002")
      expect(CharacterRegexpUtil.code2uchar(0x20)).
          toEqual("\\u0020")
      expect(CharacterRegexpUtil.code2uchar(0x200)).
          toEqual("\\u0200")
      expect(CharacterRegexpUtil.code2uchar(0x2000)).
          toEqual("\\u2000")
    it "code >= 0x1000", ->
      expect(CharacterRegexpUtil.code2uchar(0x10000)).
          toEqual("\\uD800")
      expect(CharacterRegexpUtil.code2uchar(0x10001)).
          toEqual("\\uD800")
      expect(CharacterRegexpUtil.code2uchar(0x10399)).
          toEqual("\\uD800")
      expect(CharacterRegexpUtil.code2uchar(0x10400)).
          toEqual("\\uD801")
      expect(CharacterRegexpUtil.code2uchar(0x12000)).
          toEqual("\\uD808")
      expect(CharacterRegexpUtil.code2uchar(0x102000)).
          toEqual("\\uDBC8")
      expect(CharacterRegexpUtil.code2uchar(0x10FFFF)).
          toEqual("\\uDBFF")
    it "no code", ->
      expect(CharacterRegexpUtil.code2uchar(NaN)).
          toEqual("")
      expect(CharacterRegexpUtil.code2uchar(-1)).
          toEqual("")
      expect(CharacterRegexpUtil.code2uchar(0x110000)).
          toEqual("")

  describe "CharacterRegexpUtil.char2uchar()", ->
    it "code < 0x1000", ->
      expect(CharacterRegexpUtil.char2uchar(" ")).
          toEqual("\\u0020")
      expect(CharacterRegexpUtil.char2uchar("あ")).
          toEqual("\\u3042")
      expect(CharacterRegexpUtil.char2uchar("ｱ")).
          toEqual("\\uFF71")
    it "code >= 0x1000", ->
      expect(CharacterRegexpUtil.char2uchar("𠮷")).
          toEqual("\\uD842")

  describe "CharacterRegexpUtil.escapeAscii()", ->
    it "single", ->
      expect(CharacterRegexpUtil.escapeAscii("a")).
          toEqual("\\u0061")
      expect(CharacterRegexpUtil.escapeAscii("A")).
          toEqual("\\u0041")
      expect(CharacterRegexpUtil.escapeAscii(" ")).
          toEqual("\\u0020")
      expect(CharacterRegexpUtil.escapeAscii("!")).
          toEqual("\\u0021")
      expect(CharacterRegexpUtil.escapeAscii("\\")).
          toEqual("\\u005C")
      expect(CharacterRegexpUtil.escapeAscii("*")).
          toEqual("\\u002A")
    it "word", ->
      expect(CharacterRegexpUtil.escapeAscii("aA ")).
          toEqual("\\u0061\\u0041\\u0020")
