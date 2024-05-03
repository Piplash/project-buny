extends Node2D

var inputHandlerScript: Node

var headArea   : Area2D = null
var chestArea  : Area2D = null
var carrotArea : Area2D = null
var feedingArea: Area2D = null
var modelArea  : Area2D = null

var cursorOverHeadArea   : bool = false
var cursorOverChestArea  : bool = false
var cursorOverCarrotArea : bool = false
var cursorOverFeedingArea: bool = false
var cursorOverModelArea  : bool = false

var handPointer
var arrowPointer

var eating: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	inputHandlerScript = get_node("/root/Room/Character")

	Input.set_custom_mouse_cursor(arrowPointer)
	
	handPointer  = load("res://assets/handPointer.png")
	arrowPointer = load("res://assets/arrowPointer.png")
	
	headArea    = get_node("/root/Room/Character/Buny/HeadArea")
	chestArea   = get_node("/root/Room/Character/Buny/ChestArea")
	carrotArea  = get_node("/root/Room/Food/Carrot/CarrotArea")
	feedingArea = get_node("/root/Room/Character/Buny/FeedingHeadArea")
	modelArea   = get_node("/root/Room/Character/Buny/ModelArea")
	
	headArea.connect("mouse_entered", mouseEnteredHead)
	headArea.connect("mouse_exited", mouseLeftHead)
	
	carrotArea.connect("mouse_entered", mouseEnteredCarrot)
	carrotArea.connect("mouse_exited", mouseLeftCarrot)

	chestArea.connect("mouse_entered", mouseEnteredChest)
	chestArea.connect("mouse_exited", mouseLeftChest)
	
	feedingArea.connect("mouse_entered", mouseEnteredFeeding)
	feedingArea.connect("mouse_exited", mouseLeftFeeding)
	
	modelArea.connect("mouse_entered", mouseEnteredModelArea)
	modelArea.connect("mouse_exited", mouseExitedModelArea)

func mouseEnteredHead():  # Define the function
	#print("Mouse entered head area")
	#Input.set_custom_mouse_cursor(handPointer)
	changeCursor('Entered')
	cursorOverHeadArea = true

func mouseLeftHead():
	#print("Mouse exited head area")
	#Input.set_custom_mouse_cursor(arrowPointer)
	changeCursor('Left')
	cursorOverHeadArea = false

func mouseEnteredChest():
	#print("Mouse entered chest area")
	#Input.set_custom_mouse_cursor(handPointer)
	changeCursor('Entered')
	cursorOverChestArea = true

func mouseLeftChest():
	#print("Mouse exited chest area")
	#Input.set_custom_mouse_cursor(arrowPointer)
	changeCursor('Left')
	cursorOverChestArea = false

func mouseEnteredCarrot():
	#print("Mouse entered entered")
	#Input.set_custom_mouse_cursor(handPointer)
	changeCursor('Entered')
	cursorOverCarrotArea = true

func mouseLeftCarrot():
	#print("Mouse exited carrot")
	#Input.set_custom_mouse_cursor(arrowPointer)
	changeCursor('Left')
	cursorOverCarrotArea = false

func changeCursor(event):
	eating = inputHandlerScript.getEating()
	if !eating:
		if event == 'Entered':
			Input.set_custom_mouse_cursor(handPointer)
		elif event == 'Left':
			Input.set_custom_mouse_cursor(arrowPointer)

func mouseEnteredFeeding():
	#Input.set_custom_mouse_cursor(handPointer)
	cursorOverFeedingArea = true

func mouseLeftFeeding():
	#Input.set_custom_mouse_cursor(arrowPointer)
	cursorOverFeedingArea = false

func mouseEnteredModelArea():
	cursorOverModelArea = true

func mouseExitedModelArea():
	cursorOverModelArea = false

func getHeadArea() -> bool:
	return cursorOverHeadArea

func getChestArea() -> bool:
	return cursorOverChestArea

func getCarrotArea() -> bool:
	return cursorOverCarrotArea

func getFeedingArea() -> bool:
	return cursorOverFeedingArea

func getModelArea() -> bool:
	return cursorOverModelArea
