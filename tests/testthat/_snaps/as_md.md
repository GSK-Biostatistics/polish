# polish_content_word.as_md()

    Code
      polish_content_word(as_md("*hello*"))
    Output
      <w:p>
        <w:pPr/>
        <w:r>
          <w:rPr>
            <w:i/>
          </w:rPr>
          <w:t xml:space="preserve">hello</w:t>
        </w:r>
      </w:p>

# polish_content_pptx.as_md()

    Code
      polish_content_pptx(as_md("*hello*"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="0" indent="0">
              <a:buNone/>
            </a:pPr>
            <a:r>
              <a:rPr i="1"/>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("__hello__"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="0" indent="0">
              <a:buNone/>
            </a:pPr>
            <a:r>
              <a:rPr b="1"/>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("## hello"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:r>
            <a:t>
              <text xml:space="preserve">hello</text>
            </a:t>
          </a:r>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("- hello"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("- hello\n- world!"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:r>
              <a:t>world!</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("- hello\n- *world*!"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:r>
              <a:rPr i="1"/>
              <a:t>world</a:t>
            </a:r>
            <a:r>
              <a:t>!</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("- hello\n    - world!"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr lvl="1"/>
            <a:r>
              <a:t>world!</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("- hello\n    - *world*!"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr lvl="1"/>
            <a:r>
              <a:rPr i="1"/>
              <a:t>world</a:t>
            </a:r>
            <a:r>
              <a:t>!</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("1. hello"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("1. hello\n2. world!"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>world!</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("1. hello\n2. *world*!"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:rPr i="1"/>
              <a:t>world</a:t>
            </a:r>
            <a:r>
              <a:t>!</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("1. hello\n    1. world!"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="1028700" indent="-514350" lvl="1">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>world!</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md("1. hello\n    1. *world*!"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>hello</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="1028700" indent="-514350" lvl="1">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:rPr i="1"/>
              <a:t>world</a:t>
            </a:r>
            <a:r>
              <a:t>!</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(as_md(
        "markdown is defined at [this website](https://daringfireball.net/projects/markdown/)"))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="0" indent="0">
              <a:buNone/>
            </a:pPr>
            <a:r>
              <a:t>markdown is defined at </a:t>
            </a:r>
            <a:r>
              <a:rPr>
                <a:hlinkClick r:id="https://daringfireball.net/projects/markdown/"/>
              </a:rPr>
              <a:t>this website</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

# Expected Errors

    Code
      polish_content_pptx(as_md("![subtext](man/figures/logo.png)"))
    Condition
      Error in `format_pptx_xml[[node]]()`:
      ! Images cannot be added via markdown formatting because images cannot be inline with text. Use as_file() instead.

