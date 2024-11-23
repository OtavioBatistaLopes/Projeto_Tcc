function player_state_free(){
	var key_left = keyboard_check(vk_left);
	var key_right = keyboard_check(vk_right);
	var key_jump = keyboard_check_pressed(vk_up);
	var key_jump_down = keyboard_check(vk_up);
	var key_dash = keyboard_check_pressed(ord("Z"));
	var ground = place_meeting(x,y+1,obj_wall);
	var wall = place_meeting(x + 1,y,obj_wall) or place_meeting(x - 1,y,obj_wall);
	var move = key_right - key_left != 0;

	if(move){
		sprite_index = spr_player_run;
		move_dir = point_direction(0,0,key_right - key_left,0);
		move_spd = approach(move_spd,move_spd_max,acc);	
		if (!audio_is_playing(sn_passos) and (move) and (ground)) {
			alarm [1] = 15;	
			walking = audio_play_sound(sn_passos, 1, false);  
			}	
	}else{
		sprite_index = spr_player_idle;
		move_spd = approach(move_spd,0,dcc);	
	}

	can_move = approach(can_move,0,.5);
	if(can_move <= 0) hspd = lengthdir_x(move_spd,move_dir);

	if(hspd != 0){
		x_scale = sign(hspd);
	}
	

	if(ground){
		jump = false;
		jump_count = jump_max;
		coyote_time = coyote_time_max;	
	}else{
		coyote_time--;
		if(vspd < 0){
			sprite_index = spr_player_jump;	
		}else if(vspd > 0){
			sprite_index = spr_player_fall;
		}
	}
	
	//Limitando a altura do nosso pulo
	if(!key_jump_down and vspd < 0 and jump){
		
		//limitando a velocidade vertical
		vspd = max(vspd,-jump_height / 2.3);
	}

	if(key_jump and coyote_time > 0 || key_jump and jump_count > 0){
		audio_play_sound(sn_pulo, 1, false);
		jump_count--;
		coyote_time = 0;
		vspd = 0;
		vspd-=jump_height;
		jump = true;
	}	
	
	if(wall and !ground){
		if(vspd > 1){
			jump_count = jump_max;
			sprite_index = spr_player_wall;
			vspd = 1;	
		}
		if(key_jump){
			coyote_time = 0;
			vspd = 0;
			vspd-=jump_height;
			can_move = 5;
			hspd-=2 * x_scale;
		}
	}
	
	if(key_dash and dash){
		hspd = 0;
		vspd = 0
		dash_time = 0;
		dash = false;
		audio_play_sound(sn_dash, 1, false);
		alarm[0] = dash_delay;
		state = player_state_dash;
	}
	


	//Colidindo com o inimigo
	if(!ground and vspd > 0){
		var collision_e = instance_place(x,y+1,obj_enemy_parent);
		if(collision_e){
			vspd = 0;
			vspd-=jump_height;
			jump = false;
			instance_destroy(collision_e.id)
		}
	}
	
	//Tomando dano do inimigo
	var enemy = instance_place(x+hspd,y,obj_enemy_01);
	
	if(enemy){
		hspd = 0;
		vspd-= 5;
		damage_dir = point_direction(enemy.x,enemy.y,x,y);
		life-=1;
		state = player_state_damage;
		audio_play_sound(sn_dano, 1, false); 
	}
	
	//Tomando dano do fogo
	var fire = instance_place(x+hspd,y,obj_fire_box);
	
	if(fire){
		hspd = 0;
		vspd-=15;
		damage_dir = point_direction(fire.x,fire.y,x,y);
		life-=1;
		state = player_state_damage;
		audio_play_sound(sn_dano, 1, false); 
	}
	
	//Tomando dano do espinho
	var spyke = instance_place(x+hspd,y,obj_spykes);
	
	if(spyke){
		hspd =0;
		vspd-=15;
		damage_dir = point_direction(spyke.x,spyke.y,x,y);
		life-=1;
		state = player_state_damage;
		audio_play_sound(sn_dano, 1, false); 
	}


	
}

	

function player_state_dash(){
	//Estado de dash
	hspd = lengthdir_x(dash_force,move_dir);
	dash_time = approach(dash_time,dash_distance,1);
	if(dash_time >= dash_distance){
		state = player_state_free;
	}
}


function player_state_damage(){
	hspd = lengthdir_x(damage_recoil,damage_dir);
	
	damage_time = approach(damage_time,damage_distance,1);
	
	if(damage_time >= damage_distance){
		damage_time = 0;
		hspd = 0;
		state = player_state_free;
	}
}









