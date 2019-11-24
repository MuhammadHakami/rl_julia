module Env
export Enviroment, is_empty, reward, get_state, game_over, draw_board
using LinearAlgebra
LENGTH=3

mutable struct Enviroment
    board::Array
    x::Int
    o::Int
    winner::Union{Nothing,Int}
    ended::Bool
    num_state::AbstractFloat
    Enviroment(LENGTH)=new(zeros(LENGTH,LENGTH),-1,1,nothing,false,3^(LENGTH+LENGTH))
end

Enviroment(LENGTH)

function is_empty(env::Enviroment,i,j)
    return env.board[i,j]==0
end

function reward(env::Enviroment,sym)
    if !game_over(env)
        return 0
    end
    if env.winner == sum
        return 1
    else
        return 0
    end
end



function get_state(env::Enviroment)
    k=0
    h=0
    for i in 1:LENGTH
        for j in 1:LENGTH
            if env.board[i,j]==0
                v=0
            elseif env.board[i,j]==env.x
                v=1
            elseif env.board[i,j]==env.o
                v=2
            end
            h+=(3^k)*v
            k+=1
        end
    end
    return h
end

function game_over(env::Enviroment)
    for i in 1:LENGTH
        for player in (env.x,env.o)
            if sum(env.board[i,:]) == player*LENGTH
                env.winner=player
                env.ended=True
                return true
            end
        end
    end

    for i in 1:LENGTH
        for player in (env.x,env.o)
            if sum(env.board[:,i]) == player*LENGTH
                env.winner=player
                env.ended=True
                return true
            end
        end
    end
    for player in (env.x,env.x)
        if tr(env.board)==player*LENGTH
            env.winner=player
            env.ended=true
            return true
        end
        if tr(rotl90(env.board))==player*LENGTH
            env.winner=player
            env.ended=true
            return true
        end
    end
    if all(i -> i!=0,env.board)
        env.winner=nothing
        env.ended=true
        return true
    end
    env.winner=nothing
    return false
end

function draw_board(env::Enviroment)
    for i in 1:LENGTH
        println("---------------")
        for j in 1:LENGTH
            print(" ")
            if env.board[i,j]==env.x
                print("  X")
            elseif env.board[i,j]==env.o
                print("  O")
            else
                print("  ")
            end
        end
        println("")
    end
    println("---------------")
end
end
