for target in $@
do
    # build once to make sure all dependencies are built
    pixi run configure-$config -DFREECAD_USE_PCH=OFF -DFREECAD_USE_CCACHE=OFF

    pixi run build-$config --target $target

    # remove just the target directory
    base_target=${target//"Gui"/}

    rm -rf $builddir/src/Mod/$base_target

    for i in $(seq 1 3);
    do
        pixi run configure-$config -DFREECAD_USE_PCH=OFF -DFREECAD_USE_CCACHE=OFF

        echo "Building $target run $i - PCH OFF"

        echo "Building $target - PCH OFF" >> $logdir/build_timings.log

        (time pixi run build-$config --target $target) 2>> $logdir/build_timings.log
    
        rm -rf $builddir/src/Mod/$base_target
    done

    # build once to make sure all dependencies are built
    pixi run configure-$config -DFREECAD_USE_PCH=ON -DFREECAD_USE_CCACHE=OFF

    pixi run build-$config --target $target

    # remove just the target directory
    base_target=${target//"Gui"/}

    rm -rf $builddir/src/Mod/$base_target

    for i in $(seq 1 3);
    do
        pixi run configure-$config -DFREECAD_USE_PCH=ON -DFREECAD_USE_CCACHE=OFF

        echo "Building $target run $i - PCH ON"

        echo "Building $target - PCH ON" >> $logdir/build_timings.log

        (time pixi run build-$config --target $target) 2>> $logdir/build_timings.log
    
        rm -rf $builddir/src/Mod/$base_target
    done

done
