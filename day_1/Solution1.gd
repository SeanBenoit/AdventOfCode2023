extends Control

var puzzleInputLines = []
var i = 0
var timeElapsed = 0

var inputLabel
var resultLabel
var totalLabel

var totalSoFar = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	inputLabel = $InputLabel
	resultLabel = $ResultLabel
	totalLabel = $TotalLabel
	
	inputLabel.text = "Reading input..."
	resultLabel.text = "0"
	totalLabel.text = str(totalSoFar)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (puzzleInputLines.size() <= 0):
		return
	# Don't flicker too fast
	timeElapsed += delta
	if (timeElapsed < 0.01):
		return
	timeElapsed = 0
	# Stop processing at the end of the file.
	if (i >= puzzleInputLines.size()):
		return
	# Calculate new values
	var currentLine = puzzleInputLines[i]
	var firstDigit = find_digit(currentLine, true)
	var secondDigit = find_digit(currentLine, false)
	var calibrationValue = 10 * int(firstDigit) + int(secondDigit)
	totalSoFar += calibrationValue
	i += 1
	# Display new values
	inputLabel.text = currentLine
	resultLabel.text = str(calibrationValue)
	totalLabel.text = str(totalSoFar)

func find_digit(string, searchForward):
	var j = 0
	while(j < string.length()):
		var nextChar
		if (searchForward):
			nextChar = string[j]
		else:
			nextChar = string[string.length() - 1 - j]
		if("1234567890".contains(nextChar)):
			return nextChar
		j += 1
	return -1


func _on_puzzle_root_finish_parsing(input_lines):
	puzzleInputLines = input_lines
