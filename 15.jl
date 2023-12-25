# Решить задачу 4, но при условии наличия на поле простых внутренних
# перегородок.

using HorizonSideRobots
HSR = HorizonSideRobots
r = Robot("untitled.sit", animate=true)
include("str.jl")
include("func.jl")

function mark_line!(robot, side)
    while try_move!(RectBorderRobot{Robot}(robot), side)
        putmarker!(robot)
    end
    while try_move!(RectBorderRobot{Robot}(robot), inverse(side))
        if !ismarker(robot)
            return
        end
    end
end

function mark_cross_x!(robot)
    for side in ((Nord, Ost), (Nord, West), (Sud, West), (Sud, Ost))
        mark_line!(robot, side)
    end
    putmarker!(robot)
end

mark_cross_x!(r)