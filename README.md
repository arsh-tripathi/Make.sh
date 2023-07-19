# MAKE.sh
**A make tool simulating script for C projects**

As I was trying to compile a C project, I remembered the existence of Make tools, which could easily compile all the necessary files and run the project. But when I tried to use the tool on my Windows computer, I noticed there were a lot of requirements to be fulfilled for doing something so simple.

Here is the fix to those problems. I have written a bash script (titled make) that simulates all the basic functionality of the Makefile. It compiles necessary files only, thus reducing uneccesary compilation, complication and a lot of typing for the user.

I am open to any suggestions to improve the performance of my script, or addition of any features. So for any suggestions or issues, create an issue here, or simply mail me at arsht2004@gmail.com.

## Requirements
- Requires a bash interpreter installed on the local system
- Add execute permission to the the script
```
chmod a+x make
```
- The folder structure should be as shown in the repository
    - There must be a src directory containing all the files that you want to be compiled
    - Other files can be put in a seperate directory
    - obj and bin folders will be created if they do not exist

## Features 
- Efficient; Compiles only updated files, thus reducing uneccesary compilation time
- Easy to setup and use; just download the script, add permissions, and run it
- Customizable; You can change the compiler to the one of your choice by editing the variable in the script
- Informative; Every run of the script keeps a log in the bin folder, which can be used to debug
- Controllable; to make it so that the executable doesn't run after compilation, use
```
./compile folderpath executable false
```
