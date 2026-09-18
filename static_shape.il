;; load "static_shape1.il"

fp=infile("via_net_lyr_input.txt")

when(fp==nil
axlUIConfirm("File is missing via_net_lyr_input.txt")

fp=outfile("via_net_lyr_input.txt" "w")
close(fp)
)

axlSetFindFilter(?enabled '("NOALL" "VIAS"), ?onButtons '("NOALL" "VIAS"))
via_dbs = axlGetSelSet(axlSingleSelectBox())
axlClearSelSet()

while(gets(line,fp)
	l_line=parseString(line,"\n")
	line=car(l_line)
	when(line!=nil
		l_temp=parseString(line,"\t")
		lyr_name = car(l_temp)
		lyr_name=strcat("ETCH/" lyr_name)
		net_name = cadr(l_temp)
		diameter = caddr(l_temp)
		diameter = atof(diameter)
	)
	
	
	foreach(via_db via_dbs
	via_net = via_db->net->name
	via_outer_lyr = car(via_db->startEnd)
	if(via_net == net_name then
		;via_db_pad = axlDBGetPad(via_db via_outer_lyr "REGULAR")
		;via_db_figure = car(via_db_pad->figure)
		;via_db_poly = axlPolyFromDB(via_db_figure ?endCapType 'ROUND)
		;poly1 = (axlPolyExpand via_db_poly 7 'NONE)
		;poly1 = car(poly1)
		;axlDBCreateShape(poly1 t lyr_name net_name)
		
		x = car(via_db->xy)
		y = cadr(via_db->xy)
		radius = diameter/2
		
		path = axlPathStartCircle(list(x:y radius) 0) 
		shape_created = axlDBCreateShape(path, t, lyr_name)
		axlDBAssignNet(car(shape_created) net_name)
	
		;println(via_db->xy)
		;println(via_db->name)
	;	println(via_db)
		
		;axlEnterPoint()
	)
)

	
)


netname = "B_PCIE_TX0_N_SITE1"
netname = "B_MX0_TX0_N_SITE1"
		;; B_PCIE_TX7_N_SITE1

