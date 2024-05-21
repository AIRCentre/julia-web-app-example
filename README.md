# Full-stack Julia Web Application Example

`TLDR;`

This repository is a an example to be used as a tutorial for building, packaging and destributing a full-stack web application built with the Julia progrmming language. It covers the process of containerization, utilizing Docker and GitHub Actions, and distribution of the application utilizing Github Container registry (ghcr.io).

## Overview

In this tutorial, we delve into the process of containerizing a Julia web application utilizing Docker and GitHub Actions, emphasizing the importance of containerization for simplified distribution and deployment. 

Containerization is a process that packages an application along with its dependencies into a single container image, ensuring consistent operation across different computing environments. 

GitHub Actions and Docker play very important roles by automating CI/CD workflows, encompassing the build, test, and deploy phases and seamlessly integrating with GitHub Container Registry (ghcr.io), a platform for storing and distributing Docker images.

By folowing the tutorial we will see in detail how all of this tecnologies are employed to containerize, distribute and deploy a Julia web appication.

## Prerequisits

Make sure you have the following installed on your local machine:

- [Julia](https://julialang.org/downloads/)
- [Docker](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/downloads)


>**Important!**<br>
>In order to publish your application to ghcr.io, Github Actions needs to authenticate to ghcr.io using `secrets.GITHUB_TOKEN`. Make sure you have the right permissions on your Gihub account by checking your respoitory settings. Read this [guide](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository#configuring-the-default-github_token-permissions) for instructions.

## Getting Started

Once we make sure that everything is correctly installed and configured, let's dive in.

### 1. Creating a new repository

First, lets create a new public repository on [GitHub](https://github.com) by following the instructions in the [documentation](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository).

Then, let's clone our new repository by running the following command in the terminal (Important! Replace 'YourUsername' in the URL with your actual GitHub username):

```bash
git clone https://github.com/YourUsername/julia-web-app-example.git
```

Then, change directories to move into the project's directory by running the following command:

```bash
cd julia-web-app-example
```

>**Important!**<br>
>To avoid frequent errors having to do with in which directory the commands are run in, all the commands in this tutorial should be run at the root of the project, i.e., at the base of the `julia-web-app-example` directory.

### 2. Project's structure

Now, lets take a look at what files we need to add to the project and what is the purpose of each.

```plaintext
.
├── app.jl
├── Dockerfile
├── .dockerignore
├── .github
│   └── workflows
│       └── ci.yml
├── .gitignore
├── LICENSE
├── Project.toml
├── README.md
└── test
    ├── runtests.jl
    └── test_example.jl
```

- **app.jl** - Main Julia application file. It contains the primary logic for the application's execution.

- **Dockerfile** - Defines commands to assemble a Docker image, packaging the application with its environment for consistent deployment across systems.

- **.dockerignore** - Lists files and directories for Docker to ignore during the image build, reducing the image size by excluding unnecessary files.

- **.github/workflows/ci.yml** - Part of GitHub Actions for CI/CD, this file defines an automated workflow to test, build and push our containerized application to Github's container registry.

- **.gitignore** - Specifies files and directories Git should ignore, helping to keep the repository clean by excluding temporary files, dependencies, or sensitive information.

- **LICENSE** - The software license under which the project is distributed.

- **Project.toml** - Julia's package manager configuration file that specifies project dependencies. Julia creates this file automatically when adding dependencies to the project.

- **README.md** - This file usually serves as an overview of the project, including descriptions, setup instructions, usage examples, and other essential information for users or contributors. In this example, the readme file is this tutorial.

- **test/runtests.jl** - Orchestrates the execution of the project's tests.

- **test/test_example.jl** - Contains a dummy test to exemplify how tests are declared.

> **Important!**<br>
> We don't need to create all the files right away! We will create them one by one as we progress through the tutorial.

### 3. The Julia application

We will start by adding the Julia application to our project, installing its dependencies and running it to see if everything works. 

Let's do it by following these steps:

1. **Creating the `app.jl` file:**<br>

   Let's create a new file named `app.jl` at the root of your repository. It should contain the following code:

   ```julia
   # ./app.jl

   using Dash

   app = dash()

   app.layout = html_div() do
      html_h1("Hello Dash"),
      html_div("Dash.jl: Julia interface for Dash"),
      dcc_graph(id = "example-graph",
               figure = (
                     data = [
                        (x = [1, 2, 3], y = [4, 1, 2], type = "bar", name = "Data1"),
                        (x = [1, 2, 3], y = [2, 4, 5], type = "bar", name = "Data2"),
                     ],
                     layout = (title = "Dash Data Visualization",)
               ))
   end

   run_server(app, "0.0.0.0", 8080)
   ```

   Our application is a simple web dashboard built with Dash (Dash.jl). The code for our application was based on an example from the [Dash.jl documentation](https://github.com/plotly/Dash.jl).


2. **Installing the application dependancies:**
   
   Next, we install the application dependencies. In our case we only have `Dash.jl` as a dependency. 
   
   To install it we can run the folling commands:

   ```bash
   julia --project
   ]add Dash
   ```

   Then, exit out of julia terminal py pressing `Ctrl+D`.

   Let's check out what this commands is doing:
   - `julia --project`: Starts Julia's terminal interface usning the current directory as the Julia environment.
   - `]`: Enters Julia's package manager interface.
   - `add Dash`: Installs the Dash package as a dependency of the project.

   Installing packages using the curent directory as the Julia environment will create two files called `Project.toml` and `Manifest.toml`. `Project.toml` holds dependency information and will be used later on in the containerization of our application.

2. **Starting up the application:**
   
   Start the application by running the command below.

   ```bash
   julia --project app.jl
   ```

   Once the command is executed, we should see something similar to this in the output:

   ```bash 
   [ Info: Listening on: 0.0.0.0:8080, thread id: 1
   ```
   This means that the application started correctly an the dashboard should now be avaliable.
   
   Open your browser and navigate to `http://localhost:8080`. 
   
   After the page loads you should see a simple dashboard with a single bar chart.

   To stop the application, click on the terminal window and press `Ctrl+C`.

### 4. Testing the application

Testing is a very important part of continuous integration workflow for software.

Tests should cover all the behaviors of our application to ensure code correctness and to avoid unexpected failures in production.

While we wont explore testing stratagies or methodologies in the scope of this tutorial, we will still include the test step in our CI workflow to exemplify how testing could be integrated in the proccess.

To add tests to our project we can follow the steps below.

1. Create a directory in the base of our repository named `test`.

2. Create a file named `test_example.jl` inside the `test` directory and add the following code to it:
   ```julia
   # ./test/test_example.jl

   using Test

   @testset "Example Test" begin
      @test 1 == 1
   end
   ```
   This is a dummy test that always passes just for the purpose of this example. Actual tests should assert the behavior of the code.

3. Create a file named `runtests.jl` inside the `test` directory and add the following code to it:
   ```julia
   # ./test/runtests.jl

   # Define the path to the directory containing the test files
   test_dir = @__DIR__

   # Automatically include and run all files in the directory 
   # that have prefix 'test_' and sufix '.jl'
   for test_file in readdir(test_dir)
      if startswith(test_file, "test_") && endswith(test_file, ".jl")
         include(joinpath(test_dir, test_file))
      end
   end
   ```
   This file serves as the entry point to run all our test files.


To run our tests, we execute the following command to execute the `runtests.jl` file:

```bash
julia --project -e "include(\"test/runtests.jl\")"
```

After the test run, we should see an output similar tp this:

```bash
Test Summary: | Pass  Total  Time
Example Test  |    1      1  0.0s
```

If all tests show as `Pass` in an actual project, it should tell us that our code is correct and can be safely deployed.

### 5. Containerizing the application

We will use Docker to containerize the application. Docker provides very detailed [documentation](https://docs.docker.com/) that is essencial for any one wanting to start learning how to use it effectively.

Containerizing the julia application means to build a Docker image that holds the application, all its dependencies and configuration into a single confined unit. We define how Docker builds this image with a file called [Dockerfile](./Dockerfile).

To do this, let's create a file named `Dockerfile` in the base of our reoisitory and add the folowing code to it:

```Dockerfile
#./Dockerfile

# Use the latest version of the Julia image from Docker Hub as the base image
# See which versions of Julia are avaliable on https://hub.docker.com/_/julia/tags
FROM julia:1.10.2-bullseye

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

# Set environment variables to optimize Julia:
# JULIA_DEPOT_PATH  - Path to Julia packages
# JULIA_REVISE      - Disable the Revise package to speed up startup
# EARLYBIND         - Enable early binding for performance improvements

ENV JULIA_DEPOT_PATH "/home/jl/.julia"
ENV JULIA_REVISE "off"
ENV EARLYBIND "true"

# Define the command to run the Genie app when the container starts
CMD ["julia", "--project", "app.jl"]
```

The `Dockerfile` defines the environment in which our application will run. It does the following things: 
1. Uses `julia:1.10.2-bullseye` as the base Docker image so that we start with a working julia instalation preinstalled.
2. Creates a user called `jl` for added security.
3. Installs and instantiates the project's dependencies defined in `Project.toml`.
4. Copies the source code and prepompiles it.
5. Exposes port `8080` so we can access our application using the browser.
6. Sets some `ENV` variables to optimize the julia runtime environment.
7. Defines the command to start the application.

We need to also create a file named `.dockerignore` to pervent Docker from copying unnecessary files into our image. Let's create it and fill it with the following code:

```Dockerfile
# ./.dockerignore

README.md
LICENCE
Dockerfile
.dockerignore
.gitignore
.github/
test/
Manifest.toml
```

We should also add to `.dockerignore` files and directories related to data or other staric files that are not essencial to your application. All the files and directories listed in `.dockerignore` will not be copyed into our image, which reduces it's size.

Next, we will build our Docker image and learn how to use it, by following the steps below:

1. **Building the Docker Image:**<br>
   To build our image, run the folowing command:
   ```bash
   docker build -t my-julia-dashboard .
   ```
   Lets break down this command to see what it does:
   
   - `docker`: Invokes the Docker command-line interface.
   - `build`: Builds a Docker image from a Dockerfile.
   - `-t`: Tags the built image.
     - `my-julia-dashboard`: Specifies the tag name for the image, so we can identify it.
   - `.`: Indicates the current directory as the build context, where Docker looks for the `Dockerfile`.

2. **Verify the Docker Image:**<br>
   We can see the image listed in the output of the following command:
   
   ```
   docker image ls
   ```
   
   The output should contain the image tha was created, similar to the output below:
   
   ```
   REPOSITORY           TAG       IMAGE ID       CREATED           SIZE
   my-julia-dashboard   latest    de87785ae96e   17 seconds ago    804MB
   ...                  ...       ...            ...            ...
   ```

   Now, that the Docker image has been created, it means that the application can be deployed as a container anywhere.

3. **Running the Docker image locally:**<br>
   
   Let's run our newly created image as a Docker container and check if the Julia web dashboard still loads by running the following command:

   ```
   docker run --rm -p 8000:8000 my-julia-dashboard
   ```
   
   Breaking down the command we can take a look at it more closely:
   
   - `docker`: Invokes the Docker command-line interface.
   - `run`: Runs a command in a new container.
   - `--rm`: Automatically removes the container when it stops running.
   - `-p 8000:8000`: Maps the host's port 8000 to the container's port 8000.
   - `my-julia-dashboard`: Specifies the name of the image to create a container from.

   Now, navigate to `http://localhost:8080` and check if the dashboard is loaded correctly.

   If the page loads, it means we have sucessfully depolyed our containerized application.

   To stop the application, click on the terminal window and press `Ctrl+C`. The container will stop and be removed automaticaly.

### 6. Creating the GitHub Actions CI Workflow

We can now move on to the creation of a CI workflow that performs testing, containerization and distribution of our application automatically on every commit.

The workflow will run the commands we ran previously on our local machine to create our containerized application by performing the following steps:
 - Setup julia
 - Install and precompile the application
 - Run tests
 - Build the Docker image
 - Push the image to `ghcr.io`

The difference is that the commands will all be ran automatically within GitHub Actions.

To make this work we need to create a new file called `ci.yml` inside the `.github/workflows/` directory. Let's create the directory first by runing the following command:
```
mkdir -p .github/workflows/
```

Now create the file `ci.yml` inside the `.github/workflows/` directory and add the folowing lines to it:
```yml
# ./github/workflows/ci.yml

name: CI Workflow

on: 
  push:
    branches:
      - main

jobs:
  build_and_push:
    runs-on: ubuntu-latest
    
    # Commits with 'no-ci' in the message prevent the workflow from running
    # This is useful when commiting non code files, like the README for example
    if: ${{ !contains(github.event.head_commit.message, 'no-ci') }}
    
    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0 # Necessary for commits message check

     # Set up Julia
    - name: Set up Julia
      uses: julia-actions/setup-julia@v2
      with:
        version: '1.10.2' # Specify the Julia version here; use '1.x' for the latest stable version

    # Prepare for testing
    - name: Install Dependencies and precompile
      run: |
        julia --project -e " /
          using Pkg; /
          Pkg.instantiate(); /
          Pkg.precompile(); "

    # Run the application tests
    - name: Run tests
      run: |
        julia --project -e "include(\"test/runtests.jl\")"

    # Log in to GitHub Container Registry
    - name: Log in to GitHub Container Registry
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    # Build and tag the Docker image
    - name: Build and tag the Docker image
      run: |
        docker build . --file Dockerfile --tag ghcr.io/your-github-username/julia-web-app-example

    # Push the Docker image to GitHub Container Registry
    - name: Push the Docker image to ghcr.io
      run: |
        docker push ghcr.io/your-github-username/julia-web-app-example

```
>**Important!**<br>
>Replace `your-github-username` with the actual username.

Now we can commit the changes to the main branch of the repository. Once the commit is pushed, we should see the workflow start running on the `Actions` section of your repository on GitHub.

If everything goes well, after the CI workflow finishes the application should be avaliable as a Docker image on `ghcr.io`, ready to be deployed anywhere.

To test it out, let's run our recently published applicaton directly from ghcr.io and see if our Dashboard loads correctly by running the following command:

```
docker run --rm -p 8000:8000 ghcr.io/your-github-username/julia-web-app-example
```

>**Important!**<br>
>Replace `your-github-username` with the actual username.

After the container starts, open your browser and navigate to `http://localhost:8080`. When the page loads, you should see the dashboard.

To stop the container, click on the terminal window and press `Ctrl+C`.

And, with that, we have finished the tutorial!


## Contributing

We welcome contributors to this project! Please submit improvements and bugfixes so that the tutorial gets even better! 

### How to Contribute

1. **Fork the repository**: Click on the "Fork" button at the top right corner of this page to create a copy of this repository under your own GitHub account.

2. **Clone the repository**: Once you have forked the repository, clone it to your local machine using the following command:
   ```
   git clone https://github.com/your-username/repository-name.git
   ```

3. **Create a new branch**: Create a new branch for your changes to ensure that your `main` branch remains clean and stable:
   ```
   git checkout -b your-branch-name
   ```

4. **Make your changes**: Make the necessary changes to the codebase.

5. **Commit your changes**: Once you have made your changes, commit them to your branch:
   ```
   git add .
   git commit -m "Description of your changes"
   ```

6. **Push your changes**: Push your changes to your forked repository:
   ```
   git push origin your-branch-name
   ```

7. **Create a Pull Request**: Go to the original repository on GitHub and click on the "New Pull Request" button. Fill out the necessary details and submit your pull request for review.


### License

By contributing to this project, you agree that your contributions will be licensed under the GPL-3.0 License.

Thank you for contributing to this project!





