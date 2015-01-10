UnicodeUtil = require "./unicode-util"
CharacterRegexpUtil = require "./character-regexp-util"

module.exports =
class JapaneseWrapManager
  @characterClasses = require "./character-classes"

  constructor: ->
    @setupCharRegexp()

    configNameList = [
      #'全角句読点ぶら下げ',
      #'半角句読点ぶら下げ',
      #'全角ピリオド/コンマぶら下げ',
      #'半角ピリオド/コンマぶら下げ',
      'characterWidth.greekAndCoptic',
      'characterWidth.cyrillic',
      # 'ASCII文字を禁則処理に含める',
      'lineBreakingRule.halfwidthKatakana',
      'lineBreakingRule.ideographicSpaceAsWihteSpace',
    ]
    for name in configNameList
      configName = 'japanese-wrap.' + name
      atom.config.observe configName, (newValue) =>
        @setupCharRegexp()
    @lineBreakingRuleJapanese =
        atom.config.get('japanese-wrap.lineBreakingRule.japanese')
    atom.config.observe 'japanese-wrap.lineBreakingRule.japanese',
        (newValue) =>
          @lineBreakingRuleJapanese = newValue



  setupCharRegexp: ->
    # debug
    #console.log("run setupCharRegexp")
    if atom.config.get('japanese-wrap.lineBreakingRule.ideographicSpaceAsWihteSpace')
      @whitespaceCharRegexp = /\s/
    else
      # Not incude '　'(U+3000)
      @whitespaceCharRegexp = /[\t\n\v\f\r \u00a0\u2000-\u200b\u2028\u2029]/

    #ascii = atom.config.get('japanese-wrap.ASCII文字を禁則処理に含める')
    hankaku = atom.config.get('japanese-wrap.lineBreakingRule.halfwidthKatakana')
    greek_size = atom.config.get('japanese-wrap.characterWidth.greekAndCoptic')
    cyrillic_size = atom.config.get('japanese-wrap.characterWidth.cyrillic')

    # word charater
    @wordCharRegexp = CharacterRegexpUtil.string2regexp(
        JapaneseWrapManager.characterClasses["Western characters"])

    # Characters Not Starting a Line and Low Surrogate
    # TODO: add 濁音/半濁音
    # TODO: add combine
    notStartingCharList = [
      JapaneseWrapManager.characterClasses["Closing brackets"],
      JapaneseWrapManager.characterClasses["Hyphens"],
      JapaneseWrapManager.characterClasses["Dividing punctuation marks"],
      JapaneseWrapManager.characterClasses["Middle dots"],
      JapaneseWrapManager.characterClasses["Full stops"],
      JapaneseWrapManager.characterClasses["Commas"],
      JapaneseWrapManager.characterClasses["Iteration marks"],
      JapaneseWrapManager.characterClasses["Prolonged sound mark"],
      JapaneseWrapManager.characterClasses["Small kana"],
      CharacterRegexpUtil.range2string(UnicodeUtil.lowSurrogateRange),
    ]
    # TODO
    #if ascii
    #  notStartingCharList.push(
    #    CharacterRegexpUtil.escapeAscii(
    #      JapaneseWrapManager.characterClasses["Closing brackets ASCII"]),
    #    CharacterRegexpUtil.escapeAscii(
    #      JapaneseWrapManager.characterClasses["Dividing punctuation marks ASCII"]),
    #    CharacterRegexpUtil.escapeAscii(
    #      JapaneseWrapManager.characterClasses["Full stops ASCII"]),
    #    CharacterRegexpUtil.escapeAscii(
    #      JapaneseWrapManager.characterClasses["Commas ASCII"]),
    #  )
    if hankaku
      notStartingCharList.push(
        JapaneseWrapManager.characterClasses["Closing brackets HANKAKU"],
        JapaneseWrapManager.characterClasses["Middle dots HANKAKU"],
        JapaneseWrapManager.characterClasses["Full stops HANKAKU"],
        JapaneseWrapManager.characterClasses["Commas HANKAKU"],
        JapaneseWrapManager.characterClasses["Prolonged sound mark HANKAKU"],
        JapaneseWrapManager.characterClasses["Small kana HANKAKU"],
      )
    @notStartingCharRexgep =
        CharacterRegexpUtil.string2regexp(notStartingCharList...)

    # Characters Not Ending a Line and High Surrogate
    notEndingCharList = [
      JapaneseWrapManager.characterClasses["Opening brackets"],
      CharacterRegexpUtil.range2string(UnicodeUtil.highSurrogateRange),
    ]
    # TODO
    #if ascii
    #  notEndingCharList.push(
    #    CharacterRegexpUtil.escapeAscii(
    #      JapaneseWrapManager.characterClasses["Opening brackets ASCII"]),
    #  )
    if hankaku
      notEndingCharList.push(
        JapaneseWrapManager.characterClasses["Opening brackets HANKAKU"],
      )
    @notEndingCharRegexp =
        CharacterRegexpUtil.string2regexp(notEndingCharList...)

    # Character Width
    @zeroWidthCharRegexp = CharacterRegexpUtil.string2regexp(
        "\\u200B-\\u200F",
        CharacterRegexpUtil.range2string(UnicodeUtil.lowSurrogateRange),
        "\\uFEFF",
        CharacterRegexpUtil.range2string(
            UnicodeUtil.getRangeListByName("Combining")...),
        "゙゚", # U+3099, U+309A
    )

    halfWidthCharList = [
      CharacterRegexpUtil.range2string(
          UnicodeUtil.getRangeListByName("Latin")...),
      "\\u2000-\\u200A",
      "\\u2122",
      "\\uFF61-\\uFFDC",
    ]
    if greek_size == 1
      halfWidthCharList.push(CharacterRegexpUtil.range2string(
          UnicodeUtil.getRangeListByName("Greek")...))
    if cyrillic_size == 1
      halfWidthCharList.push(CharacterRegexpUtil.range2string(
          UnicodeUtil.getRangeListByName("Cyrillic")...))
    @halfWidthCharRegexp =
        CharacterRegexpUtil.string2regexp(halfWidthCharList...)
    # /[\u0000-\u036F\u2000-\u2000A\u2122\uD800-\uD83F]/
    # @fullWidthChar = /[^\u0000-\u036F\uFF61-\uFFDC]/

    # Line Adjustment by Hanging Punctuation
    # TODO: 0.2.1...
    #@hangingPunctuationCharRegexp = CharacterRegexpUtil.string2regexp(
    #    JapaneseWrapManager.characterClasses["Full stops"],
    #    JapaneseWrapManager.characterClasses["Commas"])

  # overwrite Display#findWrapColumn()
  overwriteFindWrapColumn: (displayBuffer) ->
    unless displayBuffer.japaneseWrapManager?
      displayBuffer.japaneseWrapManager = @

    unless displayBuffer.originalFindWrapColumn?
      displayBuffer.originalFindWrapColumn = displayBuffer.findWrapColumn

    displayBuffer.findWrapColumn = (line, softWrapColumn=@getSoftWrapColumn()) ->
      # console.log(line)
      return unless @isSoftWrapped()
      # If all characters are full width, the width is twice the length.
      return unless (line.length * 2) > softWrapColumn
      return @japaneseWrapManager.findJapaneseWrapColumn(line, softWrapColumn)

  # restore Display#findWrapColumn()
  restoreFindWrapColumn: (displayBuffer) ->
    if displayBuffer.originalFindWrapColumn?
      displayBuffer.findWrapColumn = displayBuffer.originalFindWrapColumn
      displayBuffer.originalFindWrapColumn = undefined

    if displayBuffer.japaneseWrapManager?
      displayBuffer.japaneseWrapManager = undefined

  # Japanese Wrap Column
  findJapaneseWrapColumn: (line, softWrapColumn) ->
    size = 0
    for wrapColumn in [0...line.length]
      if @zeroWidthCharRegexp.test(line[wrapColumn])
        continue
      else if @halfWidthCharRegexp.test(line[wrapColumn])
        size = size + 1
      else
        size = size + 2

      if size > softWrapColumn
        if @lineBreakingRuleJapanese
          column = @searchBackwardNotEndingColumn(line, wrapColumn)
          if column?
            return column

          column = @searchForwardWhitespaceCutableColumn(line, wrapColumn)
          if not column?
            cutable = false
          else if column == wrapColumn
            cutable = true
          else
            return column

          return @searchBackwardCutableColumn(
              line,
              wrapColumn,
              cutable,
              @wordCharRegexp.test(line[wrapColumn]))
        else
          if @wordCharRegexp.test(line[wrapColumn])
            # search backward for the start of the word on the boundary
            for column in [wrapColumn..0]
              return column + 1 unless @wordCharRegexp.test(line[column])
            return wrapColumn
          else
            # search forward for the start of a word past the boundary
            for column in [wrapColumn..line.length]
              return column unless @whitespaceCharRegexp.test(line[column])
            return line.length

    return

  searchBackwardNotEndingColumn: (line, wrapColumn) ->
    foundNotEndingColumn = null
    for column in [(wrapColumn - 1)..0]
      if @whitespaceCharRegexp.test(line[column])
        continue
      else if @notEndingCharRegexp.test(line[column])
        foundNotEndingColumn = column
      else
        return foundNotEndingColumn
    return

  searchForwardWhitespaceCutableColumn: (line, wrapColumn) ->
    for column in [wrapColumn...line.length]
      unless @whitespaceCharRegexp.test(line[column])
        if @notStartingCharRexgep.test(line[column])
          return null
        else
          return column
    return line.length

  searchBackwardCutableColumn: (line, wrapColumn, cutable, preWord) ->
    for column in [(wrapColumn - 1)..0]
      if @whitespaceCharRegexp.test(line[column])
        if cutable or preWord
          preColumn = @searchBackwardNotEndingColumn(line, column)
          if preColumn?
            preColumn
          else
            return column + 1
      else if @notEndingCharRegexp.test(line[column])
        cutable = true
        if @wordCharRegexp.test(line[column])
          preWord = true
        else
          preWord = false
      else if @notStartingCharRexgep.test(line[column])
        if cutable or preWord
          return column + 1
        else
          cutable = false
          if @wordCharRegexp.test(line[column])
            preWord = true
          else
            preWord = false
      else if @wordCharRegexp.test(line[column])
        if (! preWord) and cutable
          return column + 1
        else
          preWord = true
      else
        if cutable or preWord
          return column + 1
        else
          cutable = true
          preWord = false
    return wrapColumn
