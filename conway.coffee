enumerate = (l) ->
    r = []
    for i in [0...l.length]
        r.push [i, l[i]]
    r

sum = (l) ->
    r = 0
    for i in l
        r += i
    return r


class Conway
    constructor: (@canvas, @size) ->
        @xscale = @canvas.width / @size[0]
        @yscale = @canvas.height / @size[1]

        @state = ((0 for j in [0...@size[1]]) for i in [0...@size[0]])

        @ctx = @canvas.getContext '2d'

    around: (x, y) ->
        r = []
        for dx in [-1, 0, 1]
            for dy in [-1, 0, 1]
                if not (dx == 0 and dy == 0)
                    if 0 <= x + dx < @size[0] and 0 <= y + dy < @size[1]
                        r.push [x + dx,  y + dy]
        r

    sumAround: (x, y) =>
        sum(@state[s[0]][s[1]] for s in @around(x, y))

    conway: (current, score) =>
        (current == 1 and score in [2, 3]) or (current == 0 and score == 3)

    step: () =>
        newState = ((0 for j in [0...@size[1]]) for i in [0...@size[0]])
        for x in [0...@size[0]]
            for y in [0...@size[1]]
                nxy = @conway(@state[x][y], @sumAround(x, y))
                newState[x][y] = 0
                if nxy
                    newState[x][y] = 1
        @state = newState

    drawPoint: (x, y, colour) =>
        [x, y] = [parseInt(x), parseInt(y)]
        @ctx.fillStyle = colour
        @ctx.fillRect x * @xscale, y * @yscale, @xscale, @yscale

    drawState: () =>
        @ctx.fillStyle = 'rgb(255, 255, 255)'
        @ctx.fillRect 0, 0, @canvas.width, @canvas.height

        for [x, row] in enumerate(@state)
            for [y, p] in enumerate(row)
                if p == 1
                    @drawPoint(x, y, 'rgb(0, 0, 0)')


window.addEventListener 'load', () ->
    @conway = new Conway document.getElementById('conway'), [100, 100]

    gliderGunOffset = [2, 2]
    gliderGun = """
                            *
                          * *
                **      **            **
               *   *    **            **
    **        *     *   **
    **        *   * **    * *
              *     *       *
               *   *
                **
    """

    for [y, line] in enumerate(gliderGun.split '\n')
        for [x, c] in enumerate(line)
            if c == '*'
                @conway.state[x + gliderGunOffset[0]][y + gliderGunOffset[1]] = 1

    speed = document.getElementById 'speed'

    step = () ->
        @conway.drawState()
        @conway.step()
        setTimeout step, 2000 - speed.value

    step()
