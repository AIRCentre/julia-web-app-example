module StatisticAnalysis

    export gen_numbers, calc_mean

    function gen_numbers(N::Int)
        return rand(N)
    end

    function calc_mean(x::Vector{Float64})
        return round(sum(x) / length(x); digits=4)
    end
    
end