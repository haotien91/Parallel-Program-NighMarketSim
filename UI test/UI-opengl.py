import struct
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
    phases = []
    with open("output.out", "rb") as file:
        while True:
            phase = []
            try:
                for _ in range(GRID_SIZE):  # Read 64 lines
                    line = [struct.unpack('i', file.read(4))[0] for _ in range(GRID_SIZE)]
                    phase.append(line)

                phases.append(phase)
            except struct.error:
                # End of file reached or incomplete phase
                break

    return phases

# Function to draw a single cell
def draw_cell(x, y, color):
    glColor3fv(color)
    glBegin(GL_QUADS)
    glVertex2f(x * CELL_SIZE, y * CELL_SIZE)
    glVertex2f((x + 1) * CELL_SIZE, y * CELL_SIZE)
    glVertex2f((x + 1) * CELL_SIZE, (y + 1) * CELL_SIZE)
    glVertex2f(x * CELL_SIZE, (y + 1) * CELL_SIZE)
    glEnd()

def calculate_density(phase, x, y, N, M):
    # Define the vicinity range (3x3 grid centered on the cell)
    vicinity_range = range(-1, 2)
    
    # Calculate the density
    density = 0
    for dx in vicinity_range:
        for dy in vicinity_range:
            nx, ny = x + dx, y + dy
            if 0 <= nx < N and 0 <= ny < M and phase[nx][ny] == 1:
                density += 1
    return density

# Function to map density to a color
def density_to_color(density, max_density):
    # Normalize the density
    normalized_density = density / max_density
    
    # Map normalized density to a color (blue to red gradient)
    color = (normalized_density, 0, 1 - normalized_density)
    return color

# Function to draw a single cell with heatmap colors
def draw_heatmap_cell(x, y, color):
    glColor3fv(color)  # color is now a tuple (R, G, B)
    glBegin(GL_QUADS)
    glVertex2f(x * CELL_SIZE, y * CELL_SIZE)
    glVertex2f((x + 1) * CELL_SIZE, y * CELL_SIZE)
    glVertex2f((x + 1) * CELL_SIZE, (y + 1) * CELL_SIZE)
    glVertex2f(x * CELL_SIZE, (y + 1) * CELL_SIZE)
    glEnd()


def render_grid(N, M, phase):
    max_density = 9  # Maximum density in a 3x3 vicinity

    for i in range(N):
        for j in range(M):
            if phase[i][j] == 2:  # Obstacle
                color = (0, 0, 0)  # Black
            else:
                # Calculate density and map it to a color
                density = calculate_density(phase, i, j, N, M)
                color = density_to_color(density, max_density)

            draw_heatmap_cell(j, N - 1 - i, color)

# Main function
def main():
    pygame.init()
    display = (800, 600)
    pygame.display.set_mode(display, DOUBLEBUF | OPENGL)
    gluOrtho2D(0, 1, 0, 1)  # Set the orthographic projection to cover [0, 1] range in both dimensions

    phases = read_data()
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
        render_grid(GRID_SIZE, GRID_SIZE, phases[current_phase])
        pygame.display.flip()

        # print("THIS IS PHASE {}".format(current_phase))

        # for i in phases[current_phase]:
        #     print(i)

        pygame.time.wait(1)

main()
