
extends Node2D

var socialManagerScript: Node
var mouseEventScript: Node
var carrot: Node

var cursorOverHeadArea   : bool = false
var cursorOverChestArea  : bool = false
var cursorOverCarrotArea : bool = false
var cursorOverFeedingArea: bool = false
var cursorOverModelArea  : bool = false

var pointerHovering : bool = false
var dragginCarrot   : bool = false
var eatingCarrot	: bool = false

var startExpression : bool = true
var stopExpression  : bool = true

var patAffectionIncrease  : float = 0.05
var chestAffectionDecrease: float = -3.0

var carrotInitialPosition: Vector2
var drag_offset          : Vector2

var arrowPointer

func _ready():
	arrowPointer = load("res://assets/arrowPointer.png")
	
	socialManagerScript = get_node("/root/SocialManager")
	mouseEventScript    = get_node("/root/Room/Scripts/MouseEvents")
	carrot              = get_node("../Food")
	
	carrotInitialPosition = carrot.position

func _process(delta):
	cursorOverHeadArea    = mouseEventScript.getHeadArea()
	cursorOverChestArea   = mouseEventScript.getChestArea()
	cursorOverCarrotArea  = mouseEventScript.getCarrotArea()
	cursorOverFeedingArea = mouseEventScript.getFeedingArea()
	cursorOverModelArea   = mouseEventScript.getModelArea()

func _input(event):
	var level = socialManagerScript.getCurrentLevel()

	followPointer(event)

	if cursorOverHeadArea == true:
		if !eatingCarrot:
			toDoOnHeadArea(event, level)

	if cursorOverChestArea == true:
		if !eatingCarrot:
			toDoOnChestArea(event)

	if cursorOverCarrotArea == true:
		if !eatingCarrot:
			toDoOnCarrotArea(event)

	toDoOnUnpressedClick(event)

func followPointer(event) -> void:
	if cursorOverModelArea:
		if event as InputEventMouseMotion:

			var local_pos = $Buny.to_local(event.position)
			
			var render_size: Vector2 = Vector2(
				float($Buny/GDCubismUserModel.size.x),
				float($Buny/GDCubismUserModel.size.y) * -1
				)

			local_pos /= (render_size * 0.5)


			var hunger = socialManagerScript.getHunger()
			if dragginCarrot and hunger == "Full":
				$Buny/GDCubismUserModel/GDCubismEffectTargetPoint.set_target(-local_pos)
			else:
				$Buny/GDCubismUserModel/GDCubismEffectTargetPoint.set_target(local_pos)
	else:
		$Buny/GDCubismUserModel/GDCubismEffectTargetPoint.set_target(Vector2.ZERO)

func toDoOnHeadArea(event, level) -> void:
	if event is InputEventMouseMotion and !dragginCarrot:
			if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
				pointerHovering  = true
				socialManagerScript.setLevelChange(false)

				if level == 4:
					patAffectionIncrease = 0.03
				elif level == 5:
					patAffectionIncrease = 0.015
				else:
					patAffectionIncrease = 0.05

				socialManagerScript.setDecreaseAffection(false)
				socialManagerScript.modifyAffection(patAffectionIncrease)

				if stopExpression == true:
					#print("ENTRANDO 1.1.1.1")
					$Buny/GDCubismUserModel.stop_expression()
					stopExpression = false

				if startExpression == true:
					#print("ENTRANDO 1.1.1.2")
					if level == 1 or level == 2:
						$Buny/GDCubismUserModel.start_expression("handcry")
					else:
						$Buny/GDCubismUserModel.start_expression("hand")

					$Buny/GDCubismUserModel.start_motion_loop("Idle", 2, 3, true, true)
					startExpression = false

func toDoOnChestArea(event) -> void:
	if event is InputEventMouseButton:
			#print("ENTRANDO 2.1")
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				#print("ENTRANDO 2.1.2")
				socialManagerScript.setLevelChange(false)
				socialManagerScript.modifyAffection(chestAffectionDecrease)
				$Buny/GDCubismUserModel.stop_expression()
				$Buny/GDCubismUserModel.start_expression("upset")
				defaultAnimation(2.0, "upset")
				await get_tree().create_timer(0.7).timeout
				$Buny/UpsetSound.play()

func toDoOnCarrotArea(event) -> void:
	
	if event is InputEventMouseButton:
		#print("PRIMER IF")
		if event.button_index == MOUSE_BUTTON_LEFT:
			#print("SEGUNDO IF")
			if event.pressed:
				#print("TERCER IF")
				dragginCarrot = true
				drag_offset = carrot.position - get_global_mouse_position()

	if dragginCarrot:
		#print("CUARTO IF")
		carrot.position = get_global_mouse_position() + drag_offset

func toDoOnUnpressedClick(event) -> void:
	#print("UNPRESSED")
	if event is InputEventMouseButton:
		#print("UNPRESSED IF")
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and pointerHovering:
			#print("UNPRESSED SECOND IF 3.1")
			pointerHovering = false
			
			socialManagerScript.setDecreaseAffection(true)
			socialManagerScript.setLevelChange(true)
			defaultAnimation(0.3)
			startExpression = true
			stopExpression  = true
		
		#Feed
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and dragginCarrot:
			carrot.position = carrotInitialPosition
			dragginCarrot = false
			if cursorOverFeedingArea:
				var level = socialManagerScript.getCurrentLevel()
				var hunger = socialManagerScript.getHunger()
				print("Logic to feed")
				if level >= 4 and hunger != "Full":
					eatingCarrot = true;
					Input.set_custom_mouse_cursor(arrowPointer)
					
					$Buny/GDCubismUserModel.stop_expression()
					$Buny/GDCubismUserModel.start_expression("carrot")
					$Buny/GDCubismUserModel.start_motion("Idle",4,3)
					defaultAnimation(4.5)
					await get_tree().create_timer(4.5).timeout
					eatingCarrot = false;
					socialManagerScript.modifyHunger(5)
				else:
					if hunger == "Full":
						print("Logic for when she is full")
						return

					if level < 4:
						print("Logic for when is not happy")
						$Buny/GDCubismUserModel.start_expression("upset")
						defaultAnimation(2.0, "upset")
						await get_tree().create_timer(0.7).timeout
						$Buny/UpsetSound.play()
						return

func defaultAnimation(timer: float, originalAnimation = null) -> void:
	await get_tree().create_timer(timer).timeout
	socialManagerScript.setLevelChange(true)
	socialManagerScript.changeAnimation(originalAnimation)

#Getters
func getPatting() -> bool:
	return pointerHovering

func getEating() -> bool:
	return eatingCarrot
