for target in $@
do
    for i in $(seq 1 3);
    do
        pixi run configure-$config -DFREECAD_USE_PCH=OFF -DFREECAD_USE_CCACHE=OFF

        echo "Building $target run $i - PCH OFF"

        echo "Building $target - PCH OFF" >> $logdir/build_timings.log

        (time pixi run build-$config --target $target) 2>> $logdir/build_timings.log
    
        rm -rf $builddir
        mkdir -p $builddir
    done

    for i in $(seq 1 3);
    do
        pixi run configure-$config -DFREECAD_USE_PCH=ON -DFREECAD_USE_CCACHE=OFF

        echo "Building $target run $i - PCH ON"

        echo "Building $target - PCH ON" >> $logdir/build_timings.log

        (time pixi run build-$config --target $target) 2>> $logdir/build_timings.log
    
        rm -rf $builddir
        mkdir -p $builddir
    done

done
