# as_is()

    Code
      polish_content_word(as_is("<a/>"))
    Condition
      Error in `polish_content_word()`:
      ! `x` must be a <w:p> or <w:tbl> node, not <a>.

---

    Code
      polish_content_word(as_is("<a"))
    Condition
      Error in `polish_content_word()`:
      ! Invalid xml
      Caused by error in `read_xml.raw()`:
      ! error parsing attribute name [68]

---

    Code
      polish_content_word(as_is("<a/><w:p/>"))
    Condition
      Error in `polish_content_word()`:
      ! `x` must be a <w:p> or <w:tbl> node, not <a>.

---

    Code
      polish_content_word(as_is("<a/><w:p/><b/>"))
    Condition
      Error in `polish_content_word()`:
      ! `x` must be a <w:p> or <w:tbl> node, not <a> or <b>.

