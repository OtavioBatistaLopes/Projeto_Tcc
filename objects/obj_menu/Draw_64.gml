
var dist = 50;
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var x1= gui_width / 2;
var y1 = gui_height/2;

for(var i = 0 ; i < op_max ; i ++ ){
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	draw_text(x1, y1 + (dist * i),opcoes[i]);
	
	 if(index == i){
		draw_set_color(c_red);
	 }else{
		draw_set_color(c_black);
	 }
	 
}


draw_set_font(-1);