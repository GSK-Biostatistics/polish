# polish_content_word().ggplot - partially or incorrectly defined height and width,

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = NA, width = 12)
    Condition
      Error in `polish_content_pptx()`:
      ! `height` and `width` must both be set if defining the plot size, and be positive numeric values.
      i You've supplied for `height` a <logical> vector with value NA.
      i You've supplied for `width` a <numeric> vector with value 12.

---

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = NULL, width = 12)
    Condition
      Error in `polish_content_pptx()`:
      ! `height` and `width` must both be set if defining the plot size, and be positive numeric values.
      i You've supplied for `height` a <NULL> vector with value "NULL".
      i You've supplied for `width` a <numeric> vector with value 12.

---

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = -10, width = 12)
    Condition
      Error in `polish_content_pptx()`:
      ! `height` and `width` must both be set if defining the plot size, and be positive numeric values.
      i You've supplied for `height` a <numeric> vector with value -10.
      i You've supplied for `width` a <numeric> vector with value 12.

---

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = c(10, 11), width = 12)
    Condition
      Error in `polish_content_pptx()`:
      ! `height` and `width` must both be set if defining the plot size, and be positive numeric values.
      i You've supplied for `height` a <numeric> vector with value 10 and 11.
      i You've supplied for `width` a <numeric> vector with value 12.

---

    Code
      polish_content_pptx(p, ph = ph_dims_unset, height = "invalid", width = 12)
    Condition
      Error in `polish_content_pptx()`:
      ! `height` and `width` must both be set if defining the plot size, and be positive numeric values.
      i You've supplied for `height` a <character> vector with value "invalid".
      i You've supplied for `width` a <numeric> vector with value 12.

