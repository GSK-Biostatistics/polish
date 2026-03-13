# as_xml_nodeset() checks it's nodes

    Code
      as_xml_nodeset("hello")
    Condition
      Error in `as_xml_nodeset()`:
      ! `x` must be an xml node.

---

    Code
      as_xml_nodeset("<hello")
    Condition
      Error in `as_xml_nodeset()`:
      ! Invalid xml
      Caused by error in `read_xml.raw()`:
      ! error parsing attribute name [68]

