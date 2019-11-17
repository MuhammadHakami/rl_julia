using Plots
module EpsilonGreedy
export run_experiment_eps_greedy

mutable struct Bandit_eps
    m::AbstractFloat
    mean::AbstractFloat
    N::Integer
    Bandit_eps(m,mean=0,N=0)=new(m,mean,N)
end

function pull(b::Bandit_eps)
    return randn()+b.m
end

function update!(b::Bandit_eps,x::AbstractFloat)
    b.N+=1
    b.mean=(1-1.0/b.N)*b.mean+1.0/b.N*x
    nothing
end;

function run_experiment_eps_greedy(m1, m2, m3, N)
    bandits=[Bandit_eps(m1),Bandit_eps(m2),Bandit_eps(m3)]
    data=Vector{Float64}(undef,N+1)
    for i in collect(1:N+1)
        p=rand()
        if p<1.0/(i+1)
            j=rand(collect(1:3))
        else
            j=argmax([b.mean for b in bandits])
        end
        x=pull(bandits[j])
        update!(bandits[j],x)
        data[i]=x
    end
    cum_average=cumsum(data)./(collect(1:N+1))

    return cum_average
end

end
# function main()
#     c_1=run_experiment_eps_greedy(1.0,2.0,3.0,100000)
#     c_05=run_experiment_eps_greedy(1.0,2.0,3.0,100000)
#     c_01=run_experiment_eps_greedy(1.0,2.0,3.0,100000)
#     p=Plots.plot(c_1,label="eps = 0.1",xscale=:log2)
#     Plots.plot!(p,c_05,label="eps = 0.05",xscale=:log2)
#     Plots.plot!(p,c_01,label="eps = 0.01",xscale=:log2)
# end
#
# @time main()
