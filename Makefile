CONTAINER_NAME := hcrcont
TAG_NAME := imatag
IMAGE_NAME := hcrimg
WORKSPACE_DIR := C:/dev/ros_ws
YOUR_IP := localhost

stop:
	@docker stop ${CONTAINER_NAME} || exit 0
	@docker rm ${CONTAINER_NAME} || exit 0

build: stop
	@docker build --tag=${IMAGE_NAME}:${TAG_NAME} .

# Updated USB setup with new syntax
setup-usb:
	@powershell.exe "usbipd attach --wsl --busid 3-2"

run:
	@docker run -e ROS_IP=${YOUR_IP} \
		-e ROS_MASTER_URI=http://${YOUR_IP}:11311 \
		-e DISPLAY \
		--device=/dev/ttyUSB0:/dev/ttyUSB0 \
		--device=/dev/ttyUSB1:/dev/ttyUSB1 \
		-v ${WORKSPACE_DIR}:/root/ros_ws \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-it \
		--privileged \
		--network host \
		--name ${CONTAINER_NAME} \
		${IMAGE_NAME}:${TAG_NAME}
	@docker stop ${CONTAINER_NAME} || exit 0
	@docker rm ${CONTAINER_NAME} || exit 0

exec:
	@docker exec -it ${CONTAINER_NAME} bash

