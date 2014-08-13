
module.exports =
class JapaneseWrapManager
  constructor: ->
    # Surrogate
    # High U+D800 - U+DBFF
    # Low U+DC00 - U+DFFF
    # D800 D840 D880 D8C0 D900 D940 D980 D9C0
    # DA00 DA40 DA80 DAC0 DB00 DB40 DB80 DBC0
    @highSurrogateChar = /[\uD800-\uDBFF]/
    @highSurrogateHalfWidthChar = /[\uD800-\uD83F]/ # 1xxxx
    @highSurrogateFullWdithChar = /[\uD840-\uDBFF]/ # 2xxxx - 10xxxx
    @lowSurrogateChar = /[\uDC00-\uDFFF]/

    # Not incude '　'(U+3000)
    @whitespaceChar = /[\t\n\v\f\r \u00a0\u2000-\u200b\u2028\u2029]/
    # TODO
    @unbreakbleChar = /[—…‥]/
    @europeanNumeralChar = /[\d.,]/

    # W3C - Requirements for Japanese Text Layout
    # Appendix A Character Classes
    # http://www.w3.org/TR/jlreq/#character_classes

    # A.1 Opening brackets (cl-01)
    # Basic Latin -> Halfwidth and Fullwidth Forms
    @openingBracketChar = /[‘“（〔［｛〈《「『【｟〘〖«〝]/
    # A.2 Closing brackets (cl-02)
    # Basic Latin -> Halfwidth and Fullwidth Forms
    @closingBracketChar = /[’”）〕］｝〉》」』】｠〙〗»〟]/
    # A.3 Hyphens (cl-03)
    # U+2010, U+301C, U+30A0, U+2013
    @hyphenChar = /[‐〜゠–]/
    # A.4 Dividing punctuation marks (cl-04)
    # Basic Latin -> Halfwidth and Fullwidth Forms
    @dividingPunctuationChar = /[！？‼⁇⁈⁉]/
    # A.5 Middle dots (cl-05)
    # Basic Latin -> Halfwidth and Fullwidth Forms
    @middleDotChar = /[・：；]/
    # A.6 Full stops (cl-06)
    @fullStopChar = /[。．]/
    # A.7 Commas (cl-07)
    @commaChar = /[、，]/
    # A.8 Inseparable characters (cl-08)
    # TODO: wrong rule '〳〴〵'
    @inseparableChar = /[—…‥〳〴〵]/
    # A.9 Iteration marks (cl-09)
    @iterationMarkChar = /[ヽヾゝゞ々〻]/
    # A.10 Prolonged sound mark (cl-10)
    @prolongedSoundMarkChar = /ー/
    # A.11 Small kana (cl-11)
    # Not include 'ㇷ゚'(U+31F7, U+309A)
    @smallKanaChar = /[ぁぃぅぇぉァィゥェォっゃゅょゎゕゖッャュョヮヵヶㇰㇱㇲㇳㇴㇵㇶㇷㇸㇹㇺㇻㇼㇽㇾㇿ]/
    # A.12 Prefixed abbreviations (cl-12)
    @prefAbbrChar = /[¥$£#€№]/
    # A.13 Postfixed abbreviations (cl-13)
    @postAbbrChar = /[°′″℃¢%‰㏋ℓ㌃㌍㌔㌘㌢㌣㌦㌧㌫㌶㌻㍉㍊㍍㍑㍗㎎㎏㎜㎝㎞㎡㏄]/
    # A.14 Full-width ideographic space (cl-14)
    @ideographicSpaceChar = /\u3000/ # '　'(U+3000)
    # A.27 Western characters (cl-27)
    @westernChar = /[\u0021-\u007E\u00A0-\u1FFF]/

    # Characters Not Starting a Line and Low Surrogate
    @notStartingChar = new RegExp(
        @closingBracketChar.source + "|"  +
        @hyphenChar.source + "|" +
        @dividingPunctuationChar.source + "|" +
        @middleDotChar.source + "|" +
        @fullStopChar.source + "|" +
        @commaChar.source + "|" +
        @iterationMarkChar.source + "|" +
        @prolongedSoundMarkChar.source + "|" +
        @smallKanaChar.source + "|" +
        @lowSurrogateChar.source
    )
    # Characters Not Ending a Line and High Surrogate
    @notEndingChar = new RegExp(
        @openingBracketChar.source + "|" +
        @highSurrogateChar.source
    )

    # Character Width
    @zeroWidthChar = /[\u200B-\u200F\uDC00-\uDFFF\uFEFF]/
    @halfWidthChar = /[\u0000-\u036F\u2000-\u2000A\u2122\uD800-\uD83F\uFF61-\uFFDC]/
    # @fullWidthChar = /[^\u0000-\u036F\uFF61-\uFFDC]/

  # overwrite Display#findWrapColumn()
  overwriteFindWrapColumn: (displayBuffer) ->
    unless displayBuffer.japaneseWrapManager?
      displayBuffer.japaneseWrapManager = @

    unless displayBuffer.originalFindWrapColumn?
      displayBuffer.originalFindWrapColumn = displayBuffer.findWrapColumn

    displayBuffer.findWrapColumn = (line, softWrapColumn=@getSoftWrapColumn()) ->
      return unless @softWrap
      return @japaneseWrapManager.findJapaneseWrapColumn(line, softWrapColumn)

  # restore Display#findWrapColumn()
  restoreFindWrapColumn: (displayBuffer) ->
    if displayBuffer.originalFindWrapColumn?
      displayBuffer.findWrapColumn = displayBuffer.originalFindWrapColumn
      displayBuffer.originalFindWrapColumn = undefined

    if displayBuffer.japaneseWrapManager?
      displayBuffer.japaneseWrapManager = undefined

  # Japanese Wrap Column
  findJapaneseWrapColumn: (line, sotfWrapColumn) ->
    # If all characters are full width, the width is twice the length.
    return unless (line.length * 2) > sotfWrapColumn
    size = 0
    for wrapColumn in [0...line.length]
      if @zeroWidthChar.test(line[wrapColumn])
        continue
      else if @halfWidthChar.test(line[wrapColumn])
        size = size + 1
      else
        size = size + 2

      if size > sotfWrapColumn
        if @notEndingChar.test(line[wrapColumn - 1])
          # search backward for the not ending character
          for column in [(wrapColumn - 1)...0]
            return column unless @notEndingChar.test(line[column - 1])
          return wrapColumn
        else if @whitespaceChar.test(line[wrapColumn])
          # search forward for the start of a word past the boundary
          for column in [wrapColumn...line.length]
            return column unless @whitespaceChar.test(line[column])
          return line.length
        else if @westernChar.test(line[wrapColumn])
          # search backward for the start of the word on the boundary
          for column in [wrapColumn..0]
            return column + 1 unless @westernChar.test(line[column])
          return wrapColumn
        else if @notStartingChar.test(line[wrapColumn])
          # Character Not Starting a Line
          for column in [wrapColumn...0]
            return column unless @notStartingChar.test(line[column])
          return wrapColumn
        else
          return wrapColumn
    return
