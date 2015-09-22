# kicad.js

kicad footprint viewer

## Compilation

I'm unable to code in JavaScript without screaming every few minutes so I did
kicad.js in coffeescript. You can compile it to JavaScript by installing
coffeescipt. it should be available in your standard distribution packages or
at [coffeescript.org](http://coffeescript.org/).

## Installation

Just put kicad.js where you usually put your JavaScript files. You will also
need [jQuery](http://coffeescript.org/) v2.1.4 or later. I haven't tested any
earlier versions. Maybe they work too.

## Usage

Here's a simple snippet that shows how to use kicad.js:

```
<canvas id="kicadviewer" width="480" height="320"></canvas>

<script src="kicad.js"></script>
<script>
$(function() {
    $.get('/Teensy3.x_LC.kicad_mod', function(data) {
        draw_kicad('kicad', data);
    });
});
</script>
```

First you need to create a `<canvas>` element somewhere. Give it an id. Then
preferebly at the bottom of the page load the kicad.js file. After that make
another `<script>` block where you load the actual kicad footprint file -
usually ends with .kicad_mod and load it into a string. In this example this is
done with an asynchronous AJAX call.

Finally call the `draw_kicad(element, data)` function with the id of the
element to draw on and the footprint file as a string.

If everything works it should look like this:

![screenshot](https://github.com/xengi/kicad.js/raw/master/screenshot.png "Screenshot")
