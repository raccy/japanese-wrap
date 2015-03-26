module.exports =
class UnicodeUtil
  @unicode = require('./unicode')

  # Surrogate Charracter Range
  @highSurrogateRange = [0xD800..0xDBFF]
  @lowSurrogateRange = [0xDC00..0xDFFF]

  @getBlockName: (str) ->
    charCode = @unicodeCharCodeAt(str)
    for block in @unicode
      if charCode in block[0]
        return block[1]
    return null

  @getRangeListByName: (name) ->
    rangeList = new Array()
    if !String::includes
      # console.log("String::includes is undefined")
      String::includes = ->
        'use strict'
        String::indexOf.apply(this, arguments) != -1
    for block in @unicode
      if block[1].includes(name)
        rangeList = rangeList.concat([block[0]])
    return rangeList

  @unicodeCharCodeAt: (str, index = 0) ->
    surrogateCount = 0
    for i in [0...index]
      if str.charCodeAt(i + surrogateCount) in @highSurrogateRange
        surrogateCount += 1
    index += surrogateCount
    charCode = str.charCodeAt(index)
    # Surrogete pair
    if charCode in @highSurrogateRange
      charCodeHigh = charCode
      charCodeLow = str.charCodeAt(index + 1)
      if charCodeLow in @lowSurrogateRange
        charCode = 0x10000 +
                   (charCodeHigh - 0xD800) * 0x400 +
                   charCodeLow - 0xDC00
    return charCode
