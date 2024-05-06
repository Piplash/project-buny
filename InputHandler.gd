
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
var animationOn     : bool = false
var bunyEating      : bool = false

var startExpression : bool = true
var stopExpression  : bool = true

var patAffectionIncrease  : float = 0.12
var chestAffectionDecrease: float = -5.0

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
		if !animationOn:
			toDoOnHeadArea(event, level)

	if cursorOverChestArea == true:
		if !animationOn:
			toDoOnChestArea(event)

	if cursorOverCarrotArea == true:
		if !animationOn:
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

				if level == 2:
					patAffectionIncrease = 0.11
				elif level ==3:
					patAffectionIncrease = 0.09
				elif level == 4:
					patAffectionIncrease = 0.07
				elif level == 5:
					patAffectionIncrease = 0.04
				else:
					patAffectionIncrease = 0.12

				socialManagerScript.setDecreaseAffection(false)
				socialManagerScript.modifyAffection(patAffectionIncrease)

				if stopExpression == true:
					$Buny/GDCubismUserModel.stop_expression()
					stopExpression = false

				if startExpression == true:
					if level == 1 or level == 2:
						$Buny/GDCubismUserModel.start_expression("handcry")
					else:
						$Buny/GDCubismUserModel.start_expression("hand")

					$Buny/GDCubismUserModel.start_motion_loop("Hand", 0, 3, true, true)
					startExpression = false

func toDoOnChestArea(event) -> void:
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				animationOn = true
				Input.set_custom_mouse_cursor(arrowPointer)
				
				socialManagerScript.setLevelChange(false)
				socialManagerScript.modifyAffection(chestAffectionDecrease)
				$Buny/GDCubismUserModel.stop_expression()
				$Buny/GDCubismUserModel.start_expression("upset")
				#$Buny/GDCubismUserModel.start_motion("Upset", 0, 3)
				defaultAnimation(2.0)
				await get_tree().create_timer(0.7).timeout
				$Buny/UpsetSound.play()

func toDoOnCarrotArea(event) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragginCarrot = true
				drag_offset = carrot.position - get_global_mouse_position()

	if dragginCarrot:
		carrot.position = get_global_mouse_position() + drag_offset

func toDoOnUnpressedClick(event) -> void:

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and pointerHovering:
			pointerHovering = false
			
			socialManagerScript.setDecreaseAffection(true)
			socialManagerScript.setLevelChange(true)

			var displayLevelUp = socialManagerScript.getDisplayLevelUp()

			if displayLevelUp:
				animationOn = true
				Input.set_custom_mouse_cursor(arrowPointer)

			if !displayLevelUp:
				defaultAnimation(0.5)

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
					bunyEating = true
					animationOn = true
					Input.set_custom_mouse_cursor(arrowPointer)
					
					$Buny/GDCubismUserModel.stop_expression()
					$Buny/GDCubismUserModel.start_expression("carrot")
					$Buny/GDCubismUserModel.start_motion("Carrot", 0, 3)
					defaultAnimation(4.5)
					socialManagerScript.modifyHunger(15)
				else:
					if hunger == "Full":
						print("Logic for when she is full")
						return

					if level < 4:
						animationOn = true;
						Input.set_custom_mouse_cursor(arrowPointer)
						$Buny/GDCubismUserModel.start_expression("upset")
						defaultAnimation(2.0)
						#defaultAnimation(2.0, "upset")
						await get_tree().create_timer(0.7).timeout
						$Buny/UpsetSound.play()
						return

func defaultAnimation(timer: float) -> void:
	print("4")
	await get_tree().create_timer(timer).timeout
	animationOn = false
	socialManagerScript.setLevelChange(true)
	socialManagerScript.changeAnimation()

#Getters / Setters
func getPatting() -> bool:
	return pointerHovering

func getEating() -> bool:
	return bunyEating
func setEating():
	bunyEating = false

func getAnimationOn() -> bool:
	return animationOn
func setAnimationOn():
	animationOn = false

