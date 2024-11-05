class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight):
	items.append({ "item": item, "weight": weight })
	weight_sum += weight


func remove_item(item_to_remove):
	items = items.filter(func (item): return item.item != item_to_remove)
	weight_sum = 0
	for item in items:
		weight_sum += item.weight


func pick_item(exclude: Array = []):
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	
	#NOTE: this block of code will ONLY work if the item passed in is an AbilityUpgrade
	#it is not abstracted to work with other things such as enemies because I was an idiot who wanted to make it more efficient
	#but I now realize it is more effort than it is worth I think
	#so I will probably change it back later
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item.item in exclude:
				continue
			adjusted_items.append(item)
			adjusted_weight_sum += item.weight
		
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item.weight
		if chosen_weight <= iteration_sum:
			return item["item"]
