;=====================================================================
; Verilog Pin Mismatch Debugger  -  schematic port dumper (SKILL)
;
; HOW TO USE
;   1. Open the schematic whose ports you want to check.
;   2. Paste this whole block into the Virtuoso CIW (the "icfb" window)
;      and press Enter.
;   3. It prints the terminals of the CURRENT edit window.
;   4. Copy everything from ###PORTDUMP_BEGIN### through
;      ###PORTDUMP_END### back into the web tool.
;
; Output format (one line per terminal):
;   PORT|<name>|<direction>
; where <direction> is Cadence's terminal direction, e.g.
;   input | output | inputOutput | switch | tristate | jumper | unused
;=====================================================================
let( (cv)
    cv = geGetEditCellView()
    if( cv then
        printf("###PORTDUMP_BEGIN###\n")
        printf("# lib=%s cell=%s view=%s\n"
               cv~>libName cv~>cellName cv~>viewName)
        foreach( term cv~>terminals
            printf("PORT|%s|%s\n" term~>name term~>direction)
        )
        printf("###PORTDUMP_END###\n")
    else
        printf("ERROR: no edit cellview - open a schematic first.\n")
    )
    t
)
