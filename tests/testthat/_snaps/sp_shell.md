# sp_shell()

    Code
      sp_shell("<p:ph/>")
    Output
      <p:sp>
        <p:ph/>
      </p:sp>

---

    Code
      sp_shell("<ph/>")
    Condition
      Error in `sp_shell()`:
      ! Nodes must be in the 'p:' namespace.
      i node 1 is <ph>.

---

    Code
      sp_shell("<ph/")
    Condition
      Error in `sp_shell()`:
      ! Invalid xml
      Caused by error in `read_xml.raw()`:
      ! error parsing attribute name [68]

