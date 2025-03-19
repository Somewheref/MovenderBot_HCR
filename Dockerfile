FROM ros:noetic

# Ignore this for now
SHELL [ "/bin/bash", "-c" ]  

RUN apt-get update && apt-get install -y \
    python3-catkin-tools \
    git \
    build-essential \
    qt5-default \
    libqt5gui5 \
    libqt5widgets5 \
    libqt5core5a \
    ros-noetic-rviz \
    dos2unix \
    nano

####################################################
# Clone the Aria-legacy repository and build it here
RUN git clone https://github.com/moshulu/aria-legacy.git && \
    cd aria-legacy && \
    make && \
    make install
####################################################

WORKDIR /root/ros_ws/
RUN mkdir src && source /opt/ros/noetic/setup.bash && catkin init

# Install the ROS dependencies
RUN apt install -y \
    ros-noetic-tf \
    ros-noetic-teleop-twist-keyboard \
    ros-noetic-rviz \
    ros-noetic-joint-state-publisher \
    ros-noetic-robot-state-publisher

####################################################
# Clone and build ROSARIA
RUN cd /root/ros_ws/src && \
    git clone https://github.com/amor-ros-pkg/rosaria.git && \
    cd /root/ros_ws && \
    source /opt/ros/noetic/setup.bash && \
    catkin build && \
    echo "source /root/ros_ws/devel/setup.bash" >> ~/.bashrc
####################################################

# CMD provides the default command to execute when starting a container
CMD bash
