# ДАНО: Где-то на неограниченном со всех сторон поле без внутренних
# перегородок имеется единственный маркер. Робот - в произвольной клетке этого
# поля.

# РЕЗУЛЬТАТ: Робот - в клетке с маркером.

using HorizonSideRobots
r = Robot("untitled.sit", animate=true)
include("func.jl")

function search!(robot)
    num_steps = 2
    side = Nord
    while !ismarker(robot)
        along_search!(robot, side, num_steps // 2)
        num_steps += 1
        side = left(side)
    end
end
search!(r)