axlCmdRegister("check_silk_overlapping" 'check_silk_overlapping)

(defun check_silk_overlapping ()

form_function()

form=axlFormCreate((gensym),"check_silk_overlapping_form.form",'(e outer),'check_silk_overlapping_action,t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlFormDisplay(form)

axlUIWDisableQuit(form)

start_time=getCurrentTime()
time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))
tool_run="no"


axlClearSelSet()

skill_layer="BOARD GEOMETRY/SKILL_LAYER"
endType = 'ROUND

axlLayerCreateNonConductor(skill_layer)
axlVisibleLayer(skill_layer t)

axlFormSetFieldEditable(form "select" nil)

brd_top_silk_layer="BOARD GEOMETRY/SILKSCREEN_TOP"
pkg_top_silk_layer="PACKAGE GEOMETRY/SILKSCREEN_TOP"
refdes_top_silk_layer="REF DES/SILKSCREEN_TOP"
brd_top_mask_layer="BOARD GEOMETRY/SOLDERMASK_TOP"
pkg_top_mask_layer="PACKAGE GEOMETRY/SOLDERMASK_TOP"
pin_top_mask_layer="PIN/SOLDERMASK_TOP"
via_top_mask_layer="VIA CLASS/SOLDERMASK_TOP"


brd_bot_silk_layer="BOARD GEOMETRY/SILKSCREEN_BOTTOM"
pkg_bot_silk_layer="PACKAGE GEOMETRY/SILKSCREEN_BOTTOM"
refdes_bot_silk_layer="REF DES/SILKSCREEN_BOTTOM"
brd_bot_mask_layer="BOARD GEOMETRY/SOLDERMASK_BOTTOM"
pkg_bot_mask_layer="PACKAGE GEOMETRY/SOLDERMASK_BOTTOM"
pin_bot_mask_layer="PIN/SOLDERMASK_BOTTOM"
via_bot_mask_layer="VIA CLASS/SOLDERMASK_BOTTOM"


when(axlIsVisibleLayer(brd_top_silk_layer)==t
axlFormSetField(form "brd_top_silk_checkbox" t)
)

when(axlIsVisibleLayer(pkg_top_silk_layer)==t
axlFormSetField(form "pkg_top_silk_checkbox" t)
)

when(axlIsVisibleLayer(refdes_top_silk_layer)==t
axlFormSetField(form "refdes_top_silk_checkbox" t)
)


when(axlIsVisibleLayer(brd_top_mask_layer)==t
axlFormSetField(form "brd_top_mask_checkbox" t)
)

when(axlIsVisibleLayer(pkg_top_mask_layer)==t
axlFormSetField(form "pkg_top_mask_checkbox" t)
)

when(axlIsVisibleLayer(pin_top_mask_layer)==t && axlIsVisibleLayer(via_top_mask_layer)==t
axlFormSetField(form "pad_top_mask_checkbox" t)
)


when(axlIsVisibleLayer(brd_bot_silk_layer)==t
axlFormSetField(form "brd_bot_silk_checkbox" t)
)

when(axlIsVisibleLayer(pkg_bot_silk_layer)==t
axlFormSetField(form "pkg_bot_silk_checkbox" t)
)

when(axlIsVisibleLayer(refdes_bot_silk_layer)==t
axlFormSetField(form "refdes_bot_silk_checkbox" t)
)

when(axlIsVisibleLayer(brd_bot_mask_layer)==t
axlFormSetField(form "brd_bot_mask_checkbox" t)
)

when(axlIsVisibleLayer(pkg_bot_mask_layer)==t
axlFormSetField(form "pkg_bot_mask_checkbox" t)
)

when(axlIsVisibleLayer(pin_bot_mask_layer)==t && axlIsVisibleLayer(via_bot_mask_layer)==t
axlFormSetField(form "pad_bot_mask_checkbox" t)
)


zoom_input=100
axlFormSetField(form "zoom_input" zoom_input)

airgap_input=0.0
axlFormSetField(form "airgap_input" airgap_input)


axlDBCreatePropDictEntry("OBJ_TYPE" "STRING" t)
axlDBCreatePropDictEntry("OBJ_LAYER" "STRING" t)

axlFormSetFieldEditable(form "diff_objtype_checkbox" nil)


) ;; main form

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun check_silk_overlapping_action (fform)


(case fform->curField


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("line_checkbox"

line_checkbox=axlFormGetField(form "line_checkbox")
text_checkbox=axlFormGetField(form "text_checkbox")
shape_checkbox=axlFormGetField(form "shape_checkbox")

if(line_checkbox==t || text_checkbox==t || shape_checkbox==t
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
) ;; if


if( (line_checkbox==t && text_checkbox==t) || (shape_checkbox==t && text_checkbox==t) || (shape_checkbox==t && line_checkbox==t)
then
axlFormSetFieldEditable(form "diff_objtype_checkbox" t)
else
axlFormSetFieldEditable(form "diff_objtype_checkbox" nil)
axlFormSetField(form "diff_objtype_checkbox" nil)
) ;; if

) ;; line_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("text_checkbox"

line_checkbox=axlFormGetField(form "line_checkbox")
text_checkbox=axlFormGetField(form "text_checkbox")
shape_checkbox=axlFormGetField(form "shape_checkbox")

if(line_checkbox==t || text_checkbox==t || shape_checkbox==t
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
) ;; if

if( (line_checkbox==t && text_checkbox==t) || (shape_checkbox==t && text_checkbox==t) || (shape_checkbox==t && line_checkbox==t)
then
axlFormSetFieldEditable(form "diff_objtype_checkbox" t)
else
axlFormSetFieldEditable(form "diff_objtype_checkbox" nil)
axlFormSetField(form "diff_objtype_checkbox" nil)
) ;; if

) ;; text_checkbox


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("shape_checkbox"

line_checkbox=axlFormGetField(form "line_checkbox")
text_checkbox=axlFormGetField(form "text_checkbox")
shape_checkbox=axlFormGetField(form "shape_checkbox")

if(line_checkbox==t || text_checkbox==t || shape_checkbox==t
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
) ;; if

if( (line_checkbox==t && text_checkbox==t) || (shape_checkbox==t && text_checkbox==t) || (shape_checkbox==t && line_checkbox==t)
then
axlFormSetFieldEditable(form "diff_objtype_checkbox" t)
else
axlFormSetFieldEditable(form "diff_objtype_checkbox" nil)
axlFormSetField(form "diff_objtype_checkbox" nil)
) ;; if

) ;; shape_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("silk_mask_checkbox"

line_checkbox=axlFormGetField(form "line_checkbox")
text_checkbox=axlFormGetField(form "text_checkbox")
shape_checkbox=axlFormGetField(form "shape_checkbox")
silk_mask_checkbox=axlFormGetField(form "silk_mask_checkbox")

if(silk_mask_checkbox==t
then

axlFormSetFieldEditable(form "line_checkbox" nil)
axlFormSetFieldEditable(form "text_checkbox" nil)
axlFormSetFieldEditable(form "shape_checkbox" nil)
axlFormSetField(form "airgap_input" 2.0)

;;;;;;;;;;;;;;;;;;

test_layer="-"

if(axlIsVisibleLayer("PIN/TOP")==t && axlIsVisibleLayer("VIA CLASS/TOP")==t && axlIsVisibleLayer("PIN/BOTTOM")==nil && axlIsVisibleLayer("VIA CLASS/BOTTOM")==nil
then
test_layer="TOP"
else
if(axlIsVisibleLayer("PIN/BOTTOM")==t && axlIsVisibleLayer("VIA CLASS/BOTTOM")==t && axlIsVisibleLayer("PIN/TOP")==nil && axlIsVisibleLayer("VIA CLASS/TOP")==nil
then
test_layer="BOTTOM"

)) ;; if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if(silk_mask_checkbox==t && test_layer!="-" && (line_checkbox==t || text_checkbox==t || shape_checkbox==t)
then
axlFormSetFieldEditable(form "select" t)

else
if(silk_mask_checkbox==t && test_layer=="-"
then
axlUIWPrint(fform,"Pins/Vias must be visible for one outer layer")
axlFormSetFieldEditable(form "select" nil)

else
axlUIWPrint(fform,"Tick atleast one (L/T/S)")
axlFormSetFieldEditable(form "select" nil)
)) ;; if

;;;;;;;;;;;;;;;;;;

else
axlFormSetFieldEditable(form "line_checkbox" t)
axlFormSetFieldEditable(form "text_checkbox" t)
axlFormSetFieldEditable(form "shape_checkbox" t)
axlFormSetField(form "airgap_input" 0.0)

if(line_checkbox==t || text_checkbox==t || shape_checkbox==t
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
) ;; if

) ;; if


) ;; silk_mask_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("brd_top_silk_checkbox"

brd_top_silk_checkbox=axlFormGetField(form "brd_top_silk_checkbox")

if(brd_top_silk_checkbox==t
then
axlVisibleLayer(brd_top_silk_layer t)

else
axlVisibleLayer(brd_top_silk_layer nil)

) ;; if

) ;; brd_top_silk_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("pkg_top_silk_checkbox"

pkg_top_silk_checkbox=axlFormGetField(form "pkg_top_silk_checkbox")

if(pkg_top_silk_checkbox==t
then
axlVisibleLayer(pkg_top_silk_layer t)

else
axlVisibleLayer(pkg_top_silk_layer nil)

) ;; if

) ;; pkg_top_silk_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("refdes_top_silk_checkbox"

refdes_top_silk_checkbox=axlFormGetField(form "refdes_top_silk_checkbox")

if(refdes_top_silk_checkbox==t
then
axlVisibleLayer(refdes_top_silk_layer t)

else
axlVisibleLayer(refdes_top_silk_layer nil)

) ;; if

) ;; refdes_top_silk_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("brd_top_mask_checkbox"

brd_top_mask_checkbox=axlFormGetField(form "brd_top_mask_checkbox")

if(brd_top_mask_checkbox==t
then
axlVisibleLayer(brd_top_mask_layer t)

else
axlVisibleLayer(brd_top_mask_layer nil)

) ;; if

) ;; brd_top_mask_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("pkg_top_mask_checkbox"

pkg_top_mask_checkbox=axlFormGetField(form "pkg_top_mask_checkbox")

if(pkg_top_mask_checkbox==t
then
axlVisibleLayer(pkg_top_mask_layer t)

else
axlVisibleLayer(pkg_top_mask_layer nil)

) ;; if

) ;; pkg_top_mask_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("pad_top_mask_checkbox"

pad_top_mask_checkbox=axlFormGetField(form "pad_top_mask_checkbox")

if(pad_top_mask_checkbox==t
then
axlVisibleLayer(pin_top_mask_layer t)
axlVisibleLayer(via_top_mask_layer t)

else
axlVisibleLayer(pin_top_mask_layer nil)
axlVisibleLayer(via_top_mask_layer nil)

) ;; if

) ;; pad_top_mask_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("brd_bot_silk_checkbox"

brd_bot_silk_checkbox=axlFormGetField(form "brd_bot_silk_checkbox")

if(brd_bot_silk_checkbox==t
then
axlVisibleLayer(brd_bot_silk_layer t)

else
axlVisibleLayer(brd_bot_silk_layer nil)

) ;; if

) ;; brd_bot_silk_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("pkg_bot_silk_checkbox"

pkg_bot_silk_checkbox=axlFormGetField(form "pkg_bot_silk_checkbox")

if(pkg_bot_silk_checkbox==t
then
axlVisibleLayer(pkg_bot_silk_layer t)

else
axlVisibleLayer(pkg_bot_silk_layer nil)

) ;; if

) ;; pkg_bot_silk_checkbox


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("refdes_bot_silk_checkbox"

refdes_bot_silk_checkbox=axlFormGetField(form "refdes_bot_silk_checkbox")

if(refdes_bot_silk_checkbox==t
then
axlVisibleLayer(refdes_bot_silk_layer t)

else
axlVisibleLayer(refdes_bot_silk_layer nil)

) ;; if

) ;; refdes_bot_silk_checkbox


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("brd_bot_mask_checkbox"

brd_bot_mask_checkbox=axlFormGetField(form "brd_bot_mask_checkbox")

if(brd_bot_mask_checkbox==t
then
axlVisibleLayer(brd_bot_mask_layer t)

else
axlVisibleLayer(brd_bot_mask_layer nil)

) ;; if

) ;; brd_bot_mask_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("pkg_bot_mask_checkbox"

pkg_bot_mask_checkbox=axlFormGetField(form "pkg_bot_mask_checkbox")

if(pkg_bot_mask_checkbox==t
then
axlVisibleLayer(pkg_bot_mask_layer t)

else
axlVisibleLayer(pkg_bot_mask_layer nil)

) ;; if

) ;; pkg_bot_mask_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("pad_bot_mask_checkbox"

pad_bot_mask_checkbox=axlFormGetField(form "pad_bot_mask_checkbox")

if(pad_bot_mask_checkbox==t
then
axlVisibleLayer(pin_bot_mask_layer t)
axlVisibleLayer(pin_bot_mask_layer t)

else
axlVisibleLayer(pin_bot_mask_layer nil)
axlVisibleLayer(via_bot_mask_layer nil)

) ;; if

) ;; pad_bot_mask_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("select"
fp_raf=outfile("total_violations.txt" "w")

start_time_local=getCurrentTime()
axlSetActiveLayer(skill_layer)

func_delete()

axlFormListDeleteAll(form "l_errors_menu")

test_layer="-"

if(axlIsVisibleLayer("PIN/TOP")==t && axlIsVisibleLayer("VIA CLASS/TOP")==t && axlIsVisibleLayer("PIN/BOTTOM")==nil && axlIsVisibleLayer("VIA CLASS/BOTTOM")==nil
then
test_layer="TOP"
else
if(axlIsVisibleLayer("PIN/BOTTOM")==t && axlIsVisibleLayer("VIA CLASS/BOTTOM")==t && axlIsVisibleLayer("PIN/TOP")==nil && axlIsVisibleLayer("VIA CLASS/TOP")==nil
then
test_layer="BOTTOM"

)) ;; if

axlUIWPrint(fform,"Select lines/text/shapes in silk/mask layer")


line_checkbox=axlFormGetField(form "line_checkbox")
text_checkbox=axlFormGetField(form "text_checkbox")
shape_checkbox=axlFormGetField(form "shape_checkbox")
silk_mask_checkbox=axlFormGetField(form "silk_mask_checkbox")
airgap_input=axlFormGetField(form "airgap_input")
airgap_input_half=airgap_input/2

diff_objtype_checkbox=axlFormGetField(form "diff_objtype_checkbox")

l_options_input=nil

when(line_checkbox==t
l_options_input=cons("L",l_options_input)
) ;; when

when(text_checkbox==t
l_options_input=cons("T",l_options_input)
) ;; when

when(shape_checkbox==t
l_options_input=cons("S",l_options_input)
) ;; when

/*
when(silk_mask_checkbox==t && test_layer!="-"
l_options_input=cons("L-M",l_options_input)
l_options_input=cons("T-M",l_options_input)
l_options_input=cons("S-M",l_options_input)
l_options_input=cons("M-L",l_options_input)
l_options_input=cons("M-T",l_options_input)
l_options_input=cons("M-S",l_options_input)
) ;; when
*/


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


axlClearSelSet()
axlSetFindFilter(?enabled '("noall" "lines" "text" "shapes" "pins" "vias") ?onButtons '("noall" "lines" "text" "shapes" "pins" "vias"))
axlSelect()

l_dbid = axlGetSelSet()

axlUIWPrint(fform,"Please wait...")


l_text_db=nil
l_lines_db=nil
l_shapes_db=nil
l_pv_db=nil
layer_brd=nil
drc_layer=nil

foreach(dbid,l_dbid

tool_run="yes"
objType=dbid->objType

/*
if( (objType=="path" || objType=="shape" || objType=="text") && nindex(dbid->layer,"SILKSCREEN_TOP")!=nil
then
drc_layer="DRC ERROR CLASS/TOP"
axlVisibleLayer(drc_layer t)

else
if( (objType=="path" || objType=="shape" || objType=="text") && nindex(dbid->layer,"SILKSCREEN_BOTTOM")!=nil
then
drc_layer="DRC ERROR CLASS/BOTTOM"
axlVisibleLayer(drc_layer t)
)) ;; if
*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if(objType=="path" && nindex(dbid->layer,"SILKSCREEN")!=nil && line_checkbox==t ;; && silk_mask_checkbox==nil
then
l_lines_db=cons(dbid,l_lines_db)

else
if(objType=="path" && nindex(dbid->layer,"SOLDERMASK")!=nil && line_checkbox==t && silk_mask_checkbox==t
then
l_lines_db=cons(dbid,l_lines_db)

else
if(objType=="shape" && nindex(dbid->layer,"SILKSCREEN")!=nil && shape_checkbox==t ;; && silk_mask_checkbox==nil
then
l_shapes_db=cons(dbid,l_shapes_db)

else
if(objType=="shape" && nindex(dbid->layer,"SOLDERMASK")!=nil && shape_checkbox==t && silk_mask_checkbox==t
then
l_shapes_db=cons(dbid,l_shapes_db)

else
if(objType=="text" && nindex(dbid->layer,"SILKSCREEN")!=nil && text_checkbox==t ;; && silk_mask_checkbox==nil
then
l_text_db=cons(dbid,l_text_db)

else
if(objType=="text" && nindex(dbid->layer,"SOLDERMASK")!=nil && text_checkbox==t && silk_mask_checkbox==t
then
l_text_db=cons(dbid,l_text_db)

else
if( (objType=="pin" || objType=="via") && silk_mask_checkbox==t
then
l_pv_db=cons(dbid,l_pv_db)
))))))) ;; if
) ;; l_dbid

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_dbid_brd=nil

l_dbid_brd=append(l_dbid_brd,l_lines_db)
l_dbid_brd=append(l_dbid_brd,l_shapes_db)
l_dbid_brd=append(l_dbid_brd,l_text_db)
l_dbid_brd=append(l_dbid_brd,l_pv_db)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_shapes_all_db=nil
l_poly_all=nil

foreach(dbid_brd,l_dbid_brd

objType=dbid_brd->objType
dbid_layer="-"

if(objType=="text"
then

object_type="T"

if(nindex(dbid_brd->layer,"SILKSCREEN")!=nil
then
dbid_layer="SILK"
else
if(nindex(dbid_brd->layer,"SOLDERMASK")!=nil
then
dbid_layer="MASK"
)) ;;

l_path=axlText2Lines(dbid_brd)

l_poly_temp=nil

foreach(path_l,l_path
foreach(path,path_l
l_poly = axlPolyFromDB(path ?endCapType 'ROUND ?line2poly t)
l_poly_temp=cons(l_poly,l_poly_temp)
) ;; path_l
) ;; l_path


l_poly_local=nil

foreach(poly_temp,l_poly_temp
l_poly_local = (axlPolyOperation l_poly_local poly_temp 'OR)
) ;; l_poly_temp


foreach(poly,l_poly_local

l_shape_temp_db=axlDBCreateShape(poly, t, skill_layer, nil, nil)
shape_temp_db=car(l_shape_temp_db)

l_temp=list(object_type,shape_temp_db,dbid_layer)
l_shapes_all_db=cons(l_temp,l_shapes_all_db)

axlDBAddProp(l_shape_temp_db,list("OBJ_TYPE",object_type))
axlDBAddProp(l_shape_temp_db,list("OBJ_LAYER",dbid_layer))

) ;; l_poly_local


else
if(objType=="path"
then

object_type="L"

if(nindex(dbid_brd->layer,"SILKSCREEN")!=nil
then
dbid_layer="SILK"
else
if(nindex(dbid_brd->layer,"SOLDERMASK")!=nil
then
dbid_layer="MASK"
)) ;; 


l_poly_temp = axlPolyFromDB(dbid_brd ?endCapType endType)

l_poly_local=nil

foreach(poly_temp,l_poly_temp
l_poly_local = (axlPolyOperation l_poly_local poly_temp 'OR)
) ;; l_poly_temp

foreach(poly,l_poly_local

l_shape_temp_db=axlDBCreateShape(poly, t, skill_layer, nil, nil)
shape_temp_db=car(l_shape_temp_db)

l_temp=list(object_type,shape_temp_db,dbid_layer)
l_shapes_all_db=cons(l_temp,l_shapes_all_db)

axlDBAddProp(l_shape_temp_db,list("OBJ_TYPE",object_type))
axlDBAddProp(l_shape_temp_db,list("OBJ_LAYER",dbid_layer))

) ;; l_poly_local


else
if(objType=="shape"
then

object_type="S"

if(nindex(dbid_brd->layer,"SILKSCREEN")!=nil
then
dbid_layer="SILK"
else
if(nindex(dbid_brd->layer,"SOLDERMASK")!=nil
then
dbid_layer="MASK"
)) ;; 


l_poly_temp = axlPolyFromDB(dbid_brd ?endCapType endType)

l_poly_local=nil

foreach(poly_temp,l_poly_temp
l_poly_local = (axlPolyOperation l_poly_local poly_temp 'OR)
) ;; l_poly_temp

foreach(poly,l_poly_local

l_shape_temp_db=axlDBCreateShape(poly, t, skill_layer, nil, nil)
shape_temp_db=car(l_shape_temp_db)

l_temp=list(object_type,shape_temp_db,dbid_layer)
l_shapes_all_db=cons(l_temp,l_shapes_all_db)

axlDBAddProp(l_shape_temp_db,list("OBJ_TYPE",object_type))
axlDBAddProp(l_shape_temp_db,list("OBJ_LAYER",dbid_layer))

) ;; l_poly_local


else
if(objType=="pin" || objType=="via"
then

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if(objType=="pin" && test_layer=="TOP"
then
padstack_layer="PIN/SOLDERMASK_TOP"
object_type="P"

else
if(objType=="via" && test_layer=="TOP"
then
padstack_layer="VIA CLASS/SOLDERMASK_TOP"
object_type="V"

else
if(objType=="pin" && test_layer=="BOTTOM"
then
padstack_layer="PIN/SOLDERMASK_BOTTOM"
object_type="P"

else
if(objType=="via" && test_layer=="BOTTOM"
then
padstack_layer="VIA CLASS/SOLDERMASK_BOTTOM"
object_type="V"

))))) ;; if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dbid_layer="MASK"

l_poly_temp = axlPolyFromDB(dbid_brd, ?layer padstack_layer ?padType 'regular)

l_poly_local=nil

foreach(poly_temp,l_poly_temp
l_poly_local = (axlPolyOperation l_poly_local poly_temp 'OR)
) ;; l_poly_temp

foreach(poly,l_poly_local

l_shape_temp_db=axlDBCreateShape(poly, t, skill_layer, nil, nil)
shape_temp_db=car(l_shape_temp_db)

l_temp=list(object_type,shape_temp_db,dbid_layer)
l_shapes_all_db=cons(l_temp,l_shapes_all_db)

axlDBAddProp(l_shape_temp_db,list("OBJ_TYPE",object_type))
axlDBAddProp(l_shape_temp_db,list("OBJ_LAYER",dbid_layer))

) ;; l_poly_local

))) ;; if



) ;; l_dbid_brd


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


axlSetFindFilter(?enabled '("noall" "shapes") ?onButtons '("noall" "shapes"))

l_poly_errors=nil
l_errors_menu=nil

foreach(l_shape_db,l_shapes_all_db

object_type=car(l_shape_db)
shape_db=cadr(l_shape_db)
object_layer=nth(2,l_shape_db)

l_poly_shape = axlPolyFromDB(shape_db ?endCapType endType)
l_poly_shape_expand = (axlPolyExpand l_poly_shape airgap_input_half 'ALL_ARC)
poly_shape_expand=car(l_poly_shape_expand)

l_box=poly_shape_expand->bBox

if(l_box != nil then  ; raf

axlClearSelSet()
axlAddSelectBox(l_box)

l_shapes_temp_db=axlGetSelSet()

foreach(shape_temp_db,l_shapes_temp_db

object_type_temp=shape_temp_db->prop->OBJ_TYPE
object_layer_temp=shape_temp_db->prop->OBJ_LAYER

l_objtype=nil
object_type_both="-"

when(shape_db!=shape_temp_db && shape_temp_db->layer==skill_layer && object_type_temp!=nil

l_objtype=list(object_type,object_type_temp)
l_objtype=sort(l_objtype,'alphalessp)
object_type_both=strcat(car(l_objtype),"-",cadr(l_objtype))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when( (silk_mask_checkbox==nil && object_layer==object_layer_temp && (diff_objtype_checkbox==nil || (diff_objtype_checkbox==t && object_type!=object_type_temp)) ) ||
(silk_mask_checkbox==t && object_layer!=object_layer_temp && (diff_objtype_checkbox==nil || (diff_objtype_checkbox==t && object_type!=object_type_temp)) )

l_poly_shape_temp = axlPolyFromDB(shape_temp_db ?endCapType endType)
l_poly_shape_temp_expand = (axlPolyExpand l_poly_shape_temp airgap_input_half 'ALL_ARC)

l_poly_uncommon = (axlPolyOperation l_poly_shape_expand l_poly_shape_temp_expand 'AND)
poly_uncommon=car(l_poly_uncommon)

shape_area=poly_uncommon->area

;; printf("\n%L\t%L",poly_uncommon,shape_area)
;; axlEnterPoint()

when(poly_uncommon!=nil

foreach(poly,l_poly_uncommon

l_box=poly->bBox

ll=car(poly->bBox)
ur=cadr(poly->bBox)
x1=car(ll)
y1=cadr(ll)
x2=car(ur)
y2=cadr(ur)
width=x2-x1
height=y2-y1

width_half=width/2
height_half=height/2

point_x=x1+width_half
point_y=y1+height_half
point_xy=point_x:point_y

sprintf(point_x_str "%L" point_x)
sprintf(point_y_str "%L" point_y)
sprintf(shape_area_str "%L" shape_area)

string=strcat(object_type_both," | ",point_x_str," | ",point_y_str," | ",shape_area_str)

;;;;;;;;;;;;;;;;;;;;

fprintf(fp_raf,"%s\t%L\t%L\n",object_type_both,point_xy,shape_area)

;;;;;;;;;;;;;;;;;;;;

l_errors_menu=cons(string,l_errors_menu)

;; l_dbid=axlDBCreateExternalDRC( list(object_type_both "0") point_xy drc_layer, nil nil "0")

l_shape_temp_db=axlDBCreateShape(poly, t, skill_layer, nil, nil)
shape_temp_db=car(l_shape_temp_db)

l_temp=list(shape_area,poly,object_type,object_type_temp)
l_poly_errors=cons(l_temp,l_poly_errors)

) ;; l_poly_uncommon
) ;; poly_uncommon

) ;; when

) ;; when
) ;; l_shapes_temp_db
) ;; if raf
) ;; l_shapes_all_db


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_poly_errors=unique(l_poly_errors)
l_poly_errors=sortcar(l_poly_errors,'lessp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

func_delete()

l_errors_menu=unique(l_errors_menu)
l_errors_menu=sort(l_errors_menu,'alphalessp)

axlFormSetField(form "l_errors_menu" l_errors_menu)

close(fp_raf)

;axlUIViewFileCreate("total_violations.txt" "total_violations" nil)

end_time=getCurrentTime()

time_diff=compareTime(end_time,start_time_local)
time_diff=time_diff/60


axlUIWPrint(fform,"Errors : %L | Time (min) : %L",length(l_poly_errors),time_diff)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


axlClearSelSet()



) ;; select


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("l_errors_menu"

axlClearSelSet()

axlSetFindFilter(?enabled '("noall" "text" "lines" "shapes") ?onButtons '("noall" "text" "lines" "shapes"))

l_errors_selected=axlFormListGetSelItems(form "l_errors_menu")
zoom_input=axlFormGetField(form "zoom_input")

l_dbid_all=nil
l_points_x=nil
l_points_y=nil

foreach(error_selected,l_errors_selected

l_string=parseString(error_selected," | ")
object_type_both=car(l_string)
point_x_str=cadr(l_string)
point_y_str=nth(2,l_string)

point_x=atof(point_x_str)
point_y=atof(point_y_str)

point_xy=point_x:point_y

ll_xy=point_x-1:point_y-1
ur_xy=point_x+1:point_y+1
lr_xy=point_x+1:point_y-1
ul_xy=point_x-1:point_y+1

l_points_x=cons(xCoord(ll_xy),l_points_x)
l_points_x=cons(xCoord(ur_xy),l_points_x)

l_points_y=cons(yCoord(ll_xy),l_points_y)
l_points_y=cons(yCoord(ur_xy),l_points_y)

) ;; l_errors_selected


l_points_x=sort(l_points_x,'lessp)
l_points_y=sort(l_points_y,'lessp)

ll_xy=car(l_points_x):car(l_points_y)
ur_xy=car(last(l_points_x)):car(last(l_points_y))

l_box=list(ll_xy,ur_xy)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

point_x1=xCoord(ll_xy)-zoom_input
point_y1=yCoord(ll_xy)-zoom_input
point_x2=xCoord(ur_xy)+zoom_input
point_y2=yCoord(ur_xy)+zoom_input

l_points_ll=list(point_x1,point_y1)
l_points_ur=list(point_x2,point_y2)

l_box=list(l_points_ll,l_points_ur)


axlWindowBoxSet(l_box)


) ;; l_errors_menu



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



("ignore"


l_errors_selected=axlFormListGetSelItems(form "l_errors_menu")
zoom_input=axlFormGetField(form "zoom_input")

index=0

foreach(error_selected,l_errors_selected
index=length(l_errors_menu)-length(member(error_selected,l_errors_menu))
l_errors_menu=remove(error_selected,l_errors_menu)
) ;; l_errors_selected

axlFormListDeleteAll(form "l_errors_menu")
axlFormSetField(form "l_errors_menu" l_errors_menu)


when(index==length(l_errors_menu)
index--
) ;; when

axlFormListSelect(form "l_errors_menu" index)


) ;; ignore





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("view"

axlClearSelSet()

axlSetFindFilter(?enabled '("noall" "text" "lines" "shapes") ?onButtons '("noall" "text" "lines" "shapes"))

l_errors_selected=axlFormListGetSelItems(form "l_errors_menu")
zoom_input=axlFormGetField(form "zoom_input")

l_violations_xy=nil

foreach(error_selected,l_errors_selected

l_string=parseString(error_selected," | ")
object_type_both=car(l_string)
point_x_str=cadr(l_string)
point_y_str=nth(2,l_string)

point_x=atof(point_x_str)
point_y=atof(point_y_str)

point_xy=point_x:point_y

l_temp=list(object_type_both,point_xy)
l_violations_xy=append1(l_violations_xy,l_temp)

) ;; l_errors_selected


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fp=outfile("l_violations_xy.txt" "w")

foreach(violation_xy,l_violations_xy

object_type_both=car(violation_xy)
point_xy=cadr(violation_xy)

fprintf(fp,"%s\t%L\n",object_type_both,point_xy)


) ;; l_error_xy

close(fp)



axlUIViewFileCreate("l_violations_xy.txt" "l_violations_xy" nil)


) ;; view


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



("close1"

axlClearSelSet()

func_delete()

;exit()
axlFormClose(fform)
axlCancelEnterFun()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing tool info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;when(tool_run=="yes"

;login_name=getLogin()
;end_time=getCurrentTime()
;time_diff=compareTime(end_time,start_time)

;sprintf(time_str "%L" time_diff)

;tool_name="Check Silk Overlapping$"
;tool_name=strcat("$",tool_name,time_str)

;temp=strcat(login_name,"$",axlCurrentDesign())
;temp=strcat(temp,tool_name)
;temp=strcat(temp "$" time_combined)
;share_path="//192.168.100.248/rd-altanova_tools/Skill_Program/tool_data/"

;file_name_backup=strcat(share_path,temp,".txt")

;fbackup=outfile(file_name_backup,"w")

;when(fbackup!=nil
;fprintf(fbackup,";; Owner : %s | BRD : %s | Working Directory : %s | ;;",login_name,axlCurrentDesign(),getWorkingDir())
;close(fbackup)
;)

;) ;; tool_run

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing tool info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


) ;; close1


) ;; 
) ;; check_silk_overlapping_action











;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun form_function ()

fform=outfile("check_silk_overlapping_form.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")   
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 38 60\n")
fprintf(fform,"HEADER \"(R&D-Altanova)\"\n")
fprintf(fform,"TILE\n")

fprintf(fform,"TABSET \"tab\"\n")
fprintf(fform,"FLOC 2 1\n")
fprintf(fform,"FSIZE 37 51\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"TAB \"Menu\"\n")


fprintf(fform,"TEXT \"Airgap :\"\n")
fprintf(fform,"TLOC 1 1\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD airgap_input\n")
fprintf(fform,"FLOC 8 1\n")
fprintf(fform,"REALFILLIN 5 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"TEXT \"unit\"\n")
fprintf(fform,"TLOC 15 1\n")
fprintf(fform,"ENDTEXT\n")


fprintf(fform,"FIELD line_checkbox\n")
fprintf(fform,"FLOC 1 5\n")
fprintf(fform,"CHECKLIST \"L\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD text_checkbox\n")
fprintf(fform,"FLOC 9 5\n")
fprintf(fform,"CHECKLIST \"T\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD shape_checkbox\n")
fprintf(fform,"FLOC 17 5\n")
fprintf(fform,"CHECKLIST \"S\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD silk_mask_checkbox\n")
fprintf(fform,"FLOC 25 5\n")
fprintf(fform,"CHECKLIST \"Silk-Mask\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD diff_objtype_checkbox\n")
fprintf(fform,"FLOC 1 7\n")
fprintf(fform,"CHECKLIST \"Different ObjType only?\"\n")
fprintf(fform,"ENDFIELD\n")


/*

fprintf(fform,"FIELD line_checkbox\n")
fprintf(fform,"FLOC 1 5\n")
fprintf(fform,"CHECKLIST \"L-L\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD text_checkbox\n")
fprintf(fform,"FLOC 9 5\n")
fprintf(fform,"CHECKLIST \"L-T\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD shape_checkbox\n")
fprintf(fform,"FLOC 17 5\n")
fprintf(fform,"CHECKLIST \"T-T\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD silk_mask_checkbox\n")
fprintf(fform,"FLOC 25 5\n")
fprintf(fform,"CHECKLIST \"Silk-Mask\"\n")
fprintf(fform,"ENDFIELD\n")

*/

fprintf(fform,"GROUP \"Option\"\n")
fprintf(fform,"FLOC 0 3\n")
fprintf(fform,"FSIZE 36 6\n")
fprintf(fform,"ENDGROUP\n")


fprintf(fform,"FIELD brd_top_silk_checkbox\n")
fprintf(fform,"FLOC 1 11\n")
fprintf(fform,"CHECKLIST \"BRD T.Silk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD pkg_top_silk_checkbox\n")
fprintf(fform,"FLOC 13 11\n")
fprintf(fform,"CHECKLIST \"PKG T.Silk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD refdes_top_silk_checkbox\n")
fprintf(fform,"FLOC 25 11\n")
fprintf(fform,"CHECKLIST \"REF T.Silk\"\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD brd_bot_silk_checkbox\n")
fprintf(fform,"FLOC 1 13\n")
fprintf(fform,"CHECKLIST \"BRD B.Silk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD pkg_bot_silk_checkbox\n")
fprintf(fform,"FLOC 13 13\n")
fprintf(fform,"CHECKLIST \"PKG B.Silk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD refdes_bot_silk_checkbox\n")
fprintf(fform,"FLOC 25 13\n")
fprintf(fform,"CHECKLIST \"REF B.Silk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD brd_top_mask_checkbox\n")
fprintf(fform,"FLOC 1 16\n")
fprintf(fform,"CHECKLIST \"BRD T.Msk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD pkg_top_mask_checkbox\n")
fprintf(fform,"FLOC 13 16\n")
fprintf(fform,"CHECKLIST \"PKG T.Msk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD pad_top_mask_checkbox\n")
fprintf(fform,"FLOC 25 16\n")
fprintf(fform,"CHECKLIST \"PAD T.Msk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD brd_bot_mask_checkbox\n")
fprintf(fform,"FLOC 1 18\n")
fprintf(fform,"CHECKLIST \"BRD B.Msk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD pkg_bot_mask_checkbox\n")
fprintf(fform,"FLOC 13 18\n")
fprintf(fform,"CHECKLIST \"PKG B.Msk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD pad_bot_mask_checkbox\n")
fprintf(fform,"FLOC 25 18\n")
fprintf(fform,"CHECKLIST \"PAD B.Msk\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"GROUP \"Layers\"\n")
fprintf(fform,"FLOC 0 9\n")
fprintf(fform,"FSIZE 36 12\n")
fprintf(fform,"ENDGROUP\n")


fprintf(fform,"TEXT \"Violations\"\n")
fprintf(fform,"TLOC 14 20\n")
fprintf(fform,"OPTIONS bold\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD l_errors_menu\n")
fprintf(fform,"FLOC 1 22\n")
fprintf(fform,"LIST \"\" 34 14\n")
fprintf(fform,"OPTIONS multiselect 'doubleClick\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"ENDTAB\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"TAB \"About\"\n")

fprintf(fform,"FIELD bitmap2\n")
fprintf(fform,"THUMBNAIL \"C:/cadence_skill_files/skill_files/rd-altanova_logo\"\n")
;fprintf(fform,"OPTIONS stretch\n")
fprintf(fform,"FLOC 65 27\n")
fprintf(fform,"FSIZE 16 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 7 10\n")
fprintf(fform,"FSIZE 40 13\n")
fprintf(fform,"ENDGROUP\n")

fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 9 11\n")
fprintf(fform,"FSIZE 38 11\n")
fprintf(fform,"ENDGROUP\n")


fprintf(fform,"TEXT \" Programmed By \"\n")
fprintf(fform,"TLOC 10 10\n")
fprintf(fform,"OPTIONS bold\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"AMAN ULLAH GHAZI\"\n")
fprintf(fform,"TLOC 12 13\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"Software Engineer\"\n")
fprintf(fform,"TLOC 12 15\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"R&&D-Altanova\"\n")
fprintf(fform,"TLOC 12 17\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"Email: ghaziaman.ullah@hotmail.com\"\n")
fprintf(fform,"TLOC 12 19\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 1\n")
fprintf(fform,"FSIZE 81 33\n")
fprintf(fform,"ENDGROUP\n")


fprintf(fform,"ENDTAB\n")



;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"ENDTABSET\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"TEXT \"Zoom :\"\n")
fprintf(fform,"OPTIONS BOLD\n")
fprintf(fform,"TLOC 25 52\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD zoom_input\n")
fprintf(fform,"FLOC 30 52\n")
fprintf(fform,"INTFILLIN 5 8\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD select\n")
fprintf(fform,"FLOC 2 52\n")
fprintf(fform,"MENUBUTTON \"Select\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD view\n")
fprintf(fform,"FLOC 2 54\n")
fprintf(fform,"MENUBUTTON \"View\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD ignore\n")
fprintf(fform,"FLOC 12 54\n")
fprintf(fform,"MENUBUTTON \"Ignore\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD close1\n")
fprintf(fform,"FLOC 25 54\n")
fprintf(fform,"MENUBUTTON \"Close\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"ENDTILE\n")
fprintf(fform,"ENDFORM\n")

close(fform)

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; delete objects

(defun func_delete ()

l_shapes_skill_db=axlDBGetShapes(skill_layer)
axlDeleteObject(l_shapes_skill_db)

)

;;;; delete objects


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
