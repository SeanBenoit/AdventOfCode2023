extends Control

@export
var dayNumber: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$DayLabel.text = "Day " + str(dayNumber)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
