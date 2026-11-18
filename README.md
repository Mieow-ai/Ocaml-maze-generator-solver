# OCaml Project: Maze Generator & Solver

This project consists of randomly generating, loading, displaying, and solving mazes in OCaml. Mazes are handled both as ASCII text files and through our custom in-memory data structure (`grid`).

The project aims to explore **graph algorithms**, manipulate data structures in **OCaml**, and combine a functional programming approach with imperative features (arrays, file I/O).

Visual examples and illustrations are available directly in the [project report](./Maze_Project_EN_Report.pdf).

## Authors

* **Corvoysier Simon**
* **Shortall Antoine**

## Architecture

```text
├── Composants/                  # Core OCaml modules (Grid, Generation, Solve, Tests_fonctions)
├── Tests/                       # Sample mazes and validation test files (e.g., test9.txt)
├── test/                        # Sample .laby files
├── maze.ml                      # Main entry point and CLI argument parser
├── dune                         # Dune build rules
├── dune-project                 # Dune project configuration
├── Maze_Project_EN_Report.pdf   # Detailed technical report with visual examples
└── README.md                    # Project documentation
```

## Project Objectives

1. **Algorithms:** Implementation of fundamental graph algorithms (random maze generation, Depth-First Search solving, etc.).
2. **Paradigms:** Combining pure functional code with controlled side effects (file management, mutable `Array` structures).
3. **Software Engineering:** Modular architecture, build automation using `dune`, and CLI argument parsing.

---

## Prerequisites

* **OCaml** (recent version recommended)
* **Dune** (build system)

## Components & Modules

### `Generation`
Randomly generates a valid maze and saves it into a text file.
* **Command:**
```bash
dune exec -- ./maze.exe random [m] [n] [filename]
```

### `Grid`
Parses a maze from a text file into our custom `grid` data structure and displays it in the console.
* **Command:**
```bash
dune exec -- ./maze.exe print2 [filepath]
```

### `Solve`
Solves the maze and finds a valid path from the entrance (`E`) to the exit (`S`).
* **Command:**
```bash
dune exec -- ./maze.exe solve [filepath]
```

### `Tests_fonctions`
Unit testing module used to validate the core functions of the project.
* **Command:**
```bash
dune exec -- ./maze.exe tests
```

---

## Build

To compile the project and generate the executable, run the following command from the project root:

```bash
dune build
```

## Usage

### General Syntax
```bash
dune exec -- ./maze.exe <command> [arguments]
```

### Help
```bash
dune exec -- ./maze.exe --help
```

### Examples
Generate a 15×30 maze into `data.laby`:
```bash
dune exec -- ./maze.exe random 15 30 data.laby
```

Display `data.laby` in the terminal:
```bash
dune exec -- ./maze.exe print data.laby
```
