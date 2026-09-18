axlCmdRegister("check_airgap_cu_cu" 'check_airgap_cu_cu)

(defun check_airgap_cu_cu ()

form_function()

form=axlFormCreate((gensym),"check_airgap_cu_cu_form.form",'(e outer),'check_airgap_cu_cu_action,t)

axlFormSetDecimal(form,"airgap_input",4)

axlFormDisplay(form)

axlUIWDisableQuit(form)

start_time=getCurrentTime()

tool_run="no"
time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))


axlFormSetField(form "airgap_input" '5.0)

axlFormSetField(form "same_net_checkbox" t)
axlFormSetField(form "different_net_checkbox" t)
axlFormSetField(form "hole_line_checkbox" t)
axlFormSetField(form "hole_shape_checkbox" t)
axlFormSetField(form "hole_line_input" 15.0)
axlFormSetField(form "hole_shape_input" 15.0)
axlFormSetField(form "cu_cu_input" 5.0)
axlFormSetField(form "cu_cu_checkbox" t)
axlFormSetField(form "pin_pin_checkbox" t)
axlFormSetField(form "pin_pin_input" '5.0)

axlFormSetField(form "smd_pin_checkbox" t)
axlFormSetField(form "thru_pin_checkbox" t)


axlFormSetFieldEditable(form "highlite" nil)

axlFormSetFieldEditable(form "cu_cu_input" nil)
axlFormSetFieldEditable(form "cu_cu_checkbox" nil)


skill_layer="BOARD GEOMETRY/SKILL_LAYER"

axlLayerCreateNonConductor(skill_layer)
axlVisibleLayer(skill_layer t)
axlFlushDisplay()

func_delete()

zoom_input=100
axlFormSetField(form "zoom_input" zoom_input)


) ;; main funtion


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun check_airgap_cu_cu_action (fform)


(case fform->curField


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("suppress_pad"

suppress_pad=axlFormGetField(form "suppress_pad")

if(suppress_pad==t
then
axlPadSuppressSet('on 'all)
tool_run="yes"

else
axlPadSuppressSet('off 'all)
) ;; if suppress_pad

axlVisibleUpdate(nil)

) ;; suppress_pad


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("same_net_checkbox"

same_net_checkbox=axlFormGetField(form "same_net_checkbox")
different_net_checkbox=axlFormGetField(form "different_net_checkbox")
cu_cu_checkbox=axlFormGetField(form "cu_cu_checkbox")
hole_line_checkbox=axlFormGetField(form "hole_line_checkbox")
hole_shape_checkbox=axlFormGetField(form "hole_shape_checkbox")

if( (same_net_checkbox==t || different_net_checkbox==t) && (hole_line_checkbox==t || hole_shape_checkbox==t || cu_cu_checkbox==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
)

) ;; same_net_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("different_net_checkbox"

same_net_checkbox=axlFormGetField(form "same_net_checkbox")
different_net_checkbox=axlFormGetField(form "different_net_checkbox")
cu_cu_checkbox=axlFormGetField(form "cu_cu_checkbox")
hole_line_checkbox=axlFormGetField(form "hole_line_checkbox")
hole_shape_checkbox=axlFormGetField(form "hole_shape_checkbox")

if( (same_net_checkbox==t || different_net_checkbox==t) && (hole_line_checkbox==t || hole_shape_checkbox==t || cu_cu_checkbox==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
)

) ;; different_net_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("hole_line_checkbox"

hole_line_checkbox=axlFormGetField(form "hole_line_checkbox")
hole_shape_checkbox=axlFormGetField(form "hole_shape_checkbox")
cu_cu_checkbox=axlFormGetField(form "cu_cu_checkbox")
cu_cu_input=axlFormGetField(form "cu_cu_input")
same_net_checkbox=axlFormGetField(form "same_net_checkbox")
different_net_checkbox=axlFormGetField(form "different_net_checkbox")

pin_pin_checkbox=axlFormGetField(form "pin_pin_checkbox")
smd_pin_checkbox=axlFormGetField(form "different_net_checkbox")
thru_pin_checkbox=axlFormGetField(form "different_net_checkbox")


if(hole_line_checkbox==t
then
axlFormSetFieldEditable(form "hole_line_input" t)
else
axlFormSetFieldEditable(form "hole_line_input" nil)
) ;; if

if(hole_shape_checkbox==t
then
axlFormSetFieldEditable(form "hole_shape_input" t)
else
axlFormSetFieldEditable(form "hole_shape_input" nil)
) ;; if

if(pin_pin_checkbox==t
then
axlFormSetFieldEditable(form "pin_pin_input" t)
axlFormSetFieldEditable(form "smd_pin_checkbox" t)
axlFormSetFieldEditable(form "thru_pin_checkbox" t)
else
axlFormSetFieldEditable(form "pin_pin_input" nil)
axlFormSetFieldEditable(form "smd_pin_checkbox" nil)
axlFormSetFieldEditable(form "thru_pin_checkbox" nil)
) ;; if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if( (same_net_checkbox==t || different_net_checkbox==t) && (hole_line_checkbox==t || hole_shape_checkbox==t || cu_cu_checkbox==t || pin_pin_checkbox==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
) ;; if

if(hole_line_checkbox==nil && hole_shape_checkbox==nil && pin_pin_checkbox==nil
then
axlFormSetFieldEditable(form "cu_cu_input" t)
axlFormSetFieldEditable(form "cu_cu_checkbox" t)

else
axlFormSetFieldEditable(form "cu_cu_input" nil)
axlFormSetFieldEditable(form "cu_cu_checkbox" nil)
) ;; if


) ;; hole_line_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("hole_shape_checkbox"

hole_line_checkbox=axlFormGetField(form "hole_line_checkbox")
hole_shape_checkbox=axlFormGetField(form "hole_shape_checkbox")
cu_cu_checkbox=axlFormGetField(form "cu_cu_checkbox")
cu_cu_input=axlFormGetField(form "cu_cu_input")
same_net_checkbox=axlFormGetField(form "same_net_checkbox")
different_net_checkbox=axlFormGetField(form "different_net_checkbox")

pin_pin_checkbox=axlFormGetField(form "pin_pin_checkbox")
smd_pin_checkbox=axlFormGetField(form "different_net_checkbox")
thru_pin_checkbox=axlFormGetField(form "different_net_checkbox")


if(hole_line_checkbox==t
then
axlFormSetFieldEditable(form "hole_line_input" t)
else
axlFormSetFieldEditable(form "hole_line_input" nil)
) ;; if

if(hole_shape_checkbox==t
then
axlFormSetFieldEditable(form "hole_shape_input" t)
else
axlFormSetFieldEditable(form "hole_shape_input" nil)
) ;; if

if(pin_pin_checkbox==t
then
axlFormSetFieldEditable(form "pin_pin_input" t)
axlFormSetFieldEditable(form "smd_pin_checkbox" t)
axlFormSetFieldEditable(form "thru_pin_checkbox" t)
else
axlFormSetFieldEditable(form "pin_pin_input" nil)
axlFormSetFieldEditable(form "smd_pin_checkbox" nil)
axlFormSetFieldEditable(form "thru_pin_checkbox" nil)
) ;; if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if( (same_net_checkbox==t || different_net_checkbox==t) && (hole_line_checkbox==t || hole_shape_checkbox==t || cu_cu_checkbox==t || pin_pin_checkbox==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
) ;; if

if(hole_line_checkbox==nil && hole_shape_checkbox==nil && pin_pin_checkbox==nil
then
axlFormSetFieldEditable(form "cu_cu_input" t)
axlFormSetFieldEditable(form "cu_cu_checkbox" t)

else
axlFormSetFieldEditable(form "cu_cu_input" nil)
axlFormSetFieldEditable(form "cu_cu_checkbox" nil)
) ;; if

) ;; hole_shape_checkbox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("pin_pin_checkbox"

hole_line_checkbox=axlFormGetField(form "hole_line_checkbox")
hole_shape_checkbox=axlFormGetField(form "hole_shape_checkbox")
cu_cu_checkbox=axlFormGetField(form "cu_cu_checkbox")
cu_cu_input=axlFormGetField(form "cu_cu_input")
same_net_checkbox=axlFormGetField(form "same_net_checkbox")
different_net_checkbox=axlFormGetField(form "different_net_checkbox")

pin_pin_checkbox=axlFormGetField(form "pin_pin_checkbox")
smd_pin_checkbox=axlFormGetField(form "different_net_checkbox")
thru_pin_checkbox=axlFormGetField(form "different_net_checkbox")


if(hole_line_checkbox==t
then
axlFormSetFieldEditable(form "hole_line_input" t)
else
axlFormSetFieldEditable(form "hole_line_input" nil)
) ;; if

if(hole_shape_checkbox==t
then
axlFormSetFieldEditable(form "hole_shape_input" t)
else
axlFormSetFieldEditable(form "hole_shape_input" nil)
) ;; if

if(pin_pin_checkbox==t
then
axlFormSetFieldEditable(form "pin_pin_input" t)
axlFormSetFieldEditable(form "smd_pin_checkbox" t)
axlFormSetFieldEditable(form "thru_pin_checkbox" t)
else
axlFormSetFieldEditable(form "pin_pin_input" nil)
axlFormSetFieldEditable(form "smd_pin_checkbox" nil)
axlFormSetFieldEditable(form "thru_pin_checkbox" nil)
) ;; if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if( (same_net_checkbox==t || different_net_checkbox==t) && (hole_line_checkbox==t || hole_shape_checkbox==t || cu_cu_checkbox==t || pin_pin_checkbox==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
) ;; if

if(hole_line_checkbox==nil && hole_shape_checkbox==nil && pin_pin_checkbox==nil
then
axlFormSetFieldEditable(form "cu_cu_input" t)
axlFormSetFieldEditable(form "cu_cu_checkbox" t)

else
axlFormSetFieldEditable(form "cu_cu_input" nil)
axlFormSetFieldEditable(form "cu_cu_checkbox" nil)
) ;; if

) ;; pin_pin_checkbox


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



("cu_cu_checkbox"

hole_line_checkbox=axlFormGetField(form "hole_line_checkbox")
hole_shape_checkbox=axlFormGetField(form "hole_shape_checkbox")
cu_cu_checkbox=axlFormGetField(form "cu_cu_checkbox")
cu_cu_input=axlFormGetField(form "cu_cu_input")
same_net_checkbox=axlFormGetField(form "same_net_checkbox")
different_net_checkbox=axlFormGetField(form "different_net_checkbox")

pin_pin_checkbox=axlFormGetField(form "pin_pin_checkbox")

smd_pin_checkbox=axlFormGetField(form "smd_pin_checkbox")
thru_pin_checkbox=axlFormGetField(form "thru_pin_checkbox")



if(cu_cu_checkbox==t
then
axlFormSetFieldEditable(form "cu_cu_input" t)

else
axlFormSetFieldEditable(form "cu_cu_input" nil)
) ;; if


if(hole_line_checkbox==t || hole_shape_checkbox==t || cu_cu_checkbox==t || pin_pin_checkbox==t && (smd_pin_checkbox==t || thru_pin_checkbox==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
) ;; if


) ;; cu_cu_checkbox


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



("select"

start_time_local=getCurrentTime()

func_delete()
func_get_visible_layers()

axlVisibleLayer(skill_layer t)

axlFormListDeleteAll(form "l_violations")

same_net_checkbox=axlFormGetField(form "same_net_checkbox")
different_net_checkbox=axlFormGetField(form "different_net_checkbox")
hole_line_checkbox=axlFormGetField(form "hole_line_checkbox")
hole_shape_checkbox=axlFormGetField(form "hole_shape_checkbox")
hole_shape_input=axlFormGetField(form "hole_shape_input")
hole_line_input=axlFormGetField(form "hole_line_input")

pin_pin_checkbox=axlFormGetField(form "pin_pin_checkbox")
pin_pin_input=axlFormGetField(form "pin_pin_input")

smd_pin_checkbox=axlFormGetField(form "smd_pin_checkbox")
thru_pin_checkbox=axlFormGetField(form "thru_pin_checkbox")

cu_cu_checkbox=axlFormGetField(form "cu_cu_checkbox")
cu_cu_input=axlFormGetField(form "cu_cu_input")

cu_cu_input_half=cu_cu_input/2


when(pin_pin_checkbox==t && smd_pin_checkbox==nil && thru_pin_checkbox==nil
axlFormSetField(form "smd_pin_checkbox" t)
axlFormSetField(form "thru_pin_checkbox" t)
) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlClearSelSet()

l_errors=nil
count_checked=0

when( ((hole_line_checkbox==t && axlFormIsFieldEditable(form,"hole_line_input")==t) || (hole_shape_checkbox==t && axlFormIsFieldEditable(form,"hole_shape_input")==t) && cu_cu_checkbox==nil)

;; printf("\nhole_line_checkbox")

if(hole_line_input>hole_shape_input
then
airgap_ref=hole_line_input

else
airgap_ref=hole_shape_input

) ;; if


axlSetFindFilter(?enabled '("NOALL" "VIAS" "PINS"), ?onButtons '("NOALL" "VIAS" "PINS"))

axlUIWPrint(fform,"Select pins/vias from the layout")
axlSelect(?prompt "Select pins/vias from the layout")

l_pv_db=axlGetSelSet()

axlUIWPrint(fform,"Please wait.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; separating thru pins pins ;;;;;;;;;;

l_pv_thru_db=nil

foreach(dbid,l_pv_db

when(dbid->definition->drillDiameter>0
l_pv_thru_db=cons(dbid,l_pv_thru_db)
) ;; when

) ;; l_db_brd

;;;; removing smd pins ;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlFlushDisplay()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


if(hole_line_checkbox==t && hole_shape_checkbox==t
then
axlSetFindFilter(?enabled '("NOALL" "CLINESEGS" "SHAPES"), ?onButtons '("NOALL" "CLINESEGS" "SHAPES"))

else
if(hole_line_checkbox==t && hole_shape_checkbox==nil
then
axlSetFindFilter(?enabled '("NOALL" "CLINESEGS"), ?onButtons '("NOALL" "CLINESEGS"))

else
if(hole_line_checkbox==nil && hole_shape_checkbox==t
then
axlSetFindFilter(?enabled '("NOALL" "SHAPES"), ?onButtons '("NOALL" "SHAPES"))

))) ;;


;;;;;;;;;;;;;;;;;;;;;;;;;;

count=0
item_count=0

foreach(pv_db,l_pv_thru_db

count++

tool_run="yes"

drill=pv_db->definition->drillDiameter
padstack=pv_db->name
net_pin_via=pv_db->net->name
via_xy=pv_db->xy
drill_radius=drill/2

;;;;;;;;;;;;;;;;;;

l_dbid=axlDBCreateCircle(list(pv_db->xy,drill_radius),'0,skill_layer)

circle_db=car(car(l_dbid))
l_segments_db=circle_db->segments
circle_seg_db=car(l_segments_db)

l_box=circle_db->bBox

lower_left=car(l_box)
upper_right=cadr(l_box)

lower_left=xCoord(lower_left)-airgap_ref:yCoord(lower_left)-airgap_ref
upper_right=xCoord(upper_right)+airgap_ref:yCoord(upper_right)+airgap_ref

l_box_new=list(lower_left,upper_right)

;axlDBCreateRectangle(l_box,nil,layer)
;axlDBCreateRectangle(l_box_new,nil,layer)

axlClearSelSet()
axlAddSelectBox(l_box_new)
l_line_shape_db=axlGetSelSet()

layer_line_shape_old=nil

l_line_shape_temp=nil

foreach(line_shape_db,l_line_shape_db

layer_line_shape=line_shape_db->layer
l_temp=list(layer_line_shape,line_shape_db)
l_line_shape_temp=cons(l_temp,l_line_shape_temp)

) ;; l_line_shape_db


l_line_shape_temp=sortcar(l_line_shape_temp,'alphalessp)
l_line_shape_db=l_line_shape_temp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_airgap_nearby=nil

foreach(line_shape_l,l_line_shape_db

line_shape_db=cadr(line_shape_l)

when(line_shape_db!=circle_db

object=line_shape_db->objType
layer_line_shape=line_shape_db->layer
net_line_shape=line_shape_db->net->name

layer=cadr(parseString(layer_line_shape,"/"))

pad_on_layer=axlPadOnLayer(pv_db,layer_line_shape)

when(pad_on_layer==nil

when(layer_line_shape!=layer_line_shape_old
axlSetActiveLayer(layer_line_shape)
) ;; when



l_airgap = axlAirGap(pv_db line_shape_db nil t)
object1_xy=car(cadr(l_airgap))
object2_xy=cadr(cadr(l_airgap))
airgap = nth(2,cadr(l_airgap))

;;axlEnterPoint()

;; printf("\nAirgap = %L\t%L\t%L",l_airgap,object1_xy,object2_xy)


/*
if(line_shape_db->objType=="line"
then
mid_point=axlMidPointLine(list(start_point,end_point))
else
mid_point=axlMidPointArc(list(start_point,end_point),center,radius,close_wise)
) ;; if
*/

;;;;;;;;;;;;;;

if(net_pin_via==net_line_shape
then
comment_net="Same_net"
else
comment_net="Different_net"
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(airgap!=nil

when( (hole_line_checkbox==t && airgap<hole_line_input) || (hole_shape_checkbox==t && airgap<hole_shape_input)

if(same_net_checkbox==t && different_net_checkbox==t
then
l_items=list(airgap,padstack,via_xy,net_pin_via,net_line_shape,comment_net,object1_xy,object2_xy,layer)
l_errors=cons(l_items,l_errors)

else
if(same_net_checkbox==t && different_net_checkbox==nil && net_pin_via==net_line_shape
then
l_items=list(airgap,padstack,via_xy,net_pin_via,net_line_shape,comment_net,object1_xy,object2_xy,layer)
l_errors=cons(l_items,l_errors)

else
if(same_net_checkbox==nil && different_net_checkbox==t && net_pin_via!=net_line_shape
then
l_items=list(airgap,padstack,via_xy,net_pin_via,net_line_shape,comment_net,object1_xy,object2_xy,layer)
l_errors=cons(l_items,l_errors)

))) ;; if


) ;; when
) ;; when


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

layer_line_shape_old=layer_line_shape

) ;; when
) ;; when


) ;; l_line_shape_db

) ;; l_pv_thru_db


) ;; when hole_line_checkbox/hole_shape_checkbox


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


when(pin_pin_checkbox==t && axlFormIsFieldEditable(form,"pin_pin_input")==t


if(length(l_pin_layers_with_class_visible)>1
then
axlUIConfirm("Only one layer need to be visible for pins")

else

airgap_ref=pin_pin_input

suppress_pad_in_brd="no"

axlSetFindFilter(?enabled '("NOALL" "PINS"), ?onButtons '("NOALL" "PINS"))

axlUIWPrint(fform,"Select pins from the layout")
axlSelect(?prompt "Select pins from the layout")

l_pins_brd_db=axlGetSelSet()

axlUIWPrint(fform,"Please wait.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_pins_thru_db=nil
l_pins_smd_db=nil

foreach(dbid,l_pins_brd_db

if(dbid->definition->drillDiameter==0
then
l_pins_smd_db=cons(dbid,l_pins_smd_db)
else
l_pins_thru_db=cons(dbid,l_pins_thru_db)
) ;; if

) ;; l_pins_brd_db


if(smd_pin_checkbox==t && thru_pin_checkbox==t
then
l_pins_db=l_pins_brd_db

else
if(smd_pin_checkbox==t && thru_pin_checkbox==nil
then
l_pins_db=l_pins_smd_db

else
if(smd_pin_checkbox==nil && thru_pin_checkbox==t
then
l_pins_db=l_pins_thru_db

))) ;; if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlFlushDisplay()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


count=0
item_count=0


pin_layer_with_class=car(l_pin_layers_with_class_visible)
axlSetActiveLayer(pin_layer_with_class)

foreach(pin_db,l_pins_db

count++

tool_run="yes"

drill=pin_db->definition->drillDiameter
padstack=pin_db->name
net_pin=pin_db->net->name
pin_xy=pin_db->xy
drill_radius=drill/2

;;;;;;;;;;;;;;;;;;

layer=cadr(parseString(pin_layer_with_class,"/"))
etch_layer_with_class=strcat("ETCH/",layer)


l_poly_pin = axlPolyFromDB(pin_db, ?layer etch_layer_with_class ?padType 'regular)

poly_pin=car(l_poly_pin)

when(poly_pin==nil
suppress_pad_in_brd="yes"
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(poly_pin!=nil

count_checked++

l_box=poly_pin->bBox

lower_left=car(l_box)
upper_right=cadr(l_box)

lower_left=xCoord(lower_left)-airgap_ref:yCoord(lower_left)-airgap_ref
upper_right=xCoord(upper_right)+airgap_ref:yCoord(upper_right)+airgap_ref

l_box_new=list(lower_left,upper_right)


axlClearSelSet()
axlAddSelectBox(l_box_new)
l_pins_local_brd_db=axlGetSelSet()

l_pins_local_db=nil

foreach(pin_local_db,l_pins_local_brd_db

if(smd_pin_checkbox==t && thru_pin_checkbox==t
then
l_pins_local_db=cons(pin_local_db,l_pins_local_db)

else
if(smd_pin_checkbox==t && thru_pin_checkbox==nil && pin_local_db->definition->drillDiameter==0
then
l_pins_local_db=cons(pin_local_db,l_pins_local_db)

else
if(smd_pin_checkbox==nil && thru_pin_checkbox==t && pin_local_db->definition->drillDiameter>0
then
l_pins_local_db=cons(pin_local_db,l_pins_local_db)

))) ;; if

) ;; l_pins_local_brd_db


;;;;;;;;;;;;;;;;;;

foreach(pin_local_db,l_pins_local_db

when(pin_db!=pin_local_db && axlPadOnLayer(pin_local_db,etch_layer_with_class)!=nil

net_pin_local=pin_local_db->net->name

l_airgap = axlAirGap(pin_db pin_local_db nil t)
object1_xy=car(cadr(l_airgap))
object2_xy=cadr(cadr(l_airgap))
airgap = nth(2,cadr(l_airgap))

;;printf("\n%L",l_airgap)

;;;;;;;;;;;;;;

if(net_pin==net_pin_local
then
comment_net="Same_net"
else
comment_net="Different_net"
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(airgap!=nil && airgap<pin_pin_input

if(same_net_checkbox==t && different_net_checkbox==t
then
l_items=list(airgap,padstack,pin_xy,net_pin,net_pin_local,comment_net,object1_xy,object2_xy,layer)
l_errors=cons(l_items,l_errors)

else
if(same_net_checkbox==t && different_net_checkbox==nil && net_pin==net_pin_local
then
l_items=list(airgap,padstack,pin_xy,net_pin,net_pin_local,comment_net,object1_xy,object2_xy,layer)
l_errors=cons(l_items,l_errors)

else
if(same_net_checkbox==nil && different_net_checkbox==t && net_pin!=net_pin_local
then
l_items=list(airgap,padstack,pin_xy,net_pin,net_pin_local,comment_net,object1_xy,object2_xy,layer)
l_errors=cons(l_items,l_errors)

))) ;; if


) ;; when


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

) ;; when


) ;; l_pins_local_db

) ;; when poly_pin

) ;; l_pins_db

) ;; if



printf("\n----------------------------------------------------------")
printf("\nTotal Pins Checked : %L",count_checked)
printf("\n----------------------------------------------------------")

when(suppress_pad_in_brd=="yes"
axlUIConfirm("\nPins/Vias must not be suppressed.")
) ;; when





) ;; when pin_pin_checkbox


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(cu_cu_checkbox==t && axlFormIsFieldEditable(form,"cu_cu_input")==t

func_delete()

axlSetFindFilter(?enabled '("NOALL" "VIAS" "PINS" "CLINESEGS" "SHAPES"), ?onButtons '("NOALL" "VIAS" "PINS" "CLINESEGS" "SHAPES"))

axlUIWPrint(fform,"Select pins/via/clines/shapes from the layout")
axlSelect(?prompt "Select pins/via/clines/shapes from the layout")

l_dbid=axlGetSelSet()

axlUIWPrint(fform,"Please wait.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlFlushDisplay()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


airgap_ref=cu_cu_input/2


func_get_visible_layers()

l_errors=nil
count=0
endType = 'ROUND

axlSetActiveLayer(skill_layer)


foreach(layer_visible,l_layers_visible

layer_with_class=strcat("ETCH/",layer_visible)

foreach(dbid,l_dbid

dbid_layer=nil

when(dbid->objType=="line" || dbid->objType=="arc" || dbid->objType=="shape"
dbid_layer=cadr(parseString(dbid->layer,"/"))
) ;; 

item_count_ref=0
object="-"


if( (dbid->objType=="line" || dbid->objType=="arc") && dbid_layer==layer_visible
then
object="L"
item_count_ref++
l_poly_dbid=axlPolyFromDB(dbid ?endCapType endType)
l_poly_dbid_expand=axlPolyExpand(l_poly_dbid,airgap_ref,'ALL_ARC)
net1=dbid->net->name
padstack="-"
via_xy=list(0,0)

else
if(dbid->objType=="shape" && dbid_layer==layer_visible
then
object="S"
item_count_ref++
l_poly_dbid=axlPolyFromDB(dbid ?endCapType endType)
l_poly_dbid_expand=axlPolyExpand(l_poly_dbid,airgap_ref,'ALL_ARC)
net1=dbid->net->name
padstack="-"
via_xy=list(0,0)

else
if(dbid->objType=="pin" && axlPadOnLayer(dbid,layer_with_class)==t
then
object="P"
item_count_ref++
l_poly_dbid = axlPolyFromDB(dbid, ?layer layer_with_class ?padType 'REGULAR)
l_poly_dbid_expand=axlPolyExpand(l_poly_dbid,airgap_ref,'ALL_ARC)
net1=dbid->net->name
padstack=dbid->name
via_xy=dbid->xy

else
if(dbid->objType=="via" && axlPadOnLayer(dbid,layer_with_class)==t
then
object="V"
item_count_ref++
l_poly_dbid = axlPolyFromDB(dbid, ?layer layer_with_class ?padType 'REGULAR)
l_poly_dbid_expand=axlPolyExpand(l_poly_dbid,airgap_ref,'ALL_ARC)
net1=dbid->net->name
padstack=dbid->name
via_xy=dbid->xy

)))) ;; if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

count++

l_box=dbid->bBox

lower_left=car(l_box)
upper_right=cadr(l_box)

lower_left=xCoord(lower_left)-airgap_ref:yCoord(lower_left)-airgap_ref
upper_right=xCoord(upper_right)+airgap_ref:yCoord(upper_right)+airgap_ref

l_box_new=list(lower_left,upper_right)

;;;;;;;;;;;;;;;;;;

axlClearSelSet()

axlAddSelectBox(l_box_new)
l_dbid_local_db=axlGetSelSet()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

foreach(dbid_local,l_dbid_local_db

l_objects=nil
l_objects=cons(object,l_objects)
item_count=item_count_ref

when(dbid_local!=dbid

dbid_local_layer=nil

when(dbid_local->objType=="line" || dbid_local->objType=="arc" || dbid_local->objType=="shape"
dbid_local_layer=cadr(parseString(dbid_local->layer,"/"))
) ;; 

if( (dbid_local->objType=="line" || dbid_local->objType=="arc") && dbid_local_layer==layer_visible
then
l_objects=cons("L",l_objects)
item_count++
l_poly_local_dbid=axlPolyFromDB(dbid_local ?endCapType endType)
l_poly_local_dbid_expand=axlPolyExpand(l_poly_local_dbid,airgap_ref,'ALL_ARC)
net2=dbid_local->net->name

else
if(dbid_local->objType=="shape" && dbid_local_layer==layer_visible
then
l_objects=cons("S",l_objects)
item_count++
l_poly_local_dbid=axlPolyFromDB(dbid_local ?endCapType endType)
l_poly_local_dbid_expand=axlPolyExpand(l_poly_local_dbid,airgap_ref,'ALL_ARC)
net2=dbid_local->net->name

else
if(dbid_local->objType=="pin" && axlPadOnLayer(dbid_local,layer_with_class)==t
then
l_objects=cons("P",l_objects)
item_count++
l_poly_local_dbid = axlPolyFromDB(dbid_local, ?layer layer_with_class ?padType 'REGULAR)
l_poly_local_dbid_expand=axlPolyExpand(l_poly_local_dbid,airgap_ref,'ALL_ARC)
net2=dbid_local->net->name

else
if(dbid_local->objType=="via" && axlPadOnLayer(dbid_local,layer_with_class)==t
then
l_objects=cons("V",l_objects)
item_count++
l_poly_local_dbid = axlPolyFromDB(dbid_local, ?layer layer_with_class ?padType 'REGULAR)
l_poly_local_dbid_expand=axlPolyExpand(l_poly_local_dbid,airgap_ref,'ALL_ARC)
net2=dbid_local->net->name

)))) ;; if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_objects=sort(l_objects,'alphalessp)

object1=car(l_objects)
object2=cadr(l_objects)

when(object1==nil
object1="-"
)

when(object2==nil
object2="-"
)

item_type=strcat(object1,"-",object2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_poly_uncommon = (axlPolyOperation l_poly_dbid_expand l_poly_local_dbid_expand 'AND)
poly_uncommon=car(l_poly_uncommon)

when(item_count==2 && poly_uncommon!=nil

foreach(poly,l_poly_dbid
l_shape_temp_db=axlDBCreateShape(poly, t, skill_layer, nil, nil)
shape_temp_db=car(l_shape_temp_db)
) ;; l_poly_dbid


foreach(poly,l_poly_local_dbid
l_shape_temp_db=axlDBCreateShape(poly, t, skill_layer, nil, nil)
shape_local_temp_db=car(l_shape_temp_db)
) ;; l_poly_local_dbid


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_airgap = axlAirGap(dbid dbid_local nil t)
object1_xy=car(cadr(l_airgap))
object2_xy=cadr(cadr(l_airgap))
airgap = nth(2,cadr(l_airgap))

;; printf("\nairgap = %L",airgap)

if(net1==net2
then
comment_net="Same_net"
else
comment_net="Different_net"
)

if(same_net_checkbox==t && different_net_checkbox==t
then
l_items=list(airgap,padstack,via_xy,net2,net1,comment_net,object1_xy,object2_xy,layer_visible,l_poly_uncommon)
l_errors=cons(l_items,l_errors)

else
if(same_net_checkbox==t && different_net_checkbox==nil && net2==net1
then
l_items=list(airgap,padstack,via_xy,net2,net1,comment_net,object1_xy,object2_xy,layer_visible,l_poly_uncommon)
l_errors=cons(l_items,l_errors)

else
if(same_net_checkbox==nil && different_net_checkbox==t && net2!=net1
then
l_items=list(airgap,padstack,via_xy,net2,net1,comment_net,object1_xy,object2_xy,layer_visible,l_poly_uncommon)
l_errors=cons(l_items,l_errors)

))) ;; if



) ;; item_count



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




) ;; when 



) ;; l_dbid_local_db



) ;; l_dbid

) ;; l_layers_visible


) ;; when cu_cu_checkbox



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


axlClearSelSet()

l_errors=unique(l_errors)

when(l_errors!=nil
l_errors=sortcar(l_errors,'lessp)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


fp=outfile("check_airgap_hole_hole.txt" "w")
fprintf(fp,"%s\n",axlCurrentDesign())

fprintf(fp,"Airgap\tPadstack\t(Via_x,Via_y)\tNet\tLamination\tComments")

l_violations=nil

count=0

foreach(error,l_errors

airgap=car(error)
padstack=cadr(error)
via_xy=nth(2,error)
net_pin_via=nth(3,error)
net_line_shape=nth(4,error)
comment_net=nth(5,error)
object1_xy=nth(6,error)
object2_xy=nth(7,error)
layer=nth(8,error)
l_poly_uncommon=nth(9,error)


when(net_pin_via==nil
net_pin_via="-"
)

when(net_line_shape==nil
net_line_shape="-"
)

fprintf(fp,"\n%L\t%s\t%L\t%s\t%s\t%s\t%L\t%L\t%s",airgap,padstack,via_xy,net_pin_via,net_line_shape,comment_net,object1_xy,object2_xy,layer)


count++

;;;;;;;;;;;;;


sprintf(airgap_str "%L" airgap)

point1_x=xCoord(object1_xy)
point1_y=yCoord(object1_xy)

point2_x=xCoord(object2_xy)
point2_y=yCoord(object2_xy)

sprintf(point1_x_str "%L" point1_x)
sprintf(point1_y_str "%L" point1_y)

sprintf(point2_x_str "%L" point2_x)
sprintf(point2_y_str "%L" point2_y)

point1_str=strcat(point1_x_str,",",point1_y_str)
point2_str=strcat(point2_x_str,",",point2_y_str)


l_temp=strcat(airgap_str," | ",point1_str," | ",point2_str," | ",layer)
l_violations=append1(l_violations,l_temp)


) ;; l_errors


l_violations=unique(l_violations)

fprintf(fp,"\n\n----------------------------------------------------")
fprintf(fp,"\n\nError Count : %L",count)

close(fp)

;; axlUIViewFileCreate("check_airgap_hole_hole.txt" "check_airgap_hole_hole" nil)

axlClearSelSet()

axlFormListDeleteAll(form "l_violations")
axlFormSetField(form "l_violations" l_violations)


when(l_violations!=nil
axlFormSetFieldEditable(form "highlite" t)
) ;; when

end_time_local=getCurrentTime()
time_diff_local=compareTime(end_time_local,start_time_local)
time_diff_local=time_diff_local/60

axlUIWPrint(fform,"Violations : %L | Time (min) : %L",count,time_diff_local)





) ;; select


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("l_violations"

axlClearSelSet()
func_delete()

axlVisibleDesign(nil)
axlVisibleLayer("BOARD GEOMETRY/OUTLINE" t)
axlVisibleLayer("SUBSTRATE GEOMETRY/OUTLINE" t)
axlVisibleLayer(skill_layer t)


l_violations_selected=axlFormListGetSelItems(form "l_violations")
zoom_input=axlFormGetField(form "zoom_input")


if(hole_line_checkbox==t && hole_shape_checkbox==t
then
axlSetFindFilter(?enabled '("NOALL" "CLINESEGS" "SHAPES"), ?onButtons '("NOALL" "CLINESEGS" "SHAPES"))

else
if(hole_line_checkbox==t && hole_shape_checkbox==nil
then
axlSetFindFilter(?enabled '("NOALL" "CLINESEGS"), ?onButtons '("NOALL" "CLINESEGS"))

else
if(hole_line_checkbox==nil && hole_shape_checkbox==t
then
axlSetFindFilter(?enabled '("NOALL" "SHAPES"), ?onButtons '("NOALL" "SHAPES"))

))) ;;


when(pin_pin_checkbox==t
axlSetFindFilter(?enabled '("NOALL" "PINS"), ?onButtons '("NOALL" "PINS"))
)


l_dbid=nil
l_selected_db=nil

l_violations_xy=nil

drc_x_ur=-9999
drc_y_ur=-9999
drc_x_ll=9999
drc_y_ll=9999
l_points_box=nil

l_violations_x=nil
l_violations_y=nil

foreach(violation_selected,l_violations_selected

l_string=parseString(violation_selected," | ")

l_point1=cadr(l_string)
l_point2=nth(2,l_string)
layer=nth(3,l_string)

layer_with_class=strcat("ETCH/",layer)
axlVisibleLayer(layer_with_class t)
axlVisibleLayer(strcat("PIN/",layer) t)
axlVisibleLayer(strcat("VIA CLASS/",layer) t)

layer_with_class=strcat("CONDUCTOR/",layer)
axlVisibleLayer(layer_with_class t)


l_string=parseString(l_point1," , ")
point1_x=atof(car(l_string))
point1_y=atof(cadr(l_string))

l_point1=point1_x:point1_y

l_string=parseString(l_point2," , ")
point2_x=atof(car(l_string))
point2_y=atof(cadr(l_string))

l_point2=point2_x:point2_y

l_violations_x=cons(point1_x,l_violations_x)
l_violations_x=cons(point2_x,l_violations_x)

l_violations_y=cons(point1_y,l_violations_y)
l_violations_y=cons(point2_y,l_violations_y)


axlSingleSelectPoint(l_point1)
l_dbid=axlGetSelSet()
l_selected_db=append(l_selected_db,l_dbid)

axlSingleSelectPoint(l_point2)
l_dbid=axlGetSelSet()
l_selected_db=append(l_selected_db,l_dbid)

l_temp=list(l_point1,l_point2,layer)

l_violations_xy=append1(l_violations_xy,l_temp)

l_points=list(l_point1,l_point2)

when(l_point1!=l_point2
axlDBCreateLine(l_points,'0,skill_layer)
)


) ;; l_violations_selected


axlVisibleUpdate(nil)


l_violations_x=sort(l_violations_x,'lessp)
l_violations_y=sort(l_violations_y,'lessp)

point_ur=car(last(l_violations_x))+5:car(last(l_violations_y))+5
point_ll=car(l_violations_x)-5:car(l_violations_y)-5

l_violations_xy=reverse(l_violations_xy)
l_violations_xy=unique(l_violations_xy)

drc_xy_ur=drc_x_ur:drc_y_ur
drc_xy_ll=drc_x_ll:drc_y_ll

l_points_box=list(point_ur,point_ll)

axlDBCreateRectangle(l_points_box,nil,skill_layer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

item_count=length(l_selected_db)/2

if(item_count==1
then

mid_point=axlMidPointLine(l_points)


point_x1=xCoord(mid_point)-zoom_input
point_y1=yCoord(mid_point)-zoom_input
point_x2=xCoord(mid_point)+zoom_input
point_y2=yCoord(mid_point)+zoom_input

l_points_ll=list(point_x1,point_y1)
l_points_ur=list(point_x2,point_y2)

l_box=list(l_points_ll,l_points_ur)

axlWindowBoxSet(l_box)


else
axlZoomToDbid(l_selected_db t)


) ;; if



axlSingleSelectObject(l_selected_db)



) ;; l_violations


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("highlite"

l_selected_db=unique(l_selected_db)

axlClearSelSet()
axlHighlightObject(l_selected_db t)
axlFlushDisplay()

) ;; Highlite

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("view"

fp=outfile("l_violations_xy.txt" "w")

foreach(violation_xy,l_violations_xy

l_point1=car(violation_xy)
l_point2=cadr(violation_xy)
layer=nth(2,violation_xy)

l_points=list(l_point1,l_point2)

mid_point=axlMidPointLine(l_points)

fprintf(fp,"%L\t%s\n",mid_point,layer)


) ;; l_error_xy

close(fp)



axlUIViewFileCreate("l_violations_xy.txt" "l_violations_xy" nil)




) ;; view




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("close1"

func_delete()

axlClearSelSet()
axlFormClose(fform)
axlCancelEnterFun()

printf("\n--------------------------------------------------------------");
printf("\n\nProgrammed By...");
printf("\n\nAMAN ULLAH GHAZI,");
printf("\nSoftware Engineer,");
printf("\nR&D-Altanova.");
printf("\nEmail : ghaziaman.ullah@hotmail.com\n\n");


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing tool info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(tool_run=="yes"

login_name=getLogin()
end_time=getCurrentTime()
time_diff=compareTime(end_time,start_time)

sprintf(time_str "%L" time_diff)

tool_name="Check Airgap Cu To Cu$"
tool_name=strcat("$",tool_name,time_str)

temp=strcat(login_name,"$",axlCurrentDesign())
temp=strcat(temp,tool_name)
temp=strcat(temp "$" time_combined)

share_path="//192.168.100.248/rd-altanova_tools/Skill_Program/tool_data/"

file_name_backup=strcat(share_path,temp,".txt")

fbackup=outfile(file_name_backup,"w")

when(fbackup!=nil
fprintf(fbackup,";; Owner : %s | BRD : %s | Working Directory : %s | ;;",login_name,axlCurrentDesign(),getWorkingDir())
close(fbackup)
)

) ;; tool_run

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing tool info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

) ;; close1


) ;; 
) ;; check_airgap_cu_cu_action




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun form_function ()

fform=outfile("check_airgap_cu_cu_form.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")   
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 30 14\n")
fprintf(fform,"HEADER \"(R&D-Altanova)\"\n")
fprintf(fform,"TILE\n")

fprintf(fform,"FIELD same_net_checkbox\n")
fprintf(fform,"FLOC 2 2\n")
fprintf(fform,"CHECKLIST \"Same Net\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD different_net_checkbox\n")
fprintf(fform,"FLOC 16 2\n")
fprintf(fform,"CHECKLIST \"Different Net\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD suppress_pad\n")
fprintf(fform,"FLOC 2 5\n")
fprintf(fform,"CHECKLIST \"Suppress\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"TEXT \"Zoom :\"\n")
fprintf(fform,"OPTIONS BOLD\n")
fprintf(fform,"TLOC 15 5\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD zoom_input\n")
fprintf(fform,"FLOC 21 5\n")
fprintf(fform,"INTFILLIN 5 4\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 0\n")
fprintf(fform,"FSIZE 28 7\n")
fprintf(fform,"ENDGROUP\n")

fprintf(fform,"FIELD hole_line_checkbox\n")
fprintf(fform,"FLOC 2 9\n")
fprintf(fform,"CHECKLIST \"Hole to Line --->\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD hole_line_input\n")
fprintf(fform,"FLOC 20 9\n")
fprintf(fform,"REALFILLIN 6 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD hole_shape_checkbox\n")
fprintf(fform,"FLOC 2 11\n")
fprintf(fform,"CHECKLIST \"Hole to Shape --->\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD hole_shape_input\n")
fprintf(fform,"FLOC 20 11\n")
fprintf(fform,"REALFILLIN 6 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 7\n")
fprintf(fform,"FSIZE 28 7\n")
fprintf(fform,"ENDGROUP\n")

;;;;;;;;;;;;

fprintf(fform,"FIELD pin_pin_checkbox\n")
fprintf(fform,"FLOC 2 15\n")
fprintf(fform,"CHECKLIST \"Pin to Pin --->\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD pin_pin_input\n")
fprintf(fform,"FLOC 20 15\n")
fprintf(fform,"REALFILLIN 6 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD smd_pin_checkbox\n")
fprintf(fform,"FLOC 5 17\n")
fprintf(fform,"CHECKLIST \"SMD\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD thru_pin_checkbox\n")
fprintf(fform,"FLOC 15 17\n")
fprintf(fform,"CHECKLIST \"Thru\"\n")
fprintf(fform,"ENDFIELD\n")




fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 13\n")
fprintf(fform,"FSIZE 28 7\n")
fprintf(fform,"ENDGROUP\n")


fprintf(fform,"FIELD cu_cu_checkbox\n")
fprintf(fform,"FLOC 2 22\n")
fprintf(fform,"CHECKLIST \"Copper to Copper --->\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD cu_cu_input\n")
fprintf(fform,"FLOC 20 22\n")
fprintf(fform,"REALFILLIN 6 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 20\n")
fprintf(fform,"FSIZE 28 5\n")
fprintf(fform,"ENDGROUP\n")



fprintf(fform,"TEXT \"Violations\"\n")
fprintf(fform,"TLOC 11 26\n")
fprintf(fform,"OPTIONS BOLD\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD l_violations\n")
fprintf(fform,"FLOC 1 28\n")
fprintf(fform,"LIST \"\" 28 16\n")
fprintf(fform,"OPTIONS multiselect 'doubleClick\n")
fprintf(fform,"ENDFIELD\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"FIELD select\n")
fprintf(fform,"FLOC 10 64\n")
fprintf(fform,"MENUBUTTON \"Select\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD highlite\n")
fprintf(fform,"FLOC 10 66\n")
fprintf(fform,"MENUBUTTON \"Highlite\" 10 3\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD view\n")
fprintf(fform,"FLOC 10 68\n")
fprintf(fform,"MENUBUTTON \"View\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD close1\n")
fprintf(fform,"FLOC 10 70\n")
fprintf(fform,"MENUBUTTON \"Close\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"ENDTILE\n")
fprintf(fform,"ENDFORM\n")

close(fform)

)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;; delete objects

(defun func_delete ()

l_shapes_skill_db=axlDBGetShapes(skill_layer)
axlDeleteObject(l_shapes_skill_db)

)


;;;; delete objects

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; get visible layers

(defun func_get_visible_layers ()

l_etch_layers=axlSubclasses("ETCH")
l_pin_layers=axlSubclasses("PIN")

l_layers_visible=nil
l_layers_with_class_visible=nil
layer_visible=nil

foreach(layer,l_etch_layers
when(axlIsVisibleLayer(strcat("ETCH/",layer))==t
l_layers_visible=append1(l_layers_visible,layer)
layer=strcat("ETCH/",layer)
l_layers_with_class_visible=append1(l_layers_with_class_visible,layer)
) ;; when

) ;; l_etch_layers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_pin_layers_with_class_visible=nil

foreach(layer,l_pin_layers
when(axlIsVisibleLayer(strcat("PIN/",layer))==t
layer=strcat("PIN/",layer)
l_pin_layers_with_class_visible=append1(l_pin_layers_with_class_visible,layer)
) ;; when
) ;; l_pin_layers


layer_visible=car(l_layers_with_class_visible)


) ;; func_get_visible_layers

;;; get visible layers

