extends Control

var micName = ""

func _ready():
	$Label.text = micName


func _on_button_pressed():
	if !get_parent().get_parent().get_parent().visible:
		return
	
	AudioServer.input_device = micName
	Global.createMicrophone()
	get_parent().get_parent().get_parent().visible = false
	
	
