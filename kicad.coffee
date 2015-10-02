# kicad.js v0.1.0
# (c) 2015 Ricardo (XenGi) Band


color = {}
color['Fg'] = {'r': 255, 'g': 255, 'b': 255}
color['Bg'] = {'r': 0, 'g': 0, 'b': 0}
color['F.Cu'] = {'r': 132, 'g': 0, 'b': 0}
color['B.Cu'] = {'r': 0, 'g': 132, 'b': 0}
color['F.Adhes'] = {'r': 132, 'g': 0, 'b': 132}
color['B.Adhes'] = {'r': 0, 'g': 0, 'b': 132}
color['F.Paste'] = {'r': 132, 'g': 0, 'b': 0}
color['B.Paste'] = {'r': 0, 'g': 194, 'b': 194}
color['F.SilkS'] = {'r': 0, 'g': 132, 'b': 132}
color['B.SilkS'] = {'r': 132, 'g': 0, 'b': 132}
color['F.Mask'] = {'r': 132, 'g': 0, 'b': 132}
color['B.Mask'] = {'r': 132, 'g': 132, 'b': 0}
color['Dwgs.User'] = {'r': 194, 'g': 194, 'b': 194}
color['Cmts.User'] = {'r': 0, 'g': 0, 'b': 132}
color['Eco1.User'] = {'r': 0, 'g': 132, 'b': 0}
color['Eco2.user'] = {'r': 194, 'g': 194, 'b': 0}
color['Egde.Cuts'] = {'r': 194, 'g': 194, 'b': 0}
color['Margin'] = {'r': 194, 'g': 0, 'b': 194}
color['F.CrtYd'] = {'r': 132, 'g': 132, 'b': 132}
color['B.CrtYd'] = {'r': 0, 'g': 0, 'b': 0}
color['F.Fab'] = {'r': 194, 'g': 194, 'b': 0}
color['B.Fab'] = {'r': 132, 'g': 0, 'b': 0}

draw_grid = (c, size, w, h) ->
    center_x = w / 2
    center_y = h / 2
    dots_x = parseInt(w / size)
    dots_x += dots_x % 2
    dots_y = parseInt(h / size)
    dots_y += dots_y % 2
    for x in [0..dots_x]
        for y in [0..dots_y]
            _x = x*size + center_x
            _y = y*size + center_y
            console.log("dot at #{_x},#{_y}")

            c.beginPath()
            c.strokeStyle = "rgba(132, 132, 132, 1)"
            c.arc(_x - dots_x / 2 * size, _y - dots_y / 2 * size, 1, 0, 2 * Math.PI, false)
            #c.lineWidth = 1
            c.stroke()


draw_fpline = (c, fpline) ->
    c.strokeStyle = "rgba(#{color[fpline['layer']]['r']},
                          #{color[fpline['layer']]['g']},
                          #{color[fpline['layer']]['b']},
                          1)"
    c.lineWidth = fpline['width']
    c.lineCap = 'square'
    c.beginPath()
    c.moveTo(fpline['x1'], fpline['y1'])
    c.lineTo(fpline['x2'], fpline['y2'])
    c.stroke()


draw_fpcircle = (c, fpcircle) ->
    c.beginPath()
    c.strokeStyle = "rgba(#{color[fpcircle['layer']]['r']},
                          #{color[fpcircle['layer']]['g']},
                          #{color[fpcircle['layer']]['b']},
                          1)"
    c.arc(fpcircle['center_x'], fpcircle['center_y'], fpcircle['radius'], 0, 2 * Math.PI, false)
    c.lineWidth = fpcircle['width']
    c.stroke()


draw_fparc = (c, fparc) ->
    # TODO: implement me!
    return


draw_fptext = (c, fptext) ->
    # TODO: implement me!
    return


draw_pad = (c, pad) ->
    if pad['shape'] == 'circle'
        c.beginPath()
        c.arc(pad['x'], pad['y'], pad['width'] / 2, 0, 2 * Math.PI, false)
        c.fillStyle = "rgba(#{color['B.Mask']['r']},
                            #{color['B.Mask']['g']},
                            #{color['B.Mask']['b']},
                            1)"
        c.fill()
    #else if pad['shape'] == 'oval'
        # TODO: implement me!
        #c.beginPath()
        #
        #c.fillStyle = "rgba(#{color['B.Mask']['r']},
        #                    #{color['B.Mask']['g']},
        #                    #{color['B.Mask']['b']},
        #                    1)"
        #c.fill()
    else if pad['shape'] == 'rect'
        c.beginPath()
        c.fillRect(pad['x'], pad['y'], pad['width'], pad['height'])
        c.fillStyle = "rgba(#{color['B.Mask']['r']},
                            #{color['B.Mask']['g']},
                            #{color['B.Mask']['b']},
                            1)"
        c.fill()

    if pad['type'] == 'thru_hole'
        c.beginPath()
        c.arc(pad['x'], pad['y'], pad['drill'] / 2, 0, 2 * Math.PI, false)
        c.fillStyle = "rgba(#{color['Bg']['r']},
                            #{color['Bg']['g']},
                            #{color['Bg']['b']},
                            1)"
        c.fill()
    #else if pad['type'] == 'np_thru_hole'
        # TODO: implement me!
    #else if pad['type'] == 'smd'
        # TODO: implement me!

    if pad['num'] != ''
        c.beginPath()
        c.textAlign = 'center'
        c.textBaseline = 'middle'
        c.fillStyle = "rgba(#{color['Fg']['r']},
                            #{color['Fg']['g']},
                            #{color['Fg']['b']},
                            1)"
        c.fillText(pad['num'], pad['x'], pad['y'])


draw_footprint = (canvas, data) ->
    if canvas.getContext
        context = canvas.getContext('2d')

        # draw background
        context.fillStyle = "rgb(#{color['Bg']['r']}, #{color['Bg']['g']}, #{color['Bg']['b']})"
        context.fillRect(0, 0, canvas.width, canvas.height)

        # set outer boundaries of pretty file
        left = 0
        top = 0
        right = 0
        bottom = 0

        update_dimensions = (x, y) ->
            if parseFloat(x) < parseFloat(left)
                left = x
            else if parseFloat(x) > parseFloat(right)
                right = x
            if parseFloat(y) < parseFloat(bottom)
                bottom = y
            else if parseFloat(y) > parseFloat(top)
                top = y

        # save all lines in a list to draw them later
        fp_lines = []
        fp_circles = []
        fp_arcs = []
        fp_texts = []
        pads = []

        # read pretty file
        prettylines = data.split('\n')
        for l in prettylines
            l = l.trim()

            regex_fpline = /\(fp_line\ \(start\ ([-.\d]*)\ ([-.\d]*)\)\ \(end\ ([-.\d]*)\ ([-.\d]*)\)\ \(layer\ ([.a-zA-Z]*)\)\ \(width\ ([-.\d]*)\)\)/g
            while((m = regex_fpline.exec(l)) != null)
            # TODO: forgot what the next 2 lines do..
                if (m.index == regex_fpline.lastIndex)
                    regex_fpline.lastIndex++

                fp_line = {}
                fp_line['x1'] = parseFloat(m[1])
                fp_line['y1'] = parseFloat(m[2])
                fp_line['x2'] = parseFloat(m[3])
                fp_line['y2'] = parseFloat(m[4])
                fp_line['layer'] = m[5]
                fp_line['width'] = parseFloat(m[6])

                update_dimensions(fp_line['x1'], fp_line['y1'])
                update_dimensions(fp_line['x2'], fp_line['y2'])

                fp_lines.push(fp_line)


            regex_fpcircle = /\(fp_circle\ \(center\ ([-.\d]+)\ ([-.\d]+)\)\ \(end\ ([-.\d]+)\ ([-.\d]+)\)\ \(layer\ ([.\w]+)\)\ \(width\ ([.\d]+)\)\)/g
            while((m = regex_fpcircle.exec(l)) != null)
                if(m.index == regex_fpcircle.astIndex)
                    regex_fpcircle.lastIndex++

                fp_circle = {}
                fp_circle['center_x'] = parseFloat(m[1])
                fp_circle['center_y'] = parseFloat(m[2])
                x = parseFloat(m[3])
                y = parseFloat(m[4])
                fp_circle['radius'] = Math.sqrt(Math.pow(fp_circle['center_x'] - x, 2) +
                                                Math.pow(fp_circle['center_y'] - y, 2))
                fp_circle['layer'] = m[5]
                fp_circle['width'] = parseFloat(m[6])

                update_dimensions(fp_circle['center_x'] - fp_circle['radius'],
                                  fp_circle['center_y'] - fp_circle['radius'])
                update_dimensions(fp_circle['center_x'] + fp_circle['radius'],
                                  fp_circle['center_y'] + fp_circle['radius'])

                fp_circles.push(fp_circle)


            regex_pad = /\(pad\ ([\d]*)\ ([_a-z]*)\ ([a-z]*)\ \(at\ ([-.\d]*)\ ([-.\d]*)\)\ \(size\ ([.\d]*)\ ([.\d]*)\)\ \(drill\ ([.\d]*)\)\ \(layers\ ([\w\d\s\.\*]*)\)\)/g
            while((m = regex_pad.exec(l)) != null)
            # TODO: forgot what the next 2 lines do..
                if (m.index == regex_pad.lastIndex)
                    regex_pad.lastIndex++

                pad = {}
                pad['num'] = ''
                if m[1] != '""'
                    pad['num'] = m[1]
                pad['type'] = m[2]
                pad['shape'] = m[3]
                pad['x'] = parseFloat(m[4])
                pad['y'] = parseFloat(m[5])
                pad['width'] = parseFloat(m[6])
                pad['height'] = parseFloat(m[7])
                pad['drill'] = parseFloat(m[8])
                pad['layers'] = m[9].split(' ')

                update_dimensions(pad['x'] - pad['width'] / 2,
                                  pad['y'] - pad['height'] / 2)
                update_dimensions(pad['x'] + pad['width'] / 2,
                                  pad['y'] + pad['height'] / 2)

                pads.push(pad)

        console.log("DEBUG: found #{fp_lines.length} fp_lines")
        console.log("DEBUG: found #{fp_circles.length} fp_circles")
        console.log("DEBUG: found #{fp_arcs.length} fp_arcs")
        console.log("DEBUG: found #{fp_texts.length} fp_texts")
        console.log("DEBUG: found #{pads.length} pads")

        # calculate zoom factor
        cw = canvas.width / 2
        ch = canvas.height / 2
        maxw = Math.max(Math.abs(left), Math.abs(right))
        maxh = Math.max(Math.abs(top), Math.abs(bottom))
        zoom = Math.min((cw - 10) / maxw, (ch - 10) / maxh)

        console.log("DEBUG: max dimensions: left=#{left}; right=#{right}; top=#{top}; bottom=#{bottom}")
        console.log("DEBUG: zoom: #{zoom}")


        # draw everything
        draw_grid(context, 1.27 * zoom, canvas.width, canvas.height)

        for fpline in fp_lines
            # translate coords
            fpline['x1'] = fpline['x1'] * zoom + cw
            fpline['y1'] = fpline['y1'] * zoom + ch
            fpline['x2'] = fpline['x2'] * zoom + cw
            fpline['y2'] = fpline['y2'] * zoom + ch
            fpline['width'] *= zoom
            draw_fpline(context, fpline)

        for fpcircle in fp_circles
            fpcircle['center_x'] = fpcircle['center_x'] * zoom + cw
            fpcircle['center_y'] = fpcircle['center_y'] * zoom + ch
            fpcircle['radius'] *= zoom
            fpcircle['width'] *= zoom
            draw_fpcircle(context, fpcircle)

        for fparc in fp_arcs
            #fparc['center_x'] = fparc['center_x'] * zoom + cw
            #fparc['center_y'] = fparc['center_y'] * zoom + ch
            #fparc['width'] *= zoom
            draw_fparc(context, fparc)

        for fptext in fp_texts
            #fptext['center_x'] = fptext['center_x'] * zoom + cw
            #fptext['center_y'] = fptext['center_y'] * zoom + ch
            #fptext['width'] *= zoom
            draw_fptext(context, fptext)

        for pad in pads
            pad['x'] = pad['x'] * zoom + cw
            pad['y'] = pad['y'] * zoom + ch
            pad['width'] *= zoom
            pad['height'] *= zoom
            pad['drill'] *= zoom
            draw_pad(context, pad)

Kicad = (canvas) ->
    data = {};
    zoom = 0;
    this.render = () ->
    	draw_footprint(canvas, data);
    this.load = (d) ->
        data = d;

    this.zoom = (level) ->
        zoom = zoom + level;
        render()
    
    return this

if typeof(define) != 'undefined'
    define 'kicad', [], () ->
        return Kicad
else if typeof(module) != 'undefined' && typeof(moule.exports) != 'undefined'
    module.exports = Kicad
else if window
    window.Kicad = Kicad
else if global
    global.Kicad = Kicad
