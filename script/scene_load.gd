extends Node

var currentnode
var scene_to_preload = preload("res://scene/Node2D.tscn")

var rand_indx = 0

var screen_transit_end = true

var audio_transit_end = true
var audio_transit_run = false


func random_indx(targ_range_min, targ_range_max):
	randomize()
	rand_indx = rand_range(targ_range_min, targ_range_max)
	rand_indx = round(rand_indx)
	rand_indx = int(rand_indx)
	return rand_indx


func move_node(target:Node, child: Node, indx:int):
	target.move_child(child, indx)


func reparent_node(parent: Node, child: Node):
	var old_parent = child.get_parent()
	if old_parent != null:
		old_parent.remove_child(child)
	parent.add_child(child)
	child.set_owner(parent)


func _ready():
	load_scene(scene_to_preload, 0)
	pass


func _process(_delta):
	pass

#main scene loading function
func load_scene(target, type):
	var _rootnode = get_tree().root.get_node("base")
	var node_to_add = target.instance()
	
#	if _ref != null:
#		_ref.queue_free()
#		_ref = null
	
	#print(node_to_add.name)
	if type == 0:
		#free prev, add child, record curr
		if currentnode != null:
			currentnode.queue_free()
			currentnode = null
		
		for i in get_tree().root.get_children():
			if node_to_add.name in i.name:
				i.queue_free()
		
		get_tree().root.call_deferred("add_child", node_to_add)
#		get_tree().root.call_deferred("move_child", rootnode, get_tree().root.get_child_count())
		currentnode = node_to_add
		return

#transition classes
func screen_transit_alpha(switch, target_modulate, col_low, col_hi, time):
	screen_transit_end = false
	
	if switch:
		while true:
			yield (get_tree().create_timer(time), "timeout")
			
			if target_modulate.modulate.is_equal_approx(col_low):
				target_modulate.modulate = col_low
				break
			
			target_modulate.modulate += Color(0, 0, 0, .1)
		
		screen_transit_end = true
		return 
		
	else :
		while true:
			yield (get_tree().create_timer(time), "timeout")
			
			if target_modulate.modulate.is_equal_approx(col_hi):
				target_modulate.modulate = col_hi
				break
			
			target_modulate.modulate -= Color(0, 0, 0, .1)
		
		screen_transit_end = true
		return 


func screen_transit_color(switch, type, target_tint, col_low, col_hi, col_a, time):
	screen_transit_end = false
	target_tint.color.a = 1
	
	if switch:
		match type:
			0:
				while true:
					yield(get_tree().create_timer(time), "timeout")
					
					if target_tint.color.is_equal_approx(col_low):
						target_tint.color = col_low
						break
					
					target_tint.color -= Color(.1, .1, .1, 0)
			1:
				while true:
					yield(get_tree().create_timer(time), "timeout")
					
					target_tint.color.r -= .1
					if target_tint.color.r <= 0:
						target_tint.color.g -= .1
						if target_tint.color.g <= 0:
							target_tint.color.b -= .1
							if target_tint.color.b <= 0:
								target_tint.color = col_low
								target_tint.color.a = col_a
								break
		
		target_tint.color.a = col_a
		
		screen_transit_end = true
		return
		
	else:
		match type:
			0:
				while true:
					yield(get_tree().create_timer(time), "timeout")
					
					if target_tint.color.is_equal_approx(col_hi):
						target_tint.color = col_hi
						break
					
					target_tint.color += Color(.1, .1, .1, 0)
			1:
				while true:
					yield(get_tree().create_timer(time), "timeout")
					
					target_tint.color.r += .1
					if target_tint.color.r >= 1:
						target_tint.color.g += .1
						if target_tint.color.g >= 1:
							target_tint.color.b += .1
							if target_tint.color.b >= 1:
								target_tint.color = col_hi
								break
		
		target_tint.color.a = col_a
		
		screen_transit_end = true
		return


func audio_transit(switch, fade_db, time, targ_audio):
	audio_transit_run = true
	audio_transit_end = false
	
	if switch:
		while true:
			yield(get_tree().create_timer(time), "timeout")
			
			if targ_audio.volume_db <= fade_db:
				targ_audio.volume_db = fade_db
				break
			
			targ_audio.volume_db -= 1
	else:
		while true:
			yield(get_tree().create_timer(time), "timeout")
			
			if targ_audio.volume_db >= fade_db:
				targ_audio.volume_db = fade_db
				break
			
			targ_audio.volume_db += 1
	
	audio_transit_run = false
	audio_transit_end = true
	
	return

