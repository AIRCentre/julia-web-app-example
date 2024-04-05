using Test
include(joinpath(@__DIR__, "..", "lib", "StatisticAnalysis.jl"))
using .StatisticAnalysis

@testset "StatisticAnalysis Tests" begin
    @testset "gen_numbers" begin
        numbers = gen_numbers(10)
        @test length(numbers) == 10
        @test all(numbers .>= 0) && all(numbers .<= 1)  # Since rand() generates numbers between 0 and 1
    end
    
    @testset "calc_mean" begin
        @test calc_mean([1.0, 2.0, 3.0]) ≈ 2.0 atol=0.0001
        @test calc_mean([0.0, 0.0, 0.0]) ≈ 0.0 atol=0.0001
        # Add more tests as necessary
    end
end