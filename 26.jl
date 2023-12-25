# Написать функцию, маркирующую все клетки лабиринта произвольной
# формы, ограниченного перегородками, и возвращающую робота в исходное
# положение

using HorizonSideRobots
include("func.jl")
r = Robot("untitled.sit", animate = true)

function mark_labirint!(robot)
    if !ismarker(robot)
        putmarker!(robot)
        for side in (Nord, West, Sud, Ost)
            if !isborder(robot, side)
                move!(robot, side)
                mark_labirint!(robot)
                move!(robot, inverse(side))
            end
        end
    end
end

mark_labirint!(r)