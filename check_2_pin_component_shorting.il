;; load "check_2_Pin_component_shorting.il"
axlCmdRegister("check_short_comp" 'check_short_comp)
(defun check_short_comp ()

axlClearSelSet()
fp=outfile("pins_short_rpt.txt" "w")
fprintf(fp,"%s\t%s\t%s\t%s\t%s\n","Refdes","Component Location","Pin-1 Net","Pin-2 Net","Comment")
fprintf(fp,"\n")

fp1=outfile("pins_no_short_rpt.txt" "w")
fprintf(fp1,"%s\t%s\t%s\t%s\t%s\n","Refdes","Component Location","Pin-1 Net","Pin-2 Net","Comment")
fprintf(fp1,"\n")


start_time=getCurrentTime()
count=0
count1=0

axlVisibleDesign(nil)
axlVisibleLayer("PIN/TOP", t)
axlVisibleLayer("PIN/BOTTOM", t)

axlSetFindFilter(?enabled '("NOALL" "COMPONENTS"), ?onButtons '("NOALL" "COMPONENTS"))
all_comp_db=axlGetSelSet(axlSingleSelectBox(axlDBGetDesign()->bBox))
foreach(comp_db all_comp_db
	comp_pins = comp_db->pins
	
	if(length(comp_pins) == 2 then
		comp_name = comp_db->name
		comp_loc = comp_db->symbol->xy
		comp_refdes = comp_db->symbol->refdes
		pin_nets = nil
		pin_locs = nil
		
		foreach(comp_pin comp_pins
			pin_loc = comp_pin->xy
			pin_net = comp_pin->net->name
			pin_nets = append1(pin_nets pin_net)
			pin_locs = append1(pin_locs pin_loc)
		)
		
		pin_net1 = car(pin_nets)
		pin_net2 = cadr(pin_nets)
		
		pin_loc1 = car(pin_locs)
		pin_loc2 = cadr(pin_locs)
		
		if(pin_net1 == pin_net2 then
			fprintf(fp,"%L\t%L\t%L %L\t%L %L\tShorting\n",comp_refdes,comp_loc,pin_net1,pin_loc1,pin_net2,pin_loc2)
			count++
		else
			fprintf(fp1,"%L\t%L\t%L %L\t%L %L\tNo Shorting\n",comp_refdes,comp_loc,pin_net1,pin_loc1,pin_net2,pin_loc2)
			count1++
		)
		
	)
	
)

printf("\nTotal Shorts: %L\n",count)

fprintf(fp,"\nTotal Shorts: %L",count)
close(fp)

fprintf(fp1,"\nTotal Components: %L",count1++)
close(fp1)


axlUIViewFileCreate("pins_short_rpt.txt" "pins_short_rpt.txt" nil)
axlUIViewFileCreate("pins_no_short_rpt.txt" "pins_no_short_rpt.txt" nil)

end_time=getCurrentTime()
time_diff=compareTime(end_time,start_time)
printf("Total Time: %L Seconds\n",time_diff)
axlClearSelSet()

) ;; check_short_comp

