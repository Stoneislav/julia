# Написать рекурсивную функцию, перемещающую робота на расстояние
# вдвое большее исходного расстояния от перегородки, находящейся с заданного
# направления (предполагается, что размеры поля позволяют это сделать).

using HorizonSideRobots
include("func.jl")
r = Robot("untitled.sit", animate = true)

function twdist!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        twdist!(robot, side)
        if numsteps_along!(robot, inverse(side), 2) != 2
            return false
        end
    end
    return true
end

twdist!(r, Ost)