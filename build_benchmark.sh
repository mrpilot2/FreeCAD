for target in FreeCADBase
do
    for i in $(seq 1 2);
    do
        pixi run configure-release -DFREECAD_USE_PCH=OFF

        echo "Building $target - PCH OFF" >> $logdir/build_timings.log

        (time pixi run build --target $target) 2>> $logdir/build_timings.log
    
        rm -rf $builddir
        mkdir -p $builddir
    done

    for i in $(seq 1 2);
    do
        pixi run configure-release -DFREECAD_USE_PCH=ON

        echo "Building $target - PCH ON" >> $logdir/build_timings.log

        (time pixi run build --target $target) 2>> $logdir/build_timings.log
    
        rm -rf $builddir
        mkdir -p $builddir
    done

done
