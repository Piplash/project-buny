extends Node2D

var socialManagerScript: Node

func _ready() -> void:
	socialManagerScript = get_node("/root/SocialManager")

func _process(delta: float) -> void:
	var res = socialManagerScript.affectionData()
	var hunger = socialManagerScript.getHunger()
	
	var affectionPercentage = str(res[1])
	var hungerPercentaje = str(100) #str(hunger)
	
	var stats = [affectionPercentage, hungerPercentaje]
	
	for i in range(stats.size()):
		var item = stats[i]
		var decimalPosition = item.find(".")

		if decimalPosition != -1:
			var decimalCount = item.length() - decimalPosition - 1
			if decimalCount > 2:
				item = item.left(decimalPosition + 3)
				stats[i] = item

	affectionPercentage = stats[0]
	hungerPercentaje = stats[1]

	
	$Labels/AffectionLevel.text = "Level: " + str(res[0])
	$Labels/AffectionPercentage.text = "Affection: " #+ affectionPercentage +"%"
	$Labels/ProgressBar.value = res[1]
	$Labels/Mood.text = "Mood: " + res[2]
	$Labels/Hunger.text = "Hunger: " + hunger
