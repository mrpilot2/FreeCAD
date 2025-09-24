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

for i in $(seq 1 3);
do
    pixi run configure-$config -DBUILD_JTREADER=ON -DFREECAD_USE_PCH=OFF -DFREECAD_USE_CCACHE=OFF
    echo "Building All run $i - PCH OFF"

    echo "Building All - PCH OFF" >> $logdir/build_timings.log

    (time pixi run build-$config) 2>> $logdir/build_timings.log

    rm -rf $builddir/*   
done

pixi run configure-$config -DBUILD_JTREADER=ON -DFREECAD_USE_PCH=ON -DFREECAD_USE_CCACHE=OFF

for i in $(seq 1 3);
do
    pixi run configure-$config -DBUILD_JTREADER=ON -DFREECAD_USE_PCH=ON -DFREECAD_USE_CCACHE=OFF
    echo "Building All run $i - PCH ON"

    echo "Building All - PCH ON" >> $logdir/build_timings.log

    (time pixi run build-$config) 2>> $logdir/build_timings.log

    rm -rf $builddir/*   
done
