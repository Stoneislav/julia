# ДАНО: Робот находится в произвольной клетке ограниченного
# прямоугольного поля без внутренних перегородок и маркеров.

# РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из
# маркеров, расставленных вплоть до внешней рамки.

using HorizonSideRobots
include("func.jl")
r = Robot("untitled.sit", animate=true)

function mark_cross!(robot)
    putmarker!(robot)
    for side in 0:3
        line_mark!(robot, HorizonSide(side))
    end
end
function line_mark!(robot, direction)
    local num_steps = 0
    while !isborder(robot, direction)
        move!(robot, direction)
        num_steps += 1
        putmarker!(robot)
    end
    along!(robot, inverse(direction), num_steps)
end
mark_cross!(r)
line_mark!(r)