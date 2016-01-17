# Customizable Shadow Display
A digital display which displays whatever you want, whenever you want. No batteries, no motor, no electronics, only a 3D-printed object and its shadow.

See the [GitHub repository](https://github.com/roipoussiere/Customizable-Shadow-Display) and the [Thingiverse](http://www.thingiverse.com/thing:1253190) page.

![Sundial simulation](https://raw.githubusercontent.com/roipoussiere/Customizable-Shadow-Display/master/images/simulation.jpg)

![3D-printed part](https://raw.githubusercontent.com/roipoussiere/Customizable-Shadow-Display/master/images/numbers_printed.jpg)

![shadow](https://raw.githubusercontent.com/roipoussiere/Customizable-Shadow-Display/master/images/numbers_shadow.jpg)

## About the original Digital Sundial

This work is inspirated by the Mojoptix project [Mojoptix project](http://www.thingiverse.com/thing:1068443), who describes the sundial as it:

> It's a Sundial displaying the time inside its shadow, with actual digits !
> There is a tiny bit of magic inside...
>
> No batteries, no motor, no electronics... It's all just a really super-fancy shadow show. The shape of the sundial has been mathematically designed to only let through the right sunrays at the right time/angle. This allows to display the actual time with sunlit digits inside the sundial's shadow.
>
> The sundial displays time (with actual digits !!) from 10:00 until 16:00, updating every 20 minutes.
> You can precisely adjust the displayed time simply by rotating the gnomon (the magic box that displays time). So you can even adjust for Daylight Saving Time.

![Original project](https://raw.githubusercontent.com/roipoussiere/Customizable-Digital-Sundial/master/images/original.jpg)

Its [video podcast](http://www.mojoptix.com/2015/10/25/mojoptix-001-digital-sundial) describes this sundial in details.

## The customizable shadow display

Contrary to the Mojoptix sundial, this one allows you to display, instead of the clock numbers, whatever and whenever you want. The displayed text can be as long as you want, and can contain all usual characters. In addition, you can customize a lot a others parameters, like the digits duration or the gnomon shape.

See [the simulation](https://www.youtube.com/watch?v=YztbfwrANII&feature=youtu.be) on Youtube for the [quick_fox.stl](http://www.thingiverse.com/download:1956136) example.

The attached STL files are not required, it's just few items made with the Customizer app to show you what you can do (see *Text* option bellow).

**Note:** When rendering the sundial, you may get CGal warnings saying there are a lot of elements. If you are using the Customizer app, just ignore them. If you are using OpenSCAD on you own computer, you can increase the value of parameters *Tun off rendering at* and *cache size* in the OpenSCAD preference window.

## Available Customizer options

#### Main options

- **Text**: the text displayed on the shadow of the sundial, for each position, separated by semi-colons. For example, if you want to display "Hello", then "world" few minutes later, set this field to `Hello;world`. Try with these ones:
    - [quick_fox.stl](http://www.thingiverse.com/download:1956136): `The;quick;brown;fox;jumps;over;the;lazy;dog.`
    - [clock.stl](http://www.thingiverse.com/download:1956139): `10:00;10:20;10:40;11:00;11:20;11:40;12:00;12:20;12:40;13:00;` `13:20;13:40;14:00;14:20;14:40;15:00;15:20;15:40;16:00`
    - [numbers.stl](http://www.thingiverse.com/download:1956175): `0;1;2;3;4;5;6;7;8;9`
- **Digits duration**: the duration of each text, according to the sun rotation.
- **Hemisphere**: just select where you are;
- **basic shape** of the gnomon:
    - a half-cylinder;
    - a "boat", which is an optimized shape because each hole has the same depth.
- **holder**: to print (or not) a holder which fixes the gnomon (with a screw). The holder is Mojoptix-compatible.
- **rod**: print a pipe to hold several digits together with a rod. So you can print a 1 meter long sundial, with your 12x12 printer. ;-)
-  **font**: Font used to display the text, among 2 available fonts:
    - numbers, with 4x6 digits: `0-9`, and `:`. If your text contains other characters, an error will occurs.
    - ASCII, with 5x7 digits: `0-9`, `a-z`, `A-Z`, and ` !\"#%$&'()*+,-./:;<=>?@[\]^_``{|}~¤`, where `~` and `¤` are respectively a full black digit and a heart. Note that you can easily customize and / or add fonts by editing the scad file.
- **transition delay**: during a transition, all pixels turns to black. With no transition (0%), the piece contains less material (so it's faster to print), but digits are sometimes not clear.

#### Advanced parameters

- **remove_thin_parts** : Remove parts smaller than the specified size. This option take a very long time to process, like few hours (because it calls 2 minkowski sums). It's better to use it in your computer (not with the Customizer app). Edit the .scad with your parameters, save it and make the stl file in command line : `openscad -o sundial.stl main.scad`. It will use the OpenCSG render engine, which is faster than the CGAL render for this use case.
- **gnomon radius**
- **pixel width**
- **pixel height**
- **space between columns**
- **space between rows**
- **space between digits**
- **enlarge slots** : Enlarge the slots on the bottom on the gnomon. Big slots should improve digits readability, but can also unintentionally turn some pixels to white.
- **screw size** : the screw size used to hold the gnomon.

## Instructions

#### Step by step
- Customize your sundial with the *Makerbot Customizer* interface, then download it;
- verify the item with a rendering software (OpenSCAD, Netfabb, Blender, ...), and check the digits on each position (then eventually re-customize it). Prefer an orthogonal view than a perspective view to watch the item;
- print it with the settings bellow;
- print the other pieces [from here](www.thingiverse.com/thing:1068443);
- Put them together and enjoy;
- Please take a picture and share it on Thingiverse (by clicking on *I made
one*). I am always so happy to see what people make with my work! :-)

A bonus point to the first who prints a "sundial powered word clock", which displays the time each 15 minutes, in its literal form. :-D

#### Other required parts
- an (empty !) jam jar;
- 3x M6 screws, flat head, length = 20 mm;
- 1x M6 screw, flat head, length = 50 mm;
- 4x M6 nuts;
- 4x M6 washer, outside diameter < 14mm;

#### Print settings
Tested on a Up! Plus.

- **Raft**: Yes
- **Supports**: No
- **Resolution**: 0.15mm
- **Infill**: 10%
- **Print quality**: fast
- **Print thin parts**: No

## GitHub repository

The entire code is documented and easy to read and modify.

See the [GitHub repository](https://github.com/roipoussiere/Customizable-Digital-Sundial) , it's easier to work from here and there is additional useful files (like Python and Blender scripts).

#### OpenSCAD scripts
For more readability, the .scad script is splitted in 3 files: *main*, *functions* and *fonts*.

The *functions* file uses a part of my [OpenSCAD library](http://www.thingiverse.com/thing:202724) for string and vectors operations. Take a look.

#### Python scripts
- **merge.py**: Prepare the .scad file to be uploaded on Thingiverse:
  - replace the parameters by the default parameters;
  - replace the `<include>` declarations by their contents (Customizer app doesn't supports multiple .scad files.);
  - remove lines containing `/*TODO` or `/*NOTE`.
- **compare.py**: Compare 2 .scad files representing a sundial. It slice the 3D-models in a given position, then generates a picture showing the 2 superposed slices.
- **decode_font.py**: Decode an array of numbers in hexadecimal notation and print it as a decimal array, to you use it on OpenSCAD (which doesn't support hexadecimal notation).
- **default_parameters**: a file containing default parameters, then you can modify them when you code without to be worried about publishing the file containing test parameters)

#### Blender script
This script allows you to simulate the sun shinning on the sundial. Watch [the video](https://www.youtube.com/watch?v=YztbfwrANII&feature=youtu.be) of a simulation, rendered with it.

Read [README](https://github.com/roipoussiere/Customizable-Digital-Sundial/tree/master/blender) to know how to use it.

## To come

- pixel-art display support, by editing images on a web interface;
- a video of the sundial in action (I am waiting for the sun);
- any suggested feature! ;-)

Please contact me for features or bug requests!
