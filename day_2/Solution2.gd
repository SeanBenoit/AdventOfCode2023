extends Node2D

var puzzleInputLines = []
var result = 0
var gameNumber = -1
var pullNumber = -1
var timeElapsed = 0
var totalTimeElapsed = 0
var pulls = []
var redNeeded = 0
var greenNeeded = 0
var blueNeeded = 0

var resultLabel
var gameLabel
var pullLabel
var powerLabel
var cubeHolder

# Called when the node enters the scene tree for the first time.
func _ready():
	resultLabel = $Control/ResultLabel
	gameLabel = $Control/GameLabel
	pullLabel = $Control/PullLabel
	powerLabel = $Control/PowerLabel
	cubeHolder = $CubeHolder


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if puzzleInputLines.size() <= 0:
		return
	# Don't flicker too fast
	timeElapsed += delta
	totalTimeElapsed += delta
	if timeElapsed < 0.1 / max(1, totalTimeElapsed):
		return
	timeElapsed = 0
	# Stop processing at the end of the file.
	if gameNumber >= puzzleInputLines.size():
		return
	# Go to next pull
	pullNumber += 1
	# Go to next game if we've done every pull in this one
	if pullNumber >= pulls.size():
		pullNumber = 0
		gameNumber += 1
		result += redNeeded * greenNeeded * blueNeeded
		resultLabel.text = "Result: %s" % result
		redNeeded = 0
		greenNeeded = 0
		blueNeeded = 0
		# Stop processing at the end of the file.
		if gameNumber >= puzzleInputLines.size():
			return
		parse_game(puzzleInputLines[gameNumber])
	var pull = pulls[pullNumber]
	# Calculate new values
	redNeeded = max(redNeeded, pull[0])
	greenNeeded = max(greenNeeded, pull[1])
	blueNeeded = max(blueNeeded, pull[2])
	var power = redNeeded * greenNeeded * blueNeeded
	# Display current pull
	cubeHolder.clear_squares()
	pullLabel.text = "Pull %s" % (pullNumber + 1)
	powerLabel.text = "Power: %s" % power
	cubeHolder.add_red_cubes(redNeeded)
	cubeHolder.add_green_cubes(greenNeeded)
	cubeHolder.add_blue_cubes(blueNeeded)

func parse_game(inputLine: String):
	var parts = inputLine.split(": ")
	gameLabel.text = parts[0]
	pulls = Array(parts[1].split("; ")).map(parse_pull)

func parse_pull(rawPull: String):
	var parts = Array(rawPull.split(", "))
	var redPart = parts.filter(func(part: String): return part.contains("red"))
	var numRedSquares = 0
	if redPart.size() > 0:
		numRedSquares = int(redPart[0])
	var greenPart = parts.filter(func(part: String): return part.contains("green"))
	var numGreenSquares = 0
	if greenPart.size() > 0:
		numGreenSquares = int(greenPart[0])
	var bluePart = parts.filter(func(part: String): return part.contains("blue"))
	var numBlueSquares = 0
	if bluePart.size() > 0:
		numBlueSquares = int(bluePart[0])
	return [numRedSquares, numGreenSquares, numBlueSquares]


func _on_puzzle_root_finish_parsing(input_lines):
	puzzleInputLines = input_lines
