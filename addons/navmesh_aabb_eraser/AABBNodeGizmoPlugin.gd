extends EditorSpatialGizmoPlugin

func _init() -> void:
	create_material("lines", Color.red)

func has_gizmo(spatial) -> bool:
	return spatial is AABBNode

func get_name() -> String:
	return "AABBNode"

func redraw(gizmo: EditorSpatialGizmo) -> void:
	gizmo.clear()
	var target = gizmo.get_spatial_node() as AABBNode
	if target == null:
		return
	var s : Vector3 = target.size * 0.5
	var lines = PoolVector3Array()
	lines.push_back(Vector3(s.x, s.y, s.z))
	lines.push_back(Vector3(-s.x, s.y, s.z))
	lines.push_back(Vector3(s.x, -s.y, s.z))
	lines.push_back(Vector3(-s.x, -s.y, s.z))
	lines.push_back(Vector3(s.x, s.y, -s.z))
	lines.push_back(Vector3(-s.x, s.y, -s.z))
	lines.push_back(Vector3(s.x, -s.y, -s.z))
	lines.push_back(Vector3(-s.x, -s.y, -s.z))
	
	lines.push_back(Vector3(s.x, s.y, s.z))
	lines.push_back(Vector3(s.x, -s.y, s.z))
	lines.push_back(Vector3(-s.x, -s.y, s.z))
	lines.push_back(Vector3(-s.x, s.y, s.z))
	lines.push_back(Vector3(s.x, s.y, -s.z))
	lines.push_back(Vector3(s.x, -s.y, -s.z))
	lines.push_back(Vector3(-s.x, s.y, -s.z))
	lines.push_back(Vector3(-s.x, -s.y, -s.z))
	
	lines.push_back(Vector3(s.x, s.y, s.z))
	lines.push_back(Vector3(s.x, s.y, -s.z))
	lines.push_back(Vector3(-s.x, s.y, s.z))
	lines.push_back(Vector3(-s.x, s.y, -s.z))
	lines.push_back(Vector3(s.x, -s.y, s.z))
	lines.push_back(Vector3(s.x, -s.y, -s.z))
	lines.push_back(Vector3(-s.x, -s.y, s.z))
	lines.push_back(Vector3(-s.x, -s.y, -s.z))
	
	gizmo.add_lines(lines, get_material("lines", gizmo))
