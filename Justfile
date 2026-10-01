set dotenv-load

IMAGE_NAME := "lunnaos-polaris"
TAG := "dev"

check:
    @bash ./build_files/validate.sh

build:
    podman build --pull=newer -t localhost/{{IMAGE_NAME}}:{{TAG}} .

build-iso:
    bash ./scripts/build-iso.sh localhost/{{IMAGE_NAME}}:{{TAG}}

build-qcow2:
    bash ./scripts/build-disk.sh localhost/{{IMAGE_NAME}}:{{TAG}} qcow2

build-raw:
    bash ./scripts/build-disk.sh localhost/{{IMAGE_NAME}}:{{TAG}} raw
