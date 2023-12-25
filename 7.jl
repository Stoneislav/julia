# ДАНО: Робот - рядом с горизонтальной бесконечно продолжающейся в
# обе стороны перегородкой (под ней), в которой имеется проход шириной в одну
# клетку.

# РЕЗУЛЬТАТ: Робот - в клетке под проходом

using HorizonSideRobots
r = Robot("untitled.sit", animate=true)
include("func.jl")

function srch!(robot)
    num_steps = 0
    side = Ost
    while isborder(robot, Nord)
        num_steps += 1
        along!(robot, side, num_steps)
        side = inverse(side)
    end
end

srch!(r)