
axlCmdRegister("check_bga_pin_locations" 'check_bga_pin_locations)

(defun check_bga_pin_locations ()

start_time=getCurrentTime()
tool_run="no"
time=parseString(start_time " ")
time=parseString(nth(2 time) ":")
time_combined=strcat(car(time) cadr(time) nth(2 time))

fp=infile("C:/cadence_skill_files/skill_files/bga_pins_input.txt")

l_bga_pins_input=nil

if(fp==nil
then

axlUIConfirm("File is missing C:/cadence_skill_files/skill_files/bga_pins_input.txt")

exit()

else

axlClearSelSet()

func_delete()

axlVisibleDesign(nil)
axlVisibleLayer("BOARD GEOMETRY/OUTLINE" t)
axlLayerCreateNonConductor("BOARD GEOMETRY/SKILL_LAYER")
axlVisibleLayer("BOARD GEOMETRY/SKILL_LAYER" t)
axlVisibleLayer("PIN/TOP" t)
axlVisibleUpdate(nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pitch_input_x=axlEnterString(?prompts "Enter socket pitch_x (mm)...")
pitch_input_y=axlEnterString(?prompts "Enter socket pitch_y (mm)...")

pitch_input_x=atof(pitch_input_x)
pitch_input_y=atof(pitch_input_y)


l_design_unit=axlDBGetDesignUnits()
design_unit=car(l_design_unit)

if(design_unit=="mils"
then
pitch_input_x=pitch_input_x*39.3700787402
pitch_input_y=pitch_input_y*39.3700787402

else
if(design_unit=="inches"
then
pitch_input_x=pitch_input_x*0.0393700787
pitch_input_y=pitch_input_y*0.0393700787

else
if(design_unit=="microns"
then
pitch_input_x=pitch_input_x*1000
pitch_input_y=pitch_input_y*1000

else
if(design_unit=="centimeters"
then
pitch_input_x=pitch_input_x*1000
pitch_input_y=pitch_input_y*1000

)))) ;; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;; reading bga_pins_input

first_time="yes"
l_bga_pins_input=nil
l_bga_pins_ref=nil

while(gets(line,fp)

l_line=parseString(line,"\n")
line=car(l_line)
l_string=parseString(line,"\t")

when(line!=nil && l_string!=nil
l_bga_pins_input=append1(l_bga_pins_input,l_string)

when(first_time=="yes"
l_bga_pins_ref=l_string
)

) ;; when

first_time="no"

) ;; while

close(fp)

;;;;;;;;;; reading bga_pins_input


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlUIConfirm("Select socket pins on top layer from the BRD")

axlClearSelSet()
axlSetFindFilter(?enabled '("noall" "PINS") ?onButtons '("noall" "PINS"))

axlSelect()

l_pins_db = axlGetSelSet()

l_pin_num_xy=nil
l_pin_num_xy_ref=nil
l_pin_num_x_ref=nil
l_pin_num_y_ref=nil
l_pin_num_only=nil

foreach(pin_db,l_pins_db

pin_xy=pin_db->xy
pin_net=pin_db->net->name
net_db=pin_db->net

if(pin_db->component->name==nil name="-" name=pin_db->component->name)
if(pin_db->number==nil number="-" number=pin_db->number)
if(pin_db->net->name==nil net="-" net=pin_db->net->name)

pin_name="-"

foreach(function pin_db->functionPins 
when(function->objType=="functionPin" pin_name=function->name)
)

pin=strcat(name,".",number)

l_temp=list(name,number,pin,pin_xy)
l_pin_num_xy=cons(l_temp,l_pin_num_xy)

l_pin_num_only=cons(number,l_pin_num_only)

pin_x=xCoord(pin_xy)
pin_y=yCoord(pin_xy)

when(member(number,l_bga_pins_ref)!=nil
l_pin_num_xy_ref=cons(l_temp,l_pin_num_xy_ref)

l_temp=list(pin_x,pin_y,number)
l_pin_num_x_ref=cons(l_temp,l_pin_num_x_ref)

l_temp=list(pin_y,pin_x,number)
l_pin_num_y_ref=cons(l_temp,l_pin_num_y_ref)

)

) ;; l_pins_db


l_pin_num_x_ref=sortcar(l_pin_num_x_ref,'lessp)
l_pin_num_y_ref=sortcar(l_pin_num_y_ref,'lessp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; find pitch

l_pin_num_xy_temp=l_pin_num_xy
dist_min=999
bga_array=nil


foreach(pin_num,l_pin_num_xy

pin_xy=nth(3,pin_num)
pin_x=xCoord(pin_xy)
pin_y=yCoord(pin_xy)

foreach(pin_info_temp,l_pin_num_xy_temp
when(pin_num!=pin_info_temp

pin_xy_temp=nth(3,pin_info_temp)
pin_x_temp=xCoord(pin_xy_temp)
pin_y_temp=yCoord(pin_xy_temp)

dist=axlDistance(pin_xy,pin_xy_temp)

when(dist_min>dist

dist_min=dist
dist_x=abs(pin_x-pin_x_temp)
dist_y=abs(pin_y-pin_y_temp)

if( (abs(pin_x-pin_x_temp)<=0.01 && abs(pin_y-pin_y_temp)>0.01) || (abs(pin_x-pin_x_temp)>0.01 && abs(pin_y-pin_y_temp)<=0.01)
then
bga_array="straight"

else
if(abs(pin_x-pin_x_temp)>0.01 && abs(pin_y-pin_y_temp)>0.01
then
bga_array="diagonal"

)) ;; if

) ;; when

) ;; when
) ;; l_pin_num_xy_temp

) ;; l_pin_num_xy


pitch=dist_min
pitch_x=dist_x
pitch_y=dist_y
pitch_diagonal=sqrt( (pitch*pitch)+(pitch*pitch) )

angle_radian=axlDegToRad(45.0)

pitch_dx=pitch_input_x*cos(angle_radian)
pitch_dy=pitch_input_x*sin(angle_radian)

if(bga_array=="straight"
then
pitch_factor_x=pitch_input_x
row_factor_x=pitch_input_x

pitch_factor_y=pitch_input_y
row_factor_y=pitch_input_y

else
if(bga_array=="diagonal"
then
pitch_factor_x=pitch_dx*2
row_factor_x=pitch_dx

pitch_factor_y=pitch_dy*2
row_factor_y=pitch_dy

))

;;; find pitch

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; extract bga pins from input which exist on BRD

l_bga_pins_input_brd=nil

foreach(bga_pins_input_l,l_bga_pins_input

l_pins=nil
foreach(bga_pin_input,bga_pins_input_l
when(member(bga_pin_input,l_pin_num_only)!=nil
l_pins=append1(l_pins,bga_pin_input)
) ;; when
) ;; bga_pins_input_l

l_bga_pins_input_brd=append1(l_bga_pins_input_brd,l_pins)

) ;; l_bga_pins_input

;;; extract bga pins from input which exist on BRD


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; find reference point & direction

pin_num_x_ref_first=car(l_pin_num_x_ref)
pin_num_x_ref_last=car(last(l_pin_num_x_ref))

pin_num_y_ref_first=car(l_pin_num_y_ref)
pin_num_y_ref_last=car(last(l_pin_num_y_ref))

pin_ref=nil
dir_ref=nil

pitch_polarity=nil
row_col_polarity=nil

if(abs(car(pin_num_x_ref_first)-car(pin_num_x_ref_last))>0.01 ;; horizontal
then

pin1=nth(2,pin_num_x_ref_first)
pin2=nth(2,pin_num_x_ref_last)
dir_ref="horizontal"

num1=""

for(i 1 strlen(pin1)
char=substring(pin1,i,1)

when(atoi(char)!=nil
num1=strcat(num1,char)
)
) ;; for

;;;;;;;;;;;;;;;;;

num2=""

for(i 1 strlen(pin2)
char=substring(pin2,i,1)

when(atoi(char)!=nil
num2=strcat(num2,char)
)
) ;; for

num1=atoi(num1)
num2=atoi(num2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if(num1<num2
then
pin_ref=pin1
pitch_polarity=1
row_col_polarity=-1

diff=num1-1

when(bga_array=="diagonal"
diff=diff/2
)

ref_x=car(pin_num_x_ref_first)
ref_y=cadr(pin_num_x_ref_first)
pin_a1_xy_ref=ref_x-pitch_factor_x*diff:ref_y

;;;;;

else

pin_ref=pin2
pitch_polarity=-1
row_col_polarity=1
diff=num2-1

when(bga_array=="diagonal"
diff=diff/2
)

ref_x=car(pin_num_x_ref_last)
ref_y=cadr(pin_num_x_ref_last)
pin_a1_xy_ref=ref_x+pitch_factor_x*diff:ref_y

) ;; num1 / num2

;;;;;;;;;;;;;;;;;;;;;;;;;;

else
if(abs(car(pin_num_y_ref_first)-car(pin_num_y_ref_last))>0.01 ;; vertical
then

pin1=nth(2,pin_num_y_ref_first)
pin2=nth(2,pin_num_y_ref_last)
dir_ref="vertical"

num1=""

for(i 1 strlen(pin1)
char=substring(pin1,i,1)

when(atoi(char)!=nil
num1=strcat(num1,char)
)
) ;; for

;;;;;;;;;;;;;;;;;

num2=""

for(i 1 strlen(pin2)
char=substring(pin2,i,1)

when(atoi(char)!=nil
num2=strcat(num2,char)
)
) ;; for

num1=atoi(num1)
num2=atoi(num2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if(num1<num2
then
pin_ref=pin1
pitch_polarity=1
row_col_polarity=1

diff=num1-1

when(bga_array=="diagonal"
diff=diff/2
)

ref_y=car(pin_num_y_ref_first)
ref_x=cadr(pin_num_y_ref_first)
pin_a1_xy_ref=ref_x:ref_y-pitch_factor_y*diff

;;;;;

else

pin_ref=pin2
pitch_polarity=-1
row_col_polarity=-1

diff=num2-1

when(bga_array=="diagonal"
diff=diff/2
)

ref_y=car(pin_num_y_ref_last)
ref_x=cadr(pin_num_y_ref_last)
pin_a1_xy_ref=ref_x:ref_y+pitch_factor_y*diff

) ;; num1 / num2

)) ;; if horizontal/vertical


l_location=list(pin_a1_xy_ref,15)
l_db=axlDBCreateCircle(l_location,'1,"BOARD GEOMETRY/SKILL_LAYER")

point1=xCoord(pin_a1_xy_ref):yCoord(pin_a1_xy_ref)+15
point2=xCoord(pin_a1_xy_ref):yCoord(pin_a1_xy_ref)-15
l_points=list(point1,point2)

axlDBCreateLine(l_points, 1, "BOARD GEOMETRY/SKILL_LAYER")

point1=xCoord(pin_a1_xy_ref)+15:yCoord(pin_a1_xy_ref)
point2=xCoord(pin_a1_xy_ref)-15:yCoord(pin_a1_xy_ref)
l_points=list(point1,point2)

axlDBCreateLine(l_points, 1, "BOARD GEOMETRY/SKILL_LAYER")



;;; find reference point & direction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


row=-1
l_pins_xy_std=nil
pin_a1_xy_basic=pin_a1_xy_ref
proceed="yes"

foreach(bga_pins_input_l,l_bga_pins_input

count=-1
item_count=0
row++

foreach(bga_pins_input,bga_pins_input_l

item_count++

pin_num=""
pin_alpha=""

bga_pins_input_l_chk=bga_pins_input_l

for(i 1 strlen(bga_pins_input)
char=substring(bga_pins_input,i,1)

if(atoi(char)==nil
then
pin_alpha=strcat(pin_alpha,char)
else
pin_num=strcat(pin_num,char)
) ;; if

) ;; for

pin_num=atoi(pin_num)


when(bga_array=="diagonal"

proceed="no"

if(evenp(row)==t && oddp(pin_num)==t
then
proceed="yes"

else
if(oddp(row)==t && evenp(pin_num)==t
then
proceed="yes"

)) ;; if

) ;; when


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(proceed=="yes"


count++

if(dir_ref=="horizontal"
then

pitch_offset=pitch_factor_x*count
pitch_offset=pitch_offset*pitch_polarity

;;row_col_offset=row_factor_x*row
;;row_col_offset=row_col_offset*row_col_polarity

row_col_offset=row_factor_y*row
row_col_offset=row_col_offset*row_col_polarity


pin_x_std=xCoord(pin_a1_xy_basic)+pitch_offset
pin_y_std=yCoord(pin_a1_xy_basic)+row_col_offset

pin_xy_std=pin_x_std:pin_y_std

else
if(dir_ref=="vertical"
then

;;pitch_offset=pitch_factor_x*count

pitch_offset=pitch_factor_y*count

when(oddp(row)==t && bga_array=="diagonal"
pitch_offset=pitch_offset+pitch_x
)


pitch_offset=pitch_offset*pitch_polarity

row_col_offset=row_factor_x*row
row_col_offset=row_col_offset*row_col_polarity

pin_x_std=xCoord(pin_a1_xy_basic)+row_col_offset
pin_y_std=yCoord(pin_a1_xy_basic)+pitch_offset

pin_xy_std=pin_x_std:pin_y_std

)) ;; if

when(member(bga_pins_input,l_pin_num_only)!=nil


l_temp=list(bga_pins_input,pin_xy_std)
l_pins_xy_std=append1(l_pins_xy_std,l_temp)

l_location=list(pin_xy_std,10)
l_db=axlDBCreateCircle(l_location,'1,"BOARD GEOMETRY/SKILL_LAYER")

tool_run="yes"

;;printf("\n%s\t%L",bga_pins_input,count)
;;axlEnterPoint()

) ;; when


) ;; proceed

) ;; bga_pins_input_l


) ;; l_bga_pins_input


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_errors=nil
count=0
offset_max=0

foreach(pin_num_xy,l_pin_num_xy

pin_brd=cadr(pin_num_xy)
pin_xy_brd=nth(3,pin_num_xy)

foreach(pin_num_std,l_pins_xy_std

pin_std=car(pin_num_std)
pin_xy_std=cadr(pin_num_std)

when(pin_brd==pin_std

count++
dist=axlDistance(pin_xy_brd,pin_xy_std)

when(dist>0.01

l_temp=list(pin_brd,pin_xy_brd,pin_xy_std,dist)
l_errors=append1(l_errors,l_temp)

when(offset_max<dist
offset_max=dist
) ;; when

) ;; when

) ;; when

) ;; l_pins_xy_std

) ;; l_pin_num_xy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fp=outfile("check_bga_pin_locations.txt" "w")

fprintf(fp,"%s.brd",axlCurrentDesign())
fprintf(fp,"\nPin\tPin_xy_(BRD)\tPin_xy_(STD)\tOffset")

foreach(error,l_errors

pin=car(error)
pin_xy_brd=cadr(error)
pin_xy_std=nth(2,error)
offset=nth(3,error)

fprintf(fp,"\n%s\t%L\t%L\t%L",pin,pin_xy_brd,pin_xy_std,offset)

) ;; l_pins_xy_std

fprintf(fp,"\n\n-----------------------------------------------------------------------")

fprintf(fp,"\nBGA pitch    : %L mils",pitch_input_x)
fprintf(fp,"\nBGA pattern  : %s",bga_array)
fprintf(fp,"\nPins Checked : %L",count)
fprintf(fp,"\nError Count  : %L",length(l_errors))
fprintf(fp,"\nOffset Max.  : %L",offset_max)

close(fp)


axlUIViewFileCreate("check_bga_pin_locations.txt" "check_bga_pin_locations" nil)

axlUIConfirm("Please verify bga pattern & pin count in the output report.")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fp=outfile("l_pins_xy_std.txt" "w")

fprintf(fp,"%s.brd",axlCurrentDesign())
fprintf(fp,"\nPin\t(X,Y)")

foreach(pin_std,l_pins_xy_std

pin=car(pin_std)
pin_xy=cadr(pin_std)

fprintf(fp,"\n%s\t%L",pin,pin_xy)

) ;; l_pins_xy_std

close(fp)

;;axlUIViewFileCreate("l_pins_xy_std.txt" "l_pins_xy_std" nil)


axlClearSelSet()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

) ;; main if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing tool info ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

when(tool_run=="yes"

login_name=getLogin()
end_time=getCurrentTime()
time_diff=compareTime(end_time,start_time)

sprintf(time_str "%L" time_diff)

tool_name="Check BGA Pin Locations$"
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


) ;; main function


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


