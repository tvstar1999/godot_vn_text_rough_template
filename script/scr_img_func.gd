extends Sprite

onready var rootnode = get_tree().root.get_node("base")
onready var thisnode = get_tree().root.get_node("Node2D")

onready var audio_A = rootnode.get_node("AUDIO_A")
onready var audio_B = rootnode.get_node("AUDIO_B")
onready var audio_C = rootnode.get_node("AUDIO_C")
onready var audio_D = rootnode.get_node("AUDIO_D")

export var run = true
export var type_mv = "none"

var inc = 0
var lim = 10

export var float_v:float = .2

export var scale_x:float = .002
export var scale_y:float = .002

export var shake_x:float = .5
export var shake_y:float = .5
export var shake_lim:float = 1

export var rotate_lim:float = 5
export var rotate_v:float = .2

var trigger = false

var left = false
var right = true


func _process(delta):
	if inc > lim:
		trigger = !trigger
		inc = 0
	else:
		inc += .1
	
	if run:
		match type_mv:
			"none":
				pass
			
			"shake":
				self.position.x += rand_range(-shake_x, shake_x)/delta 
				self.position.y += rand_range(-shake_y, shake_y)/delta 
				self.position.x = clamp(self.position.x, -shake_lim, shake_lim)
				self.position.y = clamp(self.position.y, -shake_lim, shake_lim)
			
			"scale":
				match trigger:
					true:
						self.scale += Vector2(scale_x, scale_y)
					false:
						self.scale -= Vector2(scale_x, scale_y)
			
			"float":
				match trigger:
					true:
						self.position += Vector2(0, float_v)
					false:
						self.position -= Vector2(0, float_v)
			
			"rotate":
				if left:
					if self.rotation <= -rotate_lim:
						right = true
						left = false
					else:
						self.rotation -= rotate_v
				if right:
					if self.rotation >= rotate_lim:
						right = false
						left = true
					else:
						self.rotation += rotate_v
	
	else:
		type_mv = "none"
		
		float_v = .2
		
		scale_x = .002
		scale_y = .002
		
		shake_x = .5
		shake_y = .5
		shake_lim = 1
		
		rotate_lim = 5
		rotate_v = .2

