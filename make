#!/bin/bash
# Usage: ./compile folderpath outputname
compiler=gcc        # Change the compiler here
cflags="-g -Wall"   # Change the flags here


# Check if number of arguments is correct
if [ $# -ne 2 -a $# -ne 3 ]
then
    echo "Usage: ./compile folderpath outputname"
    exit 1
fi

# Changing directories to project folder
if [ ! -d $1 ]
then 
    echo "Directory doesn't exist or is not readable"
    exit 1
fi

cd $1

# Clearing log file if it exists
if [ -d bin ]
then 
    echo "Log:" > bin/compile.log
fi

# Checking if the folder structure is correct
if [ ! -d src ]
then 
    echo "src sub-directory doesn't exist"
    exit 1
elif [ ! -d bin ]
then 
    mkdir bin
    echo "Creating bin directory" > bin/compile.log
elif [ ! -d obj ]
then
    echo "Creating obj directory" > bin/compile.log
    mkdir obj
fi

# Changing to src directory
cd src

files=$(ls *.c)
updated=false
log=../bin/compile.log

# Checking the status of each file
for filename in $files
do
    cfile=$filename
    dfile=${filename%".c"}.d
    # Creating/Updating dependencies list
    dfile_content=$($compiler -MM $cfile)
    ofile=${filename%".c"}.o
    recompile=false

    # Checking if depenedencies are updated
    for depend in $dfile_content
    do
        # Handling file name
        if [[ "$depend" =~ .o:$ ]]
        then 
            echo "Checking dependecies for $depend" >> $log
        elif [ -f ../obj/$ofile -a $depend -ot ../obj/$ofile ]
        then
            # Dependency not changed
            echo "$depend is unchanged" >> $log
        else
            # Depenedency modified
            echo "$depend is modified or $ofile does not exist" >> $log
            recompile=true
        fi
    done

    # Checking if recompilation is needed
    if [ $recompile == true ]
    then
        updated=true
        echo "Compiling $cfile" >> $log
        $compiler -c $cflags $cfile -o ../obj/$ofile
        if [ $? -ne 0 ]
        then 
            echo "Compilation error" >> $log
            exit 1
        fi
    fi
done

cd ../obj

# Checking if the main executable is updated
if [ -f ../bin/$2 -a $updated == false ]
then
    echo "Executable is already upto date" >> $log
else
    echo "Creating $2 in bin" >> $log
    $compiler $cflags $(ls *.o) -o ../bin/$2
    if [ $? -ne 0 ]
    then 
        echo "Linking error" >> $log
        exit 1
    fi
fi

if [ $# -eq 3 -a "$3" == false ]
then 
    exit 0
fi

# Run the executable
run=../bin/$2.exe
chmod a+x $run
$run

if [ $? -ne 0 ]
then
    echo "Run error" >> $log
    exit 1
# Uncomment the section below to remove the log and the executable after run
# else
    # rm $2.exe
    # rm $log
fi