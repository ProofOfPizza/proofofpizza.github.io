---
header:
  overlay_image: /assets/images/alley1.jpg
title: "#AutomaticAlley #2 - What are these docker things and how do I remove them?"
categories:
  - tech
  - AutomaticAlley
tags:
  - automatic-alley
  - linux
  - automation
  - docker
---
E voila: the second in the series, doubtfully dubbed #AutomaticAlley. It's where I will share small bits and bites of scripts and other tiny tricks to automate away boring and error prone stuff. The things we keep doing all the time, the things that annoy us that we need to to automate especially if we want to keep working on the command line a sane practice. This time we focus on docker: what is what, and how do I get rid of it?

Docker is a wonderful tool, all the cool kids use it, and once you get your head around it it can really make your life easier. Any modern webapp these days is deployed as docker containers. And also to make your life easier as a developer we can run things in containers and then connect to them, making it unnecessary to (globally) install languages, compilers, databases etc. And also make it super easy to work with different versions of these things.

But playing around with docker for a but can quickly cause you to have all sorts of zombie-resources on your machine clogging up the system. So what kind of stuff is there, and as always with zombies: How do we kill 'em'?

## Basic docker resources ...and some magic!
Let's have a look at some docker basics first: Images and containers. Images are the build artifacts of whatever software we're looking at. They are uneditable and we do not run them. Containers on the other hand are the running instances of these images, and we can interact with them and change their state etc. Images are built, following a set of instructions in Dockerfile. Then images are often stored in repositories such as Azure's ACR, AWS ACR or the default and popular Docker Hub. From there you can pull an image directly without having to build it.

Let's have a closer look at building images. We'll start with a simple Dockerfile:
{% include code-header.html %}
```
FROM alpine
RUN echo "echo 'important instructions'" > important_file.sh
CMD ["echo", "nice container"]
```

Dockerfiles start by defining a base-image, which is pulled from the repository and then instructions to do on top of that. In this case we start with the minimalistic linux alpine. Then we `RUN` a command, in this case writing an echo statement to a shell file. The last command `CMD` defines the default command to run when we start a container based on this image. In this case it will just print "nice container" to the console. Time to build it!
Copy the contents to a file named `Dockerfile` in a directory of your choice. Then run `docker build -t nice-image .` to build an image, give it a tag "nice-image" and send `.`, the current directory as a build-context to the docker daemon to use. It will output something like:

```
Sending build context to Docker daemon  7.168kB
Step 1/4 : FROM alpine
latest: Pulling from library/alpine
59bf1c3509f3: Pull complete
Digest: sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300
Status: Downloaded newer image for alpine:latest
 ---> c059bfaa849c
Step 2/4 : RUN echo "echo 'important instructions'" > important_file.sh
 ---> Running in 926d20de0231
Removing intermediate container 926d20de0231
 ---> 2233c37ed4aa
Step 3/4 : RUN sh important_file.sh
 ---> Running in 564f1f21d181
important instructions
Removing intermediate container 564f1f21d181
 ---> 141475288e04
Step 4/4 : CMD ["echo", "nice container"]
 ---> Running in cc177e0b79a5
Removing intermediate container cc177e0b79a5
 ---> 0f18ba2ef435
Successfully built 0f18ba2ef435
Successfully tagged nice-image:latest
```

What we see here is that the image is built in layers. Each instruction in the dockerfile that might affect the contents of the image get's it own layer. A layer is basically an image, of at least a recognizable definition of one, such that docker can cache them, and reuse them. Let's have a look: `docker image ls -a` (list all images):
```
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
nice-image   latest    0f18ba2ef435   4 minutes ago   5.59MB
<none>       <none>    2233c37ed4aa   4 minutes ago   5.59MB
<none>       <none>    141475288e04   4 minutes ago   5.59MB
alpine       latest    c059bfaa849c   2 months ago    5.59MB
```
See the hashes we saw earlier, of the steps are the very same we see here! The image marked `<none>:<none>` are the intermediate layers. Now we can remove our image by running:
{% include code-header.html %}
```
docker image rm nice-image
```
If we then look at the images, running `docker image ls -a` we see that all layers have been removed, except the base image linux-alpine.
If we then rerun the build by `docker build -t nice image .` we now see:
```
Sending build context to Docker daemon  7.168kB
Step 1/4 : FROM alpine
 ---> c059bfaa849c
Step 2/4 : RUN echo "echo 'important instructions'" > important_file.sh
...
```
The base image did not have to be downloaded again, and could be immediately reused. Reuse is also possible for other layers. We could for instance add an instruction:
{% include code-header.html %}
```
FROM alpine
RUN echo "echo 'important instructions'" > important_file.sh
RUN sh important_file.sh
CMD ["echo", "nice container"]
```
and build it `docker build -t another-nice-image .`. We see:
```
Sending build context to Docker daemon  7.168kB
Step 1/4 : FROM alpine
 ---> c059bfaa849c
Step 2/4 : RUN echo "echo 'important instructions'" > important_file.sh
 ---> Using cache
 ---> aeda0b7aec99
Step 3/4 : RUN sh important_file.sh
 ---> Running in 3f02413a1730
important instructions
Removing intermediate container 3f02413a1730
 ---> 2fb715eca8d7
Step 4/4 : CMD ["echo", "nice container"]
 ---> Running in f6b0d490c6c0
Removing intermediate container f6b0d490c6c0
 ---> aa8f1fdd1130
Successfully built aa8f1fdd1130
Successfully tagged another-nice-image:latest
```
Here we see that for the layer where we write to the sh file it says `Using cache`, meaning it reuses that layer. Also as expected, running the sh file in Step 3/4 writes "nice image" to the console. Now if we remove "nice-image" what will happen ? `docker image rm nice-image && docker image ls -a`

Dangling images are images that are untagged, and only taking up space, unrelated to any containers or even images. Unused images are images (intermediate layers as well) that are not used in any containers.

`docker image ls -a`
`docker image ls -f dangling=true`
`docker image prune -f`
`docker image prune -af`
-f to not ask confirmation

`docker system prune --volumes`

`docker network create bla_net`
`docker network ls`
`docker network prune -f`
`docker volume prune -f`
`docker system prune -a --volumes`


[proctools]: https://unix.stackexchange.com/questions/225/pgrep-and-pkill-alternatives-on-mac-os-x
