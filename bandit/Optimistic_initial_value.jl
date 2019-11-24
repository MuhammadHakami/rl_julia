using Plots
module Optimistic_initial_value
export run_experiment_oiv
# Choose a backend
 # :pyplot
 # :unicodeplots
 # :plotly
 # :plotlyjs
 # :gr
 # :pgfplots
 # :inspectdr
 # :hdf5
mutable struct Bandit_oiv
    m::AbstractFloat
    mean::AbstractFloat
    N::Integer
    Bandit_oiv(m,mean=mean,N=N)=new(m,mean,N)
end

function pull(b::Bandit_oiv)
    return randn()+b.m
end

function update!(b::Bandit_oiv,x::AbstractFloat)
    b.N+=1
    b.mean=(1-1.0/b.N)*b.mean+1.0/b.N*x
    nothing
end;

function run_experiment_oiv(m1::T, m2::T, m3::T, eps::T, N::Integer, mean::Integer,n::Integer) where {T<:AbstractFloat}
    bandits=[Bandit_oiv(m1,mean,n),Bandit_oiv(m2,mean,n),Bandit_oiv(m3,mean,n)]
    data=Vector{Float64}(undef,N+1)
    for i in collect(1:N+1)
        p=rand()
        if p<eps
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
#     c_1=run_experiment_oiv(1.0,2.0,3.0,0.1,100000,0,0)
#     oiv=run_experiment_oiv(1.0,2.0,3.0,0.0,100000,10,1)
#     c_01=run_experiment_oiv(1.0,2.0,3.0,0.01,100000,0,0)
#     p=Plots.plot(c_1,label="eps = 0.1",xscale=:log10,legend=:bottomright);
#     Plots.plot!(p,oiv,label="Optimistic mean=10",xscale=:log10);
#     Plots.plot!(p,c_01,label="eps = 0.01",xscale=:log10);
# end
#
# @time main()
