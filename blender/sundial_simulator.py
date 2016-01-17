# Author: Mojoptix
# Email: julldozer@mojoptix.com
# Date: october 13, 2015
# GPL v2: http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1

# This script prepare a Blender scene in order to render a simulation of the sun
# enlightening the gnomon over the day. See readme.md for more informations.

import bpy #Imports the Blender Python API
import mathutils #Imports Blender vector math utilities
import math #Imports the standard Python math library
import os #Imports some Miscellaneous operating system interfaces
import csv #Imports CSV File Reading & Writing tools
import configparser #Imports the configuration file parser



# camera(x,y,z),camera(rx,ry,rz)
# FLAG jpg/avi,
# avi filename

# [CSV]: date, time, geo location, output filename.jpg


#PARAMETERS =================================
Scene_parameters_filename = 'Scene_parameters.txt'   # the file with the parameters to setup the scene
Keyframes_paremeters_filename = 'Keyframes_parameters.csv' # the file with the parameters for each keyframe


# READ scene parameter file
os.chdir(bpy.path.abspath("//")) # Go to the folder where the .blend file is
config_scene = configparser.ConfigParser()
config_scene.read(Scene_parameters_filename)
STL_filename = config_scene.get("Parameters", "STL_filename")
STL_scale_x = float(config_scene.get("Parameters", "STL_scale_x"))
STL_scale_y = float(config_scene.get("Parameters", "STL_scale_y"))
STL_scale_z = float(config_scene.get("Parameters", "STL_scale_z"))
STL_position_x = float(config_scene.get("Parameters", "STL_position_x"))
STL_position_y = float(config_scene.get("Parameters", "STL_position_y"))
STL_position_z = float(config_scene.get("Parameters", "STL_position_z"))
STL_rotation_x = math.radians( float(config_scene.get("Parameters", "STL_rotation_x")) )
STL_rotation_y = math.radians( float(config_scene.get("Parameters", "STL_rotation_y")) )
STL_rotation_z = math.radians( float(config_scene.get("Parameters", "STL_rotation_z")) )


#SETUP SCENE =================================
# Switch to Cycles render engine
if not bpy.context.scene.render.engine == 'CYCLES':
    bpy.context.scene.render.engine = 'CYCLES'

# Clear the scene
bpy.ops.object.mode_set(mode='OBJECT')
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=True)

# Create ground surface
bpy.ops.mesh.primitive_cylinder_add(radius=50, depth=2, location=(0, 0, -1))
Ground_surface = bpy.context.object
mat_ground = bpy.data.materials.new("Ground_Material")
mat_ground.diffuse_color = (1,1,1)
Ground_surface.active_material = mat_ground
mat_ground.use_nodes = True
mat_ground.node_tree.nodes['Diffuse BSDF'].inputs['Roughness'].default_value = 1.0
'''glossyBSDF.inputs["Color"].default_value = [1.0, 1.0, 1.0, 1.0]
glossyBSDF = mat_ground.node_tree.nodes.new('ShaderNodeBsdfGlossy')
glossyBSDF.name = "Glossy BSDF"
glossyBSDF.inputs["Color"].default_value = [1.0, 1.0, 1.0, 1.0]
matOutput = mat_ground.node_tree.nodes['Material Output']
link_input = matOutput.inputs['Surface']
link_output = glossyBSDF.outputs['BSDF']
mat_ground.node_tree.links.new(link_input, link_output)'''
Ground_surface.name = 'GroundSurface'

# Indicate North
bpy.ops.mesh.primitive_cube_add(location=(0,50,0))
bpy.ops.transform.resize(value=(0.001,50,0.001))
North_direction = bpy.context.object
mat = bpy.data.materials.new("North_mat")
mat.diffuse_color = (.8,.8,1.0)
North_direction.active_material = mat
North_direction.name = 'NorthDirection'

# Add STL object
bpy.ops.import_mesh.stl(filter_glob="*.stl",  files=[{"name":STL_filename, "name":STL_filename}], directory="")
bpy.ops.transform.resize(value=(STL_scale_x,STL_scale_y,STL_scale_z))
The_STL = bpy.context.object
The_STL.location = (STL_position_x, STL_position_y, STL_position_z)
The_STL.rotation_mode = 'XYZ'
The_STL.rotation_euler = (STL_rotation_x, STL_rotation_y, STL_rotation_z)

# Create Camera
bpy.ops.object.camera_add(location=(0,-5,3.5), rotation=(math.radians(60),0,0))
The_camera = bpy.context.object
The_camera.name = 'TheCamera'

# Create Sun
bpy.ops.object.lamp_add(type='SUN', radius=0.0053, location=(1,1,1))
The_sun = bpy.context.object
The_sun.name = 'TheSun'
bpy.context.scene.SunPos_property.UseSunObject = True
The_sun.data.node_tree.nodes['Emission'].inputs['Strength'].default_value = 5  # Set the "Light Intensity"
bpy.context.scene.SunPos_property.SunObject = "TheSun"

# Some rendering optimizations
# no light bounces
bpy.context.object.data.cycles.max_bounces = 0
bpy.context.scene.cycles.min_bounces = 0
bpy.context.scene.cycles.max_bounces = 0
bpy.context.scene.cycles.transparent_max_bounces = 0
bpy.context.scene.cycles.transparent_min_bounces = 0
bpy.context.scene.cycles.transparent_max_bounces = 0
bpy.context.scene.cycles.transparent_min_bounces = 0
bpy.context.scene.cycles.diffuse_bounces = 0
bpy.context.scene.cycles.glossy_bounces = 0
bpy.context.scene.cycles.transmission_bounces = 0
bpy.context.scene.cycles.volume_bounces = 0

# no caustics
bpy.context.scene.cycles.caustics_reflective = False
bpy.context.scene.cycles.caustics_refractive = False


#SETUP KEYFRAMES =================================
# note: keyframes parameters (position, rotation) are additive to the scene parameters

# Clear keyframes
The_STL.animation_data_clear()
The_camera.animation_data_clear()
bpy.context.scene.animation_data_clear()

# Open the CSV file
frame_start = -1 # variable initialization
frame_end = -1 # variable initialization
with open(Keyframes_paremeters_filename ,'r') as csvfile:
    dialect = csv.Sniffer().sniff(csvfile.read(1024))   # guess the file format
    csvfile.seek(0)
    reader = csv.reader(csvfile, dialect)
    next(csvfile)   # skip the first line (reserved for describing the content)

    # Loop through the keyframes
    for row in reader:
        print(row)
        # Read the parameter for a keyframe
        STL_x = float(row[0])
        STL_y = float(row[1])
        STL_z = float(row[2])
        STL_rot_x = math.radians(float(row[3]))
        STL_rot_y = math.radians(float(row[4]))
        STL_rot_z = math.radians(float(row[5]))

        camera_x = float(row[6])
        camera_y = float(row[7])
        camera_z = float(row[8])
        camera_rot_x = math.radians(float(row[9]))
        camera_rot_y = math.radians(float(row[10]))
        camera_rot_z = math.radians(float(row[11]))

        the_latitude = float(row[12])
        the_longitude = float(row[13])
        the_UTC_zone = float(row[14])
        the_year = float(row[15])
        the_day_of_year = float(row[16])
        the_time = float(row[17])
        the_DST = ( row[18] == '1' )

        frame_number = int(row[19])
        if ((frame_start == -1) or (frame_start > frame_number)): frame_start = frame_number
        if ((frame_end == -1) or (frame_end < frame_number)): frame_end = frame_number

        # Set the current frame to frame_number
        bpy.context.scene.frame_set(frame_number)

        # Move object (relative to the scene parameters)
        The_STL.location = (STL_position_x+STL_x, STL_position_y+STL_y, STL_position_z+STL_z)
        The_STL.keyframe_insert(data_path="location")
        The_STL.rotation_euler = (STL_rotation_x+STL_rot_x, STL_rotation_y+STL_rot_y, STL_rotation_z+STL_rot_z)
        The_STL.keyframe_insert(data_path="rotation_euler")

        # Move camera
        The_camera.location = (camera_x, camera_y, camera_z)
        The_camera.keyframe_insert(data_path="location")
        The_camera.rotation_euler = (camera_rot_x, camera_rot_y, camera_rot_z)
        The_camera.keyframe_insert(data_path="rotation_euler")

        # Move sun
        bpy.context.scene.SunPos_property.Latitude = the_latitude   # in degrees, + or -
        bpy.context.scene.keyframe_insert(data_path="SunPos_property.Latitude")
        bpy.context.scene.SunPos_property.Longitude = the_longitude # in degrees, + or -
        bpy.context.scene.keyframe_insert(data_path="SunPos_property.Longitude")
        bpy.context.scene.SunPos_property.UTCzone = the_UTC_zone    # difference from Greenwich time in hours
        bpy.context.scene.keyframe_insert(data_path="SunPos_property.UTCzone")
        bpy.context.scene.SunPos_property.Year = the_year
        bpy.context.scene.keyframe_insert(data_path="SunPos_property.Year")
        bpy.context.scene.SunPos_property.Day_of_year = the_day_of_year
        bpy.context.scene.keyframe_insert(data_path="SunPos_property.Day_of_year")
        bpy.context.scene.SunPos_property.Time = the_time
        bpy.context.scene.keyframe_insert(data_path="SunPos_property.Time")
        bpy.context.scene.SunPos_property.DaylightSavings = the_DST # add 1 hours to standard time
        bpy.context.scene.keyframe_insert(data_path="SunPos_property.DaylightSavings")

# Set the interpolation mode to LINEAR (instead of the default: BEZIER)
# For the STL object
obj = The_STL
fcurves = obj.animation_data.action.fcurves
for fcurve in fcurves:
    for kf in fcurve.keyframe_points:
        kf.interpolation = 'LINEAR'
# For the camera
obj = The_camera
fcurves = obj.animation_data.action.fcurves
for fcurve in fcurves:
    for kf in fcurve.keyframe_points:
        kf.interpolation = 'LINEAR'
# For the sun
obj = bpy.context.scene
fcurves = obj.animation_data.action.fcurves
for fcurve in fcurves:
    for kf in fcurve.keyframe_points:
        kf.interpolation = 'LINEAR'



# Set the frame range
bpy.context.scene.frame_start = frame_start
bpy.context.scene.frame_end = frame_end
bpy.context.scene.frame_current = frame_start # go to the 1st frame
