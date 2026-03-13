# lists can be converted into bulleted lists - pptx

    Code
      polish_content_pptx.list(simple_list)
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:t>These</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:t>are</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:t>separate</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:t>bullets</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx.list(simple_list, list_type = "ordered")
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
              <a:t>These</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>are</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>separate</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>bullets</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx.list(nested_list)
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:t>Non indented bullet 1</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="1028700" indent="-514350"/>
            <a:r>
              <a:t>indentet bullet 1</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="1028700" indent="-514350"/>
            <a:r>
              <a:t>indented bullet 2</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:t>Non indented bullet 2</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx.list(nested_list, list_type = "ordered")
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
              <a:t>Non indented bullet 1</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="1028700" indent="-514350" lvl="1">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>indentet bullet 1</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="1028700" indent="-514350" lvl="1">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>indented bullet 2</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="+mj-lt"/>
              <a:buAutoNum type="arabicPeriod"/>
            </a:pPr>
            <a:r>
              <a:t>Non indented bullet 2</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

# lists can be converted into indented text if content is text, numeric, or md - pptx

    Code
      polish_content_pptx.list(success_list, list_type = "none")
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:t>These</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:t>1</a:t>
            </a:r>
          </a:p>
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

# lists can be converted into bulleted lists if content is text, numeric, or md - pptx

    Code
      polish_content_pptx.list(success_list, list_type = "unordered")
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="Arial" panose="020B0604020202020204" pitchFamily="34" charset="0"/>
              <a:buChar char="•"/>
            </a:pPr>
            <a:r>
              <a:t>These</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350">
              <a:buFont typeface="Arial" panose="020B0604020202020204" pitchFamily="34" charset="0"/>
              <a:buChar char="•"/>
            </a:pPr>
            <a:r>
              <a:t>1</a:t>
            </a:r>
          </a:p>
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

# lists can be converted into bulleted lists, apply styling - pptx

    Code
      polish_content_pptx.list(simple_list, font_color = "blue", font_style = "italic",
        font_size = 20)
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:rPr sz="2000" i="1">
                <a:solidFill>
                  <a:srgbClr val="0000FF"/>
                </a:solidFill>
              </a:rPr>
              <a:t>These</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:rPr sz="2000" i="1">
                <a:solidFill>
                  <a:srgbClr val="0000FF"/>
                </a:solidFill>
              </a:rPr>
              <a:t>are</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:rPr sz="2000" i="1">
                <a:solidFill>
                  <a:srgbClr val="0000FF"/>
                </a:solidFill>
              </a:rPr>
              <a:t>separate</a:t>
            </a:r>
          </a:p>
          <a:p>
            <a:pPr marL="514350" indent="-514350"/>
            <a:r>
              <a:rPr sz="2000" i="1">
                <a:solidFill>
                  <a:srgbClr val="0000FF"/>
                </a:solidFill>
              </a:rPr>
              <a:t>bullets</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

# lists cannot be converted into bulleted lists if content is not text, numeric, or md - pptx

    Code
      polish_content_pptx.list(list(mtcars))
    Condition
      Error in `polish_content_pptx.list()`:
      ! List objects to be polished can only contain character or numeric values of length 1

