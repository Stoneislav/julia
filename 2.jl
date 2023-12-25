# ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок
# и маркеров)

# РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру
# внешней рамки промаркированы.

using HorizonSideRobots
include("func.jl")
robot = Robot("untitled.sit", animate=true)

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