extends Node

enum WAGON_TYPE { MAIN, SWORD, BOW, RESOURCE }
enum UNIT_TYPE { SWORD, BOW }
enum RESOURCES_TYPE { IRON, WOOD }
enum DAMAGE_TYPE { MELEE, RANGED }
enum TARGET_TYPE { UNITS, VILLAGERS, WAGON, ENEMIES }
enum ENEMY_TYPE { BASIC, MEDIUM, BIGBOY, BOSS }


func convertTargetTypeToGroupName(target: TARGET_TYPE) -> String:
	match target:
		TARGET_TYPE.UNITS:
			return "Units"
		TARGET_TYPE.VILLAGERS:
			return "Villagers"
		TARGET_TYPE.WAGON:
			return "Wagons"
		TARGET_TYPE.ENEMIES:
			return "Enemies"
	return ""		
