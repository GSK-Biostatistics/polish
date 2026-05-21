# polish 0.3.1
* surface gt as_word argument autonum in polish_content_word.gt_tbl

# polish 3.0.0
* Open source the package

# polish 0.2.4

* Add running garbage collector after magick PDF conversion
* Allow ability to pass keep_with_next option to gt::as_word
* Allow for lists for pptx to be none, ordered, and unordered

# polish 0.2.3

* adjust autofit_ft to handle cases where rows for a row are completely missing values


# polish 0.2.2

* Adjust tests to changes in officer
* Add `as_xml_node_word()` and `as_xml_node_pptx()` functions
* `as_xml*()` functions do `glue::glue()` interpolation
* New function `show_xml()` for internal needs of exploring the 
  structure of an xml nodeset in the browser. 
* update `polish_content_word.as_is()` to handle cases where the user is passing multiple nodes

# polish 0.2.1

* Add `as_md()` function to allow writing simple markdown.
* Add ability to polish lists into ordered and un-ordered list content. 
* Add ability to style data.frame table styling same as with flextables.
* Add ability to polish gt_group objects to word documents.


# polish 0.2.0

* Update powerpoint polishing for data.frames to use flextable
* Correct flextable vertical centering algorithm
* Add ability to set text formatting (font, size, color, typeface)
* Add ability to set flextable table styling on polishing in PPTX outputs
* Improve png offsets
* Record original placeholder dimensions when polishing for future use

# polish 0.1.0

* Initial release of polish
* Moving polishing methods out of sparkle for word
* Create polishing methods for pptx
