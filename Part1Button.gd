extends Button

var dayNumber: int
# Called when the node enters the scene tree for the first time.
func _ready():
	dayNumber = get_parent().dayNumber


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	var scene_name = "res://day_%s/part_1.tscn" % dayNumber
	get_tree().change_scene_to_file(scene_name)
