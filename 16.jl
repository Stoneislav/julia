# Решить задачу 7 с использованием обобщённой функции
# shuttle!(stop_condition::Function, robot, side)

using HorizonSideRobots
include("func.jl")
include("str.jl")
r = Robot("untitled.sit", animate = true)

function shuttle!(stop_condition::Function, robot, side)
    ortogonal_side = left(side)
    n = 1
    while !stop_condition()
        along!(robot, ortogonal_side, n)
        ortogonal_side = inverse(ortogonal_side)
        n += 1
    end
end

shuttle!(() -> !isborder(r, Nord), r, Nord)