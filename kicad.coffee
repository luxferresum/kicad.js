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
    c.lineWidth = line['width']
    c.lineCap = 'square'
    c.beginPath()
    c.moveTo(line['x1'], line['y1'])
    c.lineTo(line['x2'], line['y2'])
    c.stroke()


window.draw_kicad = (element, data) ->
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
        pads = []

        # read pretty file
        lines = data.split('\n')
        for line in lines
            line = line.trim()

            # regex for fp_line
            fp_line = /\(fp_line\ \(start\ ([-.\d]*)\ ([-.\d]*)\)\ \(end\ ([-.\d]*)\ ([-.\d]*)\)\ \(layer\ ([.a-zA-Z]*)\)\ \(width\ ([-.\d]*)\)\)/g
            while((m = fp_line.exec(line)) != null)
            # TODO: forgot what the next 2 lines do..
                if (m.index == fp_line.lastIndex)
                    fp_line.lastIndex++

                min_x = Math.min(m[1], m[3])
                max_x = Math.max(m[1], m[3])
                min_y = Math.min(m[2], m[4])
                max_y = Math.max(m[2], m[4])
                if min_x < left
                    left = min_x
                if max_x > right
                    right = max_x
                if min_y < bottom
                    bottom = min_y
                if max_y > top
                    top = max_y

                line = {}
                line['x1'] = m[1]
                line['y1'] = m[2]
                line['x2'] = m[3]
                line['y2'] = m[4]
                line['layer'] = m[5]
                line['width'] = m[6]

                fp_lines.push(line)

            pad = /\(fp_line\ \(start\ ([-.\d]*)\ ([-.\d]*)\)\ \(end\ ([-.\d]*)\ ([-.\d]*)\)\ \(layer\ ([.a-zA-Z]*)\)\ \(width\ ([-.\d]*)\)\)/g
            while((m = fp_line.exec(line)) != null)
            # TODO: forgot what the next 2 lines do..
                if (m.index == fp_line.lastIndex)
                    fp_line.lastIndex++


        console.log("DEBUG: found #{fp_lines.length} lines")

        cw = canvas.width / 2
        ch = canvas.height / 2

        # calculate zoom factor
        maxw = Math.max(Math.abs(left), Math.abs(right))
        maxh = Math.max(Math.abs(top), Math.abs(bottom))
        zoom = Math.min((cw-10)/maxw, (ch-10)/maxh)
        console.log("DEBUG: max dimensions: left=#{left}; right=#{right}; top=#{top}; bottom=#{bottom}")
        console.log("DEBUG: zoom: #{zoom}")

        for line in fp_lines
            # translate coords
            line['x1'] = line['x1'] * zoom + cw
            line['y1'] = line['y1'] * zoom + ch
            line['x2'] = line['x2'] * zoom + cw
            line['y2'] = line['y2'] * zoom + ch
            line['width'] *= zoom
            draw_line(context, line)

