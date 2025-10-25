# Flipnote Spiritual Clone MK II

## Canvas Plans, Rambling, and Pontificating
To handle actual canvas drawing, I think the optimal method for me, at least what I can think of on my own, is to general layer clusters, one for each layer mask type, e.g. light to dark paint patterns, and solid colors. These masks will be, well, masked by a bool for each point in what boils down to a 2D array. Drawing will only flip points based on the additive tools being used, while subtractive (eraser) will flip all layers in a cluster.

Colors will initially be limited, like the original flipnote, that is, black, red, and blue. In theory, I can just support any number of colors by generating a layer cluster at the top of the layer cluster stack when a new color is picked. In fact, that is much like how I would likely handle having multiple layers at the user level. 

This does, however, make the term "layer" fairly misleading when discussing both UX and internal design. Hence, why I describe the grouping of the different pattersn as layer clusters. I am considering namespacing what a user might describe as a layer at a UX level, a LayerColorCluster, MaskLayerGroup, or more plainly, CompositeLayer. In the original flipnote, there were only two layers available, assigned to  and you could swap them via L/R shoulder bindings.

This is simply one collision of many between keeping faithful to an original thing while providing some quality of life improvements. That's a a real balancing act. Would I be sliding towards a more modern design if I added more complex layer management? Of course, and it would also offer better control for creators, but until I implement it, I don't know how alien it would feel versus the original.

At the same time, this is all quite superficial, and mostly pointless, because I was never *going* to be making a 1:1 replication. It wouldn't even make sense to, as the original form factor is utterly foreign compared to my target platform(s), which are single screen. So ultimately, the goal is to replicate the features from the original as fluently as possible into a one-window design. There will be plenty of concessions made in that translation, but, nonetheless, adding in features that didn't exist in the original program is really a different matter altogether so long as it isn't the result of a compromise made to translate a feature to this form factor. 

The underlying question that I think about now is, how does one capture the essence of something without copying it wholecloth? My default gut feeling is that it's actually less about the discrete features themselves, but more the environmental aspects. Sound effects, animation, visual design language, layout, etc. are all *vital* to Nintendo interfaces, much like any handlheld, dual-screen or not, guided in no small part by the inherent limitations and constraints of the platform it was design for. 

I could make a simple flipbook animation ware, and it could have all the same features, but if it doesn't have the same springy animations, colorful transitions, iconography, with all of the tools nested as minimally as possible,

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