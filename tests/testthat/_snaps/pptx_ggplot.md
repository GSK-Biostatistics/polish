# polish_content_word().ggplot - partially or incorrectly defined height and width,

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = NA, width = 12)
    Condition
      Error in `polish_content_pptx.ggplot()`:
      ! object 'width_value' not found

---

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = NULL, width = 12)
    Condition
      Error in `polish_content_pptx.ggplot()`:
      ! object 'width_value' not found

---

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = -10, width = 12)
    Condition
      Error in `polish_content_pptx.ggplot()`:
      ! object 'width_value' not found

---

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = c(10, 11), width = 12)
    Condition
      Error in `polish_content_pptx.ggplot()`:
      ! object 'width_value' not found

---

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = "invalid", width = 12)
    Condition
      Error in `polish_content_pptx.ggplot()`:
      ! object 'width_value' not found

