
;; load "placement_comparison.il"


l_symbol=axlDBGetDesign()->symbols
file=axlCurrentDesign() ;getting the current design name
design_file_name=strcat(file ".brd")
l_input_lines=nil
start_time=getCurrentTime()
tool_used="no"



axlClearSelSet()


axlCmdRegister("placement_comparison" 'placement_comparison)


(defun placement_comparison ()

add_placement_comparison_form_function()


form=axlFormCreate((gensym),"add_placement_comparison_form.form",'(e outer),'add_placement_comparison_form_Action,t)

axlClearSelSet()
start_time=getCurrentTime()

axlFormDisplay(form)
axlUIWDisableQuit(form)




)



(defun add_placement_comparison_form_Action (fform)

(case fform->curField

("generate_info"

fp = infile("board_reference_place.txt")


if(fp
then


fp_out=outfile("board_test_place.txt" "w")
fprintf(fp_out,"%L\n",design_file_name)
;board2_name=design_file_name
axlUIWPrint(fform,"File Generated board_test_place.txt")

close(fp)


else



fp_out=outfile("board_reference_place.txt" "w")
 
fprintf(fp_out,"%L\n",design_file_name)
;board1_name=design_file_name
axlUIWPrint(fform,"File Generated board_reference_place.txt")

)



symbol_l=nil
foreach(symbol l_symbol

refdes=symbol->refdes
if(refdes==nil
then
refdes = "-"
comp_device_type="-"

;temp=comp_device_type
;sprintf(temp "%L" temp)

value= "-"
package=symbol->name
xy=symbol->xy
sym_x=car(xy)
sym_y=cadr(xy)
rotation=symbol->rotation
mirror=symbol->mirrorType
;component=symbol->component


l_temp=list(refdes comp_device_type value package sym_x sym_y rotation mirror)
symbol_l=append1(symbol_l l_temp)

)

refdes=symbol->refdes
if(refdes!=nil
then
comp_device_type=symbol->component->deviceType

;temp=comp_device_type
;sprintf(temp "%L" temp)

value=parseString(comp_device_type "_")
;;printf("%L",value)
;;axlEnterPoint()
value=reverse(value)
value=car(value)
package=symbol->name
xy=symbol->xy
sym_x=car(xy)
sym_y=cadr(xy)
rotation=symbol->rotation
mirror=symbol->mirrorType
component=symbol->component


l_temp=list(refdes comp_device_type value package sym_x sym_y rotation mirror)
symbol_l=append1(symbol_l l_temp)

)

)

foreach(item symbol_l

fprintf(fp_out,"%L\n",item)

;;fprintf(fp_out,"\n%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t",refdes,comp_device_type,package,sym_x,sym_y,rotation,mirror,component)
)


close(fp_out)

) ;;generate_info
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



("compare"



fp1 = infile("board_reference_place.txt")
fp2 = infile("board_test_place.txt")




l_fp1=nil
l_fp2=nil

l_un_matched_components=nil

l_un_matched_mechanical_components=nil
l_un_matched_non_mechanical_components=nil

start="NO"
start2="NO"
count=0
count2=0
error=0

if(fp1!= nil && fp2!=nil
then
tool_used="yes"

while( l_line = lineread(fp1)
count++

l_line=car(l_line)

when(count==1
board1_name=l_line
)


when(count>1


refdes=car(l_line)
comp_device_type=cadr(l_line)
value=nth(2,l_line)
package=nth(3,l_line)
sym_x=nth(4,l_line)
sym_y=nth(5,l_line)
rotation=nth(6,l_line)
mirror=nth(7,l_line)

item=list(refdes,comp_device_type,value,package,sym_x,sym_y,rotation,mirror)
l_fp1=append1(l_fp1 item)
)
)



while( l_line_fp2 = lineread(fp2)

count2++
l_line_fp2=car(l_line_fp2)
when(count2==1
board2_name=l_line_fp2
)

when(count2>1



refdes=car(l_line_fp2)
comp_device_type=cadr(l_line_fp2)
value=nth(2,l_line_fp2)
package=nth(3,l_line_fp2)
sym_x=nth(4,l_line_fp2)
sym_y=nth(5,l_line_fp2)
rotation=nth(6,l_line_fp2)
mirror=nth(7,l_line_fp2)

item_2=list(refdes,comp_device_type,value,package,sym_x,sym_y,rotation,mirror)
l_fp2=append1(l_fp2 item_2)
)
)




fp_output=outfile("Matched.txt" "w")  ;;write data to the file
fp_output2=outfile("Un Matched.txt" "w")  ;;write data to the file





fprintf(fp_output,"%L\t\t\t\t\t\t\t\t\t\t%L\n",board1_name,board2_name)
fprintf(fp_output2,"%L\t\t\t\t\t\t\t\t\t\t%L\n",board1_name,board2_name)


l_component_new=nil
foreach(item1 l_fp1



foreach(item2 l_fp2



;;MECHANICAL_COMPONENT
when(car(item1)=="-" && car(item2)=="-" && nth(3 item1)==nth(3 item2) && nth(4 item1)==nth(4 item2) && nth(5 item1)==nth(5 item2) && nth(6 item1)==nth(6 item2) && nth(7 item1)==nth(7 item2)



if(cadr(item1)!=cadr(item2) || nth(2 item1)!=nth(2 item2) || nth(3 item1)!=nth(3 item2) || nth(4 item1)!=nth(4 item2) || nth(5 item1)!=nth(5 item2) || nth(6 item1)!=nth(6 item2) || nth(7 item1)!=nth(7 item2)


then
fprintf(fp_output2,"%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t\t\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\n",car(item1),cadr(item1),nth(2 item1),nth(3 item1),nth(4 item1),nth(5 item1),nth(6 item1),nth(7 item1),car(item2),cadr(item2),nth(2 item2),nth(3 item2),nth(4 item2),nth(5 item2),nth(6 item2),nth(7 item2))
l_un_matched_components=append1(l_un_matched_components car(item2))

l_mechanical_components = list(nth(3 item2) nth(4 item2) nth(5 item2))

l_un_matched_mechanical_components = append1(l_un_matched_mechanical_components l_mechanical_components)

/*
axlVisibleDesign(nil)
axlVisibleUpdate(t)

if(nth(7 item2)=="YES"
then
axlVisibleLayer("ETCH/BOTTOM" t)
else
axlVisibleLayer("ETCH/TOP" t)
)
axlVisibleUpdate(t)



axlSetFindFilter(?enabled '("noall" "SYMBOLS") ?onButtons '("noall" "SYMBOLS")) 
axlSingleSelectPoint(nth(4 item2):nth(5 item2))
a=axlGetSelSet()
axlClearSelSet()
axlHighlightObject(a nil)

*/

error++



else
fprintf(fp_output,"%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t\t\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\n",car(item1),cadr(item1),nth(2 item1),nth(3 item1),nth(4 item1),nth(5 item1),nth(6 item1),nth(7 item1),car(item2),cadr(item2),nth(2 item2),nth(3 item2),nth(4 item2),nth(5 item2),nth(6 item2),nth(7 item2))
check="no"

) ;if


l_fp1=remove(item1 l_fp1)
l_fp2=remove(item2 l_fp2)

) ;when



;;NON_MECHANICAL_COMPONENT
when(car(item1)==car(item2) && car(item1)!="-" && car(item2)!="-"



if(cadr(item1)!=cadr(item2) || nth(2 item1)!=nth(2 item2) || nth(3 item1)!=nth(3 item2) || nth(4 item1)!=nth(4 item2) || nth(5 item1)!=nth(5 item2) || nth(6 item1)!=nth(6 item2) || nth(7 item1)!=nth(7 item2)


then
fprintf(fp_output2,"%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t\t\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\n",car(item1),cadr(item1),nth(2 item1),nth(3 item1),nth(4 item1),nth(5 item1),nth(6 item1),nth(7 item1),car(item2),cadr(item2),nth(2 item2),nth(3 item2),nth(4 item2),nth(5 item2),nth(6 item2),nth(7 item2))
l_un_matched_components=append1(l_un_matched_components car(item2))

l_un_matched_non_mechanical_components = append1(l_un_matched_non_mechanical_components car(item2))

/*
axlVisibleDesign(nil)
axlVisibleUpdate(t)

if(nth(7 item2)=="YES"
then
axlVisibleLayer("ETCH/BOTTOM" t)
else
axlVisibleLayer("ETCH/TOP" t)
)
axlVisibleUpdate(t)



axlSetFindFilter(?enabled '("noall" "SYMBOLS") ?onButtons '("noall" "SYMBOLS")) 
axlSingleSelectPoint(nth(4 item2):nth(5 item2))
a=axlGetSelSet()
axlClearSelSet()
axlHighlightObject(a nil)

*/

error++



else
fprintf(fp_output,"%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t\t\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\n",car(item1),cadr(item1),nth(2 item1),nth(3 item1),nth(4 item1),nth(5 item1),nth(6 item1),nth(7 item1),car(item2),cadr(item2),nth(2 item2),nth(3 item2),nth(4 item2),nth(5 item2),nth(6 item2),nth(7 item2))
check="no"

) ;if


l_fp1=remove(item1 l_fp1)
l_fp2=remove(item2 l_fp2)



) ;when


) ;foreach l_fp2
) ;foreach l_fp1


if(length(l_fp1)>0
then
foreach(item1 l_fp1
fprintf(fp_output2,"%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t\t\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\t\n",car(item1),cadr(item1),nth(2 item1),nth(3 item1),nth(4 item1),nth(5 item1),nth(6 item1),nth(7 item1))
error++

if(car(item1)=="-" then
	l_mechanical_components = list(nth(3 item1) nth(4 item1) nth(5 item1))
	l_un_matched_mechanical_components = append1(l_un_matched_mechanical_components l_mechanical_components)
else
	l_un_matched_non_mechanical_components = append1(l_un_matched_non_mechanical_components car(item1))
)

) ;foreach



) ;if



if(length(l_fp2)>0
then
foreach(item2 l_fp2
fprintf(fp_output2,"N/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\tN/A\t\t\t%L\t%L\t%L\t%L\t%L\t%L\t%L\t%L\n",car(item2),cadr(item2),nth(2 item2),nth(3 item2),nth(4 item2),nth(5 item2),nth(6 item2),nth(7 item2))
l_un_matched_components=append1(l_un_matched_components car(item2))
error++

if(car(item2)=="-" then
	l_mechanical_components = list(nth(3 item2) nth(4 item2) nth(5 item2))
	l_un_matched_mechanical_components = append1(l_un_matched_mechanical_components l_mechanical_components)
else
	l_un_matched_non_mechanical_components = append1(l_un_matched_non_mechanical_components car(item2))
)

) ;foreach


) ;if



/*

if(length(l_fp1)==0 && length(l_fp2)==0 && check!="no"
then
axlUIWPrint(fform,"No Difference Found")

else
axlUIWPrint(fform,"Difference: %L",length(l_fp1)+length(l_fp2))
)


*/


if(error>0
then

fp_out_list=outfile("un_match_refdes.lst" "w")

foreach(item l_un_matched_components
fprintf(fp_out_list,"%L\n",item)
)

close(fp_out_list)




axlUIWPrint(fform,"Difference: %L",error)

else
axlUIWPrint(fform,"Difference: %L",error)

)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fp_summary = outfile("SUMMARY COMPARE PLACEMENT.txt" "w")  ;;write data to the file

fprintf(fp_summary,"BOARD NAMES: \n")
fprintf(fp_summary,"%L VS %L",board1_name,board2_name)
;fprintf(fp_summary,"%s.brd",axlCurrentDesign())

if(length(l_un_matched_mechanical_components)>0 then

	fprintf(fp_summary,"\n\n===============================================================================")
	fprintf(fp_summary,"\nMISMATCH IN THE PLACEMENT OF MECHANICAL COMPONENTS: (DO NOT IGNORE THIS ERROR)\n")
	
	fprintf(fp_summary,"\nSYMBOL\tORIGIN(X)\tORIGIN(Y)\n")

	foreach(item l_un_matched_mechanical_components
		fprintf(fp_summary,"%L\t%L\t%L\n",car(item),cadr(item),caddr(item))
	)

)



if(length(l_un_matched_non_mechanical_components)>0 then

	fprintf(fp_summary,"\n\n===============================================================================")
	fprintf(fp_summary,"\nMISMATCH IN THE PLACEMENT OF NON MECHANICAL COMPONENTS: (DO NOT IGNORE THIS ERROR)\n")
	
	fprintf(fp_summary,"\nREFDES\n")
	
	foreach(itemm l_un_matched_non_mechanical_components
		fprintf(fp_summary,"%L\n",itemm)
	)

)

fprintf(fp_summary,"\n\n===============================================================================")
fprintf(fp_summary,"\n\nTHE END")

close(fp_summary)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





close(fp_output2)
close(fp_output)




axlUIViewFileCreate("Un Matched.txt" "Difference" nil)

axlUIViewFileCreate("Matched.txt" "Matched" nil)

axlUIViewFileCreate("SUMMARY COMPARE PLACEMENT.txt" "SUMMARY COMPARE PLACEMENT" nil)




close(fp1)
close(fp2)


deleteFile("board_reference_place.txt")
deleteFile("board_test_place.txt")


else

if(fp1!= nil
then
axlUIConfirm("File not found board_test_place.txt")
else
axlUIConfirm("File not found board_reference_place.txt")
) ;if
) ;outer if


;;deleteFile("board_reference_place.txt")
;;deleteFile("board_test_place.txt")


)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;close;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
("close"



when(tool_used=="yes"

end_time=getCurrentTime()
time_diff=compareTime(end_time,start_time)
;;time_diff=time_diff/60

sprintf(time_str "%L" time_diff)

tool_name="Compare Placement$"
tool_name=strcat("$",tool_name,time_str)

temp=strcat(getLogin(),"$",axlCurrentDesign())
temp=strcat(temp,tool_name)

time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))
temp=strcat(temp "$" time_combined)




)

axlClearSelSet()

axlFormClose(fform)
axlCancelEnterFun()





) ;close
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;close;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




) ; case
) ;defun









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;form;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add_placement_comparison_form_function ()

fform=outfile("add_placement_comparison_form.form" "w")
fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")   
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 29 32\n")
fprintf(fform,"HEADER \"R&D-Altanova\"\n")
fprintf(fform,"TILE\n")


fprintf(fform,"TABSET \"tab\"\n")
fprintf(fform,"FLOC 2 1\n")
fprintf(fform,"FSIZE 25 15\n")

fprintf(fform,"TAB \"Placement Comparison\"\n")

fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 4 1\n")
fprintf(fform,"FSIZE 15 10\n")
fprintf(fform,"ENDGROUP\n")

fprintf(fform,"FIELD generate_info\n")
fprintf(fform,"FLOC 6 4\n")
fprintf(fform,"MENUBUTTON \"Generate Info\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD compare\n")
fprintf(fform,"FLOC 6 6\n")
fprintf(fform,"MENUBUTTON \"Compare\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD close\n")
fprintf(fform,"FLOC 6 8\n")
fprintf(fform,"MENUBUTTON \"Close\" 10 3\n")
fprintf(fform,"ENDFIELD\n")




fprintf(fform,"ENDTAB\n")




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;about;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fprintf(fform,"TAB \"About\"\n")

fprintf(fform,"GROUP \"Programmed By\"\n")
fprintf(fform,"FLOC 1 1\n")
fprintf(fform,"FSIZE 27 12\n")
fprintf(fform,"ENDGROUP\n")













fprintf(fform,"TEXT \"AMAN ULLAH GHAZI\"\n")
fprintf(fform,"TLOC 2 4\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"Software Developer\"\n")
fprintf(fform,"TLOC 2 5\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"R&&D-Altanova\"\n")
fprintf(fform,"TLOC 2 6\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"Email: anajeeb@rdaltanova.com\"\n")
fprintf(fform,"TLOC 2 7\n")
fprintf(fform,"ENDTEXT\n")




fprintf(fform,"ENDTAB\n")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;about;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





















fprintf(fform,"ENDTABSET\n")

fprintf(fform,"ENDTILE\n")
fprintf(fform,"ENDFORM\n")
close(fform)


printf("\n--------------------------------------------------------------");
printf("\n\nProgrammed By...");
printf("\n\nAMAN ULLAH GHAZI,");
printf("\nSoftware Engineer,");
printf("\nR&D-Altanova.");
printf("\nEmail : anajeeb@rdaltanova.com\n\n");
)
























