# Написать рекурсивную функцию, перемещающую робота в соседнюю
# клетку в заданном направлении, при этом на пути робота может находиться
# изолированная прямолинейная перегородка конечной длины.

using HorizonSideRobots
include("func.jl")
r = Robot("untitled.sit", animate = true)

function recursion_try_move!(robot, side)
    if !try_move!(robot, side)
        move!(robot, left(side))
        recursion_try_move!(robot, side)
        move!(robot, right(side))
    end
end

recursion_try_move!(r, Nord)