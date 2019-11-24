include("Env.jl")
include("Game.jl")
using .Env,.Game

LENGTH=3
mutable struct Agent{T<:AbstractFloat}
    eps::T
    alpha::T
    verbose::Bool
    state_history::Array
    V
    sym
    Agent(eps=0.1,alpha=0.5)=new{AbstractFloat}(eps,alpha,false,[])
end

function setV(agent::Agent,V)
    agent.V=V
end

function set_symbol(agent::Agent,sym)
    agent.sym=sym
end

function set_verbose(agent::Agent,v)
    agent.verbose=v
end

function reset_history(agent::Agent)
    agent.state_history=[]
end

function take_action(agent::Agent,env::Enviroment)
    r=rand()
    best_state=nothing
    if r<agent.eps
        if agent.verbose
            print("Taking a random action")
        end
        possible_moves = []
        for i in 1:LENGTH
            for j in 1:LENGTH
                if is_empty(env,i,j)
                    push!(possible_moves,(i,j))
                end
            end
        end
        idx=rand(1:size(possible_moves)[1])
        next_move=possible_moves[idx]
    else
        pos2value=Dict()
        next_move=nothing
        best_value=-1
        for i in 1:LENGTH
            for k in 1:LENGTH
                if is_empty(env)
                    env.board[i,j]=agent.sym
                    state=env.get_state()
                    env.board[i,j]=0
                    pos2value[(i,j)]=agent.V[state]
                    if agent.V[state]>best_value
                        best_value=agent.V[state]
                        best_state=state
                        next_move=(i,j)
                    end
                end
            end
        end
    end
    if agent.verbose
        println("Taking a greedy action")
        for i in 1:LENGTH
            println("---------------")
            for j in 1:LENGTH
                if is_empty(env,i,j)
                    print(pos2value[(i,j)])
                else
                    print(" ")
                    if env.board[i,j]==env.x
                        print("  X")
                    elseif env.board[i,j]==env.o
                        print("  O")
                    else
                        print("   ")
                    end
                end
            end
            println("")
        end
        println("---------------")
    end
end

function update_state_history!(agent::Agent,s)
    push!(agent.state_history,s)
end

function update!(agent::Agent,env::Enviroment)
    reward = Env.reward(env,agent.sym)
    target = reward
    for prev in reverse(agent.state_history)
        value = agent.V[prev] + agent.alpha*(target - agent.V[prev])
        agent.V[prev] = value
        target = value
    end
    agent.reset_history()
end
