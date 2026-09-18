axlClearSelSet()

start_time=getCurrentTime()
time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))
tool_run="no"

axlLayerCreateNonConductor("BOARD GEOMETRY/SKILL_LAYER")
axlVisibleLayer("BOARD GEOMETRY/SKILL_LAYER" t)

l_etch=axlGetParam("paramLayerGroup:ETCH")
l_etch=l_etch->groupMembers

defstruct(trace_info,l_points,layer,net,drill)


axlUIConfirm("All Pins/Vias must not be suppressed")


axlSetFindFilter(?enabled '("NOALL" "VIAS" "PINS" "SHAPES"), ?onButtons '("NOALL" "VIAS" "PINS" "SHAPES"))
axlUIConfirm("Select Pins/Vias and Shapes...")

axlSelect(?prompt "Select Pins/Vias and Shapes...")

l_db_brd=axlGetSelSet()


axlFlushDisplay()

l_vias_db_brd=nil
l_shapes_db_brd=nil
l_layers=nil

foreach(db,l_db_brd

when(db->objType=="via" && db->definition->drillDiameter>0
l_vias_db_brd=cons(db,l_vias_db_brd))

when(db->objType=="pin" && db->definition->drillDiameter>0
l_vias_db_brd=cons(db,l_vias_db_brd))

when(db->objType=="shape" && member(cadr(parseString(db->layer,"/")),l_etch)!=nil
l_shapes_db_brd=cons(db,l_shapes_db_brd)
l_layers=cons(cadr(parseString(db->layer,"/")),l_layers)
) ;; when

) ;; l_db_brd

l_layers=unique(l_layers)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


l_traces=list()
endType = 'ROUND
count=0
axlMeterCreate("Progress", "", t)

foreach(shape_db,l_shapes_db_brd
count++

tool_run="yes"

axlMeterUpdate((100*count)/length(l_shapes_db_brd),sprintf(nil "Check %d of %d nets" count length(l_shapes_db_brd)))

box=shape_db->bBox

lower_left=car(box)
upper_right=cadr(box)

lower_left=xCoord(lower_left)-100:yCoord(lower_left)-100
upper_right=xCoord(upper_right)+100:yCoord(upper_right)+100

box_new=list(lower_left,upper_right)


l_shape_vias_db=nil

foreach(via_db,l_vias_db_brd
when(shape_db->net->name==via_db->net->name && axlIsPointInsideBox(via_db->xy,box_new)==t

l_shape_vias_db=cons(via_db,l_shape_vias_db)
))

;;;;;;

foreach(via_db,l_shape_vias_db

drill=via_db->definition->drillDiameter
drill=drill-0.1

axlSetActiveLayer(shape_db->layer)

drill_radius=drill/2

l_db=axlDBCreateCircle(list(via_db->xy,drill_radius),'0,"BOARD GEOMETRY/SKILL_LAYER")

circle_db=car(car(l_db))
circle_db=circle_db->segments
circle_db=car(circle_db)

l_polys_circle=axlPolyFromDB(circle_db ?endCapType endType)
l_polys_shape=axlPolyFromDB(shape_db ?endCapType endType)

; get the intersection of the two polygons
l_shieldedPoly = (axlPolyOperation l_polys_circle l_polys_shape 'AND)

shieldedPoly=car(l_shieldedPoly)

when(shieldedPoly!=nil
l_shape_db_temp=axlDBCreateShape(shieldedPoly, nil, "BOARD GEOMETRY/SKILL_LAYER", nil, nil) ;; shape closed itself

shape_db_temp=car(l_shape_db_temp)

l_segments_db=shape_db_temp->segments
segment_db=car(l_segments_db)

when(length(l_segments_db)>1 || (length(l_segments_db)==1 && segment_db->isCircle==nil)

;;printf("\nInside")

layer_with_class=shape_db->layer
layer=cadr(parseString(layer_with_class,"/"))

;;;;;;;;;;;;;; check if trace is tied b/w shape & via

l_shape_connect_db=axlDBGetConnect(shape_db t)
l_via_connect_db=axlDBGetConnect(via_db t)

trace_width=0
l_width=nil

foreach(connect_db l_via_connect_db
when(member(connect_db,l_shape_connect_db)!=nil && connect_db->objType=="path"

l_segments_db=connect_db->segments

foreach(seg_db,l_segments_db
width=seg_db->width
l_width=cons(width,l_width)
) ;; l_segments_db

) ;; when
) ;; l_via_connect_db


when(l_width!=nil

l_width=unique(l_width)
l_width=sort(l_width,'lessp)
l_width=reverse(l_width)
trace_width=car(l_width) ;; pick bigger value

)

;;;;;;;;;;;;;; check if trace is tied b/w shape & via

;;;;;;;;;;;

pad = axlDBGetPad(via_db layer_with_class "REGULAR")

ll=car(pad->bBox)
ur=cadr(pad->bBox)
x1=car(ll)
y1=cadr(ll)
x2=car(ur)
y2=cadr(ur)
width=x2-x1
height=y2-y1


when( abs(width-trace_width)>=1 && width-trace_width>0

l_points=via_db->xy

str_trace=make_trace_info(?l_points,l_points,?layer,layer,?net,shape_db->net->name,?drill,drill+0.1)
l_traces=cons(str_trace,l_traces)

;;printf("\nInside")


) ;; when

) ;; when

;;axlDeleteObject(shape_db_temp)

)

;;axlDeleteObject(circle_db)


) ;; l_shape_vias_db

) ;; l_shapes_db_brd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ftemp=outfile("chk_hole_shp_rpt.txt" "w")

fprintf(ftemp,"%s\n",axlCurrentDesign())

fprintf(ftemp,"Layer\tNet\t(Via_x,Via_y)")

foreach(layer,l_layers
foreach(str_trace,l_traces
when(layer==str_trace->layer
fprintf(ftemp,"\n%s\t%s\t%L",str_trace->layer,str_trace->net,str_trace->l_points)
)
)
)

close(ftemp)


axlUIViewFileCreate("chk_hole_shp_rpt.txt" "chk_hole_shp_rpt" nil)

axlClearSelSet()

axlMeterDestroy()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing tool info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



/*
when(tool_run=="yes"



login_name=getLogin()

;end_time=getCurrentTime()
;time_diff=compareTime(end_time,start_time)

;sprintf(time_str "%L" time_diff)

;tool_name="Check Hole On Shape Boundary$"
;tool_name=strcat("$",tool_name,time_str)

;temp=strcat(login_name,"$",axlCurrentDesign())
;temp=strcat(temp,tool_name)
;temp=strcat(temp "$" time_combined)
;share_path="//192.168.100.248/rd-altanova_tools/Skill_Program/tool_data/"

;file_name_backup=strcat(share_path,temp,".txt")

;fbackup=outfile(file_name_backup,"w")

when(fbackup!=nil
fprintf(fbackup,";; Owner : %s | BRD : %s | Working Directory : %s | ;;",login_name,axlCurrentDesign(),getWorkingDir())
close(fbackup)
)





) ;; tool_run

*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing tool info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



