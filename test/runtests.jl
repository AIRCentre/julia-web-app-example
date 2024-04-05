using Test

# Define the path to the directory containing the test files
test_dir = @__DIR__
print(test_dir)
# Automatically include and run all test files in the directory
for test_file in readdir(test_dir)

    if startswith(test_file, "test_") && endswith(test_file, ".jl")
        include(joinpath(test_dir, test_file))
    end
end