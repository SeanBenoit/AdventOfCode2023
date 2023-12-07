extends Node2D

var winningNumbers = []
var gameNumbers = []
var winningNumberIndex = 0
var gameNumberIndex = 0
var score = 0

var incrementalScoring: bool
var copies = 1

signal done_card(score: int)
signal current_score(score: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y < 0:
		hide()
	else:
		show()
		$CopiesLabel.text = "Copies: %s" % copies


func set_game(input: String, winsMoreCards: bool):
	$CardLabel.set_game(input)
	winningNumbers = $CardLabel.winningNumbers
	gameNumbers = $CardLabel.gameNumbers
	incrementalScoring = winsMoreCards
	if incrementalScoring:
		$CopiesLabel.show()

func start_game():
	$WinnerHighlight.visible = true
	$NumberHighlight.visible = true
	current_score.emit(score)

func check_step():
	if winningNumberIndex >= winningNumbers.size() or gameNumberIndex >= gameNumbers.size():
		done_card.emit(score)
		$WinnerHighlight.visible = false
		$NumberHighlight.visible = false
		return
	# Check if next winning number matches next game number
	var nextWinningNum = winningNumbers[winningNumberIndex]
	var nextGameNum = gameNumbers[gameNumberIndex]
	if nextWinningNum == nextGameNum:
		increase_score()
		# Move both indices forward
		next_winning_number()
		next_game_number()
		return
	# Check if the next winning number is lower than the next game number
	if nextWinningNum < nextGameNum:
		next_winning_number()
		return
	# Next winning number must be higher than next game number
	next_game_number()

func increase_score():
	if incrementalScoring:
		score += 1
	elif score == 0:
		score = 1
	else:
		score *= 2
	current_score.emit(score)

func next_winning_number():
	winningNumberIndex += 1
	$WinnerHighlight.position.x += 22

func next_game_number():
	gameNumberIndex += 1
	$NumberHighlight.position.x += 22
