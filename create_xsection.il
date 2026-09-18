axlCmdRegister("create_xsection" 'create_xsection)

(defun create_xsection ()

axlClearSelSet()

form_function()
form=axlFormCreate((gensym),"create_xsection_form.form",'(e outer),'create_xsection_form_Action,t)

axlUIWDisableQuit(form)

start_time=getCurrentTime()

tool_run="no"
time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))


browse=nil
file_name_full=nil

make_xsection=nil
update_xsection=nil
save_xsection=nil
delete_xsection=nil
add_xsection=nil

axlFormSetFieldEditable(form "browse" nil)
axlFormSetFieldEditable(form "make_all_layers_positive" nil)




;;;;;;;;;; reading control depth padstack name ;;;;;;;;;;

fp=infile("ctrl_depth_padstack_input.txt")

l_ctrl_depth_padstack_input=nil

if(fp==nil
then

axlUIConfirm("ctrl_depth_padstack_input.txt is created for control depth padstack input")

fp=outfile("ctrl_depth_padstack_input.txt" "w")
close(fp)

exit()

else

while(gets(line,fp)

l_line=parseString(line,"\n")
line=car(l_line)

when(line!=nil
l_ctrl_depth_padstack_input=cons(line,l_ctrl_depth_padstack_input)
) ;; when

) ;; while

close(fp)

sprintf(length_str "%L" length(l_ctrl_depth_padstack_input))
msg=strcat("Control depth padstack count is ",length_str,". Please confirm")

axlUIConfirm(msg)

) ;; 


;;;;;;;;;; reading control depth padstack name ;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_layers=axlSubclasses("ETCH")

l_layers_num=nil

count=0

foreach(layer,l_layers
count++
l_temp=list(layer,count)
l_layers_num=cons(l_temp,l_layers_num)
) ;; l_layers

;;;;;;;;;;;;;; extract start and end layers ;;;;;;;;;;;;;;

l_visList=axlVisibleGet()


axlVisibleLayer("PIN" t)
axlVisibleLayer("VIA CLASS" t)

axlClearSelSet()
axlSetFindFilter(?enabled '("NOALL" "PINS" "VIAS"), ?onButtons '("NOALL" "PINS" "VIAS"))
axlAddSelectAll()

l_pv_db=axlGetSelSet()

l_padstack_name=unique(l_pv_db~>name)


l_start_end_layers=nil
l_blind_padstack=nil

foreach(padstack,l_padstack_name

padstack_db = axlDBFindByName('padstack padstack)

l_startEnd=padstack_db->startEnd
start_layer=car(l_startEnd)
end_layer=cadr(l_startEnd)



if( car(l_startEnd) != nil && cadr(l_startEnd) != nil
then
start_layer=cadr(parseString(start_layer,"/"))
end_layer=cadr(parseString(end_layer,"/"))

l_temp=list(start_layer,end_layer)
l_temp=sort(l_temp,'alphalessp)

start_layer=car(l_temp)
end_layer=cadr(l_temp)

if(start_layer==end_layer || (start_layer=="BOTTOM" && end_layer=="TOP") || member(padstack,l_ctrl_depth_padstack_input)!=nil
then
else

l_start_end_layers=cons(l_temp,l_start_end_layers)
l_temp=append1(l_temp,padstack)
l_blind_padstack=cons(l_temp,l_blind_padstack)

) ;; if

else

axlUIConfirm( "See command prompt for empty padstacks")
printf("\nEmpty padstack %L , user to check",padstack)


) ;; aneeba if( car(l_startEnd) != nil && cadr(l_startEnd) != nil
) ;; l_padstack_name

l_start_end_layers=unique(l_start_end_layers)
l_start_end_layers=sortcar(l_start_end_layers,'alphalessp)
l_blind_padstack=unique(l_blind_padstack)
l_blind_padstack=sortcar(l_blind_padstack,'alphalessp)


printf("\n--------------------------------------------------------------------------------------------------------")
printf("\nStart_Layer\tEnd_Layer\tPadstack")

foreach(blind_padstack_l,l_blind_padstack
printf("\n%s\t%s\t%s",car(blind_padstack_l),cadr(blind_padstack_l),nth(2,blind_padstack_l))
) ;; l_blind_padstack


printf("\n--------------------------------------------------------------------------------------------------------")



axlVisibleSet(l_visList)
axlVisibleUpdate(nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_start_end_layers_num=nil
l_start_end_layers_name=nil

laser_via_exist="no"

foreach(start_end_l,l_start_end_layers

start_layer=car(start_end_l)
end_layer=cadr(start_end_l)

start_layer_num=0
end_layer_num=0

foreach(layer_num,l_layers_num

when(start_layer==car(layer_num)
start_layer_num=cadr(layer_num)
) ;; when

when(end_layer==car(layer_num)
end_layer_num=cadr(layer_num)
) ;; when

) ;; l_layers_num


if(abs(start_layer_num-end_layer_num)==1
then
laser_via_exist="yes"

else

l_start_end_layers_num=cons(start_layer_num,l_start_end_layers_num)
l_start_end_layers_num=cons(end_layer_num,l_start_end_layers_num)

l_start_end_layers_name=cons(start_layer,l_start_end_layers_name)
l_start_end_layers_name=cons(end_layer,l_start_end_layers_name)

) ;; if

) ;; l_start_end_layers



l_start_end_layers_num=sort(l_start_end_layers_num,'lessp)
l_start_end_layers_name=sort(l_start_end_layers_name,'alphalessp)


;;;;;;;;;;;;;; extract start and end layers ;;;;;;;;;;;;;;



when(laser_via_exist=="yes"
axlUIConfirm("Some padstacks are defined in two layers which tool will consider as laser via (not blind/separate lamination). If it is separate lamination then user to check layer polarity/ArtworkNeg in Allegro x-section and fix accordingly if needed. Refer to command prompt for all padstacks (blind/laser)")
) ;; when



axlFormDisplay(form)

axlClearSelSet()


) ;; main


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun create_xsection_form_Action (fform)


(case fform->curField


("make_xsection"

make_xsection=axlFormGetField(form "make_xsection")

if(make_xsection==t
then
axlFormSetFieldEditable(form "browse" t)
axlFormSetFieldEditable(form "make_all_layers_positive" t)
else
axlFormSetFieldEditable(form "browse" nil)
axlFormSetFieldEditable(form "make_all_layers_positive" nil)
)

) ;; make_xsection

;;;;;;;;;;;;;

("update_xsection"

update_xsection=axlFormGetField(form "update_xsection")

if(update_xsection==t
then
axlFormSetFieldEditable(form "browse" t)
axlFormSetFieldEditable(form "make_all_layers_positive" t)
else
axlFormSetFieldEditable(form "browse" nil)
axlFormSetFieldEditable(form "make_all_layers_positive" nil)
)

) ;; update_xsection

;;;;;;;;;;;;;

("add_xsection"

add_xsection=axlFormGetField(form "add_xsection")

if(add_xsection==t
then
axlFormSetFieldEditable(form "browse" t)
axlFormSetFieldEditable(form "make_all_layers_positive" t)
else
axlFormSetFieldEditable(form "browse" nil)
axlFormSetFieldEditable(form "make_all_layers_positive" nil)
)

) ;; add_xsection


;;;;;;;;;;;;;

("save_xsection"

save_xsection=axlFormGetField(form "save_xsection")

if(save_xsection==t
then
axlFormSetFieldEditable(form "browse" nil)
axlUIWPrint(fform,"Click \"Run\"")

else
axlFormSetFieldEditable(form "browse" t)
)

) ;; save_xsection



("delete_xsection"

delete_xsection=axlFormGetField(form "delete_xsection")

if(delete_xsection==t
then

axlFormSetFieldEditable(form "browse" nil)

okay=axlUIYesNo("1. All options under Electrical Mode will be set to OFF in CM->Analysis Mode->Electrical Modes.\n2. Property 'Fixed' will be removed on all objects.\n\nYou want to proceed?")


when(okay==t
axlUnfixAll()
axlCNSEcsetModeSet('all 'off)
axlDRCUpdate(t)

axlUIWPrint(fform,"Click \"Run\"")

)

else
axlFormSetFieldEditable(form "browse" t)
)


) ;; delete_xsection



("okay"

make_xsection=axlFormGetField(form "make_xsection")
update_xsection=axlFormGetField(form "update_xsection")
save_xsection=axlFormGetField(form "save_xsection")
delete_xsection=axlFormGetField(form "delete_xsection")
add_xsection=axlFormGetField(form "add_xsection")
make_all_layers_positive=axlFormGetField(form "make_all_layers_positive")

	if(make_all_layers_positive==t then
		l_layers=axlSubclasses("ETCH")
		foreach(layer,l_layers
			when(nindex(layer "PN")!=nil || nindex(layer "pn")!=nil
				xs = axlXSectionGet(nil layer)   
				new = axlXSectionGet(nil xs->name)   
				
				rexCompile("PN")
				layer=rexReplace(layer "PP" 0)
	
				name = axlXSectionModify(?name layer)   
				ret = axlXSectionSet(new name)
			)
		) ;; for 
	)

if(make_xsection==nil && update_xsection==nil && save_xsection==nil && delete_xsection==nil && add_xsection==nil
then
axlUIWPrint(fform,"Please select option")

else
if(file_name_full==nil && (make_xsection==t || update_xsection==t)
then
axlUIWPrint(fform,"*.CSV is missing.")

else
if(file_name_full==nil && add_xsection==t
then
axlUIWPrint(fform,"*.TXT is missing.")


else

when(make_xsection==t || update_xsection==t

fp=infile(file_name_full)

l_data_input=nil

while(gets(line,fp)

l_line=parseString(line,"\n")
line=car(l_line)

when(line!=nil && nindex(line,"#")==nil && line!=" "

if(nindex(line,",")==nil
then
line=parseString(line,"|")

layer=""
type=car(line)
material=cadr(line)
thickness=nth(2,line)
dielectric_constant=nth(3,line)
loss_tangent=nth(4,line)

type_in_brd=type

lyr_num_int=0

else

line=parseString(line,"|")

layer=car(line)
type=cadr(line)
material=nth(2,line)
thickness=nth(3,line)
dielectric_constant=nth(4,line)
loss_tangent=nth(5,line)

l_temp=parseString(layer,",")

lyr_num=car(l_temp)
lyr_name=cadr(l_temp)

when(l_temp!=nil && atoi(substring(lyr_num,2))<10
lyr_num=strcat("L0",substring(lyr_num,2))
)


lyr_num=axlStringRemoveSpaces(lyr_num)
lyr_name=axlStringRemoveSpaces(lyr_name)

lyr_num_int=atoi(substring(lyr_num,2))

;; printf("\n%L",lyr_num_int)

type=upperCase(type)
type_in_brd=type

when(type=="MIXED" || type=="SIGNAL" || type=="CONDUCTOR"
type_in_brd="CONDUCTOR"
) ;; 


if(type=="SIGNAL" || type=="MIXED" || type=="CONDUCTOR"
then
lyr_num=strcat(lyr_num,"SP")
else
if(type=="MIXED"
then
lyr_num=strcat(lyr_num,"MP")
else
if(type=="PLANE" && (make_all_layers_positive==t || member(lyr_num_int,l_start_end_layers_num)!=nil)
then
lyr_num=strcat(lyr_num,"PP")
else
lyr_num=strcat(lyr_num,"PN")
))) ;; if


layer=strcat(lyr_num,"_",lyr_name)

) ;; if


when(nindex(layer,"TOP")!=nil
layer="TOP"
)

when(nindex(layer,"BOTTOM")!=nil
layer="BOTTOM"
)


item=list(layer,type_in_brd,material,thickness,dielectric_constant,loss_tangent,lyr_num_int)

l_data_input=append1(l_data_input,item)

) ;; when

) ;; while

close(fp)

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(make_xsection==t

l_data_output=nil

data_output=list("" "SURFACE" "AIR" "0 mil" "0 w/cm-degC" "0 mho/cm" "1.000000" nil nil "0" "" nil nil nil "0.000000")
l_data_output=append1(l_data_output,data_output)

foreach(data_input,l_data_input

layer=car(data_input)

type=cadr(data_input)
type=upperCase(type)

material=nth(2,data_input)
material=upperCase(material)

thickness=nth(3,data_input)
thickness=strcat("  ",thickness," mil")

dielectric_constant=nth(4,data_input)
loss_tangent=nth(5,data_input)

lyr_num_int=nth(6,data_input)

if(type=="CONDUCTOR" || make_all_layers_positive==t || member(lyr_num_int,l_start_end_layers_num)!=nil
then
data_output=list(layer,type,material,thickness,"0 w/cm-degC","595900.000000 mho/cm",dielectric_constant,nil,nil,loss_tangent,"",dielectric_constant,loss_tangent,nil,"90.0")

else
if(type=="PLANE"
then
data_output=list(layer,type,material,thickness,"0 w/cm-degC","595900.000000 mho/cm",dielectric_constant,t,t,loss_tangent,"",nil,nil,nil,"90.0")

else
if(layer==""
then
data_output=list(layer,type,material,thickness,"0 w/cm-degC","0 mho/cm",dielectric_constant,nil,nil,loss_tangent,"",nil,nil,nil,"0.0")
))) ;; if


;;printf("\n%L",data_output)

l_data_output=append1(l_data_output,data_output)


) ;; l_data_input


data_output=list("" "SURFACE" "AIR" "0 mil" "0 w/cm-degC" "0 mho/cm" "1.000000" nil nil "0" "" nil nil nil "0.000000")
l_data_output=append1(l_data_output,data_output)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
fp=outfile("xsection_output.txt" "w")

foreach(data_output,l_data_output
fprintf(fp,"%L\n",data_output)
) ;; 

close(fp)
*/


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

_fpBioImportXSection(l_data_output)

when(length(l_data_output)>0
axlUIWPrint(fform,"Total layers added : %L",length(l_data_output)-2)

tool_run="yes"

)

) ;; make_xsection


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(update_xsection==t

l_xsection_brd=axlGetXSection()


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; compare layer count & layer type


first_item=car(l_xsection_brd)
index_last=length(l_xsection_brd)-1
last_item=nth(index_last,l_xsection_brd)

if(first_item==last_item
then
l_xsection_brd_temp=remove(first_item,l_xsection_brd) ;; will remove both surface layer top/bottom

else
l_xsection_brd_temp=remove(first_item,l_xsection_brd)
l_xsection_brd_temp=remove(last_item,l_xsection_brd_temp)
) ;; if

l_type_mismatch=nil
layer_count_mismatch="no"

if(length(l_data_input)!=length(l_xsection_brd_temp)
then

axlUIConfirm("Layer count mismatch between BRD & CSV. Allgro xross section cannot be update.")
layer_count_mismatch="yes"

else

count=-1

foreach(xsection_brd,l_xsection_brd_temp

count++

name_brd=car(xsection_brd)
type_brd=cadr(xsection_brd)
data_input=nth(count,l_data_input)

type_csv=cadr(data_input)
type_csv=upperCase(type_csv)

;;printf("\n%L\t%s\t%s\t%s",count,type_brd,type_csv,name_brd)

;;axlEnterPoint()

when(type_brd!=type_csv
item=list(type_brd,type_csv,count+2,name_brd)
l_type_mismatch=append1(l_type_mismatch,item)
)


) ;; l_xsection_brd


) ;; if

;;; compare layer count & layer type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


if(length(l_type_mismatch)>0
then

axlUIConfirm("Layer type mismatch between BRD & CSV. Allgro xross section cannot be update. Refer to command prompt for details.")

printf("\nLayer type mismatch between BRD & CSV. Refer to below for details.\n")

foreach(l_items,l_type_mismatch

type_brd=car(l_items)
type_csv=cadr(l_items)
line=nth(2,l_items)
name=nth(3,l_items)

printf("\n%L\t%s\t%s (BRD)\t%s (CSV)",line,name,type_brd,type_csv)

) ;; l_type_mismatch

else
if(layer_count_mismatch=="no"
then

l_data_output=nil
l_data_output_compare=nil


xsection_brd=nth(0,l_xsection_brd)
l_data_output=append1(l_data_output,xsection_brd)
l_data_output_compare=append1(l_data_output_compare,xsection_brd)

count=0

foreach(data_input_l,l_data_input
count++

layer_input=car(data_input_l)
type=cadr(data_input_l)
type=upperCase(type)

material=nth(2,data_input_l)
material=upperCase(material)

thickness=nth(3,data_input_l)
thickness=strcat(thickness," mil")

dielectric_constant=nth(4,data_input_l)
loss_tangent=nth(5,data_input_l)

xsection_brd=nth(count,l_xsection_brd)
layer=car(xsection_brd)

;;printf("\n%L\t%L\t%s\t%s",count,layer,type,material)

usage=""
freqDepFileName=nil

if(type=="CONDUCTOR" || make_all_layers_positive==t || member(layer_input,l_start_end_layers)!=nil
then
thermalCond="0 w/cm-degC"
elecCond="595900.000000 mho/cm"
artworkNeg=nil
shield=nil
etchFactor="90.0"
SignalDieConstant=dielectric_constant
SignalLossTangent=loss_tangent

data_output=list(layer,type,material,thickness,thermalCond,elecCond,dielectric_constant,artworkNeg,shield,loss_tangent,usage,SignalDieConstant,SignalLossTangent,freqDepFileName,etchFactor)
data_output_compare=list(layer_input,type,material,thickness,thermalCond,elecCond,dielectric_constant,artworkNeg,shield,loss_tangent,usage,SignalDieConstant,SignalLossTangent,freqDepFileName,etchFactor)

else
if(type=="PLANE"
then
thermalCond="0 w/cm-degC"
elecCond="595900.000000 mho/cm"
artworkNeg=t
shield=t
etchFactor="90.0"
SignalDieConstant=nil
SignalLossTangent=nil

data_output=list(layer,type,material,thickness,thermalCond,elecCond,dielectric_constant,artworkNeg,shield,loss_tangent,usage,SignalDieConstant,SignalLossTangent,freqDepFileName,etchFactor)
data_output_compare=list(layer_input,type,material,thickness,thermalCond,elecCond,dielectric_constant,artworkNeg,shield,loss_tangent,usage,SignalDieConstant,SignalLossTangent,freqDepFileName,etchFactor)

else
if(layer==""
then
thermalCond="0 w/cm-degC"
elecCond="0 mho/cm"
artworkNeg=nil
shield=nil
etchFactor="0.0"
SignalDieConstant=nil
SignalLossTangent=nil

data_output=list(layer,type,material,thickness,thermalCond,elecCond,dielectric_constant,artworkNeg,shield,loss_tangent,usage,SignalDieConstant,SignalLossTangent,freqDepFileName,etchFactor)
data_output_compare=list(layer_input,type,material,thickness,thermalCond,elecCond,dielectric_constant,artworkNeg,shield,loss_tangent,usage,SignalDieConstant,SignalLossTangent,freqDepFileName,etchFactor)

))) ;; if


l_data_output=append1(l_data_output,data_output)
l_data_output_compare=append1(l_data_output_compare,data_output_compare)

) ;; l_data_input



last_index=length(l_xsection_brd)-1
xsection_brd=nth(last_index,l_xsection_brd)
l_data_output=append1(l_data_output,xsection_brd)
l_data_output_compare=append1(l_data_output_compare,xsection_brd)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

iteration=length(l_data_output_compare)
iteration--

l_compare_data=nil
count=-1

l_xsection_brd=axlGetXSection()

for( index 0 iteration

count++

l_xsection_brd_l=nth(index,l_xsection_brd)

layer_brd=car(l_xsection_brd_l)
type_brd=cadr(l_xsection_brd_l)
material_brd=nth(2,l_xsection_brd_l)
thickness_brd=nth(3,l_xsection_brd_l)
dielectric_constant_brd=nth(6,l_xsection_brd_l)
artworkNeg_brd=nth(7,l_xsection_brd_l)
shield_brd=nth(8,l_xsection_brd_l)
loss_tangent_brd=nth(9,l_xsection_brd_l)
SignalDieConstant_brd=nth(11,l_xsection_brd_l)
SignalLossTangent_brd=nth(12,l_xsection_brd_l)

l_string=parseString(thickness_brd," ")
thickness_brd=car(l_string)
thickness_brd=atof(thickness_brd)

dielectric_constant_brd=atof(dielectric_constant_brd)
loss_tangent_brd=atof(loss_tangent_brd)

data_output_l=nth(index,l_data_output_compare)

layer_input=car(data_output_l)
type_input=cadr(data_output_l)
material_input=nth(2,data_output_l)
thickness_input=nth(3,data_output_l)
dielectric_constant_input=nth(6,data_output_l)
artworkNeg_input=nth(7,data_output_l)
shield_input=nth(8,data_output_l)
loss_tangent_input=nth(9,data_output_l)
SignalDieConstant_input=nth(11,data_output_l)
SignalLossTangent_input=nth(12,data_output_l)

l_string=parseString(thickness_input," ")
thickness_input=car(l_string)
thickness_input=atof(thickness_input)

dielectric_constant_input=atof(dielectric_constant_input)
loss_tangent_input=atof(loss_tangent_input)

;;printf("\n%s\t%s",layer_brd,layer_input)
;;axlEnterPoint()

when(layer_brd!=layer_input
comment="Layer_name"
l_temp=list(count,layer_brd,layer_brd,layer_input,comment)
l_compare_data=cons(l_temp,l_compare_data)
) ;; 


when(type_brd!=type_input
comment="Type"
l_temp=list(count,layer_brd,type_brd,type_input,comment)
l_compare_data=cons(l_temp,l_compare_data)
) ;; 

when(material_brd!=material_input
comment="Material"
l_temp=list(count,layer_brd,material_brd,material_input,comment)
l_compare_data=cons(l_temp,l_compare_data)
) ;; 

when(thickness_brd!=thickness_input
comment="Thickness"
l_temp=list(count,layer_brd,thickness_brd,thickness_input,comment)
l_compare_data=cons(l_temp,l_compare_data)
) ;; 

when(dielectric_constant_brd!=dielectric_constant_input
comment="Dielectric_constant"
l_temp=list(count,layer_brd,dielectric_constant_brd,dielectric_constant_input,comment)
l_compare_data=cons(l_temp,l_compare_data)
) ;; 

when(loss_tangent_brd!=loss_tangent_input
comment="Loss_Tangent"
l_temp=list(count,layer_brd,loss_tangent_brd,loss_tangent_input,comment)
l_compare_data=cons(l_temp,l_compare_data)
) ;; 

when(artworkNeg_brd!=artworkNeg_input
comment="ArtworkNeg"
l_temp=list(count,layer_brd,artworkNeg_brd,artworkNeg_input,comment)
l_compare_data=cons(l_temp,l_compare_data)
) ;; 


when(shield_brd!=shield_input
comment="ArtworkShield"
l_temp=list(count,layer_brd,shield_brd,shield_input,comment)
l_compare_data=cons(l_temp,l_compare_data)
) ;; 



) ;; for


l_compare_data=reverse(l_compare_data)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_fpBioImportXSection(l_data_output)

when(length(l_data_output)>0

tool_run="yes"

axlUIWPrint(fform,"Done | Mismatch : %L",length(l_compare_data))

when(l_compare_data!=nil

axlUIConfirm("Mismatch found and updated in X-section. Pls refer to Allegro command prompt for mismatch details.")

fp=outfile("xsection_mismatch.txt" "w")

fprintf(fp,"%s.brd",axlCurrentDesign())
fprintf(fp,"\n%s.csv",file_name)


;;printf("\n--------------------------------------------------------------------------------------------------------------------\n")

fprintf(fp,"\n\nLine#\tLayer\tBRD\tInput\tField")

foreach(compare_data_l,l_compare_data
fprintf(fp,"\n%L\t%s\t%L\t%L\t%s",car(compare_data_l),cadr(compare_data_l),nth(2,compare_data_l),nth(3,compare_data_l),nth(4,compare_data_l))
) ;; l_compare_data

;;printf("\n--------------------------------------------------------------------------------------------------------------------\n")


fprintf(fp,"\n\nTotal Mismatch : %L",length(l_compare_data))

close(fp)

axlUIViewFileCreate("xsection_mismatch.txt" "xsection_mismatch" nil)


) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


) ;; when

)) ;; if

;;;;;;;;

) ;; update_xsection

;;;;;;;;;;;;;;;;;;;;;;;

when(save_xsection==t

l_xsection_brd=axlGetXSection()

fp=outfile("xsection_output.txt" "w")

fprintf(fp,"%s.brd",axlCurrentDesign())

count=0
etch_layer_count=0

foreach(xsection_brd,l_xsection_brd
count++

layer=car(xsection_brd)
type=cadr(xsection_brd)
material=nth(2,xsection_brd)
thickness=nth(3,xsection_brd)
dielectric_constant=nth(6,xsection_brd)
loss_tangent=nth(9,xsection_brd)

thickness=car(parseString(thickness," "))


when(layer!=""
etch_layer_count++
)

when(count!=1 && count!=length(l_xsection_brd)

if(layer==""
then
fprintf(fp,"\n%s|%s|%s|%s|%s",type,material,thickness,dielectric_constant,loss_tangent)
else
fprintf(fp,"\n%s|%s|%s|%s|%s|%s",layer,type,material,thickness,dielectric_constant,loss_tangent)
)

) ;; count

) l_xsection_brd

close(fp)

axlUIViewFileCreate("xsection_output.txt" "xsection_output" nil)
;;;;axlUIWPrint(fform,"File saved xsection_output.txt")

;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;

) ;; save_xsection


;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;

when(delete_xsection==t


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_shapes_db=axlDBGetShapes("BOUNDARY")
l_shapes_test_db=l_shapes_db
func_delete_shapes() ;; read l_shapes_test_db and delete

l_shapes_db=axlDBGetShapes("ROUTE KEEPOUT")
l_shapes_test_db=l_shapes_db
func_delete_shapes() ;; read l_shapes_test_db and delete

l_shapes_db=axlDBGetShapes("CONSTRAINT REGION")
l_shapes_test_db=l_shapes_db
func_delete_shapes() ;; read l_shapes_test_db and delete

l_shapes_db=axlDBGetShapes("CONSTRAINT REGION")
l_shapes_test_db=l_shapes_db
func_delete_shapes() ;; read l_shapes_test_db and delete

l_shapes_db=axlDBGetShapes("ETCH")
l_shapes_test_db=l_shapes_db
func_delete_shapes() ;; read l_shapes_test_db and delete

l_shapes_db=axlDBGetShapes("ANTI ETCH")
l_shapes_test_db=l_shapes_db
func_delete_shapes() ;; read l_shapes_test_db and delete


func_delete_objects()


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


l_data_output=nil

data_output=list("" "SURFACE" "AIR" "0 mil" "0 w/cm-degC" "0 mho/cm" "1" nil nil "0" "" nil nil nil "0.000000")
l_data_output=append1(l_data_output,data_output)

data_output=list("TOP" "CONDUCTOR" "COPPER" "1.2 mil" "0 w/cm-degC" "0 mho/cm" "4.5" nil nil "0" "" "1" "0" nil "90.0") 
l_data_output=append1(l_data_output,data_output)

data_output=list("" "DIELECTRIC" "N4800-20" "5.48 mil" "0 w/cm-degC" "0 mho/cm" "3.28" nil nil "0" "" nil nil nil "0.0") 
l_data_output=append1(l_data_output,data_output)

data_output=list("BOTTOM" "CONDUCTOR" "COPPER" "2.315 mil" "0 w/cm-degC" "595900 mho/cm" "4" nil nil "0.002" "" "1" "0" nil "90.0") 
l_data_output=append1(l_data_output,data_output)

data_output=list("" "SURFACE" "AIR" "0 mil" "0 w/cm-degC" "0 mho/cm" "1" nil nil "0" "" nil nil nil "0.0")
l_data_output=append1(l_data_output,data_output)


_fpBioImportXSection(l_data_output)


when(length(l_data_output)>0
tool_run="yes"
)

axlUIWPrint(fform,"Done")

axlVisibleDesign(nil)
axlVisibleLayer("BOARD GEOMETRY/OUTLINE" t)
axlVisibleUpdate(nil)

) ;; delete_xsection


;;;;;;;;;;;;;;;;;;;;;;;


when(add_xsection==t

l_layers_input=nil


fp=infile(file_name_full)

bracket_right="("
bracket_left=")"

warning="no"

while(gets(line,fp)

l_line=parseString(line,"\n")
line=car(l_line)

when(line!=nil && (nindex(line," ")!=nil || nindex(line,"/")!=nil || nindex(line,"\\")!=nil || nindex(line,bracket_left)!=nil || nindex(line,bracket_right)!=nil)
warning="yes"
)

when(line!=nil
l_layers_input=cons(line,l_layers_input)
)


) ;; while


;;;;;;;;;;;;;;;;;;;;;;;;;;

when(warning=="yes"
axlUIConfirm("Layer name must not contain space,bracket or slash, replace it with underscore.")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;

num=0

l_layers_input=reverse(l_layers_input)

foreach(layer,l_layers_input

num++


if(num<10
then
sprintf(number "%L" num)
number=strcat("0",number)

else
sprintf(number "%L" num)
)


if(nindex(layer,"INR")==nil && layer!="TOP" && layer!="BOTTOM" && nindex(upperCase(layer),"SENSE")==nil && nindex(upperCase(layer),"UTIL")==nil && nindex(layer,"INNER")==nil && nindex(layer,"SIG")==nil && nindex(layer,"INT")==nil && nindex(layer,"UTL")==nil && make_all_layers_positive==nil
then

polarity="NEGATIVE"
type="PLANE"
layer=strcat("L",number,"PN_",layer)

else
if(nindex(layer,"INR")==nil && layer!="TOP" && layer!="BOTTOM" && nindex(upperCase(layer),"SENSE")==nil && nindex(upperCase(layer),"UTIL")==nil && nindex(layer,"INNER")==nil && nindex(layer,"SIG")==nil && nindex(layer,"INT")==nil && nindex(layer,"UTL")==nil && make_all_layers_positive==t
then

polarity="POSITIVE"
type="PLANE"
layer=strcat("L",number,"PP_",layer)

else

polarity="POSITIVE"
type="CONDUCTOR"
layer=strcat("L",number,"SP_",layer)

))


when(num==1
layer="TOP"
)

when(num==length(l_layers_input)
layer="BOTTOM"
)


when(num>2 && warning=="no"
axlLayerCreateCrossSection("BOTTOM","DIELECTRIC","N4800-20")

tool_run="yes"

)

when(warning=="no"
axlLayerCreateCrossSection("BOTTOM",type,"COPPER",layer,polarity)

tool_run="yes"

)

) ;; l_layers_input


when(warning=="no"
axlUIWPrint(fform,"Total layers added : %L",length(l_layers_input))


)

) ;; add_xsection

;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;

))) ;; main if

) ;; okay





;;;;;;;;;;;;;;;;

("browse"

make_xsection=axlFormGetField(form "make_xsection")
update_xsection=axlFormGetField(form "update_xsection")
save_xsection=axlFormGetField(form "save_xsection")
delete_xsection=axlFormGetField(form "delete_xsection")
add_xsection=axlFormGetField(form "add_xsection")

if(make_xsection==nil && update_xsection==nil && add_xsection==nil
then
axlUIWPrint(fform,"Please select option")

else
if(make_xsection==t || update_xsection==t
then
file_name_full=axlDMFileBrowse(nil nil ?optFilters "CSV files(*.csv)|*.csv")
file_path=car(axlDMFileParts(file_name_full))
file_name=cadr(axlDMFileParts(file_name_full))
file_extension=nth(3,axlDMFileParts(file_name_full))

axlUIWPrint(fform,"Click \"Run\"")

else
if(add_xsection==t
then
file_name_full=axlDMFileBrowse(nil nil ?optFilters "TXT files(*.txt)|*.txt")
file_path=car(axlDMFileParts(file_name_full))
file_name=cadr(axlDMFileParts(file_name_full))
file_extension=nth(3,axlDMFileParts(file_name_full))
axlUIWPrint(fform,"Click \"Run\"")
))

) ;; if


) ;; browse


;;;;;;;;;;;

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

tool_name="Create Xsection$"
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

) ;; create_xsection_form_Action




;;;;;;;;;;;;;;;

;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun form_function ()

fform=outfile("create_xsection_form.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")   
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 34 27\n")
fprintf(fform,"HEADER \"(R&D-Altanova)\"\n")
fprintf(fform,"TILE\n")

fprintf(fform,"TABSET \"tab\"\n")
fprintf(fform,"FLOC 2 1\n")
fprintf(fform,"FSIZE 31 25\n")

fprintf(fform,"TAB \"Input\"\n")

fprintf(fform,"FIELD make_xsection\n")
fprintf(fform,"FLOC 3 2\n")
fprintf(fform,"CHECKLIST \"Create Xsection (new BRD)\" \"rg\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD update_xsection\n")
fprintf(fform,"FLOC 3 4\n")
fprintf(fform,"CHECKLIST \"Update Xsection (same lyr count)\" \"rg\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD add_xsection\n")
fprintf(fform,"FLOC 3 6\n")
fprintf(fform,"CHECKLIST \"Add Xsection (*.txt)\" \"rg\"\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD delete_xsection\n")
fprintf(fform,"FLOC 3 8\n")
fprintf(fform,"CHECKLIST \"Delete Xsection\" \"rg\"\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD save_xsection\n")
fprintf(fform,"FLOC 3 10\n")
fprintf(fform,"CHECKLIST \"Save Xsection\" \"rg\"\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD make_all_layers_positive\n")
fprintf(fform,"FLOC 3 13\n")
fprintf(fform,"CHECKLIST \"Make all layers positive and layers PN To PP (INTEL) \"\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD browse\n")
fprintf(fform,"FLOC 3 16\n")
fprintf(fform,"MENUBUTTON \"Browse\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"TEXT \"(*.CSV/*.TXT)\"\n")
fprintf(fform,"TLOC 14 16\n")
fprintf(fform,"ENDTEXT\n")


fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 0\n")
fprintf(fform,"FSIZE 28 19\n")
fprintf(fform,"ENDGROUP\n")


fprintf(fform,"FIELD okay\n")
fprintf(fform,"FLOC 2 20\n")
fprintf(fform,"MENUBUTTON \"Run\" 10 3\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD close1\n")
fprintf(fform,"FLOC 18 20\n")
fprintf(fform,"MENUBUTTON \"Close\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"ENDTAB\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"TAB \"About\"\n")


fprintf(fform,"TEXT \" Programmed By \"\n")
fprintf(fform,"TLOC 2 4\n")
fprintf(fform,"OPTIONS bold\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"AMAN ULLAH GHAZI\"\n")
fprintf(fform,"TLOC 4 6\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"Software Engineer\"\n")
fprintf(fform,"TLOC 4 8\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"R&&D-Altanova\"\n")
fprintf(fform,"TLOC 4 10\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"TEXT \"Email: ghaziaman.ullah@hotmail.com\"\n")
fprintf(fform,"TLOC 4 12\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"GROUP \"\"\n")
fprintf(fform,"FLOC 1 2\n")
fprintf(fform,"FSIZE 28 13\n")
fprintf(fform,"ENDGROUP\n")

/*
fprintf(fform,"FIELD bitmap\n")
fprintf(fform,"THUMBNAIL \"C:/cadence_skill_files/skill_files/rd-altanova_logo\"\n")
;fprintf(fform,"OPTIONS stretch\n")
fprintf(fform,"FLOC 4 12\n")
fprintf(fform,"FSIZE 16 6\n")
fprintf(fform,"ENDFIELD\n")
*/

fprintf(fform,"FIELD close\n")
fprintf(fform,"FLOC 18 17\n")
fprintf(fform,"MENUBUTTON \"Close\" 10 3\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"ENDTAB\n")


fprintf(fform,"ENDTABSET\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"ENDTILE\n")
fprintf(fform,"ENDFORM\n")

close(fform)

)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun func_delete_shapes ()

l_shapes_delete=nil
foreach(shape,l_shapes_test_db
when(nindex(shape->layer,"TOP")==nil && nindex(shape->layer,"BOTTOM")==nil && nindex(shape->layer,"ALL")==nil
l_shapes_delete=cons(shape,l_shapes_delete)
)
)

axlDeleteObject(l_shapes_delete)

) ;; func_delete_shapes


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun func_delete_objects ()

axlClearSelSet()
axlVisibleDesign(nil)

axlVisibleLayer("ANTI ETCH" t)
axlVisibleLayer("BOUNDARY" t)
axlVisibleUpdate(nil)

axlSetFindFilter(?enabled list("noall" "LINESEGS") ?onButtons list("noall" "LINESEGS"))
l_db_brd=nil
axlAddSelectAll()
l_db_brd=axlGetSelSet()

l_db_delete=nil

foreach(db,l_db_brd
when(nindex(db->layer,"TOP")==nil && nindex(db->layer,"BOTTOM")==nil
l_db_delete=cons(db,l_db_delete)
)
) ;; l_db_brd

axlDeleteObject(l_db_delete)
axlClearSelSet()

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
