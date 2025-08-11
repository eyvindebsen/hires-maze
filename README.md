# hires-maze
Code to display a maze in hires on the Commodore 64

Using Alvaro Alonso G' excellent graphics engine,
https://www.facebook.com/share/v/1JaQCcXspz/
i was able to construct a simple depth first search algorithm
to create a solvable maze in hires mode, using (almost) any cell size you want.
This is like having a Simons Basic cartridge-light for free, but only for simple graphics, like plot and line.
I have moved the graphics engine code to disk for faster execution.
The code is located at address 49152-49966 ($C000-$C32E).
So you need the disk to run the program.
In that way this code should work with most basic versions.
This version is aimed at the Commodore 64 (Basic v2).
For now it can draw any maze from cell pixel size 5 and up.
If you want to go lower then you run into memory problems.
This is my v1 solver. It needs a lot of optimization i know, but it should be a bit reader friendly.
The goal is to create Commodore 64 BASIC code that can solve a cell pixel size of 2. This will roughly spend at least 16000 bytes of data just to store the maze in X*Y.
Is there a way?
