
;;load "copy_placement.il"

;;copy_placement()

;;encrypt "copy_placement.il" "copy_placement.eil"

axlCmdRegister("copy_placement" 'copy_placement)
start_time=getCurrentTime()

(defun copy_placement ()

axlUIConfirm("Please first fill the Input and Output fields then fill the # of REFDES to change.")

form_function()

form=axlFormCreate((gensym),"copy_placement_form.form",'(e outer),'copy_placement_form_Action,t)



axlFormDisplay(form)
axlUIWDisableQuit(form)

tool_use="no"
axlFormSetFieldEditable(form "import" nil)


;;axlUIConfirm("Before using tool, click File->Import->Sub-Drawing->Cancel")


)



(defun copy_placement_form_Action (fform)


(case fform->curField

("input"
input=axlFormGetField(form "input")
)


("output"
output=axlFormGetField(form "output")
)

("input2"
input2=axlFormGetField(form "input2")
)


("output2"
output2=axlFormGetField(form "output2")
)


("ref"
ref=axlFormGetField(form "ref")
ref = atoi(ref)

if(ref == 1 && input!="" && output!=""
then
axlFormSetFieldEditable(form "import" t)
else

axlUIWPrint(fform,"enter input/output first")
)



if(ref == 2 && input!="" && output!="" && input2!="" && output2!=""
then
axlFormSetFieldEditable(form "import" t)
else

axlUIWPrint(fform,"enter all input/output first")
)

)




("browse"




layer_target=nil
layer_src=nil
file_name_full=nil
l_mapping=nil
l_layers_target_used=nil



file_name_full=axlDMFileBrowse(nil nil ?optFilters "CLP files(*.clp)|*.clp")
file_path=car(axlDMFileParts(file_name_full))
file_name=cadr(axlDMFileParts(file_name_full))
file_extension=nth(3,axlDMFileParts(file_name_full))

;axlFormSetFieldEditable(form "import" t)


) ;; browse







("import"


if(ref == 1 then

	;println("HERE1")

	l_a=nil
	when(file_name_full!=nil



	fp=infile(file_name_full)

	file_name_new=strcat(file_name,"_",output,".clp")
	fout=outfile(file_name_new "w")


	l_layers_source=nil
	new_line=nil
	while(gets(line,fp)

	l_line=parseString(line,"\n")
	line=car(l_line)




	if(line!=nil && nindex(line,"_clpDBCreateText")!=nil

	then

	rexCompile(input)
	line=rexReplace(line output 0)

	new_line=append1(new_line line)


	else

	when(line!=nil && nindex(line,"_clpDBCreateSymbolSkeleton")!=nil 

	rexCompile(input)
	line=rexReplace(line output 0)

	new_line=append1(new_line line)

	) ;when

	)

	when(line!=nil && nindex(line,"_clpDBCreateSymbolSkeleton")==nil && nindex(line,"_clpDBCreateText")==nil
	new_line=append1(new_line line)
	)


	) ;while

	close(fp)

	) ;when



	foreach(item new_line
	when(item!=nil

	fprintf(fout,"%s\n",item)
	)
	)
	close(fout)
	axlUIWPrint(fform,"%s is created",file_name_new)



	clip_file_new=nil
	clip_file_new=strcat(file_path,"/",file_name_new)


	is_loaded=load(file_name_new)

	when(is_loaded!=nil
	tool_use="yes"
	)
	
);;ref == 1

if(ref == 2 then

	;println("HERE2")

	l_a=nil
	when(file_name_full!=nil



	fp=infile(file_name_full)

	file_name_new=strcat(file_name,"_",output,".clp")
	fout=outfile(file_name_new "w")


	l_layers_source=nil
	new_line=nil
	while(gets(line,fp)

	l_line=parseString(line,"\n")
	line=car(l_line)




	if(line!=nil && nindex(line,"_clpDBCreateText")!=nil

	then

	rexCompile(input)
	line=rexReplace(line output 0)

	new_line=append1(new_line line)


	else

	when(line!=nil && nindex(line,"_clpDBCreateSymbolSkeleton")!=nil 

	rexCompile(input)
	line=rexReplace(line output 0)

	new_line=append1(new_line line)

	) ;when

	)

	when(line!=nil && nindex(line,"_clpDBCreateSymbolSkeleton")==nil && nindex(line,"_clpDBCreateText")==nil
	new_line=append1(new_line line)
	)


	) ;while

	close(fp)

	) ;when



	foreach(item new_line
	when(item!=nil

	fprintf(fout,"%s\n",item)
	)
	)
	close(fout)
	axlUIWPrint(fform,"%s is created",file_name_new)

	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;file_path=car(axlDMFileParts(file_name_new))
	file_name=cadr(axlDMFileParts(file_name_new))
	file_extension=nth(3,axlDMFileParts(file_name_new))
	
	;println("file_path")
	;println(file_path)
	;println("file_name")
	;println(file_name)
	;println("file_extension")
	;println(file_extension)
	
	fp=infile(file_name_new)

	file_name_new1=strcat(file_name,"_",output2,".clp")
	fout=outfile(file_name_new1 "w")


	l_layers_source=nil
	new_line=nil
	while(gets(line,fp)

	l_line=parseString(line,"\n")
	line=car(l_line)




	if(line!=nil && nindex(line,"_clpDBCreateText")!=nil

	then

	rexCompile(input2)
	line=rexReplace(line output2 0)

	new_line=append1(new_line line)


	else

	when(line!=nil && nindex(line,"_clpDBCreateSymbolSkeleton")!=nil 

	rexCompile(input2)
	line=rexReplace(line output2 0)

	new_line=append1(new_line line)

	) ;when

	)

	when(line!=nil && nindex(line,"_clpDBCreateSymbolSkeleton")==nil && nindex(line,"_clpDBCreateText")==nil
	new_line=append1(new_line line)
	)


	) ;while

	close(fp)


	foreach(item new_line
	when(item!=nil

	fprintf(fout,"%s\n",item)
	)
	)
	close(fout)
	axlUIWPrint(fform,"%s is created",file_name_new1)
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;println("file_path2")
	;println(file_path)
	

	clip_file_new=nil
	clip_file_new=strcat(file_path,"/",file_name_new1)


	is_loaded=load(file_name_new1)

	when(is_loaded!=nil
	tool_use="yes"
	)
	
);;ref == 2

) ;;import






("close_1"

when(tool_use=="yes"

printf("File successfully imported")
end_time=getCurrentTime()



time_diff=compareTime(end_time,start_time)
;;time_diff=time_diff/60

sprintf(time_str "%L" time_diff)


;tool_name="Copy Placement$"
;tool_name=strcat("$",tool_name,time_str)

;temp=strcat(getLogin(),"$",axlCurrentDesign())
;temp=strcat(temp,tool_name)

;time=parseString(start_time " ")
;time=parseString(nth(2 time) ":")
;time_combined=strcat(car(time) cadr(time) nth(2 time))
;temp=strcat(temp "$" time_combined)

;share_path="//192.168.100.248/rd-altanova_tools/Skill_Program/tool_data/"

;file_name_backup=strcat(share_path,temp,".txt")


;fbackup=outfile(file_name_backup,"w")


;when(fbackup!=nil
;fprintf(fbackup,";; Owner : %s | BRD : %s | Working Directory : %s | ;;",getLogin(),axlCurrentDesign(),getWorkingDir())
;close(fbackup)
;)
)



axlClearSelSet()
printf("\n--------------------------------------------------------------");
printf("\n\nProgrammed By...");
printf("\n\nAMAN ULLAH GHAZI,");
printf("\nSoftware Engineer,");
printf("\nR&D-Altanova.");







axlFormClose(fform)
axlCancelEnterFun()
) ;; close







) ;; 

) ;; copy_placement_form_form_Action



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun form_function ()

fform=outfile("copy_placement_form.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")   
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
;fprintf(fform,"PORT 21 14\n")
fprintf(fform,"PORT 38 14\n")
fprintf(fform,"HEADER \"(R&D-Altanova)\"\n")
fprintf(fform,"TILE\n")








fprintf(fform,"TEXT \"Enter # of REFDES to change (1 or 2) \"\n")
fprintf(fform,"TLOC 2 2\n")
fprintf(fform,"ENDTEXT\n")



fprintf(fform,"FIELD ref\n")
fprintf(fform,"FLOC 28 2\n")
fprintf(fform,"STRFILLIN 6 10\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"TEXT \"Input\"\n")
fprintf(fform,"TLOC 2 4\n")
fprintf(fform,"ENDTEXT\n")



fprintf(fform,"FIELD input\n")
fprintf(fform,"FLOC 8 4\n")
fprintf(fform,"STRFILLIN 6 10\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"TEXT \"Input2\"\n")
fprintf(fform,"TLOC 16 4\n")
fprintf(fform,"ENDTEXT\n")



fprintf(fform,"FIELD input2\n")
fprintf(fform,"FLOC 24 4\n")
fprintf(fform,"STRFILLIN 6 10\n")
fprintf(fform,"ENDFIELD\n")




fprintf(fform,"TEXT \"Output\"\n")
fprintf(fform,"TLOC 2 6\n")
fprintf(fform,"ENDTEXT\n")



fprintf(fform,"FIELD output\n")
fprintf(fform,"FLOC 8 6\n")
fprintf(fform,"STRFILLIN 6 10\n")
fprintf(fform,"ENDFIELD\n")



fprintf(fform,"TEXT \"Output2\"\n")
fprintf(fform,"TLOC 16 6\n")
fprintf(fform,"ENDTEXT\n")



fprintf(fform,"FIELD output2\n")
fprintf(fform,"FLOC 24 6\n")
fprintf(fform,"STRFILLIN 6 10\n")
fprintf(fform,"ENDFIELD\n")



fprintf(fform,"FIELD browse\n")
fprintf(fform,"FLOC 2 8\n")
fprintf(fform,"MENUBUTTON \"Browse\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"TEXT \"(*.CLP)\"\n")
fprintf(fform,"TLOC 13 8\n")
fprintf(fform,"ENDTEXT\n")


fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 0\n")
fprintf(fform,"FSIZE 35 14\n")
fprintf(fform,"ENDGROUP\n")


fprintf(fform,"FIELD import\n")
fprintf(fform,"FLOC 6 15\n")
fprintf(fform,"MENUBUTTON \"Import\" 10 3\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD close_1\n")
fprintf(fform,"FLOC 6 17\n")
fprintf(fform,"MENUBUTTON \"Close\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"ENDTILE\n")
fprintf(fform,"ENDFORM\n")

close(fform)

)



