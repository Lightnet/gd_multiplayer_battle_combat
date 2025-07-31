extends Resource
class_name HitInfoData

@export var name:String = "None"
@export var amount_point:float = 1.0 # damage or heal amount
@export var type:String = "Physical" #Type: Physical, damage, heal, buff, debuff
## if there no owner default here
## for this example is area effect tick
var current_owner_name:String = "None" 
var current_owner:Node3D #owner
