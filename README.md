# Human-Centred Robotics 2024

This repository is intended for Imperial College students taking the Human Centred Robotics class with Pr. Demiris.

## Important notions
Some basic notions of Docker and ROS would be helpful to get you started. Most of these notions have been covered in the lectures and in today's presentation; if some of them are unclear, use the links below to refresh your memory,

- Linux
  - [Environment variables](https://www.freecodecamp.org/news/how-to-set-an-environment-variable-in-linux/)
- [Docker](https://medium.com/swlh/understand-dockerfile-dd11746ed183)
  - Container
  - Image
  - Volumes
  - docker build, docker run, docker exec commands
- [ROS](https://roboticsbackend.com/what-is-a-ros-topic/)
  - Workspace
  - Package
  - Node
  - Topic
  - roscore, roslaunch, rosrun


## Tutorial
The purpose of this tutorial is to give you some hands-on practice. There are 3 main parts:
 1) 10 minutes presentation of the main concepts.
 2) Controlling a P3AT in simulation, by learning to use ROS, Docker, Makefiles and Gazebo.
 3) Controlling the real robot, for which you'll need to connect over SSH to the robot's laptop, set up your VNC server, and manage a multi-machine ROS network.

### Real robot - Preparation: Adding new packages
To work with the real P3AT, we need some new packages
- [aria-legacy](https://github.com/moshulu/aria-legacy/): Adept MobileRobots Advanced Robotics Interface for Applications.
- [rosaria](https://github.com/amor-ros-pkg/rosaria.git): A ROS package leveraging ARIA library to communicate with AMR robots.

Let's first add the driver to our Dockerfile:
1. Find the section for this in your Dockerfile.
1. `git clone` the package using docker.
1. `cd` into this package, `make` and `make install`.

   \*hint: You can joint instructions together with `&&`. E.g. `cd aria-legacy && make && make install`

Now add the ROS wrapper:
1. Set your work directory to be your workspace.
1. `cd` into the src folder.
1. `git clone` the package and `source` your ROS workspace.
1. `catkin build`.

You can build your docker image now.

### Real robot - Task 1: Connecting to a remote machine
First, make sure that you have connected to this network: 5G-WiFi-27JF-5GHz.

Before you connect to the robot, we need to configure some parameters.
- ROS_IP=192.168.1.? (Your IP address can be found with `$ ifconfig` or through network settings, install the package with `$ sudo apt install net-tools` if not found)
- ROS_MASTER_URI=http://192.168.1.253:11311 (Your master's IP address) 

You can configure your environment variables by passing when launching your docker container.
Modify these parameters in your Makefile.

Test the connecting by running `$ rostopic list`. If you see actual topics, congratulations. 

Inform the GTAs of your success and now you can move the robot with `$ rosrun teleop_twist_keyboard teleop_twist_keyboard.py cmd_vel:=/RosAria/cmd_vel`. Don't forget to source your workspace!

### Real robot - Task 2: Controlling the remote machine
The driver was previously started on the master machine by your GTAs. Now it's time to get rid of the them.

To do this, you need to 'hack' into that laptop and take control. This can be done with SSH.

1. First generate your key:
`$ ssh-keygen`.
1. Try to connect to the master machine:
`$ ssh prl@192.168.1.253​`. The password is `prlhuman`.
1. To avoid typing the password everytime, you can ask the master machine to "remember" you: 
`$ ssh-copy-id prl@192.168.1.253`.
1. To avoid typing the IP address everytime, you can give the master machine a nick name:
    - open file `~/.ssh/config`
    - add the following:
        ```
        Host nickname
        HostName 192.168.1.253
        User prl
        IdentityFile ~/.ssh/id_rsa
        ForwardX11 yes
        ```
    - save and exit
1. `cd hcr2024_tutorial` then `make run`. Now you can launch the driver yourself with `rosrun rosaria RosAria _port:=/dev/ttyUSB0`. Once the driver is running, you can control the robot as in Task 1.

Congratulations! You have finished all tutorial today. Have a nice one!
