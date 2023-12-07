extends Node2D


var cards = []
var currentCard = 0
var total = 0

var cardTemplate = preload("res://day_4/card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var timeElapsed = 0
var totalTimeElapsed = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentCard >= cards.size():
		return
	timeElapsed += delta
	totalTimeElapsed += delta
	if timeElapsed < 0.2 / max(1, totalTimeElapsed/2):
		return
	timeElapsed = 0
	cards[currentCard].check_step()

func _on_puzzle_root_finish_parsing(input_lines):
	for i in input_lines.size():
		var line = input_lines[i]
		var newCard = cardTemplate.instantiate()
		newCard.set_game(line)
		cards.append(newCard)
		add_child(newCard)
		newCard.position.y = 26 * i
		newCard.current_score.connect(_on_card_current_score)
		newCard.done_card.connect(_on_card_done_card)
	cards[0].start_game()

func _on_card_current_score(score: int):
	$DisplayRoot/CurrentCardScore.text = "Current card score: %s" % score

func _on_card_done_card(score: int):
	# Update the total
	total += score
	$DisplayRoot/TotalLabel.text = "Total: %s" % total
	# Move to the next card
	currentCard += 1
	if currentCard < cards.size():
		cards[currentCard].start_game()
	# Shift all the cards up
	for card in cards:
		card.position.y -= 26
