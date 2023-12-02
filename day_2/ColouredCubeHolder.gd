extends Node2D

@export
var colour: Color

var colouredSquare = preload("res://day_2/ColouredSquare.tscn")
var squaresHeld = 0
var maxSquaresPerRow = 50

signal rowsChanged(numOfRows)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_coloured_square():
	# Make the new square
	var newSquare = colouredSquare.instantiate()
	newSquare.color = colour
	add_child(newSquare)
	# Position the new square
	var rowNumber = squaresHeld / maxSquaresPerRow
	newSquare.position = Vector2(30 * (squaresHeld % maxSquaresPerRow), rowNumber * 30)
	# Adjust scene spacing if needed
	squaresHeld += 1
	if squaresHeld % maxSquaresPerRow == 1:
		rowsChanged.emit(rowNumber + 1)

func clear_coloured_squares():
	var allSquares = get_children()
	for i in allSquares.size():
		allSquares[i].free()
	squaresHeld = 0
	rowsChanged.emit(0)
