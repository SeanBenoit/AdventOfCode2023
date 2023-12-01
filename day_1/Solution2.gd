extends Control

var puzzleInputLines = []
var i = 0
var timeElapsed = 0

var inputLabel
var resultLabel
var totalLabel
var forwardRegex = RegEx.new()
var backwardRegex = RegEx.new()

var totalSoFar = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	forwardRegex.compile("(\\d|one|two|three|four|five|six|seven|eight|nine|zero)")
	backwardRegex.compile(".*(\\d|one|two|three|four|five|six|seven|eight|nine|zero)")
	
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
	var forwardRegexResult = forwardRegex.search(currentLine)
	if (forwardRegexResult == null):
		print("No forward result in: %s" % currentLine)
	var backwardRegexResult = backwardRegex.search(currentLine)
	if (backwardRegexResult == null):
		print("No backward result in: %s" % currentLine)
	var firstDigit = convert_to_digit(forwardRegexResult.get_string(1))
	var secondDigit = convert_to_digit(backwardRegexResult.get_string(1))
	var calibrationValue = 10 * int(firstDigit) + int(secondDigit)
	totalSoFar += calibrationValue
	i += 1
	# Display new values
	inputLabel.text = currentLine
	resultLabel.text = str(calibrationValue)
	totalLabel.text = str(totalSoFar)

func convert_to_digit(string):
	match string:
		"one":
			return 1
		"two":
			return 2
		"three":
			return 3
		"four":
			return 4
		"five":
			return 5
		"six":
			return 6
		"seven":
			return 7
		"eight":
			return 8
		"nine":
			return 9
		"zero":
			return 0
		_:
			return int(string)


func _on_puzzle_root_finish_parsing(input_lines):
	puzzleInputLines = input_lines
