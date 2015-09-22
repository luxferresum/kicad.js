color = {}
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
color['F.Crtyd'] = {'r': 132, 'g': 132, 'b': 132}
color['B.CrtYd'] = {'r': 0, 'g': 0, 'b': 0}
color['F.Fab'] = {'r': 194, 'g': 194, 'b': 0}
color['B.Fab'] = {'r': 132, 'g': 0, 'b': 0}

draw_line = (c, line) ->
    c.strokeStyle = "rgba(#{color[line['layer']]['r']},
                          #{color[line['layer']]['g']},
                          #{color[line['layer']]['b']},
                          1)"
    c.lineWidth = 3.0
    c.lineCap = 'square'
    c.beginPath()
    c.moveTo(line['x1'], line['y1'])
    c.lineTo(line['x2'], line['y2'])
    c.stroke()


window.draw_kicad = (element, data) ->
    if element.indexOf('#') == 0
        element = element.substring(1)
    canvas = document.getElementById(element)

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
        # save all lines in a list to draw them later
        fp_lines = []

        # read pretty file
        lines = data.split('\n')
        for line in lines
            line = line.trim()

            # regex for fp_line
            fp_line = /\(fp_line\ \(start\ ([-.\d]*)\ ([-.\d]*)\)\ \(end\ ([-.\d]*)\ ([-.\d]*)\)\ \(layer\ ([.a-zA-Z]*)\)\ \(width\ ([-.\d]*)\)\)/g
            while((m = fp_line.exec(line)) != null)
                if (m.index == fp_line.lastIndex)
                    fp_line.lastIndex++

                min_x = Math.min.apply(Math, [m[1], m[3]])
                max_x = Math.max.apply(Math, [m[1], m[3]])
                min_y = Math.min.apply(Math, [m[2], m[4]])
                max_y = Math.max.apply(Math, [m[2], m[4]])
                if min_x < left
                    left = min_x
                if max_x > right
                    right = max_x
                if min_y < top
                    top = min_y
                if max_y > bottom
                    bottom = max_y

                line = {}
                line['x1'] = m[1]
                line['y1'] = m[2]
                line['x2'] = m[3]
                line['y2'] = m[4]
                line['layer'] = m[5]
                line['width'] = m[6]

                fp_lines.push(line)

        console.log("found #{fp_lines.length} lines")
        console.log("left: #{left}; top: #{top}; right: #{right}; bottom: #{bottom}")

        for line in fp_lines
            padding = 10
            cw = (canvas.width - padding) / 2
            ch = (canvas.height - padding) / 2
            #line['x1'] = (cw * line['x1']) / max_x + cw
            #line['y1'] = (ch * line['y1']) / max_y + ch
            #line['x2'] = (cw * line['x2']) / max_x + cw
            #line['y2'] = (ch * line['y2']) / max_y + ch
            line['x1'] = line['x1'] * 10 + cw
            line['y1'] = line['y1'] * 10 + ch
            line['x2'] = line['x2'] * 10 + cw
            line['y2'] = line['y2'] * 10 + ch
            draw_line(context, line)

