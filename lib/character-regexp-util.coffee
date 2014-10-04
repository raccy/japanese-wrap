module.exports =
class CharaterRegexpUtil

  @combineRegexp: (regexpList...) ->
    regexpString = ""
    regexpString += "["
    for regexp in regexpList
      str = regexp.source
      if str.length == 0
        continue
      if str.startsWith("[") and str.endsWith("]")
        regexpString += str.substr(1, str.length - 2)
      else
        regexpString += str
    regexpString += "]"
    return new RegExp(regexpString)

  @string2regexp: (strList...) ->
    regexpString = ""
    regexpString += "["
    for str in strList
      regexpString += str
    regexpString += "]"
    return new RegExp(regexpString)

  @code2uchar: (code) ->
    str = "\\u"
    if code < 0
      # no Unicode code
      return ""
    else if code < 0x10
      str += "000"
    else if code < 0x100
      str += "00"
    else if code < 0x1000
      str += "0"
    else if code < 0x10000
      # do nothing
    else if code < 0x110000
      # only High Surrogate
      # Math.log2(0x400) == 10 -> true
      # (x >> 10) == (x - x % 0x400) / 0x400 -> true
      code = ((code - 0x10000) >> 10) + 0xD800
    else
      # no Unicode code
      return ""
    str += code.toString(16).toUpperCase()
    return str

  @char2uchar: (char) ->
    return @code2uchar(char.charCodeAt(0))

  @range2string: (rangeList...) ->
    str = ""
    for range in rangeList
      firstCode = range[0]
      lastCode = range[range.length - 1]
      if lastCode < 0x10000 || firstCode >= 0x10000
        str += @code2uchar(firstCode) + "-" + @code2uchar(lastCode)
      else
        str += @code2uchar(firstCode) + "-" + @code2uchar(0xFFFF) +
          @code2uchar(0x10000) + "-" + @code2uchar(lastCode)
    return str

  @range2regexp: (rangeList...) ->
    return @string2regexp(@range2string(rangeList...))

  @escapeAscii: (str) ->
    escape_str = ""
    for i in [0...str.length]
      escape_str += @code2uchar(str.charCodeAt(i))
    return escape_str
