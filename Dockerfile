# Use the latest version of the Julia image from Docker Hub as the base image
FROM julia:latest

# Create a new user named 'jl' with a home directory and bash shell
# Note: using a custom user to run our application instead of root results in better security
RUN useradd --create-home --shell /bin/bash jl

# Create a directory for the application in the 'jl' user's home directory
RUN mkdir /home/jl/app

# Set the working directory to the app directory
WORKDIR /home/jl/app

# Change the ownership of the home directory to the 'jl' user and group
RUN chown -R jl:jl /home/jl/

# Switch to the 'jl' user for running subsequent commands
USER jl

# Copy the project dependency file app directory in the container
# Note: Copying this file and installing the dependencies before the rest of the code results in faster build times in subsequent builds
COPY Project.toml .

# Run a Julia command to set up the project: activate the project and instantiate to download its dependencies
RUN julia --project -e "using Pkg; Pkg.instantiate();"

# Copy the current directory's contents into the working directory in the container
COPY . .

# Precompile project's code and dependencies
RUN julia --project -e "using Pkg; Pkg.precompile();"

# Inform Docker that the container listens on ports 8000 at runtime
EXPOSE 8000

# Set environment variables used by Julia and the Genie app
# JULIA_DEPOT_PATH  # Path to Julia packages
# JULIA_REVISE      # Disable the Revise package to speed up startup
# GENIE_ENV         # Set the Genie environment to production
# GENIE_HOST        # Make the Genie app listen on all network interfaces
# PORT              # Set the HTTP port for the Genie app
# WSPORT            # Set the WebSocket port for real-time communication
# EARLYBIND         # Enable early binding for performance improvements
ENV JULIA_DEPOT_PATH "/home/jl/.julia"
ENV JULIA_REVISE "off"                   
ENV GENIE_ENV "prod"                     
ENV GENIE_HOST "0.0.0.0"                 
ENV PORT "8000"                          
ENV WSPORT "8000"                        
ENV EARLYBIND "true"                     

# Define the command to run the Genie app when the container starts
CMD ["julia", "--project", "-e", "using GenieFramework; Genie.loadapp(); up(async=false);"]
