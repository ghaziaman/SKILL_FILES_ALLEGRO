
axlCmdRegister("check_sense_pins_vias" 'check_sense_pins_vias)

(defun check_sense_pins_vias ()

form_function()
form=axlFormCreate((gensym),"check_sense_pins_vias_form.form",'(e outer),'check_sense_pins_vias_action,t)
axlFormDisplay(form)

;; axlUIWDisableQuit(form)
axlClearSelSet()

tool_run="no"

start_time=getCurrentTime()
time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))

axlFormDisplay(form)


axlDehighlightObject('all)
axlFlushDisplay()


) ;; main functrion


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun check_sense_pins_vias_action (fform)


(case fform->curField

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("ignore_padstack"

axlUIWPrint(fform,"Select padstack to ignore")

axlClearSelSet()
axlSetFindFilter(?enabled '("NOALL" "PINS" "VIAS"), ?onButtons '("NOALL" "PINS" "VIAS"))
axlSelect()

l_pv_ignore_db=axlGetSelSet()


l_padstack_ignore_brd=nil

foreach(pv_db,l_pv_ignore_db
padstack=pv_db->name
l_padstack_ignore_brd=cons(padstack,l_padstack_ignore_brd)
) ;; l_pv_ignore_db


l_padstack_ignore_brd=unique(l_padstack_ignore_brd)


;;;;;;;;;;;;;;;;;;;;;;;;;;

l_padstack_ignore_input=nil

fp=infile("ignore_padstack.txt")

when(fp!=nil

while(gets(line,fp)

l_line=parseString(line,"\n")
line=car(l_line)

when(line!=nil
l_padstack_ignore_input=cons(line,l_padstack_ignore_input)
) ;; when

) ;; while

close(fp)

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;

l_padstack_ignore=nil

l_padstack_ignore=append(l_padstack_ignore_input,l_padstack_ignore_brd)
l_padstack_ignore=unique(l_padstack_ignore)


fp=outfile("ignore_padstack.txt" "w")


foreach(padstack,l_padstack_ignore
fprintf(fp,"%s\n",padstack)
) ;; l_padstack_ignore

close(fp)


;;;;;;;;;;;;;;;;;;;;;;;;;;

axlUIWPrint(fform,"Ignore Count : %L",length(l_padstack_ignore))



) ;; ignore_padstack


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("run"

axlUIWPrint(fform,"Please wait")

axlDehighlightObject('all)
axlFlushDisplay()

l_padstack_ignore=nil

fp=infile("ignore_padstack.txt")

when(fp!=nil

while(gets(line,fp)

l_line=parseString(line,"\n")
line=car(l_line)

when(line!=nil
l_padstack_ignore=cons(line,l_padstack_ignore)
) ;; when

) ;; while

close(fp)


) ;; when


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


l_visList=axlVisibleGet()

axlVisibleLayer("PIN" t)
axlVisibleLayer("VIA CLASS" t)

axlClearSelSet()
axlSetFindFilter(?enabled '("NOALL" "PINS" "VIAS"), ?onButtons '("NOALL" "PINS" "VIAS"))
axlAddSelectAll()
l_pv_db=axlGetSelSet()

axlVisibleSet(l_visList)
axlVisibleUpdate(nil)


fp=outfile("pins_vias_prop.txt" "w")

fprintf(fp,"%s.brd",axlCurrentDesign())
fprintf(fp,"\n\nRouting and Shapes both found at below locations. User to check if these belong to only DUT vias")
fprintf(fp,"\n\n(X,Y)\tComp_pin\tPadstack\tNet\tDrill\tNo_Shape_Connect\tTrace_Layers\tShape_Layers")


l_padstack=nil

error_count=0

foreach(pv_db,l_pv_db

tool_run="yes"

l_startEnd=pv_db->startEnd
start_layer_with_class=car(l_startEnd)
end_layer_with_class=cadr(l_startEnd)
shape_prop=pv_db->prop->NO_SHAPE_CONNECT
net_db=pv_db->net
net=net_db->name
pv_xy=pv_db->xy
drill_size=pv_db->definition->drillDiameter
padstack=pv_db->name

when(drill_size>0 && member(padstack,l_padstack_ignore)==nil

if(pv_db->component->name==nil refdes="-" refdes=pv_db->component->name)
if(pv_db->number==nil number="-" number=pv_db->number)

comp_pin=strcat(refdes,".",number)

l_connect_db=axlDBGetConnect(pv_db t)

l_trace_layer_outer=nil
l_trace_layer_inner=nil
l_shape_layer_inner=nil
l_shape_layer_outer=nil
l_trace_layers=nil
l_shape_layers=nil

foreach(connect_db l_connect_db

is_thermal=connect_db->thermal

;;; path ;;;

when(connect_db->objType=="path" && is_thermal==nil

trace_layer=cadr(parseString(connect_db->layer,"/"))

when(connect_db->layer!=start_layer_with_class && connect_db->layer!=end_layer_with_class
l_trace_layer_inner=cons(trace_layer,l_trace_layer_inner)
l_trace_layers=cons(trace_layer,l_trace_layers) ;; store inner layers
) ;; 


;;;;;;;;;;;;;;;;;;;;;

when(connect_db->layer==start_layer_with_class || connect_db->layer==end_layer_with_class

l_path_connect_db=axlDBGetConnect(connect_db t)

is_fanout="no"

foreach(path_connect l_path_connect_db
when(path_connect->objType=="pin" && pv_db!=path_connect && path_connect->definition->drillDiameter==0
if(path_connect->component->name==nil refdes="-" refdes=path_connect->component->name)
if(path_connect->number==nil number="-" number=path_connect->number)
pin=strcat(refdes,".",number)
is_fanout="yes"
) ;; when
) ;; l_path_connect_db

;;;;;;;;;;;;;;;;;;;;;

when(is_fanout=="no"
l_trace_layers=cons(trace_layer,l_trace_layers)
) ;; when


) ;; when outer layer

;;;;;;;;;;;;;;;;;;;;;

) ;; when

;;; end of path ;;;

;;; shape ;;;

when(connect_db->objType=="shape"

shape_prop=connect_db->prop->SI_PARAM1
shape_layer=cadr(parseString(connect_db->layer,"/"))

when(shape_prop==nil
l_shape_layers=cons(shape_layer,l_shape_layers)
) ;; 


) ;; when


;;; shape ;;;

) ;; l_connect_db

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


l_trace_layers=unique(l_trace_layers)
l_shape_layers=unique(l_shape_layers)


when(l_shape_layers!=nil && l_trace_layers!=nil

l_padstack=cons(padstack,l_padstack)
error_count++

fprintf(fp,"\n%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L",pv_xy,comp_pin,padstack,net,drill_size,shape_prop,l_trace_layers,l_shape_layers)
axlHighlightObject(pv_db t)

) ;; when



) ;; when
) ;; l_pv_db

l_padstack=unique(l_padstack)


fprintf(fp,"\n\n--------------------------------- Unique Padstack ---------------------------------")

foreach(padstack,l_padstack
fprintf(fp,"\n%s",padstack)
) ;; l_padstack


close(fp)


axlUIViewFileCreate("pins_vias_prop.txt" "pins_vias_prop" nil)


axlClearSelSet()


axlUIWPrint(fform,"Error Count : %L",error_count)




) ;; run



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("close1"

axlClearSelSet()
axlFormClose(fform)
axlCancelEnterFun()


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing tool info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(tool_run=="yes"

login_name=getLogin()
end_time=getCurrentTime()
time_diff=compareTime(end_time,start_time)

sprintf(time_str "%L" time_diff)

tool_name="Check Sense Pins Vias$"
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


printf("\n--------------------------------------------------------------");
printf("\n\nProgrammed By...");
printf("\n\nAMAN ULLAH GHAZI,");
printf("\nSoftware Engineer,");
printf("\nR&D-Altanova.");
printf("\nEmail : ghaziaman.ullah@hotmail.com\n\n");

) ;; close1



) ;; 

) ;; check_sense_pins_vias_action











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun form_function ()

fform=outfile("check_sense_pins_vias_form.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")   
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 25 8\n")
fprintf(fform,"HEADER \"(R&D-Altanova)\"\n")
fprintf(fform,"TILE\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"FIELD run\n")
fprintf(fform,"FLOC 8 4\n")
fprintf(fform,"MENUBUTTON \"Run\" 10 3\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD ignore_padstack\n")
fprintf(fform,"FLOC 8 6\n")
fprintf(fform,"MENUBUTTON \"Ignore\" 10 3\n")
fprintf(fform,"ENDFIELD\n")



fprintf(fform,"FIELD close1\n")
fprintf(fform,"FLOC 8 8\n")
fprintf(fform,"MENUBUTTON \"Close\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"ENDTILE\n")
fprintf(fform,"ENDFORM\n")

close(fform)

) ;; check_sense_pins_vias_form


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







