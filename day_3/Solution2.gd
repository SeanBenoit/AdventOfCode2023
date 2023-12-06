extends Node

var gridRoot
var totalLabel

var done = false
var totalSoFar = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gridRoot = get_parent().get_node("GridRoot")
	totalLabel = get_parent().get_node("DisplayRoot/TotalLabel")


var timeElapsed = 0
var totalTimeElapsed = 0
var checkingGear = false
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
	# Check if we're processing a gear or the current symbol could be one
	if checkingGear or is_current_gear_symbol():
		if checkGear():
			done = gridRoot.move_focus_square(true)
	else:
		# Nothing to see here, move along
		done = gridRoot.move_focus_square(true)

func is_digit(pos: Vector2):
	return "1234567890".contains(gridRoot.get_symbol(pos))

func is_current_gear_symbol():
	return gridRoot.current_symbol() == "*"

var adjacentSpaces = []
var processingNumber = false
var foundFirstNumber = false
var foundSecondNumber = false
var numberStartPos = Vector2(-1, -1)
var currentPos = Vector2(-1, -1)
var firstNumber = 0
var secondNumber = 0
# Returns true when it's done checking this gear
func checkGear():
	if not checkingGear:
		# Reset
		adjacentSpaces = []
		processingNumber = false
		foundFirstNumber = false
		foundSecondNumber = false
		numberStartPos = Vector2(-1, -1)
		currentPos = Vector2(-1, -1)
		firstNumber = 0
		secondNumber = 0
		# Add all potential neighbours to adjacent squares
		var currentFocusPos = gridRoot.focusSquareOffset
		adjacentSpaces.append(Vector2(currentFocusPos.x - 1, currentFocusPos.y - 1))
		adjacentSpaces.append(Vector2(currentFocusPos.x - 1, currentFocusPos.y))
		adjacentSpaces.append(Vector2(currentFocusPos.x - 1, currentFocusPos.y + 1))
		adjacentSpaces.append(Vector2(currentFocusPos.x, currentFocusPos.y - 1))
		adjacentSpaces.append(Vector2(currentFocusPos.x, currentFocusPos.y + 1))
		adjacentSpaces.append(Vector2(currentFocusPos.x + 1, currentFocusPos.y - 1))
		adjacentSpaces.append(Vector2(currentFocusPos.x + 1, currentFocusPos.y))
		adjacentSpaces.append(Vector2(currentFocusPos.x + 1, currentFocusPos.y + 1))
		# Remember that we're processing a gear
		checkingGear = true
		return false
	if foundFirstNumber and foundSecondNumber:
		totalSoFar += firstNumber * secondNumber
		checkingGear = false
		gridRoot.hide_checking_square()
		return true
	if numberStartPos != Vector2(-1, -1):
		scan_for_number()
		return false
	# Check next adjacent square for a number
	return check_for_adjacent_digit()

# Returns true when it's done checking adjacent spaces
func check_for_adjacent_digit():
	if adjacentSpaces.size() <= 0:
		checkingGear = false
		gridRoot.hide_checking_square()
		return true
	# Stay in bounds
	var nextSpot = adjacentSpaces[0]
	adjacentSpaces.remove_at(0)
	while is_out_of_bounds(nextSpot):
		if adjacentSpaces.size() <= 0:
			checkingGear = false
			gridRoot.hide_checking_square()
			return true
		nextSpot = adjacentSpaces[0]
		adjacentSpaces.remove_at(0)
	# Show the checking square
	gridRoot.show_checking_square(nextSpot)
	if is_digit(nextSpot):
		numberStartPos = nextSpot
		currentPos = nextSpot
		return false
	return false

var currentValue = ""
var foundLeftEnd = false
var foundRightEnd = false
# Returns true when it's done processing this number
func scan_for_number():
	gridRoot.show_checking_square(currentPos)
	# Check if we just started handling this number
	if not processingNumber:
		processingNumber = true
		# Reset
		currentValue = ""
		foundLeftEnd = false
		foundRightEnd = false
		# Start highlighting the current number
		gridRoot.show_number_box_at(numberStartPos)
		return false
	# Check if we're still getting more digits
	if is_digit(currentPos):
		# Remove this space from adjacents, if it's there
		var index = adjacentSpaces.find(currentPos)
		adjacentSpaces.remove_at(index)
		# Add current digit to the existing number
		if not foundRightEnd:
			# Add a new least significant digit
			currentValue += gridRoot.get_symbol(currentPos)
			# Manipulate focus box to highlight current number
			gridRoot.expand_number_box()
			# Find the next square to check
			currentPos.x += 1
			if is_out_of_bounds(currentPos) or not is_digit(currentPos):
				foundRightEnd = true
				currentPos = numberStartPos
				currentPos.x -= 1
				if is_out_of_bounds(currentPos) or not is_digit(currentPos):
					foundLeftEnd = true
					return set_number(currentValue)
		else:
			# Add a new most significant digit
			currentValue = gridRoot.get_symbol(currentPos) + currentValue
			# Manipulate focus box to highlight current number
			gridRoot.expand_number_box_left()
			# Find the next square to check
			currentPos.x -= 1
			if is_out_of_bounds(currentPos) or not is_digit(currentPos):
				foundLeftEnd = true
				return set_number(currentValue)
	return false

func set_number(value):
	gridRoot.reset_number_box()
	numberStartPos = Vector2(-1, -1)
	processingNumber = false
	if foundFirstNumber:
		secondNumber = int(value)
		foundSecondNumber = true
		return true
	firstNumber = int(value)
	foundFirstNumber = true
	return false

func is_out_of_bounds(spot: Vector2):
	return spot.x < 0 or spot.x >= gridRoot.gridSize.x or spot.y < 0 or spot.y >= gridRoot.gridSize.y
