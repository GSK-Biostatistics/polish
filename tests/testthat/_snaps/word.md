# polish_content_word() fails on unknown class

    Code
      polish_content_word(new_object("foo"))
    Condition
      Error in `polish_content_word()`:
      ! No available method for objects of type <foo>.

# polish_content_word() fails on files with unknown extensions

    Code
      polish_content_word(local_file(".foo"))
    Condition
      Error in `polish_content_word()`:
      ! No available method for `.foo` files.

# polish_content_word.character()

    Code
      polish_content_word("<")
    Condition
      Error in `polish_content_word()`:
      ! Invalid xml
      Caused by error in `read_xml.raw()`:
      ! StartTag: invalid element name [68]

# polish_content_word.data.frame()

    Code
      polish_content_word(data.frame(x = 1:2, y = c("hello", "world")))
    Output
      <w:tbl xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
        <w:tblPr>
          <w:tblLayout w:type="autofit"/>
          <w:jc w:val="center"/>
          <w:tblW w:type="pct" w:w="5000"/>
          <w:tblLook w:firstRow="1" w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
        </w:tblPr>
        <w:tr>
          <w:trPr>
            <w:tblHeader/>
          </w:trPr>
          <w:tc>
            <w:p>
              <w:pPr>
                <w:pStyle w:pstlname="Normal"/>
                <w:jc w:val="center"/>
              </w:pPr>
              <w:r>
                <w:t>x</w:t>
              </w:r>
            </w:p>
          </w:tc>
          <w:tc>
            <w:p>
              <w:pPr>
                <w:pStyle w:pstlname="Normal"/>
                <w:jc w:val="center"/>
              </w:pPr>
              <w:r>
                <w:t>y</w:t>
              </w:r>
            </w:p>
          </w:tc>
        </w:tr>
        <w:tr>
          <w:tc>
            <w:p>
              <w:pPr>
                <w:pStyle w:pstlname="Normal"/>
                <w:jc w:val="center"/>
              </w:pPr>
              <w:r>
                <w:t>1</w:t>
              </w:r>
            </w:p>
          </w:tc>
          <w:tc>
            <w:p>
              <w:pPr>
                <w:pStyle w:pstlname="Normal"/>
                <w:jc w:val="center"/>
              </w:pPr>
              <w:r>
                <w:t>hello</w:t>
              </w:r>
            </w:p>
          </w:tc>
        </w:tr>
        <w:tr>
          <w:tc>
            <w:p>
              <w:pPr>
                <w:pStyle w:pstlname="Normal"/>
                <w:jc w:val="center"/>
              </w:pPr>
              <w:r>
                <w:t>2</w:t>
              </w:r>
            </w:p>
          </w:tc>
          <w:tc>
            <w:p>
              <w:pPr>
                <w:pStyle w:pstlname="Normal"/>
                <w:jc w:val="center"/>
              </w:pPr>
              <w:r>
                <w:t>world</w:t>
              </w:r>
            </w:p>
          </w:tc>
        </w:tr>
      </w:tbl>

# polish_content_word().numeric

    Code
      polish_content_word(42L)
    Output
      <w:p>
        <w:r>
          <w:t xml:space="preserve">42</w:t>
        </w:r>
      </w:p>

---

    Code
      polish_content_word(42.5)
    Output
      <w:p>
        <w:r>
          <w:t xml:space="preserve">42.5</w:t>
        </w:r>
      </w:p>

---

    Code
      polish_content_word(c(42L, 43L))
    Output
      <w:p>
        <w:r>
          <w:t xml:space="preserve">42</w:t>
        </w:r>
      </w:p>
      <w:p>
        <w:r>
          <w:t xml:space="preserve">43</w:t>
        </w:r>
      </w:p>

---

    Code
      polish_content_word(c(42.5, 43.5))
    Output
      <w:p>
        <w:r>
          <w:t xml:space="preserve">42.5</w:t>
        </w:r>
      </w:p>
      <w:p>
        <w:r>
          <w:t xml:space="preserve">43.5</w:t>
        </w:r>
      </w:p>

# polish_content_word().ggplot

    Code
      polish_content_word(ggplot(mtcars))
    Output
      <w:p>
        <w:r xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml">
          <w:rPr/>
          <w:drawing xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
            <wp:inline distT="0" distB="0" distL="0" distR="0">
              <wp:extent cx="5486400" cy="4572000"/>
              <wp:docPr id="" name="" descr=""/>
              <wp:cNvGraphicFramePr>
                <a:graphicFrameLocks xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" noChangeAspect="1"/>
              </wp:cNvGraphicFramePr>
              <a:graphic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
                <a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture">
                  <pic:pic xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">
                    <pic:nvPicPr>
                      <pic:cNvPr id="" name=""/>
                      <pic:cNvPicPr>
                        <a:picLocks noChangeAspect="1" noChangeArrowheads="1"/>
                      </pic:cNvPicPr>
                    </pic:nvPicPr>
                    <pic:blipFill>
                      <a:blip r:embed="[...]"/>
                      <a:stretch>
                        <a:fillRect/>
                      </a:stretch>
                    </pic:blipFill>
                    <pic:spPr bwMode="auto">
                      <a:xfrm>
                        <a:off x="[...]" y="[...]"/>
                        <a:ext cx="[...]" cy="[...]"/>
                      </a:xfrm>
                      <a:prstGeom prst="rect">
                        <a:avLst/>
                      </a:prstGeom>
                      <a:noFill/>
                    </pic:spPr>
                  </pic:pic>
                </a:graphicData>
              </a:graphic>
            </wp:inline>
          </w:drawing>
        </w:r>
      </w:p>

