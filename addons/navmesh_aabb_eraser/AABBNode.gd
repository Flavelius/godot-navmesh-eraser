tool
extends Spatial
class_name AABBNode

export(Vector3) var size = Vector3(1,1,1) setget set_value,get_value

func set_value(value: Vector3):
	size = value
	update_gizmo()
	
func get_value() -> Vector3:
	return size

func get_global_bounds() -> AABB:
	return AABB(global_transform.origin - (size * 0.5), size)
