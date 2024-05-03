extends Sprite2D

var socialManagerScript: Node
var inputHandlerScript : Node

func _ready():
	#print("ANIMATION MANAGER")
	$GDCubismUserModel.parameter_mode = 0
	$GDCubismUserModel.start_expression("sadcry")
	$GDCubismUserModel.start_motion_loop("Idle", 1, 3, true, true)

	socialManagerScript = get_node("/root/SocialManager")
	inputHandlerScript  = get_node("/root/Room/Character")

func changeAnimation(animation: int, originalAnimation = null) -> void:
	
	var patting = inputHandlerScript.getPatting()
	var hunger  = socialManagerScript.getHunger()
	
	if !patting:
		$GDCubismUserModel.stop_expression()

	if originalAnimation!=null:
		$GDCubismUserModel.stop_expression()

	if animation == 5:
		#print("CHANGE TO 5")
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Idle", 3, 3, true, true)
		if hunger == 'Full':
			$GDCubismUserModel.start_expression("superhappy")
		else:
			$GDCubismUserModel.start_expression("happy")

	if animation == 4:
		#print("CHANGE TO 4")
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Idle", 0, 3, true, true)
		$GDCubismUserModel.start_expression("happy")

	if animation == 3:
		#print("CHANGE TO 3")
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Idle", 0, 3, true, true)
		$GDCubismUserModel.start_expression("sad")

	if animation == 2:
		#print("CHANGE TO 2")
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Idle", 0, 3, true, true)
		$GDCubismUserModel.start_expression("sadcry")

	if animation == 1:
		#print("CHANGE TO 1")
		#$GDCubismUserModel.stop_expression()
		$GDCubismUserModel.start_motion_loop("Idle", 1, 3, true, true)
		$GDCubismUserModel.start_expression("sadcry")
