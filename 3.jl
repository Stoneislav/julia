# ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
# поля

# РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля
# промаркированы.

using HorizonSideRobots
include("func.jl")
robot = Robot("untitled.sit", animate=true)

function marker_all!(robot)
    num_steps_West = num_steps_along!(robot, West)
    num_steps_Sud = num_steps_along!(robot, Sud)
    side = Ost
    marker_row!(robot, side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        marker_row!(robot, side)
    end
    along!(robot, West)
    along!(robot, Sud)
    along!(robot, Ost, num_steps_West)
    along!(robot, Nord, num_steps_Sud)

end
marker_all!(robot)