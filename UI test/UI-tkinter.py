import tkinter as tk
from threading import Thread

# This version may not work well on hades.

# N,M <- Width, Height
def read_output_file(filename):
    with open(filename, 'r') as file:
        N, M = map(int, file.readline().split())
        phases = [line.strip() for line in file]
    return N, M, phases

def create_ui():
    root = tk.Tk()
    root.title("Night-Market-Sim")
    app = App(root)
    app.pack(expand=True, fill='both')
    root.mainloop()

class App(tk.Frame):
    def __init__(self, master):
        super().__init__(master)
        self.master = master
        self.master.geometry("800x600")  # Set initial window size
        self.N, self.M, self.phases = read_output_file('2.out')
        self.current_phase = 0
        self.create_menu_scene()
        self.create_playground_scene()
        self.playground_frame.pack_forget()
        self.master.bind('<Configure>', self.on_resize)

    def create_menu_scene(self):
        self.menu_frame = tk.Frame(self.master)
        tk.Label(self.menu_frame, text="Night-Market-Sim", font=("Helvetica", 24)).pack(pady=(20, 10))
        tk.Button(self.menu_frame, text="Start", command=self.show_playground, height=2, width=10).pack(pady=10)
        tk.Button(self.menu_frame, text="Quit", command=self.master.quit, height=2, width=10).pack(pady=10)
        self.menu_frame.pack(expand=True, fill='both')

    def create_playground_scene(self):
        self.playground_frame = tk.Frame(self.master)
        self.scale = tk.Scale(self.playground_frame, from_=0, to=len(self.phases)-1, orient="horizontal", command=self.on_scale_change)
        self.scale.pack(side='bottom', fill='x')
        tk.Button(self.playground_frame, text="Back to Menu", command=self.show_menu).pack(side='top', anchor='ne')
        
        self.grid_frame = tk.Frame(self.playground_frame)
        self.grid_frame.pack(expand=True, fill='both')

        self.cells = [[tk.Canvas(self.grid_frame, width=20, height=20, highlightthickness=1, highlightbackground="black")
                       for _ in range(self.N)] for _ in range(self.M)]
        for i in range(self.M):
            for j in range(self.N):
                self.cells[i][j].grid(row=i, column=j, sticky="nsew")
            
        for i in range(self.M):
            self.grid_frame.grid_rowconfigure(i, weight=1)
            for j in range(self.N):
                self.grid_frame.grid_columnconfigure(j, weight=1)

    def show_playground(self):
        self.menu_frame.pack_forget()
        self.playground_frame.pack(expand=True, fill='both')
        self.scale.set(0)  # Reset the scale to phase 0
        self.update_grid(self.current_phase)

    def show_menu(self):
        self.playground_frame.pack_forget()
        self.menu_frame.pack(expand=True, fill='both')

    def update_grid(self, phase_index):
        phase = self.phases[phase_index]
        for i in range(self.M):
            for j in range(self.N):
                # Update each block in its own thread
                Thread(target=self.update_block, args=(i, j, phase[i * self.N + j])).start()

    def update_block(self, i, j, value):
        # This function runs in a separate thread for each block
        color = 'white' if value == '0' else 'blue' if value == '1' else 'black'
        self.cells[i][j].configure(bg=color)

    def on_scale_change(self, value):
        self.current_phase = int(value)
        self.update_grid(self.current_phase)

    def on_resize(self, event=None):
        # Calculate the new size of the cells based on the window size
        window_width = self.grid_frame.winfo_width()
        window_height = self.grid_frame.winfo_height()
        # Ensure the cell size is always square
        cell_size = min(window_width // self.N, window_height // self.M)
        for row in self.cells:
            for cell in row:
                cell.config(width=cell_size, height=cell_size)

# Make sure to replace 'output.out' with the actual path to your output file
create_ui()
