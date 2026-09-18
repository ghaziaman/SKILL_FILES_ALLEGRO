;load("check_airgap_pinvia_to_clineseg.il")
;checkairgappinviatoclineseg ()

axlCmdRegister("checkairgappinviatoclineseg" 'checkairgappinviatoclineseg)

(defun checkairgappinviatoclineseg ()

form_function()
form=axlFormCreate((gensym),"checkairgappinviatoclineseg.form",'(e outer),'checkairgappinviatoclineseg_action,t)

;start_time=getCurrentTime()
;end_time=getCurrentTime()
;time_diff=compareTime(end_time,start_time)

(defun func_get_airgap ()
airgap_req=axlFormGetField(form "dist_via")
when(airgap_req == "" || airgap_req == nil 
axlUIConfirm("ENTER AIRGAP")
)
)

axlFormDisplay(form)

axlUIWPrint(form "Choose the tool to run")
)
 ;; main functrion

(defun  checkairgappinviatoclineseg_action (fform)

(case fform->curField

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("select"

start_time=getCurrentTime()

func_get_airgap()

;;;defining subclass of layer
l_layers=axlSubclasses("ETCH")

;;;initializing
l_layers_visible=nil
l_layers_with_class_visible=nil

etch_layer=nil

;;;for loop
foreach(layer,l_layers
when(axlIsVisibleLayer(strcat("ETCH/",layer))==t
axlSetActiveLayer(strcat("ETCH/",layer))
etch_layer=append1(etch_layer,layer)
layer=strcat("ETCH/",layer)
l_layers_visible=append1(l_layers_visible,layer)
);;;end of when
);;;end of for loop

when(length(l_layers_visible) <= 1
axlUIConfirm("Please visible any layer")
exit()
)
	
;when(length(l_layers_visible) > 1
;axlUIConfirm("Please visible any ONE layer")
;exit()
;)
	
;when(length(l_layers_visible) == 1	
;when(axlIsLayerNegative(car(l_layers_visible)) != t
;printf("Please visible any NEGATIVE layer")
;axlUIConfirm("Please visible any NEGATIVE layer")
;exit()
;)
;)

;;;printing layer name
printf("Layer Name: %L \n",l_layers_visible)

;;;priting 
printf("\nSelect Cline and Pins/Vias \n")
axlUIWPrint(fform,"Select Cline and Pins/Vias")

;;;output file
fp=outfile("check_airgap_pinvia_to_clineseg.txt" "w")
fprintf(fp,"%s.brd\n",axlCurrentDesign())
fprintf(fp,"Locations to Check\n")
fprintf(fp,"Location\tREFDES\tLocation\tREFDES\n")

;;;enabling object pins and vias find filter
axlSetFindFilter( ?enabled '("noall" "clinesegs" "pins" "vias")  ?onButtons '("noall" "clinesegs" "pins" "vias"))

;;;selecting specific pins/vias
axlSelect()

;;;initializing etch_layer variable
etch_layer=nil

l_clinesegs=nil

l_pinvia=nil

;;;passing the dbids of selected pins/vias
lselects = axlGetSelSet()

;;;length of pins/vias
length_selects=length(lselects)

foreach(lselect lselects

if(lselect->objType=="pin" || lselect->objType=="via"
then
l_pinvia=cons(lselect,l_pinvia)
)

if( (lselect->objType=="path" || lselect->objType=="line" || lselect->objType=="arc")
then
l_clinesegs=cons(lselect,l_clinesegs)
)
)

;;;printing length of pins/vias	
axlUIWPrint(fform,"Total Selected %d \n",length_selects)

axlClearSelSet()

	foreach(l1 l_pinvia
	
		foreach(l2 l_clinesegs
			
			;res = axlAirGap(l1 l2 nil 'anyLayer)
			
			airgap = axlAirGap(l1 l2 nil 'anyLayer)
			
			;println("res")
			;println(res)
			
			;location1 = nth(8 res)
			;location2 = nth(10 res)
			;airgap = lastelem(res)
			
			println("airgap")
			println(airgap)
				
			airgap_req=axlFormGetField(form "dist_via")
			
			;;;if
			if(airgap != nil && airgap <= airgap_req
			then
			
				;axlEnterPoint()
			
				;axlHighlightObject(l1->parent)
				;axlHighlightObject(l2->parent)
			
				location1 = l1->xy
				ss1refdes = l1->parent->refdes
				location2 = l2->xy
				ss2refdes = l2->parent->refdes
			
				fprintf(fp,"%L\t%L\t%L\t%L\n" ,location1,ss1refdes,location2,ss2refdes)
				
				;item=list(location1,ss1refdes,location2,ss2refdes)
				;l_items=cons(item,l_items)
				
			);;;end of if
			
		)
		
	)
	
	;l_items=unique(l_items)
		
	
	
	
;;;closing output file	
close(fp)
axlUIViewFileCreate("check_airgap_pinvia_to_clineseg.txt" "check_airgap_pinvia_to_clineseg" nil)	

end_time=getCurrentTime()
time_diff=compareTime(end_time,start_time)
printf("Total Time: %L Seconds\n",time_diff)

);;;;;pin/via

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

("close1"

axlClearSelSet()
axlFormClose(fform)
axlCancelEnterFun()

);;;;;close1


)


)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun form_function ()

fform=outfile("checkairgappinviatoclineseg.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 35 25\n")
fprintf(fform,"HEADER \"check_airgap_pinvia_to_clineseg\"\n")
fprintf(fform,"TILE\n")

;;;;;;;;;;TABS

fprintf(fform,"TABSET \"tab\"\n")
fprintf(fform,"FLOC 2 1\n")
fprintf(fform,"FSIZE 35 25\n")

;;;;;;;;;;MAINTABS

fprintf(fform,"TAB \"Menu\"\n")

fprintf(fform,"POPUP <bd_pop>\"Standard\"\"Standard\",\"Premium\"\"Premium\"\n")

;;;;;;;;Texts

fprintf(fform,"TEXT \"Choose the tool to run\"\n")
fprintf(fform,"TLOC 5 1\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"Airgap :\"\n")
fprintf(fform,"TLOC 5 4\n")
fprintf(fform,"ENDTEXT\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Field

fprintf(fform,"FIELD dist_via\n")
fprintf(fform,"FLOC 18 4\n")
fprintf(fform,"REALFILLIN 11 11\n")
fprintf(fform,"ENDFIELD\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Buttons

fprintf(fform,"FIELD select\n")
fprintf(fform,"FLOC 10 7\n")
fprintf(fform,"MENUBUTTON \"Select\" 9 3\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD close1\n")
fprintf(fform,"FLOC 10 13\n")
fprintf(fform,"MENUBUTTON \"Close\" 9 3\n")
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