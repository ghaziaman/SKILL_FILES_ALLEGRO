axlCmdRegister("addNettoShape" 'addNettoShape)

(defun addNettoShape ()

form_function()
form=axlFormCreate((gensym),"addNettoShape.form",'(e outer),'addNettoShape_action,t)

axlClearSelSet()

start_time=getCurrentTime()
fp=nil
tool_run="no"
time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))

etch_layer=nil

(defun func_get_all_layers ()

    l_layers=axlSubclasses("ETCH")

    l_layers_visible=nil
    l_layers_with_class_visible=nil

    foreach(layer,l_layers

        when(axlIsVisibleLayer(strcat("ETCH/",layer))==t
            l_layers_visible=append1(l_layers_visible,layer)
            layer=strcat("ETCH/",layer)
            etch_layer=append1(etch_layer,layer)
            ) ;; when

        l_layers_visible=append1(l_layers_visible,layer)

        layer=strcat("ETCH/",layer)
        l_layers_with_class_visible=append1(l_layers_with_class_visible,layer)

    ) ;; for    
        
) ;; func_get_all_layers


func_get_all_layers()

axlFormDisplay(form)
 

) ;; main functrion


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun  addNettoShape_action (fform)

(case fform->curField

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

tool_name="Create Trace Between Pin Vias"
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


printf("\n--------------------------------------------------------------");
printf("\n\nProgrammed By...");
printf("\n\nAMAN ULLAH GHAZI,");
printf("\nSoftware Engineer,");
printf("\nR&D-Altanova.");
printf("\nEmail : ghaziaman.ullah@hotmail.com\n\n");


) ;; close1


("run_tool"

    axlClearSelSet()
    axlSetFindFilter(?enabled list("noall") ?onButtons list("noall"))
    axlSetFindFilter(?enabled list("vias") ?onButtons list("vias"))
    axlSelect()
    l_vias = axlGetSelSet()
    axlClearSelSet()
    axlSetFindFilter(?enabled list("noall") ?onButtons list("noall"))
    axlSetFindFilter(?enabled list("shapes") ?onButtons list("shapes"))
    
	count = 0
	dummy_pin= 0
    (foreach via l_vias
      ;  println(via->bBox)
        ;;axlSingleSelectBox(via->bBox)
		axlSingleSelectPoint(via->xy)
        l_shapes = axlGetSelSet()
		
        ;shape = car(l_shapes)
		
		(foreach shape l_shapes
		
			;axlEnterPoint()
			
			;println(via->net->name)
			
			if(via->net->name != ""
			then
			axlDBAssignNet(shape via->net->name t)
			printf("Assigned net %L to shape location=%L\n",via->net->name, shape->bBox)
			count++
			axlClearSelSet()
			
			else
			axlUIWPrint(form,"Selected via has dummy net")
			printf("Selected via at location %L has dummy net\n",via->xy)
			dummy_pin++
			)
			
		)

    )
	
axlUIWPrint(form,"%L shape assigned net in brd",count)
if(dummy_pin>0
then
printf("%L dummy pins selected",dummy_pin)
)

) ;runtool

("close_1"
;close(fp)
axlClearSelSet()
axlFormClose(fform)
axlCancelEnterFun()

);close



) ;;case


) ;; addNettoShape_action


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun form_function ()

fform=outfile("addNettoShape.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 35 16\n")
fprintf(fform,"HEADER \"Add Net to Shape \"\n")
fprintf(fform,"TILE\n")

;;;;;;;;;;TABS

fprintf(fform,"TABSET \"tab\"\n")
fprintf(fform,"FLOC 2 1\n")
fprintf(fform,"FSIZE 35 16\n")

;;;;;;;;;;MAINTABS

fprintf(fform,"TAB \"Menu\"\n")

fprintf(fform,"POPUP <bd_pop>\"Standard\"\"Standard\",\"Premium\"\"Premium\"\n")

;;;;;;;;Texts


fprintf(fform,"TEXT \"Select the vias \"\n")
fprintf(fform,"TLOC 2 1\n")
fprintf(fform,"ENDTEXT\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Buttons

fprintf(fform,"FIELD run_tool\n")
fprintf(fform,"FLOC 10 10\n")
fprintf(fform,"MENUBUTTON \"Run\" 7 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD close_1\n")
fprintf(fform,"FLOC 10 15\n")
fprintf(fform,"MENUBUTTON \"Close\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"ENDTAB\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


fprintf(fform,"TAB \"About\"\n")

fprintf(fform,"TEXT \" Programmed By \"\n")
fprintf(fform,"TLOC 2 5\n")
fprintf(fform,"OPTIONS bold\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"AMAN ULLAH GHAZI\"\n")
fprintf(fform,"TLOC 3 13\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"Software Engineer\"\n")
fprintf(fform,"TLOC 3 15\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"R&D-Altanova\"\n")
fprintf(fform,"TLOC 3 17\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"Email: ghaziaman.ullah@hotmail.com\"\n")
fprintf(fform,"TLOC 3 19\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 1\n")
fprintf(fform,"FSIZE 26 33\n")
fprintf(fform,"ENDGROUP\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;
fprintf(fform,"ENDTAB\n")



;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"ENDTABSET\n")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


fprintf(fform,"ENDTILE\n")
fprintf(fform,"ENDFORM\n")

close(fform)

) ;; gui_template_form



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
