# Navmesh AABB Eraser (Godot Addon)
Allows removing areas of a navmesh defined by scene-placed AABB-nodes (also provided by the addon).
Only removes whole polygons whose points fall inside the AABB, does not clip them to their precise bounds (for now?) - see screenshot

Mainly useful to remove unused floating islands that tend to almost always be generated when baking heightmaps.

![alt text](https://github.com/Flavelius/godot-navmesh-eraser/blob/main/Images/removal_preview.jpg?raw=true)
