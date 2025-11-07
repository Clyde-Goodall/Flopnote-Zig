# Flipnote Spiritual Clone MK II

## Rambling
This is my second attempt at a Flipnote-like in Zig and Raylib, after coming back to it after a year or so. It's extremely early stage, so really only the skeleton of the UI while I build the internals out.

## Technical Details
- The playback speed increments 1 - 8 are a range of .5 to 30 FPS
- Color palette:
  - black: #000000
  - blue: #3000FB
  - red: #fb0030
  - white: #ffffff
- Drawing:
  - Pencil:
    - 16 brush options (8 are shown, while the other 8 require the L/R pressed)
  - Paint:
    - 16 brush options (8 are shown, while the other 8 require the L/R pressed)
  - Eraser:
    - 16 brush options (8 are shown, while the other 8 require the L/R pressed)
    - first 8 are solid. second 8 are based on the pattern currently selecte for paint.
    - I may take a creative liberty here and not directly link eraser and paint selections
- Layers:
  - There are 2 layers in the original DSi version. (3DS version has 3)
  - You can merge the 2 layers upwards or downwards
  - You can toggle copying the contents of the frame on new frame creation
  - Gotta figure out the drafting tool mechanics still**
  - You can also change the page background color, toggleable to black or white.
