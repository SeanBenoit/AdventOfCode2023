extends Node

var gridRoot
var totalLabel

var atLastSquare = false
var done = false
var totalSoFar = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gridRoot = get_parent().get_node("GridRoot")
	totalLabel = get_parent().get_node("DisplayRoot/TotalLabel")


var timeElapsed = 0
var totalTimeElapsed = 0
var processingNumber = false
var pauseForEffect = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	totalLabel.text = "Total: %s" % totalSoFar
	if not gridRoot.readyToStart:
		return
	if done:
		return
	timeElapsed += delta
	totalTimeElapsed += delta
	if timeElapsed < 0.2 / max(1, totalTimeElapsed/2):
		return
	timeElapsed = 0
	if pauseForEffect:
		pauseForEffect = false
		gridRoot.hide_checking_square()
		return
	# If current square is a digit, scan for rest of the number.
	var doneScanningNumber = not is_current_digit()
	if doneRow and not processingNumber:
		doneRow = false
		atLastSquare = gridRoot.move_focus_square(true)
	elif is_current_digit() or processingNumber:
		doneScanningNumber = scan_for_number()
	else:
		# If current square is not a digit, move to next.
		atLastSquare = gridRoot.move_focus_square(true)
	
	done = atLastSquare and doneScanningNumber

func is_current_digit():
	return "1234567890".contains(gridRoot.current_symbol())

func is_symbol(pos: Vector2):
	return not ".1234567890".contains(gridRoot.get_symbol(pos))

var currentValue = 0
var startPos: Vector2
var adjacentSpaces = []
var gotAllDigits = false
var doneRow = false
# Returns true when it's done processing this number
func scan_for_number():
	# Check if we just started handling this number
	if not processingNumber:
		processingNumber = true
		# Remember the adjacents to the left
		var currentPos = gridRoot.focusSquareOffset
		adjacentSpaces.append(Vector2(currentPos.x - 1, currentPos.y - 1))
		adjacentSpaces.append(Vector2(currentPos.x - 1, currentPos.y))
		adjacentSpaces.append(Vector2(currentPos.x - 1, currentPos.y + 1))
		# Start highlighting the current number
		gridRoot.show_number_box()
		return false
	# Check if we're still getting more digits
	if (is_current_digit() and (not atLastSquare) and (not doneRow)):
		# Remember the adjacents above and below this space
		var currentPos = gridRoot.focusSquareOffset
		adjacentSpaces.append(Vector2(currentPos.x, currentPos.y - 1))
		adjacentSpaces.append(Vector2(currentPos.x, currentPos.y + 1))
		# Add current digit to the existing number
		currentValue = 10 * currentValue + int(gridRoot.current_symbol())
		# Manipulate focus box to highlight current number
		gridRoot.expand_number_box()
		doneRow = gridRoot.move_focus_square(false)
		atLastSquare = gridRoot.focus_is_at_end()
		return false
	if not gotAllDigits:
		gotAllDigits = true
		# Remember the adjacents to the right
		var currentPos = gridRoot.focusSquareOffset
		adjacentSpaces.append(Vector2(currentPos.x, currentPos.y - 1))
		adjacentSpaces.append(Vector2(currentPos.x, currentPos.y))
		adjacentSpaces.append(Vector2(currentPos.x, currentPos.y + 1))
	# Check if we're adjacent to a symbol
	if check_for_adjacent_symbol():
		processingNumber = false
		gotAllDigits = false
		adjacentSpaces = []
		currentValue = 0
		gridRoot.reset_number_box()
		return true
	return false

func check_for_adjacent_symbol():
	if adjacentSpaces.size() <= 0:
		processingNumber = false
		gridRoot.hide_checking_square()
		return true
	# Stay in bounds
	var nextSpot = adjacentSpaces[0]
	adjacentSpaces.remove_at(0)
	while is_out_of_bounds(nextSpot):
		if adjacentSpaces.size() <= 0:
			processingNumber = false
			gridRoot.hide_checking_square()
			return true
		nextSpot = adjacentSpaces[0]
		adjacentSpaces.remove_at(0)
	# Show the checking square
	gridRoot.show_checking_square(nextSpot)
	if is_symbol(nextSpot):
		pauseForEffect = true
		processingNumber = false
		totalSoFar += currentValue
		return true
	return false

func is_out_of_bounds(spot: Vector2):
	return spot.x < 0 or spot.x >= gridRoot.gridSize.x or spot.y < 0 or spot.y >= gridRoot.gridSize.y
