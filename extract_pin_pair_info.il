;; load "extract_pin_pair_info.il"


file=axlCurrentDesign() ;getting the current design name
filewithext=strncat( file ".brd" 4)
start_time=getCurrentTime()
axlClearSelSet()
axlSetFindFilter(?enabled '("noall" "VIAS" "PINS" "SYMBOLS" "NETS") ?onButtons '("noall" "VIAS" "PINS" "SYMBOLS" "NETS"))
axlSelect(?prompt "\nSelect Highlight item from the layout")
l_data_highlighted=axlGetSelSet()

axlClearSelSet()
l_temp_via=nil
l_temp_pin=nil
l_temp_symbol=nil
l_temp_net=nil
l_symbol=nil
l_net=nil
l_via=nil
l_pin=nil


foreach(item l_data_highlighted

when(item->objType=="via" 
l_temp_via=cons(item l_temp_via)
)


when(item->objType=="pin" 
l_temp_pin=cons(item l_temp_pin)
)

when(item->objType=="symbol" 
l_temp_symbol=cons(item l_temp_symbol)
)

when(item->objType=="net" 
l_temp_net=cons(item l_temp_net)
)


)
