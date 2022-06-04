# arch-girga-dev
A Dockerfile to build an image of "arch-girga-dev", a Docker image based on archlinux:base-devel.

# Setup
Docker's command line interface is actually really simple once you learn the commands and why you use certain options. To set up a "arch-girga-dev" environment using a downloaded Dockerfile, we need to accomplish 4 main things: we need to [build an image](#building-an-image), we need to [tag the image](#tagging-an-image) so we can use it (basically, name it), we need to [create a container](#creating-a-container) (basically, it represents a unique "instance" of the image that we will run, but only the changes between the container and the base image are stored), and we need to be able to [start this container on command](#starting-a-container). Before we do any of this, however, we must [obtain the Dockerfile](#obtaining) that contains the instructions that Docker needs in order to construct our image. It's usually a good idea to see what a Dockerfile does before building an image with it on a machine with sensitive information on it. You can read it in plaintext with any text editor to make sure it isn't going to do anything strange.

# Obtaining
To obtain the Dockerfile, you can download it direcly from GitLab: [Download](https://gitlab.com/nickgirga/arch-girga-dev/-/raw/main/Dockerfile?inline=false)

This is all you will need to create the image that you will need to use the "arch-girga-dev" environment. Proceed to the [Building an Image](#building-an-image) section.

# Building an Image
This is the fun part of Docker. You get to watch all the automation take place. Simply navigate to the directory that contains the Dockerfile and run `docker build .`. This will tell Docker to build an image using resources in the current directory ("`.`"). Docker will then read the Dockerfile line by line and execute the instructions in order to build a final image. It is possible that changes to the base image make steps in the Dockerfile no longer function (e.g. a command line utility is updated and changes how you interface with it). It's a good idea to pay attention to the output for any severe issues. When Docker finishes building the image, it will say something like `Successfully built 1a2b3c4d5e6f`. This cryptic identifier at the end represents your image. Make note of this identifier and head to the [Tagging an Image](#tagging-an-image) section.

# Tagging an Image
In order to actually utilize our image, we must give it a tag (or a name). Docker makes this super simple: `docker tag [identifier] [desired_tag]`. If you just built your image, you should be able to simply copy and paste the indentifier from the finishing text of the build process. If you no longer have this identifier, you can find it by running `docker image ls -a`. This should show you all of your images. If you keep this organized, there should only be one image without a name. Use that image ID. The `docker tag` command will essentially name your image, so that you can refer to it when you [create a container](#creating-a-container).

Here's an example with a fake identifier: `docker tag 1a2b3c4d5e6f arch-girga-dev`. This will name the tag for the image with the identifier of `1a2b3c4d5e6f` to `latest` (this is assumed) and the repository for it to `arch-girga-dev`.

# Creating a Container
To create a container, you need to use the `docker run` command. To fully understand the command, you should view `docker run --help` and play around with it, making/destroying containers yourself to get a feel for it.

To quickly get up and going you can just run `docker run -it --name=dev [image] /usr/bin/zsh`, replacing `[image]` with the name that you gave the image in the [Tagging an Image](#tagging-an-image) section. It will automatically use the "latest" tag for the specified image. If you forgot what you named your image repository/tag, you can find it by running `docker image ls -a`.

Optionally, we can throw `-v [host_shared_directory]:[docker_shared_directory]` after the `--name` option and before the `[image]` option to create a shared directory between the host and the docker container. This can be useful if you intent on destroying and recreating a container often, yet need persistent storage for project files, for example.

Here's an example of what I personally use: `docker run -it --name=dev -v /home/nick/Projects/_docker/storage:/data arch-girga-dev /usr/bin/zsh`. This will tell Docker to create a container named `dev` with the `arch-girga-dev:latest` image (again, `latest` is assumed) with settings that allow us to interact with its isolated version of zsh in our terminal, while still having access to files and directories stored in the host device's `/home/nick/Projects/_docker/storage` directory. Make sure you adjust this command to suit your system and where your directories are located. When you run it, it will automatically start the container. However, if we want to start it again once it stops, we must start it using a different method. See more in the [Starting a Container](#starting-a-container) section.

# Starting a Container
To start an existing, but stopped container, it's fairly simple. Launch configuration was already set when we ran the `docker run` command, so you only need to specify the container you want to start and the way you want to interact with it. We can easily do this with `docker start -ai [container]`. The `-ai` part essentially means what the `-it` part does in the `docker run` command: we want to interact with it right now in the terminal.

Here's an example with the container name we've be using so far: `docker start -ai dev`. That's seriously it. It will bring you right back into the "arch-girga-dev" environment, logged in and ready to work.

# Basic Removal
Generally speaking, it's a pretty simple task to stop the container (essentially, just `exit` until no terminal is logged into it anymore) and run `docker container prune`. This command will remove any stopped containers. Ensure this will not delete any important data before running it.

To remove individual containers, remove images, and more, I strongly advise making use of man entries with `man docker` and the help resources (which can usually be read by adding `--help` after a command). Docker has great built-in documentation regarding its command line interface and you'll likely understand it much better just checking out all of the options and playing with them all yourself. It's a really intuitive tool.
