;;check_refdes.il

axlClearSelSet()

file=axlCurrentDesign() ;getting the current design name

design_file_name=strncat(file ".brd" 4)




axlVisibleLayer("PIN/BOTTOM" t)
axlVisibleLayer("VIA CLASS/BOTTOM" t)

axlVisibleLayer("PIN/TOP" t)
axlVisibleLayer("VIA CLASS/TOP" t)
axlVisibleUpdate(t)


;;;;;;;;;;extracting components from brd;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

axlClearSelSet()
axlSetFindFilter(?enabled '("noall" "SYMBOLS") ?onButtons '("noall" "SYMBOLS"))
axlAddSelectAll()
l_symbol=axlGetSelSet()

;;;;;;;;;;extracting components from brd;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;;;;;;;;;;;;;;;;;;;;;;;;;;;Making list for components refdes and mirror/nonmirror;;;;;;;;;;;;;;;;;;
sym_refdes_mirror_list_top=nil
sym_refdes_mirror_list_bottom=nil
foreach(symbol l_symbol
axlDehighlightObject(symbol nil)
refdes=symbol->refdes
mirror=symbol->mirrorType
name=symbol->name
location=symbol->xy

if(mirror=="NO"
then
sym_refdes_mirror_top=list(name refdes mirror location symbol)
sym_refdes_mirror_list_top=append1(sym_refdes_mirror_list_top sym_refdes_mirror_top)
else
sym_refdes_mirror_bottom=list(name refdes mirror location symbol)
sym_refdes_mirror_list_bottom=append1(sym_refdes_mirror_list_bottom sym_refdes_mirror_bottom)
) ;if
) ;foreach l_symbol
;;;;;;;;;;;;;;;;;;;;;;;;;;;Making list for components refdes and mirror/nonmirror;;;;;;;;;;;;;;;;;;



temp1=sym_refdes_mirror_list_top
temp2=sym_refdes_mirror_list_bottom




;;;;;;;;;;;;;;;;;;;Taking text values from silk screen top;;;;;;;;;;;;;;;;;;;;;;;
axlVisibleDesign(nil)
axlClearSelSet()
axlVisibleLayer("REF DES/SILKSCREEN_TOP" t)
axlVisibleUpdate(t)


;;axlSetFindFilter(?enabled '("noall" "TEXT") ?onButtons '("noall" "TEXT"))
axlSetFindFilter(?enabled list("noall" "TEXT") ?onButtons list("noall" "TEXT"))
axlAddSelectAll()
l_text=axlGetSelSet()

text_name_top=nil

foreach(item l_text
text=item->text

text_name_top=append1(text_name_top text)
) ;foreach l_text
;;;;;;;;;;;;;;;;;;;Taking text values from silk screen top;;;;;;;;;;;;;;;;;;;;;;;








;;;;;;;;;;;;;;;;;;;;;;comparing text with each refdes of symbol;;;;;;;;;;;;;;;;;;;;;;;
foreach(symbol sym_refdes_mirror_list_top

foreach(text text_name_top

if(cadr(symbol)==text                                                ;;if text is found in assembly top
then
sym_refdes_mirror_list_top=remove(symbol sym_refdes_mirror_list_top)   ;; remove it from the symbol list
)
) ;foreach text_name
) ;foreach sym_refdes_mirror_list_top

;;;;;;;;;;;;;;;;;;;;;;comparing text with each refdes of symbol;;;;;;;;;;;;;;;;;;;;;;;

sym_refdes_mirror_list_top=sortcar(sym_refdes_mirror_list_top 'alphalessp)








;;;;;;list_text_not_there_top;;;;;;;;;;;
list_text_not_there_top=nil
if(length(sym_refdes_mirror_list_top)>0
then
foreach(item sym_refdes_mirror_list_top

list_text_not_there_top=append1(list_text_not_there_top item)
axlHighlightObject(nth(4 item) t)
) ;foreach sym_refdes_mirror_list_top
) ;if
;;;;;;list_text_not_there_top;;;;;;;;;;;









;;;;;;;;;;;;;;;;;;;Taking text values from silk screen bottom;;;;;;;;;;;;;;;;;;;;;;;
axlVisibleDesign(nil)

axlVisibleLayer("REF DES/SILKSCREEN_BOTTOM" t)
axlVisibleUpdate(t)


axlSetFindFilter(?enabled '("noall" "TEXT") ?onButtons '("noall" "TEXT"))
axlAddSelectAll()
l_text=axlGetSelSet()

text_name_bottom=nil

foreach(item l_text
text=item->text

text_name_bottom=append1(text_name_bottom text)
) ;foreach l_text
;;;;;;;;;;;;;;;;;;;Taking text values from silk screen bottom;;;;;;;;;;;;;;;;;;;;;;;











;;;;;;;;;;;;;;;;;;;;;;comparing text with each refdes of symbol;;;;;;;;;;;;;;;;;;;;;;;

foreach(symbol sym_refdes_mirror_list_bottom

foreach(text text_name_bottom

if(cadr(symbol)==text
then
sym_refdes_mirror_list_bottom=remove(symbol sym_refdes_mirror_list_bottom)
) ;if
) ;foreach text_name
) ;foreach sym_refdes_mirror_list_bottom
sym_refdes_mirror_list_bottom=sortcar(sym_refdes_mirror_list_bottom 'alphalessp)
;;;;;;;;;;;;;;;;;;;;;;comparing text with each refdes of symbol;;;;;;;;;;;;;;;;;;;;;;;













;;;;;;list_text_not_there;;;;;;;;;;;
list_text_not_there_bottom=nil
if(length(sym_refdes_mirror_list_bottom)>0
then
foreach(item sym_refdes_mirror_list_bottom

list_text_not_there_bottom=append1(list_text_not_there_bottom item)
axlHighlightObject(nth(4 item) t)

) ;foreach
) ;if

;;;;;;list_text_not_there;;;;;;;;;;;










;;;;;;;;;;;;;;;;;;;;;;;TOP FILE VIEW;;;;;;;;;;;;;;;;;
if(length(list_text_not_there_top)>0
then
fp_out=outfile("Remaining_Refdes_Top.txt" "w")
fprintf(fp_out,"%s\n",design_file_name)
fprintf(fp_out,"%s\t%s\t%s\n","Name","Refdes","Location")



foreach(item list_text_not_there_top
fprintf(fp_out,"\n%L\t%L\t%L",car(item),cadr(item),nth(3 item))

) ;foreachl_symbol

close(fp_out)
axlUIViewFileCreate("Remaining_Refdes_Top.txt" "Refdes List (TOP)" nil)

) ;if
;;;;;;;;;;;;;;;;;;;;;;;TOP FILE VIEW;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;BOTTOM FILE VIEW;;;;;;;;;;;;;;;;;
if(length(list_text_not_there_bottom)>0
then
fp_out2=outfile("Remaining_Refdes_Bottom.txt" "w")
fprintf(fp_out2,"%s\n",design_file_name)
fprintf(fp_out2,"%s\t%s\t%s\n","Name","Refdes","Location")



foreach(item list_text_not_there_bottom
fprintf(fp_out2,"\n%L\t%L\t%L",car(item),cadr(item),nth(3 item))

) ;foreachl_symbol

close(fp_out2)
axlUIViewFileCreate("Remaining_Refdes_Bottom.txt" "Refdes List (BOTTOM)" nil)

) ;if

;;;;;;;;;;;;;;;;;;;;;;;BOTTOM FILE VIEW;;;;;;;;;;;;;;;;;


axlVisibleLayer("PIN/BOTTOM" t)
axlVisibleLayer("VIA CLASS/BOTTOM" t)

axlVisibleLayer("PIN/TOP" t)
axlVisibleLayer("VIA CLASS/TOP" t)
axlVisibleUpdate(t)




axlVisibleLayer("REF DES/SILKSCREEN_TOP" nil)
axlVisibleLayer("REF DES/SILKSCREEN_BOTTOM" nil)
axlVisibleUpdate(t)




printf("\n--------------------------------------------------------------");
printf("\n\nProgrammed By...");
printf("\n\nAMAN ULLAH GHAZI,");
printf("\nSoftware Engineer R&D-Altanova,");
;printf("\nR&D-Altanova.");
;printf("\nEmail : ghaziaman.ullah@hotmail.com@hotmail.com\n\n");

