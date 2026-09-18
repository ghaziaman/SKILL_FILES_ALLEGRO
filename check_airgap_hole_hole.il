axlCmdRegister("check_airgap_hole_hole" 'check_airgap_hole_hole)

(defun check_airgap_hole_hole ()

form_function()

form=axlFormCreate((gensym),"check_airgap_hole_hole_form.form",'(e outer),'check_airgap_hole_hole_Action,t)

axlFormSetDecimal(form,"airgap_input",4)

axlFormDisplay(form)

axlUIWDisableQuit(form)

start_time=getCurrentTime()

tool_run="no"
time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))


axlFormSetField(form "airgap_input" '5.0)

axlFormSetField(form "same_net" t)
axlFormSetField(form "different_net" t)
axlFormSetField(form "same_lamination" t)
axlFormSetField(form "different_lamination" t)

axlFormSetFieldEditable(form "highlite" nil)

layer="BOARD GEOMETRY/SKILL_LAYER"

axlLayerCreateNonConductor(layer)
axlVisibleLayer(layer t)
axlFlushDisplay()

func_delete()

zoom_input=100
axlFormSetField(form "zoom_input" zoom_input)


) ;; main funtion


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun check_airgap_hole_hole_Action (fform)


(case fform->curField


("same_lamination"

same_lamination=axlFormGetField(form "same_lamination")
different_lamination=axlFormGetField(form "different_lamination")
same_net=axlFormGetField(form "same_net")
different_net=axlFormGetField(form "different_net")


if( (same_lamination==t || different_lamination==t) && (same_net==t || different_net==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
)

) ;; same_lamination

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("different_lamination"

same_lamination=axlFormGetField(form "same_lamination")
different_lamination=axlFormGetField(form "different_lamination")
same_net=axlFormGetField(form "same_net")
different_net=axlFormGetField(form "different_net")

if( (same_lamination==t || different_lamination==t) && (same_net==t || different_net==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
)

) ;; different_lamination

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("same_net"

same_lamination=axlFormGetField(form "same_lamination")
different_lamination=axlFormGetField(form "different_lamination")
same_net=axlFormGetField(form "same_net")
different_net=axlFormGetField(form "different_net")

if( (same_lamination==t || different_lamination==t) && (same_net==t || different_net==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
)

) ;; same_net

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("different_net"

same_lamination=axlFormGetField(form "same_lamination")
different_lamination=axlFormGetField(form "different_lamination")
same_net=axlFormGetField(form "same_net")
different_net=axlFormGetField(form "different_net")

if( (same_lamination==t || different_lamination==t) && (same_net==t || different_net==t)
then
axlFormSetFieldEditable(form "select" t)
else
axlFormSetFieldEditable(form "select" nil)
)

) ;; different_net

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



("select"

axlFormListDeleteAll(form "l_violations")

axlUIWPrint(fform,"Select pins/vias from the layout")

airgap_input=axlFormGetField(form "airgap_input")
same_net=axlFormGetField(form "same_net")
different_net=axlFormGetField(form "different_net")
same_lamination=axlFormGetField(form "same_lamination")
different_lamination=axlFormGetField(form "different_lamination")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlClearSelSet()
axlSetFindFilter(?enabled '("NOALL" "VIAS" "PINS"), ?onButtons '("NOALL" "VIAS" "PINS"))

axlSelect(?prompt "Select pins/vias from the layout")
l_pv_db_all_brd=axlGetSelSet()


axlUIWPrint(fform,"Please wait.")

start_time_local=getCurrentTime()


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; removing smd pins ;;;;;;;;;;

l_pv_db_all_brd_temp=nil
foreach(pv_db,l_pv_db_all_brd
when(pv_db->definition->drillDiameter>0
l_pv_db_all_brd_temp=cons(pv_db,l_pv_db_all_brd_temp)
) ;; when
) ;; l_pv_db_all_brd

l_pv_db_all_brd=l_pv_db_all_brd_temp

;;;; removing smd pins ;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


l_pv_db_all_brd_temp=l_pv_db_all_brd

axlFlushDisplay()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_errors=nil
l_pv_checked=nil
pv_total=length(l_pv_db_all_brd)
count=0
item_count=0
;;axlMeterCreate("Progress", "", t)
l_errors_xy=nil
airgap_twice=airgap_input*2


foreach(pv_db,l_pv_db_all_brd

count++

;;axlMeterUpdate((100*count)/pv_total,sprintf(nil "Checking %d of %d holes" count pv_total))
tool_run="yes"


drill_test=pv_db->definition->drillDiameter
padstack_test=pv_db->name
net_test=pv_db->net->name

l_layers=pv_db->definition->startEnd
layer1=car(l_layers)
layer2=cadr(l_layers)
layer1_test=substring(layer1,6)
layer2_test=substring(layer2,6)
lamination_test=list(layer1_test,layer2_test)

via_xy_test=pv_db->xy
drill_radius_test=drill_test/2

l_airgap_nearby=nil

foreach(pv_db_temp,l_pv_db_all_brd_temp

drill_temp=pv_db_temp->definition->drillDiameter

when(pv_db_temp!=pv_db && member(pv_db_temp,l_pv_db_all_brd)!=nil ;;; && member(list(pv_db,pv_db_temp),l_pv_checked)==nil && member(list(pv_db_temp,pv_db),l_pv_checked)==nil

padstack_temp=pv_db_temp->name
l_layers=pv_db_temp->definition->startEnd
layer1=car(l_layers)
layer2=cadr(l_layers)
layer1_temp=substring(layer1,6)
layer2_temp=substring(layer2,6)
lamination_temp=list(layer1_temp,layer2_temp)

net_temp=pv_db_temp->net->name
via_xy_temp=pv_db_temp->xy
drill_radius_temp=drill_temp/2

dist=axlDistance(via_xy_test,via_xy_temp)

radius_sum=drill_radius_test+drill_radius_temp

airgap=dist-radius_sum

/*
when(match_extact==t && airgap>airgap_input && airgap<airgap_twice
l_airgap_nearby=cons(airgap,l_airgap_nearby) 
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)
) ;; when
*/

;;;;;;;;;;;;;;

if(net_test==net_temp
then
comment_net="Same_net"
else
comment_net="Different_net"
)

if(lamination_test==lamination_temp
then
comment_lamination="Same_lamination"
else
comment_lamination="Different_lamination"
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


when(airgap<airgap_input

if(same_net==t && different_net==t
then

if(same_lamination==t && different_lamination==t
then
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)

else
if(same_lamination==t && different_lamination==nil && lamination_test==lamination_temp
then
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)

else
if(same_lamination==nil && different_lamination==t && lamination_test!=lamination_temp
then
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)

)))

;;;;
else
if(same_net==t && different_net==nil && net_test==net_temp
then

if(same_lamination==t && different_lamination==t
then
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)

else
if(same_lamination==t && different_lamination==nil && lamination_test==lamination_temp
then
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)


else
if(same_lamination==nil && different_lamination==t && lamination_test!=lamination_temp
then
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)

)))

;;;;

else
if(same_net==nil && different_net==t && net_test!=net_temp
then

if(same_lamination==t && different_lamination==t
then
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)

else
if(same_lamination==t && different_lamination==nil && lamination_test==lamination_temp
then
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)

else
if(same_lamination==nil && different_lamination==t && lamination_test!=lamination_temp
then
item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)

)))


))) ;; if

;;;;;;

) ;; when airgap

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

) ;; l_pv_db_all_brd_temp

/*
when(match_extact==t && airgap_ref>airgap_input

item=list(airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)
l_errors=cons(item,l_errors)
l_points=list(via_xy_test,via_xy_temp)
l_errors_xy=cons(l_points,l_errors_xy)

) ;; when

*/

;;axlUIWPrint(fform,"Checking : %L of %L",count,pv_total)




) ;; l_pv_db_all_brd

;;axlMeterDestroy()


l_errors=sortcar(l_errors,'lessp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fp=outfile("check_airgap_hole_hole.txt" "w")
fprintf(fp,"%s\n",axlCurrentDesign())

fprintf(fp,"Airgap\tPadstack\t(Via_x,Via_y)\tNet\tLamination\tComments")

l_errors_printed=nil

l_violations=nil


count=0
foreach(error,l_errors

airgap=car(error)
padstack_test=cadr(error)
padstack_temp=nth(2,error)
via_xy_test=nth(3,error)
via_xy_temp=nth(4,error)
net_test=nth(5,error)
net_temp=nth(6,error)
comment_lamination=nth(7,error)
comment_net=nth(8,error)


when(net_test==nil
net_test="-"
)

when(net_temp==nil
net_temp="-"
)



when(member(error,l_errors_printed)==nil

fprintf(fp,"\n%L\t%s/%s\t%L/%L\t%s/%s\t%s\t%s",airgap,padstack_test,padstack_temp,via_xy_test,via_xy_temp,net_test,net_temp,comment_lamination,comment_net)

l_errors_printed=append1(l_errors_printed,error)
l_items=list(airgap,padstack_temp,padstack_test,via_xy_temp,via_xy_test,net_temp,net_test,comment_lamination,comment_net)
l_errors_printed=append1(l_errors_printed,l_items)

count++

;;;;;;;;;;;;;


sprintf(airgap_str "%L" airgap)

point1_x=xCoord(via_xy_test)
point1_y=yCoord(via_xy_test)

point2_x=xCoord(via_xy_temp)
point2_y=yCoord(via_xy_temp)

sprintf(point1_x_str "%L" point1_x)
sprintf(point1_y_str "%L" point1_y)

sprintf(point2_x_str "%L" point2_x)
sprintf(point2_y_str "%L" point2_y)

point1_str=strcat(point1_x_str,",",point1_y_str)
point2_str=strcat(point2_x_str,",",point2_y_str)


l_temp=strcat(airgap_str," | ",point1_str," | ",point2_str)
l_violations=append1(l_violations,l_temp)


) ;; when


) ;; l_errors

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

l_violations_selected=axlFormListGetSelItems(form "l_violations")
zoom_input=axlFormGetField(form "zoom_input")

axlSetFindFilter(?enabled '("NOALL" "VIAS" "PINS"), ?onButtons '("NOALL" "VIAS" "PINS"))

l_dbid=nil
l_pv_db=nil

l_violations_xy=nil


foreach(violation_selected,l_violations_selected

l_string=parseString(violation_selected,"|")

l_point1=cadr(l_string)
l_point2=nth(2,l_string)

l_string=parseString(l_point1," , ")
point1_x=atof(car(l_string))
point1_y=atof(cadr(l_string))

l_point1=point1_x:point1_y

l_string=parseString(l_point2," , ")
point2_x=atof(car(l_string))
point2_y=atof(cadr(l_string))

l_point2=point2_x:point2_y


axlSingleSelectPoint(l_point1)
l_dbid=axlGetSelSet()
l_pv_db=append(l_pv_db,l_dbid)

axlSingleSelectPoint(l_point2)
l_dbid=axlGetSelSet()
l_pv_db=append(l_pv_db,l_dbid)


l_temp=list(l_point1,l_point2)

l_violations_xy=append1(l_violations_xy,l_temp)

l_points=list(l_point1,l_point2)

axlDBCreateLine(l_points,'0,layer)

) ;; l_violations_selected


l_violations_xy=reverse(l_violations_xy)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

item_count=length(l_pv_db)/2

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
axlZoomToDbid(l_pv_db t)


) ;; if



axlSingleSelectObject(l_pv_db)



) ;; l_violations


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("highlite"

l_pv_db=unique(l_pv_db)

axlClearSelSet()
axlHighlightObject(l_pv_db t)
axlFlushDisplay()

) ;; Highlite

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("view"

fp=outfile("l_violations_xy.txt" "w")

foreach(violation_xy,l_violations_xy

l_point1=car(violation_xy)
l_point2=cadr(violation_xy)

fprintf(fp,"%L,%L\n",l_point1,l_point2)


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

tool_name="Check Airgap Hole To Hole$"
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
) ;; check_airgap_hole_hole_Action




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun form_function ()

fform=outfile("check_airgap_hole_hole_form.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")   
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 30 14\n")
fprintf(fform,"HEADER \"(R&D-Altanova)\"\n")
fprintf(fform,"TILE\n")

fprintf(fform,"TEXT \"Min Airgap :\"\n")
fprintf(fform,"TLOC 3 2\n")
fprintf(fform,"OPTIONS BOLD\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD airgap_input\n")
fprintf(fform,"FLOC 15 2\n")
fprintf(fform,"REALFILLIN 5 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"TEXT \"unit\"\n")
fprintf(fform,"TLOC 22 2\n")
fprintf(fform,"ENDTEXT\n")


fprintf(fform,"TEXT \"Zoom Factor :\"\n")
fprintf(fform,"OPTIONS BOLD\n")
fprintf(fform,"TLOC 3 5\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD zoom_input\n")
fprintf(fform,"FLOC 15 5\n")
fprintf(fform,"INTFILLIN 5 4\n")
fprintf(fform,"ENDFIELD\n")






fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 0\n")
fprintf(fform,"FSIZE 28 7\n")
fprintf(fform,"ENDGROUP\n")

fprintf(fform,"FIELD same_net\n")
fprintf(fform,"FLOC 3 8\n")
fprintf(fform,"CHECKLIST \"Same Net\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD different_net\n")
fprintf(fform,"FLOC 3 10\n")
fprintf(fform,"CHECKLIST \"Different Net\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 6\n")
fprintf(fform,"FSIZE 28 6\n")
fprintf(fform,"ENDGROUP\n")


fprintf(fform,"FIELD same_lamination\n")
fprintf(fform,"FLOC 3 13\n")
fprintf(fform,"CHECKLIST \"Same Lamination\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD different_lamination\n")
fprintf(fform,"FLOC 3 15\n")
fprintf(fform,"CHECKLIST \"Different Lamination\"\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 11\n")
fprintf(fform,"FSIZE 28 6\n")
fprintf(fform,"ENDGROUP\n")


fprintf(fform,"TEXT \"Violations\"\n")
fprintf(fform,"TLOC 11 18\n")
fprintf(fform,"OPTIONS BOLD\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD l_violations\n")
fprintf(fform,"FLOC 1 20\n")
fprintf(fform,"LIST \"\" 28 22\n")
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;; delete objects

(defun func_delete ()

axlClearSelSet()
axlSetFindFilter(?enabled '("NOALL" "LINES"), ?onButtons '("NOALL" "LINES"))
axlAddSelectAll()
l_db_brd=axlGetSelSet()

l_db_delete=nil

foreach(db,l_db_brd
when(db->layer=="BOARD GEOMETRY/SKILL_LAYER"
l_db_delete=cons(db,l_db_delete)
)
) ;; l_db_brd

axlDeleteObject(l_db_delete)
axlClearSelSet()

)

;;;; delete objects






