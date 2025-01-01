for target in FreeCADBase FreeCADApp FreeCADGui AddonManager Assembly AssemblyGui BIM CAMSimulator Drawing DrawingGui Fem FemGui Help Import ImportGui JtReader Inspection Materials Measure MeasureGui Mesh MeshGui MeshPart MeshPartGui Part PartGui PartDesign PartDesignGui Path PathGui Points PointsGui Robot RobotGui Sketcher SketcherGui Spreadsheet SpreadsheetGui Start StartGui Surface SurfaceGui TechDraw TechDrawGui all
do
    for i in $(seq 1 5);
    do
        pixi run configure-release -DFREECAD_USE_PCH=OFF

        echo "Building $target - PCH OFF" >> $logdir/build_timings.log

        (time pixi run build --target $target) 2>> $logdir/build_timings.log
    
        rm -rf $builddir
        mkdir -p $builddir
    done

    for i in $(seq 1 5);
    do
        pixi run configure-release -DFREECAD_USE_PCH=ON

        echo "Building $target - PCH ON" >> $logdir/build_timings.log

        (time pixi run build --target $target) 2>> $logdir/build_timings.log
    
        rm -rf $builddir
        mkdir -p $builddir
    done

done
