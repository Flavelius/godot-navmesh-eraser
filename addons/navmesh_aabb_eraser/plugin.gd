tool
extends EditorPlugin

var type_script: Script = preload("./AABBNode.gd")
var gizmo_plugin: Script = preload("./AABBNodeGizmoPlugin.gd")
var plugin_instance: EditorSpatialGizmoPlugin = null
var button_instance: Button = null

var edited_obj: NavigationMeshInstance = null

func _enter_tree():
	edited_obj = null
	if plugin_instance == null:
		plugin_instance = gizmo_plugin.new()
	if button_instance == null:
		button_instance = Button.new()
		button_instance.text = "Clip"
		button_instance.connect("pressed", self, "on_clip")
		button_instance.visible = false
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button_instance)
	add_spatial_gizmo_plugin(plugin_instance)
	add_custom_type("AABBNode", "Spatial", type_script, get_editor_interface().get_base_control().get_icon("RoomBounds", "EditorIcons"))

func _exit_tree():
	edited_obj = null
	if plugin_instance != null:
		remove_spatial_gizmo_plugin(plugin_instance)
	if button_instance != null:
		button_instance.disconnect("pressed", self, "on_clip")
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button_instance)
		button_instance.queue_free()
	remove_custom_type("AABBNode")

func clear():
	edited_obj = null

func handles(object):
	return object is NavigationMeshInstance
	
func make_visible(visible):
	if button_instance != null:
		button_instance.visible = visible
	if visible == false:
		edited_obj = null
		
func edit(object):
	if not object is NavigationMeshInstance:
		return
	edited_obj = object

func on_clip():
	if edited_obj == null:
		printerr("invalid state - edited object is null")
		return
	modify(edited_obj)

func get_sub_boxes(target: Spatial) -> Array:
	var children = target.get_children()
	var ret = Array()
	for c in children:
		if c is AABBNode:
			ret.append(c.get_global_bounds())
	return ret
	
func has_point(boxes: Array, point: Vector3) -> bool:
	for box in boxes:
		if box.has_point(point):
			return true
	return false
	
func modify(target: NavigationMeshInstance):
	var navmesh = target.navmesh
	if navmesh == null:
		return
	var boxes = get_sub_boxes(target)
	if boxes.size() == 0:
		print("no removal areas (AABBNode) found")
		return
	var indices : Array = Array()
	var vertices : PoolVector3Array = PoolVector3Array()
	var existing_vertices : PoolVector3Array = navmesh.get_vertices()
	for i in navmesh.get_polygon_count():
		var p = navmesh.get_polygon(i) as PoolIntArray
		var is_inside: bool = false
		for	p_idx in p:
			var global_point = target.to_global(existing_vertices[p_idx])
			if has_point(boxes, global_point):
				is_inside = true
				break
		if is_inside:
			continue
		var p_arr = PoolIntArray()
		for p_idx in p:
			p_arr.append(vertices.size())
			vertices.append(existing_vertices[p_idx])
		indices.append(p_arr)
	navmesh.clear_polygons()
	navmesh.set_vertices(vertices)
	for p in indices:
		navmesh.add_polygon(p)
