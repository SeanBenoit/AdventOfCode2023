extends Node2D

var puzzleInputLines = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	# Load input file.
	var inputFileName = "res://day_%s/part_%s.txt" % [parent.dayNumber, parent.partNumber]
	var inputFile = FileAccess.open(inputFileName, FileAccess.READ)
	while not inputFile.eof_reached():
		puzzleInputLines.append(inputFile.get_line())
	if (puzzleInputLines[-1] == ""):
		puzzleInputLines.remove_at(puzzleInputLines.size() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
