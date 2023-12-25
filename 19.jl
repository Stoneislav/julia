# Написать рекурсивную функцию, перемещающую робота до упора в
# заданном направлении.

using HorizonSideRobots
include("func.jl")
r = Robot("untitled.sit", animate=true)

function recursion_along!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        recursion_along!(robot, side)
        move!(robot, inverse(side))
    end
end

for side in (Nord, Sud, West, Ost)
    recursion_along!(r, side)
end