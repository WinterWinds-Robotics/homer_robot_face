FROM osrf/ros:melodic-desktop-full
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y xauth && \
    apt-get install -y ros-melodic-gazebo-ros-pkgs && \
    apt-get install -y ros-melodic-desktop-full && \
    apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && \
    apt-get install -y vim

WORKDIR /home/catkin_ws
ADD . /home/catkin_ws/src/homer_robot_face

RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial main universe" >> /etc/apt/sources.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main universe" >> /etc/apt/sources.list
RUN apt-get update && rosdep install --from-paths /home/catkin_ws/src/ --ignore-src --rosdistro melodic -y -r --os=debian:stretch

RUN /bin/bash -c 'source /opt/ros/melodic/setup.bash; cd /home/catkin_ws; catkin_make'
RUN echo "source /home/catkin_ws/devel/setup.bash" >> ~/.bashrc

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
