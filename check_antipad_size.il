axlClearSelSet()
axlWindowFit()

axlVisibleDesign(nil)
axlVisibleLayer("BOARD GEOMETRY/OUTLINE" t)
axlVisibleLayer("PIN/TOP" t)
axlVisibleLayer("VIA CLASS/TOP" t)
axlVisibleLayer("PIN/BOTTOM" t)
axlVisibleLayer("VIA CLASS/BOTTOM" t)

axlVisibleUpdate(nil)

axlSetFindFilter(?enabled '("NOALL" "VIAS" "PINS"), ?onButtons '("NOALL" "VIAS" "PINS"))

axlAddSelectAll()

;;axlFlushDisplay()

l_db_brd=axlGetSelSet()

l_pv_db_brd=nil
l_padstack_brd=nil

foreach(db,l_db_brd

when(db->definition->drillDiameter>0
l_pv_db_brd=cons(db,l_pv_db_brd)
l_padstack_brd=cons(db->name,l_padstack_brd)

)
) ;; l_db_brd


l_padstack_unique_brd=unique(l_padstack_brd)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; check drill size vs antipad

l_padstack_error=nil
l_padstack_error_unique=nil

foreach(padstack,l_padstack_unique_brd

count=0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

foreach(pv_db,l_pv_db_brd
when(pv_db->name==padstack && count==0
count=1

drill=pv_db->definition->drillDiameter
drillSizeWidth=pv_db->definition->drillSizeWidth
drillSizeHeight=pv_db->definition->drillSizeHeight

when(drillSizeWidth==drillSizeHeight
drillSizeWidth=drill
drillSizeHeight=drill
)

drillSizeWidth_needed=drillSizeWidth+30
drillSizeHeight_needed=drillSizeHeight+30


l_pads=pv_db->definition->pads

foreach(pad l_pads

ll=car(pad->bBox)
ur=cadr(pad->bBox)
x1=car(ll)
y1=cadr(ll)
x2=car(ur)
y2=cadr(ur)
width=x2-x1
height=y2-y1

figureSize=list(width height)

layer=cadr(parseString(pad->layer "/"))

when(pad->type=="ANTI"

;;printf("\n%L\t%L\t%L",drill_size_needed,width,height)

when(width<drillSizeWidth_needed

diff=drillSizeWidth_needed-width
item=list(padstack,layer,diff,pv_db->xy)
l_padstack_error=cons(item,l_padstack_error)
l_padstack_error_unique=cons(padstack,l_padstack_error_unique)

)

when(height<drillSizeHeight_needed

diff=drillSizeHeight_needed-height
item=list(padstack,layer,diff,pv_db->xy)
l_padstack_error=cons(item,l_padstack_error)
l_padstack_error_unique=cons(padstack,l_padstack_error_unique)
)

) ;; when

) ;; l_pads

) ;; when
) ;; inner for
) ;; outer for

;;;; check drill size vs antipad

l_padstack_error_unique=unique(l_padstack_error_unique)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


fp=outfile("check_antipad_size.txt" "w")
fprintf(fp,"%s",axlCurrentDesign())

fprintf(fp,"\nPadstack\tLayer\tDifference")

foreach(error,l_padstack_error
fprintf(fp,"\n%s\t%s\t%L\t%L",car(error),cadr(error),nth(3,error),nth(2,error))
) ;; l_errors


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fprintf(fp,"\n\n------------Unique Padstack------------\n")

foreach(padstack,l_padstack_error_unique
fprintf(fp,"\n%s",padstack)
) ;; l_errors


fprintf(fp,"\n\n--------------------------------------------\n")

fprintf(fp,"\n\nTotal Errors : %L",length(l_padstack_error))

close(fp)

axlUIViewFileCreate("check_antipad_size.txt" "check_antipad_size" nil)


axlClearSelSet()
