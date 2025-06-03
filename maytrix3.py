#!/usr/bin/env python3

import curses
import random
import time

TRAIL_LENGTH = 30
FRAME_DELAY = 0.08
SPAWN_CHANCE = 0.5

def matrix_rain(stdscr):
    with open("matrix_debug.log", "w") as log:
        curses.curs_set(0)
        stdscr.nodelay(True)
        stdscr.timeout(0)

        sh, sw = stdscr.getmaxyx()
        log.write(f"Terminal size: {sw}x{sh}\n")

        chars = "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜ"
        try:
            "".join(chars).encode("utf-8")
        except UnicodeEncodeError:
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        curses.start_color()
        curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_GREEN, -1)
        green = curses.color_pair(1)

        streams = [[] for _ in range(sw)]

        frame = 0
        while True:
            stdscr.erase()
            log.write(f"Frame {frame}\n")
            frame += 1

            for x in range(sw):
                if random.random() < SPAWN_CHANCE:
                    streams[x].insert(0, 0)
                    log.write(f"Spawn new stream at column {x}\n")

                new_stream = []
                for i, y in enumerate(streams[x]):
                    if y >= sh:
                        continue

                    char = random.choice(chars)
                    if i == 0:
                        attr = curses.A_BOLD
                    elif i < TRAIL_LENGTH * 0.4:
                        attr = curses.A_NORMAL
                    elif i < TRAIL_LENGTH:
                        attr = curses.A_DIM
                    else:
                        continue

                    try:
                        stdscr.addstr(y, x, char, green | attr)
                        log.write(f"Draw '{char}' at ({y},{x}) attr={attr}\n")
                    except curses.error:
                        log.write(f"ERROR drawing at ({y},{x})\n")
                        continue

                    new_stream.append(y + 1)

                streams[x] = new_stream[:TRAIL_LENGTH]

            stdscr.refresh()
            time.sleep(FRAME_DELAY)

def main():
    curses.wrapper(matrix_rain)

if __name__ == "__main__":
    main()

