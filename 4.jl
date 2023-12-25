# ДАНО: Робот находится в произвольной клетке ограниченного
# прямоугольного поля без внутренних перегородок и маркеров.

# РЕЗУЛЬТАТ: Робот — в исходном положении в центре косого креста из
# маркеров, расставленных вплоть до внешней рамки.

using HorizonSideRobots
r = Robot("untitled.sit", animate=true)
include("func.jl")

function mark_star!(robot)
    putmarker!(robot)
    for side in ((Nord, West), (Nord, Ost), (Sud, West), (Sud, Ost))
        krest(robot, side)
    end
end
function krest(robot, side::NTuple{2,HorizonSide})
    num_steps = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        num_steps += 1
    end
    side = inverse(side)
    for s in side
        along!(robot, s, num_steps)
    end
end

mark_star!(r)
