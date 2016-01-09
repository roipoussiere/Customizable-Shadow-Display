# How to render sun simulations

## 1. Download Blender
[Here](https://www.blender.org/download/). You need a recent version (>= 2.76)

## 2. Install the addon
- Download the [Sun position addon](http://wiki.blender.org/index.php/Extensions:2.6/Py/Scripts/3D_interaction/Sun_Position);
- On Blender, go to *File*, *preferences*, *Addon* tab;
- Click on *install from file* on the bottom and select the addon ;
- Then check it on the addons list, save user settings and exit the window.

## 3. Enable and configure the addon
- On the right panel, select *world view* (small rounded icon);
- On the *Sun position* tab (on the bottom), click *Enable*;
- Then click on the calendar icon to display the days numbers;

## 4. Launching the script
- Select the *Text editor* editor type, by clicking on the small icon on the bottom-left corner;
- Click on the button *Text*, then *Open text block* then select the python script in the repository
(*Customizable-Digital-Sundial/blender/sundial_simulator.py*);
- Save your Blender scene where you want;
- Click on *Run script*
- You can eventually edit *Scene_parameters.txt* and *Keyframes_parameters.csv*
to place correctly the sundial and the camera, then run the script again.

## 5. Rendering
- On the right panel, select the *Render view* (camera icon);
- On the *Output* tab, chose a destination folder and the video encoding.
Select a low resolution first, to check the sundial and camera positions;
- On the *Render* tab, click on *Animation*;
- Edit eventually *Scene_parameters.txt* and *Keyframes_parameters.csv*
to place correctly the sundial and the camera, then run the script again;
- Choose a high resolution and render the scene again.
