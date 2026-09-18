axlCmdRegister("check_airgap_shape_shape" 'check_airgap_shape_shape)

(defun check_airgap_shape_shape ()

l_layers=axlSubclasses("ETCH")

form_function()
form=axlFormCreate((gensym),"check_airgap_shape_shape_form.form",'(e outer),'check_airgap_shape_shape_action,t)
axlFormDisplay(form)

axlUIWDisableQuit(form)

start_time=getCurrentTime()
time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))
tool_run="no"

axlFormSetFieldEditable(form "select_shapes" nil)

axlVisibleLayer("BOUNDARY" nil)


) ;; check_airgap_shape_shape


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun check_airgap_shape_shape_action (fform)


(case fform->curField


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("airgap_min"

airgap_min=axlFormGetField(form "airgap_min")

if(airgap_min==0
then
axlFormSetFieldEditable(form "select_shapes" nil)
else
axlFormSetFieldEditable(form "select_shapes" t)
)

) ;; airgap_min

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("select_shapes"

axlUIWPrint(fform,"Select shapes boundaries from the BRD")

airgap_min=axlFormGetField(form "airgap_min")

airgap_min=airgap_min-0.01

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlClearSelSet()
;; axlSetFindFilter(?enabled '("NOALL" "SHAPESEGS" "VOIDSEGS"), ?onButtons '("NOALL" "SHAPESEGS" "VOIDSEGS"))
axlSetFindFilter(?enabled '("NOALL" "SHAPESEGS"), ?onButtons '("NOALL" "SHAPESEGS"))

axlSelect()


l_segments_db=axlGetSelSet()

l_segments_temp_db=nil

foreach(seg_db,l_segments_db

layer_with_class=seg_db->layer
layer=cadr(parseString(layer_with_class,"/"))

when(member(layer,l_layers)!=nil
l_segments_temp_db=cons(seg_db,l_segments_temp_db)
) ;; when
) ;; l_segments_db

l_segments_db=l_segments_temp_db

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_segments_temp_db=l_segments_db

l_violations=nil
l_violations_db_only=nil

seg_test_db=car(l_segments_db)

axlSetActiveLayer(seg_test_db->layer)


foreach(seg_db,l_segments_db

l_box=seg_db->bBox

lower_left=car(l_box)
upper_right=cadr(l_box)

lower_left=xCoord(lower_left)-airgap_min:yCoord(lower_left)-airgap_min
upper_right=xCoord(upper_right)+airgap_min:yCoord(upper_right)+airgap_min

l_box_new=list(lower_left,upper_right)

axlClearSelSet()
axlAddSelectBox(l_box_new)

l_segments_temp_db=axlGetSelSet()

foreach(seg_temp_db,l_segments_temp_db
;;when(seg_db->net!=seg_temp_db->net
when(seg_db->parent->parent!=seg_temp_db->parent->parent && seg_db!=seg_temp_db

tool_run="yes"


l_airgap=axlAirGap(seg_db,seg_temp_db,nil,t)
drc_pt1=car(cadr(l_airgap))
drc_pt2=cadr(cadr(l_airgap))
airgap=nth(2,cadr(l_airgap))


when(airgap!=nil && (airgap<airgap_min || airgap==0)

l_points=seg_db->startEnd
start_point=car(l_points)
end_point=cadr(l_points)
center=seg_db->xy
radius=seg_db->radius
close_wise=seg_db->isClockwise


if(seg_db->objType=="line"
then
mid_point=axlMidPointLine(list(start_point,end_point))
else
mid_point=axlMidPointArc(list(start_point,end_point),center,radius,close_wise)
) ;; if

l_temp=list(airgap,seg_db->layer,seg_db->net->name,drc_pt1,drc_pt2,mid_point)
l_violations=cons(l_temp,l_violations)

l_violations_db_only=cons(seg_db,l_violations_db_only)

) ;; when

) ;; when
) ;; l_segments_temp_db
) ;; l_segments_db


l_violations=sortcar(l_violations,'lessp)

axlClearSelSet()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_drc=nil

fp=outfile("check_airgap_shape_shape.txt" "w")

fprintf(fp,"%s.brd",axlCurrentDesign())

fprintf(fp,"\nLayer\tNet\tAirgap\tStart_Point\tEnd_Point")

foreach(violations,l_violations

airgap=car(violations)

layer_with_class=cadr(violations)
layer=cadr(parseString(layer_with_class,"/"))

;;layer=substring(cadr(violations),6)

net=nth(2,violations)
start_point=nth(3,violations)
end_point=nth(4,violations)
mid_point=nth(5,violations)

sprintf(airgap_min_str "%L" airgap_min)
sprintf(airgap_str "%L" airgap)

axlDBCreateExternalDRC( list("Segment to Segment Spacing" airgap_min_str) start_point layer, nil nil airgap_str)
fprintf(fp,"\n%s\t%s\t%L\t%L",layer,net,airgap,start_point)


;;axlDBCreateExternalDRC( list("Segment to Segment Spacing" airgap_min_str) end_point layer, nil nil airgap_str)
;;fprintf(fp,"\n%s\t%s\t%L\t%L",layer,net,airgap,end_point)


) ;; l_violations

fprintf(fp,"\n\n------------------------------------------------------------------")
fprintf(fp,"\n\nTotal Violation Count : %L",length(l_violations))


close(fp)

axlUIViewFileCreate("check_airgap_shape_shape.txt" "check_airgap_shape_shape" nil)

axlUIWPrint(fform,"Violation : %L",length(l_violations))

axlAddSelectObject(l_violations_db_only)


) ;; select_shape



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



("close1"

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

tool_name="Check Airgap Shape To Shape$"
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
) ;; check_airgap_shape_shape_action


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun form_function ()

fform=outfile("check_airgap_shape_shape_form.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")   
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 22 14\n")
fprintf(fform,"HEADER \"(R&D-Altanova)\"\n")
fprintf(fform,"TILE\n")

fprintf(fform,"TEXT \"Min Airgap :\"\n")
fprintf(fform,"TLOC 3 2\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD airgap_min\n")
fprintf(fform,"FLOC 11 2\n")
fprintf(fform,"REALFILLIN 5 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"TEXT \"unit\"\n")
fprintf(fform,"TLOC 18 2\n")
fprintf(fform,"ENDTEXT\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"FIELD select_shapes\n")
fprintf(fform,"FLOC 4 6\n")
fprintf(fform,"MENUBUTTON \"Select Shapes\" 15 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD close1\n")
fprintf(fform,"FLOC 4 8\n")
fprintf(fform,"MENUBUTTON \"Close\" 15 3\n")
fprintf(fform,"ENDFIELD\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"ENDTILE\n")
fprintf(fform,"ENDFORM\n")

close(fform)

) ;; check_airgap_shape_shape_form















