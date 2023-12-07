extends Label

var cardText = "Card 0:"
var winningNumbers = []
var gameNumbers = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_game(inputLine: String):
	# Extract the card number
	var parts = inputLine.split(":")
	cardText = parts[0] + ":"
	text = cardText + " "
	# Extract the winning numbers
	parts = parts[1].split("|")
	var rawWinners = Array(parts[0].split(" ", false))
	winningNumbers = rawWinners.map(func(str): return int(str))
	winningNumbers.sort()
	var winnersText = sort_numbers_in_string(parts[0])
	text += winnersText + " | "
	# Extract the game numbers
	var rawGameNumbers = Array(parts[1].split(" ", false))
	gameNumbers = rawGameNumbers.map(func(str): return int(str))
	gameNumbers.sort()
	var gameNumbersText = sort_numbers_in_string(parts[1])
	text += gameNumbersText

func sort_numbers_in_string(input: String):
	var rawNumbers = Array(input.split(" ", false))
	var maxDigits = rawNumbers.map(func(str): return len(str)).max()
	var numbers = rawNumbers.map(func(str): return int(str))
	numbers.sort()
	rawNumbers = numbers.map(func(number): return ("%s" % number).lpad(maxDigits, "0"))
	return " ".join(rawNumbers)
