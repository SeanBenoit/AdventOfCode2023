extends Node2D

var readyToStart = false

var puzzleInputLines = []
var symbolHolder = preload("res://day_3/symbol_holder.tscn")
var symbolRow = preload("res://day_3/symbol_row.tscn")
var symbolRows = []
var symbolHolders = []
var gridSize = Vector2(0, 0)
var visibleGridSize = Vector2(1580 / 26, 830 / 26)

var adjacentCheckSquare
var focusSquare
var numberBox
var rowHolder

var gridOffset = Vector2(0, 0)
var focusSquareOffset = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	adjacentCheckSquare = $AdjacentCheckSquare
	focusSquare = $FocusSquare
	numberBox = $NumberBox
	rowHolder = $RowHolder


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func current_symbol():
	return get_symbol(focusSquareOffset)

func get_symbol(pos: Vector2):
	return symbolHolders[pos.y][pos.x].text

func focus_is_at_end():
	return focusSquareOffset.y >= gridSize.y - 1 and focusSquareOffset.x >= gridSize.x - 1

# Returns true if it has reached the end or false if there are unreached squares in the grid
func move_focus_square(shouldMoveRows: bool):
	if focusSquareOffset.y >= gridSize.y - 1 and focusSquareOffset.x >= gridSize.x - 1:
		return true
	elif focusSquareOffset.x >= gridSize.x - 1:
		if not shouldMoveRows:
			return true
		jump_focus_square_to_next_row()
	else:
		move_focus_square_along_row()
	return false

func jump_focus_square_to_next_row():
	# Reset grid to left side
	shift_grid_left(gridOffset.x)
	# Bookkeeping
	focusSquare.position.x = 0
	gridOffset.x = 0
	focusSquareOffset.x = 0
	focusSquareOffset.y += 1
	# Check if the square is too low on the screen
	if focusSquare.position.y >= 775:
		shift_grid_up(1)
	else:
		focusSquare.position.y += 26

func move_focus_square_along_row():
	focusSquareOffset.x += 1
	# Check if right edge of grid is visible
	if gridSize.x - visibleGridSize.x + gridOffset.x <= 0:
		focusSquare.position.x += 26
	elif focusSquare.position.x < 1400:
		focusSquare.position.x += 26
	else:
		shift_grid_left(1)

func shift_grid_up(rows: int):
	gridOffset.y -= rows
	for row in symbolRows:
		row.position.y = row.position.y - 26 * rows

func shift_grid_left(columns: int):
	gridOffset.x -= columns
	numberBox.position.x -= 26 * columns
	rowHolder.position.x = rowHolder.position.x - 26 * columns

func show_number_box():
	numberBox.position = 26 * (focusSquareOffset + gridOffset)
	numberBox.visible = true

func expand_number_box():
	numberBox.polygon[1].x += 26
	numberBox.polygon[2].x += 26

func reset_number_box():
	numberBox.visible = false
	numberBox.polygon[1].x = 0
	numberBox.polygon[2].x = 0

func show_checking_square(pos: Vector2):
	adjacentCheckSquare.position = 26 * (pos + gridOffset)
	adjacentCheckSquare.visible = true

func hide_checking_square():
	adjacentCheckSquare.visible = false

func _on_puzzle_root_finish_parsing(input_lines):
	puzzleInputLines = input_lines
	for i in puzzleInputLines.size():
		var line = puzzleInputLines[i]
		# Create the new symbol row
		var newSymbolRow = symbolRow.instantiate()
		symbolRows.append(newSymbolRow)
		rowHolder.add_child(newSymbolRow)
		symbolHolders.append([])
		newSymbolRow.position = Vector2(0, 26 * i)
		# Fill the row
		for j in len(line):
			# Create the new symbol holder
			var newSymbolHolder = symbolHolder.instantiate()
			newSymbolHolder.text = line[j]
			newSymbolRow.add_child(newSymbolHolder)
			symbolHolders[i].append(newSymbolHolder)
			newSymbolHolder.position = Vector2(26 * j, 0)
	gridSize = Vector2(symbolHolders[0].size(), symbolRows.size())
	readyToStart = true
