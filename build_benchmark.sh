#!/bin/bash

set -x

delete_existing_target_build_dir() {
    target=$1
    
    # remove just the target directory
    base_target=${target//"Gui"/}

    if [[ "$target" == "FreeCADBase" ]]
    then
        rm -rf $builddir/src/Base
    elif [[ "$target" == "FreeCADApp" ]]
    then
        rm -rf $builddir/src/App
    elif [[ "$target" == "FreeCADGui" ]]
    then
        rm -rf $builddir/src/Gui
    elif [[ "$target" == *Gui ]]
    then
        rm -rf $builddir/src/Mod/$base_target/Gui
    else
        rm -rf $builddir/src/Mod/$base_target/App
    fi
}

rm -rf $builddir/*

pixi run configure-$config -DBUILD_JTREADER=ON -DFREECAD_USE_PCH=OFF -DFREECAD_USE_CCACHE=OFF

for target in $@
do
    # build once to make sure all dependencies are built

    pixi run build-$config --target $target

    delete_existing_target_build_dir $target

    for i in $(seq 1 3);
    do
        pixi run configure-$config -DBUILD_JTREADER=ON -DFREECAD_USE_PCH=OFF -DFREECAD_USE_CCACHE=OFF

        echo "Building $target run $i - PCH OFF"

        echo "Building $target - PCH OFF" >> $logdir/build_timings.log

        (time pixi run build-$config --target $target) 2>> $logdir/build_timings.log
   
        if [[ $i -ne 3 ]]
        then 
            delete_existing_target_build_dir $target
        fi
    done
done

pixi run configure-$config -DBUILD_JTREADER=ON -DFREECAD_USE_PCH=ON -DFREECAD_USE_CCACHE=OFF
for target in $@
do
    # build once to make sure all dependencies are built
    pixi run build-$config --target $target

    delete_existing_target_build_dir $target

    for i in $(seq 1 3);
    do
        pixi run configure-$config -DBUILD_JTREADER=ON -DFREECAD_USE_PCH=ON -DFREECAD_USE_CCACHE=OFF

        echo "Building $target run $i - PCH ON"

        echo "Building $target - PCH ON" >> $logdir/build_timings.log

        (time pixi run build-$config --target $target) 2>> $logdir/build_timings.log
    
        if [[ $i -ne 3 ]]
        then 
            delete_existing_target_build_dir $target
        fi
    done

done
