# Full-stack Julia Web Application Example

`TLDR;`

This repository is a an example to be used as a tutorial for building a full-stack web application using the Julia programming language. It covers the entire process of deployment, using a very simple sample application to demonstrate the steps involved.

## 1. Overview

In this tutorial, we delve into the process of containerizing a Julia web application utilizing Docker and GitHub Actions, emphasizing the importance of containerization for simplified distribution and deployment. 

Containerization is a process that packages an application along with its dependencies into a single container image, ensuring consistent operation across different computing environments. 

Our application is simple web dashboard developed with GenieFramework.jl, a robust open-source framework designed for creating production-grade, data-driven web apps with Julia. 

GitHub Actions and Docker play very important roles by automating CI/CD workflows, encompassing the build, test, and deploy phases and seamlessly integrating with GitHub Container Registry (ghcr.io), a platform for storing and distributing Docker images.

By folowing the tutorial we will see in detail how all of this tecnologies are employed to containerize, distribute and deploy a Julia web appication.

## 2. Prerequisits

Make sure you have the following installed on your local machine:

- [Julia](https://julialang.org/downloads/)
- [Docker](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/downloads)


**Important!**<br>
In order to publish your application to ghcr.io, Github Actions needs to authenticate to ghcr.io using `secrets.GITHUB_TOKEN`. Make sure you have the right permissions on your Gihub account by checking your respoitory settings. Read this [guide](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository#configuring-the-default-github_token-permissions) for instructions.

## 3. Getting Started

Once we make sure that everything is correctly installed and configured, let's dive in.

### 3.1. Cloning the repository

First, lets clone the repository using Git by runnig the following command:

```bash
git clone https://github.com/AIRCentre/julia-web-app-example.git
```

Then, change directories to move into the project's directory by running the following command:

```bash
 cd julia-web-app-example
```

**Important!**<br>
To avoid frequent errors having to do with in which directory the commands are run in, all the commands in this tutorial should be run at the root of the project, i.e., at the base of the `julia-web-app-example` directory.

### 3.2. Getting familiarized with the Project's structure

Now, lets take a look at the project's file structure and know what is the purpose of each file.

```plaintext
.
├── app.jl
├── Dockerfile
├── .dockerignore
├── .github
│   └── workflows
│       └── ci.yml
├── .gitignore
├── lib
│   └── StatisticAnalysis.jl
├── LICENSE
├── Project.toml
├── README.md
└── test
    ├── runtests.jl
    └── test_statistic_analysis.jl
```

- **app.jl** - Main Julia application file. It contains the primary logic for the application's execution.

- **Dockerfile** - Defines commands to assemble a Docker image, packaging the application with its environment for consistent deployment across systems.

- **.dockerignore** - Lists files and directories for Docker to ignore during the image build, reducing the image size by excluding unnecessary files.

- **.github/workflows/ci.yml** - Part of GitHub Actions for CI/CD, this file defines an automated workflow to test, build and push our containerized application to Github's container registry.

- **.gitignore** - Specifies files and directories Git should ignore, helping to keep the repository clean by excluding temporary files, dependencies, or sensitive information.

- **lib/StatisticAnalysis.jl** - A Julia module within the `lib` directory with simple functions.

- **LICENSE** - The software license under which the project is distributed.

- **Project.toml** - Julia's package manager configuration file that specifies project dependencies.

- **README.md** - An overview of the project, including descriptions, setup instructions, usage examples, and other essential information for users or contributors.

- **test/runtests.jl** - Orchestrates the execution of the project's automated tests.

- **test/test_statistic_analysis.jl** - Contains tests for the `StatisticAnalysis.jl` module.

### 3.3. Running the Julia application

Let's run the Julia application locally to see if its working correctly by folowing these steps:

1. **Installing the application dependancies:**<br>
   Run the folowing commands to download, install and precompile the application's dependencies.
   ``` bash
   julia --project -e "using Pkg; Pkg.instantiate(); Pkg.precompile();"
   ```
   Lets breakdown this command to see what it does:
   - `julia`: Starts the Julia program.
   - `--project`: Specifies to use the project environment from the `Project.toml` file.
   - `-e`: Executes the following Julia code as a script:
     - `using Pkg;`: Loads Julia's package manager.
     - `Pkg.instantiate();`: Installs dependencies listed in `Project.toml`.
     - `Pkg.precompile();`: Compiles packages for faster startup.

2. **Starting up the application:**<br>
   Our application is a simple web dashboard built with Genie (GenieFramework.jl). Feel free to checking out the documentation for this framework and add things to our application.
   
   Start the application by running the command below.
   ```bash
   julia --project -e "using GenieFramework; Genie.loadapp(); up(async=false);"
   ```
   We already saw what the `julia`, `--project` and `-e` are for. 
   
   Now, let's see what the julia script part is doing:
   - `using GenieFramework`: Imports the GenieFramework package into the Julia environment.
   - `Genie.loadapp()`: Loads the web application defined in `app.jl`.
   - `up(async=false)`: Starts the web server in synchronous mode, blocking further commands until the server is stopped.

   Once the command is executed we should see something similar to this in the output:

   ```bash 
    ██████╗ ███████╗███╗   ██╗██╗███████╗    ███████╗
   ██╔════╝ ██╔════╝████╗  ██║██║██╔════╝    ██╔════╝
   ██║  ███╗█████╗  ██╔██╗ ██║██║█████╗      ███████╗
   ██║   ██║██╔══╝  ██║╚██╗██║██║██╔══╝      ╚════██║
   ╚██████╔╝███████╗██║ ╚████║██║███████╗    ███████║
    ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝╚══════╝    ╚══════╝
   
   | Website  https://genieframework.com
   | GitHub   https://github.com/genieframework
   | Docs     https://learn.genieframework.com
   | Discord  https://discord.com/invite/9zyZbD6J7H
   | Twitter  https://twitter.com/essenciary
   
   Active env: DEV
   
   [ Info: 2024-04-05 14:54:41 Watching ["/your/path/to/julia-web-app-example"]
   
   Ready! 
   
   ┌ Info: 2024-04-05 14:54:43 
   └ Web Server starting at http://127.0.0.1:8000 - press Ctrl/Cmd+C to stop the server. 
   [ Info: 2024-04-05 14:54:43 Listening on: 127.0.0.1:8000, thread id: 1
   ```
    This means that the application started correctly an the dashboard should now be avaliable.

3. **Take a look at the Dashboard**<br>
   Open your browser and navigate to `http://localhost:8000`. 
   
   After the page loads you should see the a a heading entitled 'A simple dashboard', an insteractive slider and an empty bar chart. Using the mouse to move the slider, we should notice that the bar chart starts updating in real time as the slider value changes.



### 3.4. Containerizing the application

We will use Docker to containerize the application. Docker provides very detailed [documentation](https://docs.docker.com/) that is essencial for any one wanting to start learning how to use it effectively.

Containerizing the julia application means to build a Docker image that holds the application, all its dependencies and configuration into a single confined unit. We define how Docker builds this image with a file called [Dockerfile](./Dockerfile).

After taking a look at the dockerfile and checking out what each line does by reading the comments, we can build our Docker image and lean how to use it by doing the folowing steps:

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
   
   ```bash
   docker image ls
   ```
   
   The output should be something similat to this:
   
   ```bash
   REPOSITORY           TAG       IMAGE ID       CREATED        SIZE
   my-julia-dashboard   latest    de87785ae96e   3 hours ago    1.07GB
   ...                  ...       ...            ...            ...
   ```

3. **Verify the Docker Image:**<br>
   Now, that the Docker image has been created, it meand the application was containerized and can be deployed.
   
   Let's run our newly created image as a Docker container and check if the Julia web dashboard still loads by running the following command:
   ```bash
   docker run --rm -p 8000:8000 my-julia-dashboard
   ```
   
   Breaking down the command we can take a look at it more closely:
   
   - `docker`: Invokes the Docker command-line interface.
   - `run`: Runs a command in a new container.
   - `--rm`: Automatically removes the container when it exits.
   - `-p 8000:8000`: 
     - Maps the host's port 8000 to the container's port 8000.
   - `my-julia-dashboard`: Specifies the name of the image to create a container from.
