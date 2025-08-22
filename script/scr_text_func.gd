extends Panel

onready var rootnode = get_tree().root.get_node("base")
onready var thisnode = get_tree().root.get_node("Node2D")

onready var audio_A = rootnode.get_node("AUDIO_A")
onready var audio_B = rootnode.get_node("AUDIO_B")
onready var audio_C = rootnode.get_node("AUDIO_C")
onready var audio_D = rootnode.get_node("AUDIO_D")

onready var LB_TEX_0 = get_node("SC_TEX/LB_TEX_0")
onready var BG = thisnode.get_node("background")

#auto scroll
var MAX_SCROLL = 0
var IS_SCROLL = true

#language switch
export var lang = "ENG"

#text type
export var TXT_OVERRIDE = false #debug
export var TEX_NUM = 999
var TXT_FILE = "res://text/text_999.txt"
var TXT_STR = ""

#sequence value
export var seq_0 = -1
export var seq_1 = 0

#main text printing
var inc0 = 0
var lim0 = .5 #set to .5

#text wait
var inc1 = 0
var lim1 = 14 #set to 20

#end condition wait
var inc2 = 0

#detection wait
var inc_i0 = 0
var lim_i0 = .2

#text file operation
var indx = 0

var read_tex = []
var tex = []

var didread = false
var didpush = false

#system bool
var is_running = false

var switch = false
var texinit = false
var haltinit = false


#text file functions
#func loadstr():
#	read_tex.clear()
#	tex.clear()
#
#	didread = false
#	var file = File.new()
#	file.open(TXT_FILE, File.READ)
#	for i in file.get_len():
#		read_tex.push_back(file.get_line())
#		if file.eof_reached():
#			break
#	file.close()
#
#	if read_tex.size() != 0:
#		didread = true
#	return read_tex
#
#
#func anlzarr():
#	didpush = false
#	for i in read_tex:
#		match i.substr(0,2):
#			"TX":
#				var push = i.rsplit("_",true, 1)
#				var A_indx = Array(push).find("TX")
#
#				push.remove(A_indx)
#				push[0] = push[0].replacen("*", "\n")
#
#				tex.push_back(push[0])
#
#	if tex.size() != 0:
#		didpush = true

#text file printing function
#func taktak():
#	#initial load
#	if texinit:
#		loadstr()
#		anlzarr()
#
#		inc1 = lim1
#		texinit = false
#
#	if inc1 > lim1:
#		#end condition
#		if !range(tex.size()).has(indx):
#			if inc2 > 2:
#				switch = false
#				indx = 0
#				inc1 = 0
#				inc2 = 0
#			else:
#				inc2 += .1
#		
#		#print text
#		else:
#			message(String(tex[indx]))
#			indx += 1
#			inc1 = 0
#	
#	#continue increment
#	else:
#		inc1 += .1


func start_chat():
	#text file loading
#	if !is_running:
#		TXT_FILE = "res://text/text_" + String(TEX_NUM) + "_" + String(lang) + ".txt"
#		switch = true
#		texinit = true
	
	#so much measurement to prevent sequence skipping lol
	inc_i0 = 0
	
	#release input
	Input.action_release("ui_ok")
	Input.action_release("ui_ok")
	Input.action_release("ui_ok")
	Input.action_release("ui_ok")
	
	#wait
	while inc_i0 < lim_i0:
		yield(get_tree().create_timer(.01), "timeout")
		inc_i0 += .1
	
	#run dialogue
	if !is_running:
		refresh()


#main branch function
func refresh(): 
	var do = false
	inc0 = 0
	
	audio_B.stop()
	
	#enemy node get
	var _targ = thisnode.get_node("enemy")
	var targ_sp = thisnode.get_node("enemy/SPR")
	
	targ_sp.modulate = Color.white
	
#	print("seq_0: " + String(seq_0) + " seq_1: " + String(seq_1))
	
	if !TXT_OVERRIDE:
		TEX_NUM = 999
		
		match seq_0:
			-1: #intro
				targ_sp.set_texture(load("res://image/placeholder_exclamation.png"))
				
				if lang == "ENG":
					TXT_STR = "TEST: This is a test.\nseq 0: -1."
				
				do = true
				while inc0 < lim0:
					inc0 += .1
					yield(get_tree().create_timer(.01), "timeout")
				
				seq_0 = 0
				seq_1 = 0
			
			0:
				BG.set_texture(load("res://image/texture_07.png"))
				
				match seq_1:
					0:
						targ_sp.set_texture(load("res://image/placeholder.png"))
						
						if lang == "ENG":
							TXT_STR = "\n\nTEST: This is a test.\nseq 0: 0, seq 1: 0."
						
						var num = .001
						
						targ_sp.run = true
						targ_sp.type_mv = "scale"
						targ_sp.scale_x = num
						targ_sp.scale_y = num
						
						do = true
						while inc0 < lim0:
							inc0 += .1
							yield(get_tree().create_timer(.01), "timeout")
						
						seq_0 = 0
						seq_1 = 1
					1:
						targ_sp.set_texture(load("res://image/placeholder_check.png"))
						
						if lang == "ENG":
							TXT_STR = "\n\nTEST: This is a test.\nseq 0: 0, seq 1: 1."
						
						do = true
						while inc0 < lim0:
							inc0 += .1
							yield(get_tree().create_timer(.01), "timeout")
						
						seq_0 = 50
						seq_1 = 0
			
			50:
				#fade out
				sceneload.screen_transit_alpha(true, thisnode.get_node("overlay"), Color(0, 0, 0, 1), Color(0, 0, 0, 0), .08)
				
				while true:
					yield(get_tree().create_timer(.01), "timeout")
					if sceneload.screen_transit_end:
						break
				
				#fade audio
				sceneload.audio_transit(true, -80, .02, audio_A)
				
				while true:
					yield(get_tree().create_timer(.01), "timeout")
					
					if sceneload.audio_transit_end:
						break
				
				#end game
				get_tree().quit()
			
			99: 
				BG.set_texture(load("res://image/texture_07.png"))
				targ_sp.set_texture(load("res://image/placeholder_question.png"))
				
				match seq_1:
					0:
						if lang == "ENG":
							TXT_STR = "test."
						if lang == "JP":
							TXT_STR = "テスト。"
						
						do = false
						while inc0 < lim0:
							inc0 += .1
							yield(get_tree().create_timer(.01), "timeout")
				
				seq_0 = 99
				seq_1 = 0
		
		if do:
			message(String(TXT_STR))
		else:
			pass
	else:
		print("TXT_OVERRIDE is ON")


func message(text):
	audio_B.stream = load("res://audio/tone1.wav")
	audio_B.play()
	
	#seek to nearest
	var v_scroll = get_node("SC_TEX").get_v_scrollbar()
	v_scroll.value = v_scroll.max_value + v_scroll.value/2
	
#	LB_TEX_0.text = ""
	LB_TEX_0.text += text


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			Input.action_press("ui_ok")
	
	if event is InputEventScreenTouch:
		Input.action_press("ui_ok")


func _ready():
	var v_scroll = get_node("SC_TEX").get_v_scrollbar()
	v_scroll.connect("changed", self, "auto_scroll")
	v_scroll.connect("scrolling", self, "set_scroll")
	
	MAX_SCROLL = v_scroll.max_value
	IS_SCROLL = true
	
	#language switcher (font override)
	if lang == "ENG":
		LB_TEX_0.add_font_override("font", load("res://resource/theme/font/notosans_regular_dynamic.tres"))
	if lang == "JP":
		LB_TEX_0.add_font_override("font", load("res://resource/theme/font/pixelMplus12_dynamic.tres"))


func _process(_delta):
	if Input.is_action_just_pressed("ui_ok"):
		start_chat()
	
#	if Input.is_action_just_pressed("ui_focus_next") and TXT_OVERRIDE:
#		message("TEST:" + "\nThis is a test.\nTesting line breaks.")
	
#	if switch:
#		taktak()
#		is_running = true
#	else:
#		is_running = false


func set_scroll():
	IS_SCROLL = false


func auto_scroll():
	var v_scroll = get_node("SC_TEX").get_v_scrollbar()
	
	if MAX_SCROLL != v_scroll.max_value:
		MAX_SCROLL = v_scroll.max_value
		IS_SCROLL = true
		
		while IS_SCROLL:
			yield(get_tree().create_timer(.01), "timeout")
			
#			print("max scroll " + String(MAX_SCROLL) + "scroll value " +  String(v_scroll.value))
			get_node("SC_TEX").set_deferred("scroll_vertical", v_scroll.value + 1.8)
			
			if v_scroll.value >= MAX_SCROLL:
				v_scroll.value = MAX_SCROLL

