# polish_content() fails with wrong type

    Code
      polish_content("", type = "xml")
    Condition <rlang_error>
      Error in `polish_content()`:
      ! `type` must be one of "word" or "pptx", not "xml".

# polish_content() fails on unknown class

    Code
      polish_content(foo, type = "word")
    Condition <polish_content_word_error>
      Error in `polish_content()`:
      ! Cannot polish content for word documents.
      Caused by error in `polish_content_word()`:
      ! No available method for objects of type <foo>.

---

    Code
      polish_content(foo, type = "pptx")
    Condition <polish_content_pptx_error>
      Error in `polish_content()`:
      ! Cannot polish content for pptx documents.
      Caused by error in `polish_content_pptx()`:
      ! No available method for objects of type <foo>.

# polish_content(type=) is mandatory

    Code
      polish_content(42)
    Condition
      Error in `polish_content()`:
      ! `type` must be one of "word" or "pptx", not absent.

# polish_content() fails on files with unknown extensions

    Code
      polish_content(file, type = "word")
    Condition <polish_content_word_error>
      Error in `polish_content()`:
      ! Cannot polish content for word documents.
      Caused by error in `polish_content_word()`:
      ! No available method for `.foo` files.

---

    Code
      polish_content(file, type = "pptx")
    Condition <polish_content_pptx_error>
      Error in `polish_content()`:
      ! Cannot polish content for pptx documents.
      Caused by error in `polish_content_pptx()`:
      ! No available method for `.foo` files.

# polish_content() checks that the method returns an xml_nodeset

    Code
      polish_content(foo, type = "word")
    Condition
      Error in `polish_content()`:
      ! Polished content must be an <xml_nodeset> object, not a string.
      i Check the `polish_content_word()` method objects of class <>.
        => polish_content_word.foo
        * polish_content_word.default

---

    Code
      polish_content(bar, type = "word")
    Condition
      Error in `polish_content()`:
      ! Polished content must be an <xml_nodeset> object, not a string.
      i Check the `polish_content_word()` method objects of class <>.
        => polish_content_word.bar
        -> polish_content_word.foo
        * polish_content_word.default

---

    Code
      polish_content(foo, type = "pptx")
    Condition
      Error in `polish_content()`:
      ! Polished content must be an <xml_nodeset> object, not a string.
      i Check the `polish_content_pptx()` method objects of class <>.
        => polish_content_pptx.foo
        * polish_content_pptx.default

---

    Code
      polish_content(bar, type = "pptx")
    Condition
      Error in `polish_content()`:
      ! Polished content must be an <xml_nodeset> object, not a string.
      i Check the `polish_content_pptx()` method objects of class <>.
        => polish_content_pptx.bar
        -> polish_content_pptx.foo
        * polish_content_pptx.default

