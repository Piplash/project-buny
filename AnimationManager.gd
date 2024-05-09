extends Sprite2D

var socialManagerScript: Node
var inputHandlerScript : Node

func _ready():
	#print("ANIMATION MANAGER")
	$GDCubismUserModel.parameter_mode = 0
	$GDCubismUserModel.start_expression("sadcry")
	$GDCubismUserModel.start_motion_loop("Tears", 0, 3, true, true)

	socialManagerScript = get_node("/root/SocialManager")
	inputHandlerScript  = get_node("/root/Room/Character")

func changeAnimation(animation: int, displayLevelUp = false, me = false) -> void:

	var patting = inputHandlerScript.getPatting()
	var hunger  = socialManagerScript.getHunger()
	var eating  = inputHandlerScript.getEating()
	var upset   = inputHandlerScript.getUpset()

	if upset:
		$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.stop_motion()
		inputHandlerScript.setUpset()

	if eating:
		$GDCubismUserModel.stop_expression()
		inputHandlerScript.setEating()

	if !patting and me:
		$GDCubismUserModel.stop_expression()

	
	if displayLevelUp == true:
		$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.stop_motion()
		$GDCubismUserModel.start_expression("hearts")
		$GDCubismUserModel.start_motion_loop("Hearts", 0, 3, true, true)
		await get_tree().create_timer(2).timeout
		socialManagerScript.setDisplayLevelUp()
		inputHandlerScript.setAnimationOn()

	if animation == 5:
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Superhappy", 0, 3, true, true)
		if hunger == 'Full':
			$GDCubismUserModel.start_expression("superhappy")
		else:
			$GDCubismUserModel.start_expression("happy")

	if animation == 4:
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Idle", 0, 3, true, true)
		$GDCubismUserModel.start_expression("happy")

	if animation == 3:
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Idle", 0, 3, true, true)
		$GDCubismUserModel.start_expression("sad")

	if animation == 2:
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Idle", 0, 3, true, true)
		$GDCubismUserModel.start_expression("sadcry")

	if animation == 1:
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Tears", 0, 3, true, true)
		$GDCubismUserModel.start_expression("sadcry")
