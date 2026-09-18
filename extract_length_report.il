axlCmdRegister("extract_length_report" 'extract_length_report)

(defun extract_length_report ()


form_function()
form=axlFormCreate((gensym),"extract_length_report_form.form",'(e outer),'extract_length_report_action,t)

axlUIWDisableQuit(form)

start_time=getCurrentTime()
tool_run="no"

time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))

axlFormSetFieldEditable(form "run" nil)

;;;;;;;;;;;;;;;;;;;;;;;;;; reading header info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fp=infile("C:/cadence_skill_files/skill_files/extract_length_report_header.txt")


l_header_std=nil
l_header_only=nil

if(fp==nil
then

axlUIConfirm("C:/cadence_skill_files/skill_files/extract_length_report_header.txt is missing.")
exit()

else

when(fp!=nil

while(gets(line,fp)

l_line=parseString(line,"\n")
line=car(l_line)

l_string=parseString(line,"\t")
l_header_std=append1(l_header_std,l_string)
l_header_only=append(l_header_only,l_string)

) ;; while

close(fp)


l_header_std=cons(list("Line #"),l_header_std)

) ;; when


) ;; if

;;;;;;;;;;;;;;;;;;;;;;;;;; reading header info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;; reading excel column number ;;;;;;;;;;;;;;;;;;;;;;;;;;

fp=infile("C:/cadence_skill_files/skill_files/excel_column_number.txt")

l_column_info_excel=nil
skip_line="yes"

while(gets(line,fp)

l_line=parseString(line,"\n")
line=car(l_line)
l_temp=parseString(line,"\t")

col_num=car(l_temp)
col_name=cadr(l_temp)

when(skip_line=="no" && line!=nil

l_items=list(col_num,col_name)
l_column_info_excel=append1(l_column_info_excel,l_items)
) ;; skip_line

skip_line="no"

) ;; while

close(fp)

;;;;;;;;;;;;;;;;;;;;;;;;;; reading excel column number ;;;;;;;;;;;;;;;;;;;;;;;;;;




/*

;;;;;;;;;;;;;;;;;;;;;;;;;; reading nets, pin name and pin number ;;;;;;;;;;;;;;;;;;;;;;;;;;

l_visList=axlVisibleGet()

l_layers=axlSubclasses("ETCH")

axlClearSelSet()

design=axlDBGetDesign()

l_nets_all=unique(design~>nets~>name)
l_symbols_db=design->symbols

l_pin_name_all=nil
l_pin_num_all=nil

l_pin_net=nil

foreach(symbol_db,l_symbols_db

l_pins_db=symbol_db->pins

l_pin_name=l_pins_db~>functionPins~>name
l_pin_name_all=append(l_pin_name_all,l_pin_name)

l_pin_number=l_pins_db~>number
l_pin_num_all=append(l_pin_num_all,l_pin_number)

) ;; l_symbols_db


l_pin_name_all=unique(l_pin_name_all)
l_pin_num_all=unique(l_pin_num_all)


axlVisibleSet(l_visList)
axlVisibleUpdate(nil)

;;;;;;;;;;;;;;;;;;;;;;;;;; reading nets, pin name and pin number ;;;;;;;;;;;;;;;;;;;;;;;;;;

*/

cell_input="???"
cell_output="???"

axlFormSetField(form "cell_input" cell_input)
axlFormSetField(form "cell_output" cell_output)

;;;; initialize ;;;;

cell_input="B3"
cell_output="W3"

axlFormSetField(form "cell_input" cell_input)
axlFormSetField(form "cell_output" cell_output)

;;;; initialize ;;;;



l_pogos_93k_std=list("J101","J102","J103","J104","J105","J106","J107","J108","J109","J110","J111","J112","J113","J114","J115","J116","J117","J118","J119","J120","J121","J122","J123","J124","J125","J126","J127","J128","J129","J130","J131","J132","J201","J202","J203","J204","J205","J206","J207","J208","J209","J210","J211","J212","J213","J214","J215","J216","J217","J218","J219","J220","J221","J222","J223","J224","J225","J226","J227","J228","J229","J230","J231","J232","J301","J302","J303","J304","J305","J306","J307","J308","J309","J310","J311","J312","J313","J314","J315","J316","J317","J318","J319","J320","J321","J322","J323","J324","J325","J326","J327","J328","J329","J330","J331","J332","J401","J402","J403","J404","J405","J406","J407","J408","J409","J410","J411","J412","J413","J414","J415","J416","J417","J418","J419","J420","J421","J422","J423","J424","J425","J426","J427","J428","J429","J430","J431","J432","J1DPS","J2DPS","J3DPS","J4DPS","J5DPS","J6DPS","J7DPS","J8DPS","J1UTIL","J2UTIL","J3UTIL","J4UTIL","J5UTIL","J6UTIL","J7UTIL","J8UTIL")


;;;;;;;;;;;;;;;;;;;;;;;;;; extract netlist ;;;;;;;;;;;;;;;;;;;;;;;;;;

l_netlist=nil

when(member("POGO",l_header_only)!=nil

design=axlDBGetDesign()
l_nets_db=design->nets

l_netlist=nil

foreach(net_db,l_nets_db

net_name=net_db->name
l_nodes_db = axlPinsOfNet(net_db,nil)

l_nodes=nil
foreach(pin_db,l_nodes_db
get_pin_from_pin_db() ;; read pin_db and return pin, pin_name, pin_num, net & refdes
l_nodes=append1(l_nodes,pin)
) ;; l_nodes_db

l_nodes=sort(l_nodes,'alphalessp)

l_temp=list(length(l_nodes),net_name,l_nodes)
l_netlist=cons(l_temp,l_netlist)

) ;; l_nets

l_netlist=sortcar(l_netlist,'lessp)

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;; extract netlist ;;;;;;;;;;;;;;;;;;;;;;;;;;

axlFormDisplay(form)


) ;; main function


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun extract_length_report_action (fform)


(case fform->curField

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

/*

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing tool info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(tool_run=="yes"

login_name=getLogin()
end_time=getCurrentTime()
time_diff=compareTime(end_time,start_time)

sprintf(time_str "%L" time_diff)

tool_name="Extract Length Report$"
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

*/


) ;; close1



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



("file_input"

file_name_full=axlDMFileBrowse(nil nil ?optFilters "TXT files(*.txt)|*.txt")

when(file_name_full!=nil
file_path=car(axlDMFileParts(file_name_full))
file_name=cadr(axlDMFileParts(file_name_full))
file_extension=nth(3,axlDMFileParts(file_name_full))
) ;; when


if(file_name_full==nil
then
axlUIWPrint(fform,"No file found")
axlFormSetFieldEditable(form "run" nil)

else
if(file_name_full!=nil
then
axlFormSetFieldEditable(form "run" t)
axlUIWPrint(fform,"Input file : %s",file_name)

)) ;; if


) ;; file_input


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


("run"


axlUIWPrint(fform,"Please wait")



cell_input=axlFormGetField(form "cell_input")
cell_output=axlFormGetField(form "cell_output")
read_indirect_tc=axlFormGetField(form "read_indirect_tc")

cell_input=upperCase(cell_input)
cell_output=upperCase(cell_output)

excel_cell_input=cell_input
func_get_cell_alpha_num() ;; read excel_cell_input & output cell_alpha/cell_num

cell_alpha_input=cell_alpha
cell_num_input=cell_num

excel_cell_input=cell_output
func_get_cell_alpha_num() ;; read excel_cell_input & output cell_alpha/cell_num

cell_alpha_output=cell_alpha
cell_num_cell_output=cell_num

row_input=atoi(cell_num_input)

col_num_input=0
col_num_output=0

foreach(column_info_excel_l,l_column_info_excel
when(cell_alpha_input==cadr(column_info_excel_l)
col_num_input=atoi(car(column_info_excel_l))
) ;; when

when(cell_alpha_output==cadr(column_info_excel_l)
col_num_output=atoi(car(column_info_excel_l))
) ;; when



) ;; l_column_info_excel

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

tool_run="yes"
comma=","

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;; reading input file ;;;;;;;;;;;

fp=infile(file_name_full)

header_exist_in_input="no"

when(fp!=nil

header_row_num=0
header_col_num=0
row_num=0
col_num=0
header_found="no"
l_header_new=nil
l_data_input_temp=nil
l_header_input_temp=nil
l_data_all_input=nil
read_data="no"
l_string_temp=nil

while(gets(line,fp)

row_num++
l_line=parseString(line,"\n")
line=car(l_line)

when(line!=nil
l_string=parseString(line,"\t")
first_item=car(l_string)
) ;; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when( (line==nil || first_item==nil) && read_data=="yes" ;; data complete when line is nil or contain no data

;;printf("\n%L\t%L\t%L\t%L",row_num,line,first_item,read_data)

l_temp=append(l_header_input_temp,l_data_input_temp)
l_data_all_input=append1(l_data_all_input,l_temp)

read_data="no"
header_found="no"
l_data_input_temp=nil
l_header_input_temp=nil
l_string_temp=nil


) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(line!=nil

l_string=parseString(line,"\t")

iteration=strlen(line)

l_break_index=nil

for( i 1 iteration
string_temp=substring(line,i,1)
when(string_temp=="\t"
l_break_index=append1(l_break_index,i)
) ;; when
) ;; iteration

;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start_index=1

l_string_local=nil

foreach(break_index,l_break_index
end_index=break_index-start_index
string_temp=substring(line,start_index,end_index)
start_index=break_index+1
l_string_local=append1(l_string_local,string_temp)
) ;; l_break_index

string_temp=substring(line,start_index)

when(string_temp==nil
string_temp="-"
) ;; 

l_string_local=append1(l_string_local,string_temp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(read_data=="yes"

;;printf("\n%s\t%L",string_temp,strlen(string_temp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_string_temp=cons(row_num,l_string_local)
l_data_input_temp=append1(l_data_input_temp,l_string_temp)

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_found=="no"

foreach(string,l_string_local

string=upperCase(string)
when(member(string,l_header_only)!=nil || substring(string,1,3)=="NET"
header_found="yes"
header_exist_in_input="yes"
header_row_num=row_num
) ;; when
) ;; l_string_local

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_found=="yes"

header_found="no"
read_data="yes"

l_temp=cons(header_row_num,l_string_local)
l_header_input_temp=append1(l_header_input_temp,l_temp)

foreach(string,l_string_local
string=upperCase(string)
when(member(string,l_header_only)==nil && string!="" && substring(string,1,3)!="NET"
l_temp=list(row_num,string)
l_header_new=append1(l_header_new,l_temp)
) ;; when

) ;; l_string_local

) ;; when

;;;;;;;;;;

) ;; when
) ;; while

close(fp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(read_data=="yes" ;; data complete when line is nil or contain no data
l_temp=append(l_header_input_temp,l_data_input_temp)
l_data_all_input=append1(l_data_all_input,l_temp)
) ;; when


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(l_header_new!=nil

axlUIConfirm("Some headers are not identifyable in the input file. Please refer to Allegro command prompt & fix either in input file or add in the tool database \"extract_length_report_header.txt\"")

printf("\n---------------------------------")

printf("\nRow#\tHeader")

foreach(header_new,l_header_new
printf("\n%L\t%L",car(header_new),cadr(header_new))
) ;; l_header_new

printf("\n---------------------------------")

) ;; l_header_new

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_exist_in_input=="no"
axlUIConfirm("Headers are missing in input file")
) ;; when


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

) ;; when fp


;;;;;;;;;;; reading input file ;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

quote=""
fp=outfile("data_out.txt" "w")

row_start=1
row_num_current=row_input
row_num_start=0
row_offset_adjust=0

foreach(data_input_all_l,l_data_all_input

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

count=0
line_count=0
first_time="yes"
l_max_min_skew=nil
l_headers_input=nil

foreach(data_input_l,data_input_all_l

count++

row_num=car(data_input_l)

row_offset=row_num-row_start
row_offset=row_offset-row_offset_adjust
row_start=row_start+row_offset

row_num_current=row_num_current+row_offset ;;+row_offset_adjust

for( i 1 row_offset
fprintf(fp,"\n")
) ;; row_offset

l_net_length_col_num_sum=nil
l_net_length_col_num_total=nil

if(count==1 ;; first entry is heading
then

count_temp=0

foreach(data_input,data_input_l

count_temp++

if(count_temp==1
then
fprintf(fp,"%L",data_input)
else
fprintf(fp,"\t%L",data_input)
) ;; if


foreach(header_std_l,l_header_std
if(stringp(data_input)==t && member(upperCase(data_input),header_std_l)!=nil
then
l_headers_input=append1(l_headers_input,car(header_std_l))

else
if(stringp(data_input)==t
then
foreach(header_std,header_std_l
when(header_std==substring(upperCase(data_input),1,3) && header_std=="NET"
l_headers_input=append1(l_headers_input,car(header_std_l))
) ;; when
) ;; header_std_l

)) ;; if
) ;; l_header_std


) ;; data_input_l

l_headers_input=cons("LINE #",l_headers_input)

;;;;;;;;;;;;;;;;;;;;;;;;;;

index=-1
index_new=0

foreach(header_input,l_headers_input

index++
col_num=col_num_output+index

col_num_index=col_num-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)

when(header_input=="LENGTH" || header_input=="SKEW" || header_input=="SUM LENGTH" || header_input=="TOTAL LENGTH"

;; printf("\nfsl")

index_diff=index-index_new
l_temp=list(index_diff,cell_alpha)
l_max_min_skew=append1(l_max_min_skew,l_temp)

index_new=index

) ;; when
) ;; l_headers_input

;;;;;;;;;;;;;;;;;;;;;;;;;;


else

line_count++
index=-1
col=0
col_num_current=col_num_output
pin_index=-1
pin_col_num=0
net_index=-1
pin_net_index=-1
ref_pin="-"
net_col_num=0
pin_col_found="no"
net_col_found="no"

when(first_time=="yes"
row_num_start=row_num_current
first_time="no"
)

foreach(header_input,l_headers_input

index++
col++

;;printf("\n%L",header_input)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="LINE #"

pin_index++
net_index++
pin_net_index++
data_input=nth(index,data_input_l)
fprintf(fp,"%L",data_input)

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="PIN #"

;;printf("\n%L",header_input)

pin_net_index++
data_input=nth(index,data_input_l)
fprintf(fp,"\t%L",data_input)
pin_col_num=col_num_output+index
pin_col_found="yes"

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="PIN NAME"

;; =VLOOKUP(Q76,cmp_pin_rpt!$A:$G,6,0)

pin_name_col=col_num_output+index

if(pin_col_found=="yes"
then

col_num_index=pin_col_num-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)

sprintf(row_num_current_str "%L" row_num_current+row_offset_adjust)
cell=strcat(cell_alpha,row_num_current_str)
formula=strcat("=IFERROR(VLOOKUP(",cell,comma,"cmp_pin_rpt!$A:$G,6,0),","\"","","\"",")")
fprintf(fp,"\t%s",formula)

else
fprintf(fp,"\t-")

) ;; if

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="NET" || substring(header_input,1,3)=="NET"

;; =VLOOKUP(Q76,cmp_pin_rpt!$A:$G,7,0)

net_col_num_previous=net_col_num
net_col_num=col_num_output+index
net_col_found="yes"

net_name="-"

if(pin_col_found=="yes"
then

;;pin_net_index++
col_num_index=pin_col_num-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)

sprintf(row_num_current_str "%L" row_num_current+row_offset_adjust)
cell=strcat(cell_alpha,row_num_current_str)
formula=strcat("=IFERROR(VLOOKUP(",cell,comma,"cmp_pin_rpt!$A:$G,7,0),","\"","","\"",")")
fprintf(fp,"\t%s",formula)
pin=data_input

foreach(netlist_l,l_netlist
when(member(pin,nth(2,netlist_l))!=nil
net_name=cadr(netlist_l)
) ;; when
) ;; l_netlist

else

;;;;;;;;

pin_net_index++
data_input=nth(index,data_input_l)
net_name=data_input

if(read_indirect_tc==nil
then
fprintf(fp,"\t%L",data_input)

else

col_num_index=net_col_num_previous-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)

sprintf(row_num_current_str "%L" row_num_current+row_offset_adjust)
cell=strcat(cell_alpha,row_num_current_str)

formula=strcat("=IFERROR(VLOOKUP(",cell,comma,"cmp_pin_rpt!$L:$M,2,0),","\"","","\"",")")
fprintf(fp,"\t%s",formula)

) ;; if

;;;;;;;;

) ;; if

pin_col_found="no"

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="LAYER"

;; =VLOOKUP(Q76,length_qa!$V:$AC,2,0)

if(net_col_found=="yes"
then

col_num_index=net_col_num-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)

sprintf(row_num_current_str "%L" row_num_current+row_offset_adjust)
cell=strcat(cell_alpha,row_num_current_str)
formula=strcat("=iferror(VLOOKUP(",cell,comma,"length_qa!$K:$L,2,0),","\"","","\"",")")
fprintf(fp,"\t%s",formula)
;; =iferror(VLOOKUP(T3,length_qa!$K:$L,2,0),\-\")"
;; =IFERROR(VLOOKUP(T4,length_qa!$K:$L,2,0),"-")
else
fprintf(fp,"\t")

) ;; if

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="LENGTH"

;; =VLOOKUP(S76,cmp_pin_rpt!$L:$P,3,0)

net_length_col_num=col_num_output+index
l_net_length_col_num_sum=append1(l_net_length_col_num_sum,net_length_col_num)
l_net_length_col_num_total=append1(l_net_length_col_num_total,net_length_col_num)

if(net_col_found=="yes"
then

col_num_index=net_col_num-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)

sprintf(row_num_current_str "%L" row_num_current+row_offset_adjust)
cell=strcat(cell_alpha,row_num_current_str)
formula=strcat("=iferror(VLOOKUP(",cell,comma,"length_qa!$A:$E,3,0),0)")
fprintf(fp,"\t%s",formula)

else
fprintf(fp,"\t0")

) ;; if

net_col_found="no"

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="SKEW"

;; =ABS(U76-U77)

skew_col_num=col_num_output+index

col_num_index=net_length_col_num-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)


row_num_next=row_num_current+1+row_offset_adjust
row_num_previous=row_num_current-1+row_offset_adjust

sprintf(row_num_current_str "%L" row_num_current+row_offset_adjust)
sprintf(row_num_next_str "%L" row_num_next)
sprintf(row_num_previous_str "%L" row_num_previous)

cell_current=strcat(cell_alpha,row_num_current_str)
cell_next=strcat(cell_alpha,row_num_next_str)
cell_previous=strcat(cell_alpha,row_num_previous_str)

printf("\n",oddp(index))

if(oddp(line_count)==t
then
formula=strcat("=ABS(",cell_current,"-",cell_next,")")
else
;;formula=strcat("=ABS(",cell_current,"-",cell_previous,")")
formula=""
) ;; if


fprintf(fp,"\t%L",formula)

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="SUM LENGTH"

;; =F76+K76

net_length_col_num=col_num_output+index

counter=0

foreach(col_num,l_net_length_col_num_sum

counter++
col_num_index=col_num-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)
row_num_next=row_num_current+1


sprintf(row_num_current_str "%L" row_num_current+row_offset_adjust)
cell=strcat(cell_alpha,row_num_current_str)

if(counter==1
then
formula=strcat("=",cell)
else
formula=strcat(formula,"+",cell)
) ;; if

) ;; l_net_length_col_num_sum

fprintf(fp,"\t%L",formula)

l_net_length_col_num_sum=nil

) ;; when


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="TOTAL LENGTH"

;; =F76+K76

net_length_col_num=col_num_output+index

counter=0

foreach(col_num,l_net_length_col_num_total

counter++
col_num_index=col_num-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)
row_num_next=row_num_current+1


sprintf(row_num_current_str "%L" row_num_current+row_offset_adjust)
cell=strcat(cell_alpha,row_num_current_str)

if(counter==1
then
formula=strcat("=",cell)
else
formula=strcat(formula,"+",cell)
) ;; if

) ;; l_net_length_col_num_total

fprintf(fp,"\t%L",formula)

l_net_length_col_num_sum=nil

) ;; when

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(header_input=="POGO"

pogo_index=0

;;;;;;;;;;;;;;;;;;;

foreach(netlist_l,l_netlist
when(net_name==cadr(netlist_l)

l_nodes=nth(2,netlist_l)

count_temp=1

foreach(node,l_nodes
count_temp++
refdes=car(parseString(node,"."))
when(member(refdes,l_pogos_93k_std)
pogo_index=count_temp
) ;; when
) ;; l_nodes
) ;; when

) ;; l_netlist

sprintf(pogo_index_str "%L" pogo_index)

;;;;;;;;;;;;;;;;;;;

col_num_index=net_col_num-1
column_info_l=nth(col_num_index,l_column_info_excel)
cell_alpha=cadr(column_info_l)

sprintf(row_num_current_str "%L" row_num_current+row_offset_adjust)
cell=strcat(cell_alpha,row_num_current_str)

;; =MID(VLOOKUP(AD2,netlist!$A:$XFC,2,0),2,3)&IF(LEN(RIGHT(VLOOKUP(AD2,netlist!$A:$XFC,2,0),LEN(VLOOKUP(AD2,netlist!$A:$XFC,2,0))-5))=1,"0"&RIGHT(VLOOKUP(AD2,netlist!$A:$XFC,2,0),LEN(VLOOKUP(AD2,netlist!$A:$XFC,2,0))-5),RIGHT(VLOOKUP(AD2,netlist!$A:$XFC,2,0),LEN(VLOOKUP(AD2,netlist!$A:$XFC,2,0))-5))

formula_temp=strcat("VLOOKUP(",cell,comma,"netlist!$A:$XFC,",pogo_index_str,",0)")

formula=strcat("=iferror(MID(",formula_temp,",2,3)&IF(LEN(RIGHT(",formula_temp,",LEN(",formula_temp,")-5))=1,\"0\"&RIGHT(",formula_temp,",LEN(",formula_temp,")-5),RIGHT(",formula_temp,",LEN(",formula_temp,")-5)),\"\")")


fprintf(fp,"\t%s",formula)


) ;; when POGO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; fprintf(fp,"\t")


col_num_current++



) ;; l_headers_input


) ;; if count

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

) ;; data_input_all_l



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fp,"\n\n")

;; =MAX(AB76:AB99)

foreach(max_min_skew_l,l_max_min_skew

index=car(max_min_skew_l)
cell_alpha=cadr(max_min_skew_l)

iteration=index
iteration--

for( i 0 iteration
fprintf(fp,"\t")
) ;; for

sprintf(row_num_start_str "%L" row_num_start+row_offset_adjust)

cell_1=strcat(cell_alpha,row_num_start_str)
cell_2=strcat(cell_alpha,row_num_current_str)

formula=strcat("=MAX(",cell_1,":",cell_2,")")

fprintf(fp,"%s",formula)

) ;; l_max_min_skew

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fp,"\n")

;; =MIN(AB76:AB99)

foreach(max_min_skew_l,l_max_min_skew

index=car(max_min_skew_l)
cell_alpha=cadr(max_min_skew_l)

iteration=index
iteration--

for( i 0 iteration
fprintf(fp,"\t")
) ;; for

sprintf(row_num_start_str "%L" row_num_start+row_offset_adjust)

cell_1=strcat(cell_alpha,row_num_start_str)
cell_2=strcat(cell_alpha,row_num_current_str)

formula=strcat("=MIN(",cell_1,":",cell_2,")")

fprintf(fp,"%s",formula)

) ;; l_max_min_skew


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fp,"\n")

;; =AB101-AB102

foreach(max_min_skew_l,l_max_min_skew

index=car(max_min_skew_l)
cell_alpha=cadr(max_min_skew_l)

iteration=index
iteration--

for( i 0 iteration
fprintf(fp,"\t")
) ;; for

row_num_skew_max=row_num_current+2
row_num_skew_min=row_num_current+3

sprintf(row_num_skew_max_str "%L" row_num_skew_max+row_offset_adjust)
sprintf(row_num_skew_min_str "%L" row_num_skew_min+row_offset_adjust)

cell_1=strcat(cell_alpha,row_num_skew_max_str)
cell_2=strcat(cell_alpha,row_num_skew_min_str)

formula=strcat("=",cell_1,"-",cell_2)

fprintf(fp,"%s",formula)

) ;; l_max_min_skew



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

row_offset_adjust=4






) ;; l_data_all_input


close(fp)

axlUIViewFileCreate("data_out.txt" "data_out" nil)















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlUIWPrint(fform,"Done")


) ;; run

) ;; case

) ;; extract_length_report_action





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun get_pin_from_pin_db ()

pin_name="-"
foreach(function pin_db->functionPins 
when(function->objType=="functionPin" pin_name=function->name)
)

if(pin_db->number==nil then pin_num="-" else pin_num=pin_db->number)

if(pin_db->component->name==nil 
then 

if( (pin_db->symbolEtch=="" || pin_db->symbolEtch==nil) 
then 
refdes="-" 
else 
refdes=pin_db->symbolEtch->refdes
)

else refdes=pin_db->component->name
)

pin=strcat(refdes,".",pin_num)
net=pin_db->net->name

) ;; function


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Making Form ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun form_function ()

fform=outfile("extract_length_report_form.form" "w")

fprintf(fform,"FILE_TYPE=FORM_DEFN VERSION=2\n")   
fprintf(fform,"FORM\n")
fprintf(fform,"FIXED\n")
fprintf(fform,"PORT 26 14\n")
fprintf(fform,"HEADER \"(R&D-Altanova)\"\n")
fprintf(fform,"TILE\n")

fprintf(fform,"TEXT \"Excel Cell Input :\"\n")
fprintf(fform,"TLOC 3 2\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD cell_input\n")
fprintf(fform,"FLOC 16 2\n")
fprintf(fform,"STRFILLIN 5 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"TEXT \"Excel Cell Output :\"\n")
fprintf(fform,"TLOC 3 4\n")
fprintf(fform,"ENDTEXT\n")

fprintf(fform,"FIELD cell_output\n")
fprintf(fform,"FLOC 16 4\n")
fprintf(fform,"STRFILLIN 5 6\n")
fprintf(fform,"ENDFIELD\n")

fprintf(fform,"FIELD read_indirect_tc\n")
fprintf(fform,"FLOC 3 7\n")
fprintf(fform,"CHECKLIST \"Read indirect TC from excel\"\n")
fprintf(fform,"ENDFIELD\n")



fprintf(fform,"FIELD file_input\n")
fprintf(fform,"FLOC 4 10\n")
fprintf(fform,"MENUBUTTON \"Browse\" 10 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"TEXT \"(*.txt)\"\n")
fprintf(fform,"TLOC 15 10\n")
fprintf(fform,"ENDTEXT\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"FIELD run\n")
fprintf(fform,"FLOC 6 14\n")
fprintf(fform,"MENUBUTTON \"Run\" 15 3\n")
fprintf(fform,"ENDFIELD\n")


fprintf(fform,"FIELD close1\n")
fprintf(fform,"FLOC 6 16\n")
fprintf(fform,"MENUBUTTON \"Close\" 15 3\n")
fprintf(fform,"ENDFIELD\n")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fform,"ENDTILE\n")
fprintf(fform,"ENDFORM\n")

close(fform)

) ;; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun func_get_cell_alpha_num ()

str_length=strlen(excel_cell_input)

cell_alpha=""
cell_num=""

for( i 1 str_length

string=substring(excel_cell_input,i,1)

if(atoi(string)==nil
then
cell_alpha=strcat(cell_alpha,string)
else
cell_num=strcat(cell_num,string)
)

) ;; for

) ;; func_get_cell_alpha_num





