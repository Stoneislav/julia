# Решить задачу 8 с использованием обобщённой функции
# spiral!(stop_condition::Function, robot)

using HorizonSideRobots
include("func.jl")
include("str.jl")
r = Robot( "untitled.sit",animate = true)

function spiral!(stop_condition::Function, robot)
    n = 2
    side = Nord
    while !stop_condition()
        num_steps_along!(stop_condition, robot, side, div(n, 2))
        n += 1
        side = right(side)
    end
end

spiral!(() -> ismarker(r), r)