using Plots,Gadfly,GR,PGFPlots,Plotly
pyplot() # Choose a backend
 # :pyplot
 # :unicodeplots
 # :plotly
 # :plotlyjs
 # :gr
 # :pgfplots
 # :inspectdr
 # :hdf5
mutable struct Bandit
    m::AbstractFloat
    mean::AbstractFloat
    N::Integer
    Bandit(m,mean=mean,N=N)=new(m,mean,N)
end

function pull(b::Bandit)
    return randn()+b.m
end

function update!(b::Bandit,x::AbstractFloat)
    b.N+=1
    b.mean=(1-1.0/b.N)*b.mean+1.0/b.N*x
    nothing
end;

function run_experiment(m1::T, m2::T, m3::T, eps::T, N::Integer, mean::Integer,n::Integer) where {T<:AbstractFloat}
    bandits=[Bandit(m1,mean,n),Bandit(m2,mean,n),Bandit(m3,mean,n)]
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

    for b in bandits
        println(b.mean)
    end
    println("----------")
    return cum_average
end


function main()
    c_1=run_experiment(1.0,2.0,3.0,0.1,100000,0,0)
    oiv=run_experiment(1.0,2.0,3.0,0.0,100000,10,1)
    c_01=run_experiment(1.0,2.0,3.0,0.01,100000,0,0)
    print(size(c_1))
    Gadfly.plot(c_1,Geom.line);
    # Plots.plot!(p,oiv,label="Optimistic mean=10",xscale=:log10);
    # Plots.plot!(p,c_01,label="eps = 0.01",xscale=:log10);

end

@time main()
