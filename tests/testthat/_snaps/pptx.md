# polish_content_pptx() fails on unknown class

    Code
      polish_content_pptx(new_object("foo"))
    Condition
      Error in `polish_content_pptx()`:
      ! No available method for objects of type <foo>.

# polish_content_pptx() fails on files with unknown extensions

    Code
      polish_content_pptx(local_file(".foo"))
    Condition
      Error in `polish_content_pptx()`:
      ! No available method for `.foo` files.

# polish_content_pptx().character

    Code
      polish_content_pptx("<", escape = FALSE)
    Condition
      Error in `polish_content_pptx()`:
      ! Invalid xml
      Caused by error in `read_xml.raw()`:
      ! StartTag: invalid element name [68]

# polish_content_pptx.data.frame()

    Code
      polish_content_pptx(data.frame(x = 1:2, y = c("hello", "world")))
    Output
      <p:graphicFrame xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
        <p:nvGraphicFramePr>
          <p:cNvPr id="[...]"/>
          <p:cNvGraphicFramePr>
            <a:graphicFrameLocks noGrp="true"/>
          </p:cNvGraphicFramePr>
          <p:nvPr/>
        </p:nvGraphicFramePr>
        <p:xfrm rot="0">
          <a:off x="[...]" y="[...]"/>
          <a:ext cx="[...]" cy="[...]"/>
        </p:xfrm>
        <a:graphic>
          <a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/table">
            <a:tbl>
              <a:tblPr/>
              <a:tblGrid>
                <a:gridCol w="[...]"/>
                <a:gridCol w="[...]"/>
              </a:tblGrid>
              <a:tr h="[...]">
                <a:tc>
                  <a:txBody>
                    <a:bodyPr/>
                    <a:lstStyle/>
                    <a:p>
                      <a:pPr algn="r" marL="63500" marR="63500">
                        <a:lnSpc>
                          <a:spcPct val="100000"/>
                        </a:lnSpc>
                        <a:spcBef>
                          <a:spcPts val="500"/>
                        </a:spcBef>
                        <a:spcAft>
                          <a:spcPts val="500"/>
                        </a:spcAft>
                        <a:buNone/>
                      </a:pPr>
                      <a:r>
                        <a:rPr cap="none" sz="1100" i="0" b="0" u="none" strike="noStrike">
                          <a:solidFill>
                            <a:srgbClr val="000000">
                              <a:alpha val="100000"/>
                            </a:srgbClr>
                          </a:solidFill>
                          <a:latin typeface="[...]"/>
                          <a:cs typeface="[...]"/>
                          <a:ea typeface="[...]"/>
                          <a:sym typeface="[...]"/>
                        </a:rPr>
                        <a:t>x</a:t>
                      </a:r>
                    </a:p>
                  </a:txBody>
                  <a:tcPr anchor="ctr" marB="63500" marT="63500" marR="0" marL="0">
                    <a:lnL algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnL>
                    <a:lnR algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnR>
                    <a:lnT algn="ctr" cmpd="sng" cap="flat" w="19050">
                      <a:solidFill>
                        <a:srgbClr val="666666">
                          <a:alpha val="100000"/>
                        </a:srgbClr>
                      </a:solidFill>
                      <a:prstDash val="solid"/>
                    </a:lnT>
                    <a:lnB algn="ctr" cmpd="sng" cap="flat" w="19050">
                      <a:solidFill>
                        <a:srgbClr val="666666">
                          <a:alpha val="100000"/>
                        </a:srgbClr>
                      </a:solidFill>
                      <a:prstDash val="solid"/>
                    </a:lnB>
                    <a:solidFill>
                      <a:srgbClr val="FFFFFF">
                        <a:alpha val="0"/>
                      </a:srgbClr>
                    </a:solidFill>
                  </a:tcPr>
                </a:tc>
                <a:tc>
                  <a:txBody>
                    <a:bodyPr/>
                    <a:lstStyle/>
                    <a:p>
                      <a:pPr algn="l" marL="63500" marR="63500">
                        <a:lnSpc>
                          <a:spcPct val="100000"/>
                        </a:lnSpc>
                        <a:spcBef>
                          <a:spcPts val="500"/>
                        </a:spcBef>
                        <a:spcAft>
                          <a:spcPts val="500"/>
                        </a:spcAft>
                        <a:buNone/>
                      </a:pPr>
                      <a:r>
                        <a:rPr cap="none" sz="1100" i="0" b="0" u="none" strike="noStrike">
                          <a:solidFill>
                            <a:srgbClr val="000000">
                              <a:alpha val="100000"/>
                            </a:srgbClr>
                          </a:solidFill>
                          <a:latin typeface="[...]"/>
                          <a:cs typeface="[...]"/>
                          <a:ea typeface="[...]"/>
                          <a:sym typeface="[...]"/>
                        </a:rPr>
                        <a:t>y</a:t>
                      </a:r>
                    </a:p>
                  </a:txBody>
                  <a:tcPr anchor="ctr" marB="63500" marT="63500" marR="0" marL="0">
                    <a:lnL algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnL>
                    <a:lnR algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnR>
                    <a:lnT algn="ctr" cmpd="sng" cap="flat" w="19050">
                      <a:solidFill>
                        <a:srgbClr val="666666">
                          <a:alpha val="100000"/>
                        </a:srgbClr>
                      </a:solidFill>
                      <a:prstDash val="solid"/>
                    </a:lnT>
                    <a:lnB algn="ctr" cmpd="sng" cap="flat" w="19050">
                      <a:solidFill>
                        <a:srgbClr val="666666">
                          <a:alpha val="100000"/>
                        </a:srgbClr>
                      </a:solidFill>
                      <a:prstDash val="solid"/>
                    </a:lnB>
                    <a:solidFill>
                      <a:srgbClr val="FFFFFF">
                        <a:alpha val="0"/>
                      </a:srgbClr>
                    </a:solidFill>
                  </a:tcPr>
                </a:tc>
              </a:tr>
              <a:tr h="[...]">
                <a:tc>
                  <a:txBody>
                    <a:bodyPr/>
                    <a:lstStyle/>
                    <a:p>
                      <a:pPr algn="r" marL="63500" marR="63500">
                        <a:lnSpc>
                          <a:spcPct val="100000"/>
                        </a:lnSpc>
                        <a:spcBef>
                          <a:spcPts val="500"/>
                        </a:spcBef>
                        <a:spcAft>
                          <a:spcPts val="500"/>
                        </a:spcAft>
                        <a:buNone/>
                      </a:pPr>
                      <a:r>
                        <a:rPr cap="none" sz="1100" i="0" b="0" u="none" strike="noStrike">
                          <a:solidFill>
                            <a:srgbClr val="000000">
                              <a:alpha val="100000"/>
                            </a:srgbClr>
                          </a:solidFill>
                          <a:latin typeface="[...]"/>
                          <a:cs typeface="[...]"/>
                          <a:ea typeface="[...]"/>
                          <a:sym typeface="[...]"/>
                        </a:rPr>
                        <a:t>1</a:t>
                      </a:r>
                    </a:p>
                  </a:txBody>
                  <a:tcPr anchor="ctr" marB="63500" marT="63500" marR="0" marL="0">
                    <a:lnL algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnL>
                    <a:lnR algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnR>
                    <a:lnT algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnT>
                    <a:lnB algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnB>
                    <a:solidFill>
                      <a:srgbClr val="FFFFFF">
                        <a:alpha val="0"/>
                      </a:srgbClr>
                    </a:solidFill>
                  </a:tcPr>
                </a:tc>
                <a:tc>
                  <a:txBody>
                    <a:bodyPr/>
                    <a:lstStyle/>
                    <a:p>
                      <a:pPr algn="l" marL="63500" marR="63500">
                        <a:lnSpc>
                          <a:spcPct val="100000"/>
                        </a:lnSpc>
                        <a:spcBef>
                          <a:spcPts val="500"/>
                        </a:spcBef>
                        <a:spcAft>
                          <a:spcPts val="500"/>
                        </a:spcAft>
                        <a:buNone/>
                      </a:pPr>
                      <a:r>
                        <a:rPr cap="none" sz="1100" i="0" b="0" u="none" strike="noStrike">
                          <a:solidFill>
                            <a:srgbClr val="000000">
                              <a:alpha val="100000"/>
                            </a:srgbClr>
                          </a:solidFill>
                          <a:latin typeface="[...]"/>
                          <a:cs typeface="[...]"/>
                          <a:ea typeface="[...]"/>
                          <a:sym typeface="[...]"/>
                        </a:rPr>
                        <a:t>hello</a:t>
                      </a:r>
                    </a:p>
                  </a:txBody>
                  <a:tcPr anchor="ctr" marB="63500" marT="63500" marR="0" marL="0">
                    <a:lnL algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnL>
                    <a:lnR algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnR>
                    <a:lnT algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnT>
                    <a:lnB algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnB>
                    <a:solidFill>
                      <a:srgbClr val="FFFFFF">
                        <a:alpha val="0"/>
                      </a:srgbClr>
                    </a:solidFill>
                  </a:tcPr>
                </a:tc>
              </a:tr>
              <a:tr h="[...]">
                <a:tc>
                  <a:txBody>
                    <a:bodyPr/>
                    <a:lstStyle/>
                    <a:p>
                      <a:pPr algn="r" marL="63500" marR="63500">
                        <a:lnSpc>
                          <a:spcPct val="100000"/>
                        </a:lnSpc>
                        <a:spcBef>
                          <a:spcPts val="500"/>
                        </a:spcBef>
                        <a:spcAft>
                          <a:spcPts val="500"/>
                        </a:spcAft>
                        <a:buNone/>
                      </a:pPr>
                      <a:r>
                        <a:rPr cap="none" sz="1100" i="0" b="0" u="none" strike="noStrike">
                          <a:solidFill>
                            <a:srgbClr val="000000">
                              <a:alpha val="100000"/>
                            </a:srgbClr>
                          </a:solidFill>
                          <a:latin typeface="[...]"/>
                          <a:cs typeface="[...]"/>
                          <a:ea typeface="[...]"/>
                          <a:sym typeface="[...]"/>
                        </a:rPr>
                        <a:t>2</a:t>
                      </a:r>
                    </a:p>
                  </a:txBody>
                  <a:tcPr anchor="ctr" marB="63500" marT="63500" marR="0" marL="0">
                    <a:lnL algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnL>
                    <a:lnR algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnR>
                    <a:lnT algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnT>
                    <a:lnB algn="ctr" cmpd="sng" cap="flat" w="19050">
                      <a:solidFill>
                        <a:srgbClr val="666666">
                          <a:alpha val="100000"/>
                        </a:srgbClr>
                      </a:solidFill>
                      <a:prstDash val="solid"/>
                    </a:lnB>
                    <a:solidFill>
                      <a:srgbClr val="FFFFFF">
                        <a:alpha val="0"/>
                      </a:srgbClr>
                    </a:solidFill>
                  </a:tcPr>
                </a:tc>
                <a:tc>
                  <a:txBody>
                    <a:bodyPr/>
                    <a:lstStyle/>
                    <a:p>
                      <a:pPr algn="l" marL="63500" marR="63500">
                        <a:lnSpc>
                          <a:spcPct val="100000"/>
                        </a:lnSpc>
                        <a:spcBef>
                          <a:spcPts val="500"/>
                        </a:spcBef>
                        <a:spcAft>
                          <a:spcPts val="500"/>
                        </a:spcAft>
                        <a:buNone/>
                      </a:pPr>
                      <a:r>
                        <a:rPr cap="none" sz="1100" i="0" b="0" u="none" strike="noStrike">
                          <a:solidFill>
                            <a:srgbClr val="000000">
                              <a:alpha val="100000"/>
                            </a:srgbClr>
                          </a:solidFill>
                          <a:latin typeface="[...]"/>
                          <a:cs typeface="[...]"/>
                          <a:ea typeface="[...]"/>
                          <a:sym typeface="[...]"/>
                        </a:rPr>
                        <a:t>world</a:t>
                      </a:r>
                    </a:p>
                  </a:txBody>
                  <a:tcPr anchor="ctr" marB="63500" marT="63500" marR="0" marL="0">
                    <a:lnL algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnL>
                    <a:lnR algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnR>
                    <a:lnT algn="ctr" cmpd="sng" cap="flat" w="0">
                      <a:noFill/>
                      <a:prstDash val="solid"/>
                    </a:lnT>
                    <a:lnB algn="ctr" cmpd="sng" cap="flat" w="19050">
                      <a:solidFill>
                        <a:srgbClr val="666666">
                          <a:alpha val="100000"/>
                        </a:srgbClr>
                      </a:solidFill>
                      <a:prstDash val="solid"/>
                    </a:lnB>
                    <a:solidFill>
                      <a:srgbClr val="FFFFFF">
                        <a:alpha val="0"/>
                      </a:srgbClr>
                    </a:solidFill>
                  </a:tcPr>
                </a:tc>
              </a:tr>
            </a:tbl>
          </a:graphicData>
        </a:graphic>
      </p:graphicFrame>

# polish_content_pptx().numeric

    Code
      polish_content_pptx(42L)
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:t>42</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(42.5)
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:t>42.5</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(c(42L, 43L))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:t>42</a:t>
            </a:r>
            <a:r>
              <a:t>43</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

---

    Code
      polish_content_pptx(c(42.5, 43.5))
    Output
      <p:sp>
        <p:ph/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:t>42.5</a:t>
            </a:r>
            <a:r>
              <a:t>43.5</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>

# polish_content_word().ggplot

    Code
      polish_content_pptx(ggplot(mtcars))
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

