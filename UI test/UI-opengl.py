import pygame
from pygame.locals import *
from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
import time

# Constants for the grid
GRID_SIZE = 64
CELL_SIZE = 1.0 / GRID_SIZE  # Scale down the cells to fit the grid

# Read the data from the file
def read_data():
    with open("output.out", "r") as file:
        N, M = map(int, file.readline().split())
        phases = [list(map(int, list(line.strip()))) for line in file]
    return N, M, phases

# Function to draw a single cell
def draw_cell(x, y, color):
    glColor3fv(color)
    glBegin(GL_QUADS)
    glVertex2f(x * CELL_SIZE, y * CELL_SIZE)
    glVertex2f((x + 1) * CELL_SIZE, y * CELL_SIZE)
    glVertex2f((x + 1) * CELL_SIZE, (y + 1) * CELL_SIZE)
    glVertex2f(x * CELL_SIZE, (y + 1) * CELL_SIZE)
    glEnd()

# Render the grid
def render_grid(N, M, phase):
    for i in range(N):
        for j in range(M):
            color = (1, 1, 1) if phase[i * M + j] == 0 else (0, 0, 1) if phase[i * M + j] == 1 else (0, 0, 0)
            draw_cell(j, N - 1 - i, color)

# Main function
def main():
    pygame.init()
    display = (800, 600)
    pygame.display.set_mode(display, DOUBLEBUF | OPENGL)
    gluOrtho2D(0, 1, 0, 1)  # Set the orthographic projection to cover [0, 1] range in both dimensions

    N, M, phases = read_data()
    current_phase = 0
    phase_change_counter = 0
    phase_change_interval = 60

    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                quit()

        phase_change_counter += 1
        if phase_change_counter >= phase_change_interval:
            current_phase = (current_phase + 1) % len(phases)
            phase_change_counter = 0

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        render_grid(N, M, phases[current_phase])
        pygame.display.flip()
        pygame.time.wait(1)

main()
