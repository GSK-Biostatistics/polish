# polish_content_word(<file_txt>)

    Code
      polish_content_word(as_file(tf), inline = TRUE)
    Output
      <w:r>
        <w:t>hello</w:t>
      </w:r>
      <w:br w:type="textWrapping" w:clear="all"/>
      <w:r>
        <w:t>world</w:t>
      </w:r>

---

    Code
      polish_content_word(as_file(tf), inline = FALSE)
    Output
      <w:p>
        <w:r>
          <w:t>hello</w:t>
        </w:r>
        <w:br w:type="textWrapping" w:clear="all"/>
        <w:r>
          <w:t>world</w:t>
        </w:r>
      </w:p>

# polish_content_word(<file_md>)

    Code
      polish_content_word(as_file(tf))
    Output
      <w:p>
        <w:pPr/>
        <w:r>
          <w:rPr/>
          <w:t xml:space="preserve">hello</w:t>
        </w:r>
        <w:br w:type="textWrapping" w:clear="right"/>
        <w:r>
          <w:rPr>
            <w:i/>
          </w:rPr>
          <w:t xml:space="preserve">world</w:t>
        </w:r>
      </w:p>

# polish_content_word(<file_docx>

    Code
      polish_content_word(as_file(tf))
    Output
      <w:altChunk xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" r:id="[...]"/>

# polish_content_word(<file_rtf>

    Code
      polish_content_word(as_file(tf))
    Output
      <w:altChunk r:id="[...]"/>

# polish_content_word(<file_html>)

    Code
      polish_content_word(as_file(tf))
    Output
      <w:altChunk r:id="[...]"/>

# polish_content_pptx(<file_txt>)

    Code
      polish_content_pptx(as_file(tf))
    Condition
      Error in `polish_content_pptx()`:
      ! polish_content_pptx(<file_text>) is not yet implemented.
      i See <https://github.com/GSK-Biostatistics/polish/issues/1> for progress.

# polish_content_pptx(<file_md>)

    Code
      polish_content_pptx(as_file(tf))
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
              <a:t>hello</a:t>
            </a:r>
            <a:r>
              <a:rPr i="1"/>
              <a:t>world</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

# polish_content_pptx(<file_rtf>)

    Code
      polish_content_pptx(as_file(tf))
    Output
      <p:pic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
        <p:nvPicPr>
          <p:cNvPr id="[...]"/>
          <p:cNvPicPr>
            <a:picLocks noGrp="1"/>
          </p:cNvPicPr>
          <p:nvPr>
            <p:ph/>
          </p:nvPr>
        </p:nvPicPr>
        <p:blipFill>
          <a:blip r:embed="[...]"/>
          <a:stretch>
            <a:fillRect/>
          </a:stretch>
        </p:blipFill>
        <p:spPr>
          <a:xfrm>
            <a:off x="[...]" y="[...]"/>
            <a:ext cx="[...]" cy="[...]"/>
          </a:xfrm>
          <a:prstGeom prst="rect">
            <a:avLst/>
          </a:prstGeom>
          <a:solidFill>
            <a:srgbClr val="FFFFFF">
              <a:alpha val="0"/>
            </a:srgbClr>
          </a:solidFill>
          <a:ln w="0" cap="rnd" cmpd="sng">
            <a:noFill/>
            <a:prstDash val="solid"/>
            <a:round/>
            <a:headEnd type="none" w="med" len="med"/>
            <a:tailEnd type="none" w="med" len="med"/>
          </a:ln>
        </p:spPr>
      </p:pic>

# polish_content_pptx(<file_html>)

    Code
      polish_content_pptx(as_file(tf))
    Output
      <p:pic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
        <p:nvPicPr>
          <p:cNvPr id="[...]"/>
          <p:cNvPicPr>
            <a:picLocks noGrp="1"/>
          </p:cNvPicPr>
          <p:nvPr>
            <p:ph/>
          </p:nvPr>
        </p:nvPicPr>
        <p:blipFill>
          <a:blip r:embed="[...]"/>
          <a:stretch>
            <a:fillRect/>
          </a:stretch>
        </p:blipFill>
        <p:spPr>
          <a:xfrm>
            <a:off x="[...]" y="[...]"/>
            <a:ext cx="[...]" cy="[...]"/>
          </a:xfrm>
          <a:prstGeom prst="rect">
            <a:avLst/>
          </a:prstGeom>
          <a:solidFill>
            <a:srgbClr val="FFFFFF">
              <a:alpha val="0"/>
            </a:srgbClr>
          </a:solidFill>
          <a:ln w="0" cap="rnd" cmpd="sng">
            <a:noFill/>
            <a:prstDash val="solid"/>
            <a:round/>
            <a:headEnd type="none" w="med" len="med"/>
            <a:tailEnd type="none" w="med" len="med"/>
          </a:ln>
        </p:spPr>
      </p:pic>

