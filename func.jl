using HorizonSideRobots
import HorizonSideRobots.move!
import HorizonSideRobots.isborder
import HorizonSideRobots.putmarker!

HSR = HorizonSideRobots

"""
along!(robot, direct)::Nothing
-- перемещает робота до упора в заданном направлении
"""
along!(robot, direction)::Nothing =
    while try_move!(robot, direction)
    end

"""
along!(robot, direct, num_steps)::Nothing
-- перемещает робота в заданном направлении на заданное 
число шагов (предполагается, что это возможно)
"""
function along!(robot, direction, num_steps)::Nothing
    for _ in 1:num_steps
        move!(robot, direction)
    end
end

"""
num_steps_along!(robot, direct)::Int
-- перемещает робота в заданном направлении до упора и 
возвращает число фактически сделанных им шагов
"""
function num_steps_along!(robot, direction)::Int
    steps = 0
    while try_move!(robot, direction)
        steps += 1
    end
    return steps
end

function marker_row!(robot, side)
    putmarker!(robot)
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
    end
end

"""
along_search!(robot, direction, num_steps)
-- перемещает робота в заданном направлении на заданное 
число шагов (предполагается, что это возможно)
или пока не встретит маркированное поле
"""
function along_search!(robot, direction, num_steps)
    for _ in 1:num_steps
        if ismarker(robot)
            break
        end
        move!(robot, direction)
    end
end

"""
try_move!(robot, direct)::Bool
-- делает попытку одного шага в заданном направлении и
возвращает true, в случае, если это возможно, и false - в 
противном случае (робот остается в исходном положении) 
"""
try_move!(robot, direction) = ((isborder(robot, direction)) ||
    (move!(robot, direction); return true);
return false)

"""
numsteps_along!(robot, direct, max_num_steps)::Int
-- перемещает робота в заданном направлении до упора, если 
необходимое для этого число шагов не превосходит 
max_num_steps, или на max_num_steps шагов, и возвращает 
число фактически сделанных им шагов
"""
function numsteps_along!(robot, direction, max_num_steps)::Int
    num_steps = zero(max_num_steps)
    while num_steps < max_num_steps && try_move!(robot, direction)
        num_steps += 1
    end
    return num_steps
end

function numsteps_along!(robot, direction)::Int
    num_steps = 0
    while try_move!(robot, direction)
        num_steps += 1
    end
    return num_steps
end
"""
inverse(side::HorizonSide)::HorizonSide
-- возвращает направление, противоположное заданному 
@enum HorizonSide Nord=0, West=1, Sud=2, Ost=3
"""
function inverse(side::HorizonSide)::HorizonSide # mod - остаток от деления
    if side == Nord
        return Sud
    elseif side == Ost
        return West
    elseif side == Sud
        return Nord
    else
        return Ost
    end
end

"""
right(side::HorizonSide)::HorizonSide
-- возвращает направление, следующее по часовой стрелке по 
отношению к заданному
"""
right(side::HorizonSide)::HorizonSide =
    HorizonSide(mod(Int(side) - 1, 4))

"""
left(side::HorizonSide)::HorizonSide
-- возвращает направление, следующее против часовой стрелки 
по отношению к заданному
"""
left(side::HorizonSide)::HorizonSide =
    HorizonSide(mod(Int(side) + 1, 4))

"""
ДАНО: робот находится в произвольной клетке ограниченного 
прямоугольного поля (без внутренних перегородок и маркеров).
РЕЗУЛЬТАТ: робот - в исходном положении в центре из прямого креста из 
маркеров.
"""
function mark_cross!(robot)::Nothing
    putmarker!(robot)
    for side in 0:3
        line_markings!(robot, HorizonSide(side))
    end
end

function line_markings!(robot, direction)
    local num_steps = 0
    while !isborder(robot, direction)
        move!(robot, direction)
        num_steps += 1
        putmarker!(robot)
    end
    along!(robot, inverse(direction), num_steps)
end

"""
numsteps_mark_along!(robot, direct)::Int
-- перемещает робота в заданном направлении до упора, после 
каждого шага ставя маркер, и возвращает число фактически 
сделанных им шагов
"""
function numsteps_mark_along!(robot, direct)::Int
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
        num_steps += 1
    end
    return num_steps
end

"""
mark_along!(robot, direct)::Nothing
-- перемещает робота в заданном направлении до упора, после 
каждого шага ставя маркер.
"""
function mark_along!(robot, direction)::Nothing
    while !isborder(robot, direction)
        move!(robot, direction)
        putmarker!(robot)
    end
end

# mark_row!(robot, direction) = (putmarker!(robot); markstaigth!(robot, direction)) !?

HSR.move!(robot, side::NTuple{2,HorizonSide})::Nothing =
    for s in side
        move!(robot, s)
    end

inverse(directions::NTuple{2,HorizonSide}) = inverse.(directions)

HSR.isborder(robot, side::NTuple{2,HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])

"""
find_pass!(robot, border_side) 
-- ищет проход в перегородке, рядом с которой находится 
робот, и возвращает именованный кортеж с полями: back_size, 
num_steps (эти значения определяют координаты начального 
положение робота относительно его текущего положения)
"""
function find_pass!(robot, border_side)
    num_steps = 0
    bypass_side = left(border_side)
    while isborder(robot, border_side)
        num_steps += 1
        along!(robot, bypass_side, num_steps)
        bypass_side = inverse(bypass_side)
    end
    if num_steps % 2 == 0
        return (back_side=bypass_side, num_steps=num_steps // 2)
    end
    return (back_side=bypass_side, num_steps=num_steps // 2 + 1) # именованный кортеж
end

"""
move_to_angle!(robot, side::NTuple{2, HorizonSide})::Array
-- Принимает в качестве аргумента кортеж с направление угла в который должен переместиться робот
(Nord, West), (Nord, Ost), (Sud, West), (Sud, Ost)
функция возвращает путь пройденный роботом в форме массива кортежей,
где первый элемент кортежа: направление в которое следует двигаться роботу чтобы вернуться на исходное положение,
и второй элемент кортежа: количество шагов которые нужно сделать роботу в данном направлении
"""
function move_to_angle!(robot, side::NTuple{2,HorizonSide})::Array
    path = Tuple{HorizonSide,Int}[]
    current_side = side[1] # Действующее направление
    while !isborder(robot, side[1]) || !isborder(robot, side[2])
        pushfirst!(path, (inverse(current_side), numsteps_along!(robot, current_side)))
        if current_side == side[1]
            current_side = side[2]
        else
            current_side = side[1]
        end
    end
    return path
end

"""
move_to_back!(robot, path)
-- возвращает робота в исходное положение испльзуя path как инструкцию
"""
function move_to_back!(robot, path)
    for step in path
        along!(robot, step[1], step[2])
    end
end


###  Специальные функции для 10 задания
"""
num_steps_mark_along!(robot, direction, num_steps)
-- строит полосу из маркеров длиною в num_steps шагов в заданном направлении
"""
function num_steps_mark_along!(robot, direction, num_steps) # Специальная функция для putmarker!(robot, N)
    putmarker!(robot)
    for _ in 1:(num_steps-1)
        move!(robot, direction)
        putmarker!(robot)
    end
end

"""
NxN_marker!(robot, N::Int)::Nothing
-- функция строт квадрат размером NxN из маркеров
предполагается что данный квадрат влезает в поле
и что робот в конце останется в юго-западном углу этого квадрата
"""
function NxN_marker_right!(robot, N::Int)::Nothing
    side = Ost
    for n in 1:N
        num_steps_mark_along!(robot, side, N)
        side = inverse(side)
        if n != N
            move!(robot, Nord)
        end
    end
    along!(robot, Sud, N - 1)
    if inverse(side) == West
        along!(robot, Ost, N - 1)
    end
end

function NxN_marker_left!(robot, N::Int)::Nothing
    side = West
    for n in 1:N
        num_steps_mark_along!(robot, side, N)
        side = inverse(side)
        if n != N
            move!(robot, Nord)
        end
    end
    along!(robot, Sud, N - 1)
    if inverse(side) == Ost
        along!(robot, West, N - 1)
    end
end