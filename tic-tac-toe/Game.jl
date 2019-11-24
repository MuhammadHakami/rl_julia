module Game
export play_game, get_state_hash_and_winner, initialv_o, initialv_x 
function play_game(p1, p2, env, draw=false)
    current_player=nothing
    while !game_over()
        if current_player==p1
            current_player=p2
        else
            current_player=p1
        end
        if draw
            if draw==1 & current_player ==p1
                draw_board()
            end
            if draw ==2 & current_player ==p2
                draw_board()
            end
        end
        take_action(current_player)

        state=get_state()
        update_state_history(p1)
        update_state_history(p2)

    end
    if draw
        draw_board()
    end
    update!(p1)
    update!(p2)
end

function get_state_hash_and_winner(env,i=0,j=0)
    results=[]

    for v in (0,env.x,env.o)
        env.board[i,j] = v
        if j==2
            if i==2
                state=get_state()
                ended=game_over(force_recalculate=True)
                winner=env.winner
                results.append((state, winner, ended))
            else
                results += get_state_hash_and_winner(env,i+1,0)
            end
        else
            results +=get_state_hash_and_winner(env,i,j+1)
        end
    end
end

function initialv_x(env, state_winner_triples)
    V=zeros(env.num_state)
    for (state, winner, ended) in zip(state_winner_triples)
        if ended
            if winner==env.x
                v=1
            else
                v=0
            end
        else
            v=0.5
        end
        V[state]=v
    end
end

function initialv_o(env, state_winner_triples)
    V=zeros(env.num_state)
    for (state, winner, ended) in zip(state_winner_triples)
        if ended
            if winner==env.o
                v=1
            else
                v=0
            end
        else
            v=0.5
        end
        V[state]=v
    end
end
end
