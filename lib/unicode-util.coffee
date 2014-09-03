module.exports =
class UnicodeUtil
  @unicode = require('./unicode.coffee')

  @string2regexp: (strList...) ->
    regexpString = ""
    regexpString += "["
    for str in strList
      regexpString += str
    regexpString += "]"
    return new RegExp(regexpString)

  @range2string: (range) ->
    firstCode = range[0]
    lastCode = firstCode + range.length - 1
    str = ""
    str += "\\u"
    if firstCode < 0x10
      str += "000"
    else if firstCode < 0x100
      str += "00"
    else if firstCode < 0x1000
      str += "0"
    str += firstCode.toString(16).toUpperCase()
    str += "-\\u"
    if lastCode < 0x10
      str += "000"
    else if lastCode < 0x100
      str += "00"
    else if lastCode < 0x1000
      str += "0"
    str += lastCode.toString(16).toUpperCase()
    return str

  @range2regexp: (range) ->
    return @string2regexp(@range2string(range))

  @getBlockName: (str) ->
    charCode = str.charCodeAt()
    # Surrogete pair
    if charCode in [0xD800..0xDBFF]
      charCodeHigh = charCode
      charCodeLow = str.charCodeAt(1)
      if charCodeLow in [0xDC00..0xDFFF]
        charCode = 0x10000 + (charCodeHigh - 0xD800) * 0x400 + (charCodeLow - 0xDC00);
    for block in @unicode
      if charCode in block[0]
        return block[1]
    return null
