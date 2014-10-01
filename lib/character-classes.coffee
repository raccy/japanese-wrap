# W3C - Requirements for Japanese Text Layout
# Appendix A Character Classes
# http://www.w3.org/TR/jlreq/#character_classes
module.exports =
{
  # A.1 Opening brackets (cl-01)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  "Opening brackets": "‘“（〔［｛〈《「『【｟〘〖«〝＜"
  # add "<" (U+003C LESS-THAN SIGN SIGN)
  "Opening brackets ASCII": "([{<" # ([{<
  "Opening brackets HANKAKU": "｢"

  # A.2 Closing brackets (cl-02)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  "Closing brackets": "’”）〕］｝〉》」』】｠〙〗»〟＞"
  # add ">" (U+003E GREATER-THAN)
  "Closing brackets ASCII": ")]}>" # )]}>
  "Closing brackets HANKAKU": "｣"

  # A.3 Hyphens (cl-03)
  # U+2010, U+301C, U+30A0, U+2013
  # add "－" (U+FF0D FULLWIDTH HYPHEN-MINUS), "～" (U+FF5E FULLWIDTH TILDE)
  "Hyphens": "‐〜゠–－～"
  # add "-" (U+002D HYPHEN-MINUS), "~" (U+̃007E TILDE)
  "Hyphens ASCII": "-~"

  # A.4 Dividing punctuation marks (cl-04)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  "Dividing punctuation marks": "！？‼⁇⁈⁉"
  "Dividing punctuation marks ASCII": "!?"

  # A.5 Middle dots (cl-05)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  # TODO: Disscuss "·" (U+00B7 MIDDLE DOT)
  "Middle dots": "・：；"
  "Middle dots ASCII": ":;"
  "Middle dots HANKAKU": "･"
  # A.6 Full stops (cl-06)
  "Full stops": "。．"
  "Full stops ASCII": "."
  "Full stops HANKAKU": "｡"
  # A.7 Commas (cl-07)
  "Commas": "、，"
  "Commas ASCII": ","
  "Commas HANKAKU": "､"
  # A.8 Inseparable characters (cl-08)
  # "—" (U+2014) is EM DASH, is not HYPHEN-MINUS(ASCII)
  # add "―" (U+2015 HORIZONTAL BAR)
  "Inseparable characters": "—―…‥"
  "Inseparable characters sets": ["〳〵", "〴〵"] # Array
  # A.9 Iteration marks (cl-09)
  "Iteration marks": "ヽヾゝゞ々〻"
  # A.10 Prolonged sound mark (cl-10)
  "Prolonged sound mark": "ー"
  "Prolonged sound mark HANKAKU": "ｰ"
  # A.11 Small kana (cl-11)
  # Not include "ㇷ゚" (U+31F7, U+309A)
  "Small kana": "ぁぃぅぇぉァィゥェォっゃゅょゎゕゖッャュョヮヵヶㇰㇱㇲㇳㇴㇵㇶㇷㇸㇹㇺㇻㇼㇽㇾㇿ"
  "Small kana HANKAKU": "ｧｨｩｪｫｬｭｮｯ"
  # A.12 Prefixed abbreviations (cl-12)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  # "¥" (U+00A5) is YEN SIGN, is not REVERSE SOLIDUS(ASCII)
  # add "¤" (U+00A4) CURRENCY SIGN
  # add "₩" (U+20A9) WON SIGN
  # add FULLWIDTH ￡￥￦
  "Prefixed abbreviations": "¥＄£€¤₩￡￥￦" + "№＃"
  "Prefixed abbreviations ASCII": "\\$" + "#"
  # KANJI
  # TODO: add...
  "Prefixed abbreviations KANJI": ""
  # A.13 Postfixed abbreviations (cl-13)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  # "°" (U+00B0 DEGREE SIGN) is not KATKANAｰHIRAGAN SEMI-VOICED SOUND MARK
  # add ‱℉ℊΩKÅ
  # add ¢ (U+00A2 CENT SIGN)
  # add ￠(U+FFE0 FULLWIDTH CENT SIGN)
  # add U+3300-U+3357 U+3371-U+337A U+3380-U+33DF CJK Compatibility SQURE *
  #   inculde "㏋㌃㌍㌔㌘㌢㌣㌦㌧㌫㌶㌻㍉㍊㍍㍑㍗㎎㎏㎜㎝㎞㎡㏄"
  "Postfixed abbreviations": "°′″℃％‰‱ℓ℉ℊΩKÅ" +
      "\\u3300-\\u3377\\u3371-\\u337A\\u3380-\\u33DF" +
      "¢￠"
  "Postfixed abbreviations ASCII": "%" # %
  # KANJI
  # TODO: add...
  "Postfixed abbreviations KANJI": ""

  # A.14 Full-width ideographic space (cl-14)
  "Full-width ideographic space": "　" # U+3000

  # A.15 Hiragana (cl-15)
  # add small kana
  # not include combine
  "Hiragana": "\\u3041-\\u3096"

  # A.16 Katakana (cl-16)
  # add small kana
  # not include combine
  "Katakana": "\\u30A1-\\u30FA"

  # A.17 Math symbols (cl-17)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  # add U+2200-U+22FF Mathematical Operators
  #   include most math symbols
  #   exclude "−" (U+2212) "∓" (U+2213)
  "Math symbols": "＝＜＞\\u2200-\\u2211\\u2214-\\u22FF⇒⇔↔"
  "Math symbols ASCII": "=<>"

  # A.18 Math operators (cl-18)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  # add MINUS-HYPHEN
  "Math symbols": "＋−×÷±∓－"
  "Math symbols ASCII": "+-"

  # A.19 Ideographic characters (cl-19)
  # TODO: all KANJI?
  # A.20 Characters as reference marks (cl-20)
  # A.21 Ornamented character complexes (cl-21)
  # A.22 Simple-ruby character complexes (cl-22)
  # A.23 Jukugo-ruby character complexes (cl-23)

  # A.24 Grouped numerals (cl-24)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  "Grouped numerals": "　，．０１２３４５６７８９"
  "Grouped numerals ASCII": " ,.0123456789"

  # A.25 Unit symbols (cl-25)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  "Unit symbols": "　（）／１−４Ａ-Ｚａ-ｚΩμ℧Å−・"
  "Unit symbols ASCII": " ()/1234" +
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
      "abcdefghijklmnopqrstuvwxyz"

  # A.26 Western word space (cl-26)
  "Western word space": "\\u0020"

  # A.27 Western characters (cl-27)
  # TODO: add over U+2000 chars and FULLWIDTH
  "Western characters": "\\u0021-\\u007E\\u00A0-\\u1FFF"

  # A.28 Warichu opening brackets (cl-28)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  "Warichu opening brackets": "（〔［"
  "Warichu opening brackets ASCII": "(["

  # A.29 Warichu closing brackets (cl-29)
  # Basic Latin -> Halfwidth and Fullwidth Forms
  "Warichu closing brackets": "）〕］"
  "Warichu closing brackets ASCII": ")]"

  # A.30 Characters in tate-chu-yoko (cl-30)
}
