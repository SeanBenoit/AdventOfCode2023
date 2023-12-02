extends Node2D

var puzzleInputLines = []
var result = 0
var gameNumber = -1
var pullNumber = -1
var timeElapsed = 0
var totalTimeElapsed = 0
var pulls = []
var gameIsPossible = true

var resultLabel
var gameLabel
var pullLabel
var possibilityLabel
var cubeHolder

# Called when the node enters the scene tree for the first time.
func _ready():
	resultLabel = $Control/ResultLabel
	gameLabel = $Control/GameLabel
	pullLabel = $Control/PullLabel
	possibilityLabel = $Control/PossibilityLabel
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
		if gameIsPossible:
			result += gameNumber
			resultLabel.text = "Result: %s" % result
		gameIsPossible = true
		# Stop processing at the end of the file.
		if gameNumber >= puzzleInputLines.size():
			return
		parse_game(puzzleInputLines[gameNumber])
	var pull = pulls[pullNumber]
	# Display current pull
	cubeHolder.clear_squares()
	pullLabel.text = "Pull %s" % (pullNumber + 1)
	cubeHolder.add_red_cubes(pull[0])
	cubeHolder.add_green_cubes(pull[1])
	cubeHolder.add_blue_cubes(pull[2])
	# Calculate new values
	gameIsPossible = gameIsPossible and pull[0] <= 12 and pull[1] <= 13 and pull[2] <= 14
	if gameIsPossible:
		possibilityLabel.text = "Possible"
	else:
		possibilityLabel.text = "IMPOSSIBLE"
		# Skip to next game
		pullNumber = pulls.size()

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
