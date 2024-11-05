extends Resource
class_name MetaUpgrade

@export var id: String
@export var max_quantity: int = 1
@export var cost: int = 10
@export var title: String
@export_multiline var description: String
#NOTE: this texture must always be a consistent size for it to work well
#the current sprite being used is about 1000x1000, but downsized by 0.12
#though the visible part isn't bigger than 70x70
@export var sprite: Texture
