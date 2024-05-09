extends Node2D

var inputHandlerScript: Node

var headArea       : Area2D = null
var chestArea      : Area2D = null
var carrotArea     : Area2D = null
var feedingArea    : Area2D = null
var modelArea      : Area2D = null
var leftCheekArea  : Area2D = null
var rightCheekArea : Area2D = null
var leftEarArea    : Area2D = null
var rightEarArea   : Area2D = null 

var cursorOverHeadArea   : bool = false
var cursorOverChestArea  : bool = false
var cursorOverCarrotArea : bool = false
var cursorOverFeedingArea: bool = false
var cursorOverModelArea  : bool = false

var cursorOverLeftCheek  : bool = false
var cursorOverRightCheek : bool = false
var cursorOverLeftEar    : bool = false
var cursorOverRightEar   : bool = false

var handPointer
var arrowPointer

var animationOn: bool = false
var patting: bool = false

var model

# Called when the node enters the scene tree for the first time.
func _ready():
	inputHandlerScript = get_node("/root/Room/Character")

	Input.set_custom_mouse_cursor(arrowPointer)
	
	model = get_node("/root/Room/Character/Buny/GDCubismUserModel")
	
	handPointer  = load("res://assets/handPointer.png")
	arrowPointer = load("res://assets/arrowPointer.png")
	
	headArea       = get_node("/root/Room/Character/Buny/HeadArea")
	chestArea      = get_node("/root/Room/Character/Buny/ChestArea")
	carrotArea     = get_node("/root/Room/Food/Carrot/CarrotArea")
	feedingArea    = get_node("/root/Room/Character/Buny/FeedingHeadArea")
	modelArea      = get_node("/root/Room/Character/Buny/ModelArea")
	leftCheekArea  = get_node("/root/Room/Character/Buny/LeftCheek")
	rightCheekArea = get_node("/root/Room/Character/Buny/RightCheek")
	leftEarArea    = get_node("/root/Room/Character/Buny/LeftEar")
	rightEarArea   = get_node("/root/Room/Character/Buny/RightEar")
	
	headArea.connect("mouse_entered", mouseEnteredHead)
	headArea.connect("mouse_exited", mouseLeftHead)
	
	carrotArea.connect("mouse_entered", mouseEnteredCarrot)
	carrotArea.connect("mouse_exited", mouseLeftCarrot)

	chestArea.connect("mouse_entered", mouseEnteredChest)
	chestArea.connect("mouse_exited", mouseLeftChest)
	
	feedingArea.connect("mouse_entered", mouseEnteredFeeding)
	feedingArea.connect("mouse_exited", mouseLeftFeeding)
	
	modelArea.connect("mouse_entered", mouseEnteredModelArea)
	modelArea.connect("mouse_exited", mouseLeftModelArea)
	
	leftCheekArea.connect("mouse_entered", mouseEnteredLeftCheek)
	leftCheekArea.connect("mouse_exited", mouseLeftLeftCheek)
	
	rightCheekArea.connect("mouse_entered", mouseEnteredRightCheek)
	rightCheekArea.connect("mouse_exited", mouseLeftRightCheek)
	
	leftEarArea.connect("mouse_entered", mouseEnteredLeftEar)
	leftEarArea.connect("mouse_exited", mouseLeftLeftEar)
	
	rightEarArea.connect("mouse_entered", mouseEnteredRightEar)
	rightEarArea.connect("mouse_exited", mouseLeftRightEar)

func _process(delta):
	animationOn = inputHandlerScript.getAnimationOn()
	patting = inputHandlerScript.getPatting()
	if cursorOverHeadArea and !animationOn:
		Input.set_custom_mouse_cursor(handPointer)

func mouseEnteredHead():  # Define the function
	#print("Mouse entered head area")
	#Input.set_custom_mouse_cursor(handPointer)
	changeCursor('Entered')
	cursorOverHeadArea = true
func mouseLeftHead():
	#print("Mouse exited head area")
	#Input.set_custom_mouse_cursor(arrowPointer)
	changeCursor('Left')

	if !animationOn and patting:
		inputHandlerScript.defaultAnimation(0, true)
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

func mouseEnteredLeftCheek():
	changeCursor('Entered')
	cursorOverLeftCheek = true
func mouseLeftLeftCheek():
	changeCursor('Left')
	cursorOverLeftCheek = false

func mouseEnteredRightCheek():
	changeCursor('Entered')
	cursorOverRightCheek = true
func mouseLeftRightCheek():
	changeCursor('Left')
	cursorOverRightCheek = false

func mouseEnteredLeftEar():
	changeCursor('Entered')
	cursorOverLeftEar = true
func mouseLeftLeftEar():
	changeCursor('Left')
	cursorOverLeftEar = false

func mouseEnteredRightEar():
	changeCursor('Entered')
	cursorOverRightEar = true
func mouseLeftRightEar():
	changeCursor('Left')
	cursorOverRightEar = false

func mouseEnteredFeeding():
	#Input.set_custom_mouse_cursor(handPointer)
	cursorOverFeedingArea = true
func mouseLeftFeeding():
	#Input.set_custom_mouse_cursor(arrowPointer)
	cursorOverFeedingArea = false

func mouseEnteredModelArea():
	cursorOverModelArea = true
func mouseLeftModelArea():
	cursorOverModelArea = false

func changeCursor(event):
	animationOn = inputHandlerScript.getAnimationOn()
	#if !animationOn:
	if event == 'Entered':
		Input.set_custom_mouse_cursor(handPointer)
	elif event == 'Left':
		Input.set_custom_mouse_cursor(arrowPointer)

#Getters
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

func getLeftCheekArea() -> bool:
	return cursorOverLeftCheek
func getRightCheekArea() -> bool:
	return cursorOverRightCheek

func getLeftEarArea() -> bool:
	return cursorOverLeftEar
func getRightEarArea() -> bool:
	return cursorOverRightEar
