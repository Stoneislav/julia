using HorizonSideRobots
include("func.jl")
robot = Robot("untitled.sit",animate=true)
function marker_row!(robot, side)
    putmarker!(robot)
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
    end
end
function mark_perimeter!(robot)
    ssud = num_steps_along!(robot, Sud)
    swest = num_steps_along!(robot, West)
    for side in [Nord, Ost, Sud, West]
        marker_row!(robot, side)
    end
    along!(robot, Ost, swest)
    along!(robot, Nord, ssud)
end
mark_perimeter!(robot)