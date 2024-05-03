extends Node2D

var animationManagerScript: Node
var inputHandlerScript: Node

var affection         : float = 0
var affectionLevel    : int = 1
var prevAffectionLevel: int = 1

var decreasePerSecond : float = 0.05
var decreaseAffection: bool = true

var hunger : float = 0
var hungerLevel: String = 'Very hungry'
var prevHungerLevel: String = 'Very hungry'

var decreaseHunger: bool = true
var decreaseHungerPerSecond: float = 0.01

var levelChange : bool = true
var hungerChange: bool = true

func _ready() -> void:
	animationManagerScript = get_node("/root/Room/Character/Buny")
	inputHandlerScript     = get_node("/root/Room/Character")

func _process(delta: float) -> void:
	# Disminución del afecto. 0.5 cada 10 segundos > 0.5/10 = 0.05 (bajaPorSegundo)
	print(hunger)
	if decreaseAffection == true:
		affection -= decreasePerSecond * delta 
	
	if decreaseHunger == true:
		hunger -= decreaseHungerPerSecond * delta

	affection = clamp(affection, 0.0, 100.0)
	hunger    = clamp(hunger, 0.0, 100.0)

	if levelChange == true:
		if prevAffectionLevel != affectionLevel:
			animationManagerScript.changeAnimation(affectionLevel)
			prevAffectionLevel = affectionLevel

	var eating = inputHandlerScript.getEating()

	if hungerChange == true:
		if !eating:
			if prevHungerLevel != hungerLevel:
				animationManagerScript.changeAnimation(affectionLevel)
				prevHungerLevel = hungerLevel

	getAffectionLevel(affection)

func getAffectionLevel(affection : float) -> Array:

	if affection >= 90.0:
		affectionLevel = 5
	elif affection >= 80.0:
		affectionLevel = 4
	elif affection >= 40.0:
		affectionLevel = 3
	elif affection >= 15.0:
		affectionLevel = 2
	else: 
		affectionLevel = 1

	#Calcula el estado, de acuerdo al nivel de afecto
	var mood: String = affectionInfo(affectionLevel)

	var response = [affectionLevel, mood]
	return response

func changeAnimation(originalAnimation) -> void:
	animationManagerScript.changeAnimation(affectionLevel, originalAnimation)

func affectionInfo(affectionLevel) -> String:
	var mood: String
	
	if affectionLevel == 5:
		if hungerLevel == 'Full':
			mood = "Completely happy"
		else:
			mood = "Very happy"
	elif affectionLevel == 4:
		mood = "Happy"
	elif affectionLevel == 3:
		mood = "Normal"
	elif affectionLevel == 2:
		mood = "Sad"
	else: 
		mood = "Very sad"
	
	return mood

#Devuelve datos del afecto para mostrar en UI	
func affectionData() -> Array:
	var info = getAffectionLevel(affection)
	var response = [info[0], affection, info[1]]
	return response

#Aumenta el afecto de acuerdo a distintas acciones
func modifyAffection(modifyAffectionBy: float) -> void:
	affection = affection + modifyAffectionBy
	affection = clamp(affection, 0.0, 100.0)

func modifyHunger(modifyHungerBy: float) -> void:
	hunger = hunger + modifyHungerBy
	hunger = clamp(hunger, 0.0, 100.0)

#Getters / Setters
func getCurrentLevel() -> int:
	return affectionLevel

func getHunger() -> String:
	if hunger >= 90:
		hungerLevel = "Full"
	elif hunger >= 30:
		hungerLevel = "Kind of hungry"
	else:
		hungerLevel = "Very hungry"
	return hungerLevel

func setDecreaseAffection(decrease: bool) -> void:
	decreaseAffection = decrease
	
func setLevelChange(level: bool) -> void:
	levelChange = level
