extends Node2D

var redRows = 0
var greenRows = 0
var blueRows = 0

var redCubeHolder
var greenCubeHolder
var blueCubeHolder

# Called when the node enters the scene tree for the first time.
func _ready():
	redCubeHolder = $RedCubeHolder
	greenCubeHolder = $GreenCubeHolder
	blueCubeHolder = $BlueCubeHolder


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_red_cubes(numberOfCubes: int):
	for i in range(numberOfCubes):
		redCubeHolder.add_coloured_square()

func add_green_cubes(numberOfCubes: int):
	for i in range(numberOfCubes):
		greenCubeHolder.add_coloured_square()

func add_blue_cubes(numberOfCubes: int):
	for i in range(numberOfCubes):
		blueCubeHolder.add_coloured_square()

func clear_squares():
	redCubeHolder.clear_coloured_squares()
	greenCubeHolder.clear_coloured_squares()
	blueCubeHolder.clear_coloured_squares()

func position_green_holder():
	greenCubeHolder.position = Vector2(0, 30 * redRows)
	position_blue_holder()

func position_blue_holder():
	blueCubeHolder.position = Vector2(0, 30 * (redRows + greenRows))


func _on_red_cube_holder_rows_changed(numOfRows):
	redRows = numOfRows
	position_green_holder()


func _on_green_cube_holder_rows_changed(numOfRows):
	greenRows = numOfRows
	position_blue_holder()


func _on_blue_cube_holder_rows_changed(numOfRows):
	blueRows = numOfRows
