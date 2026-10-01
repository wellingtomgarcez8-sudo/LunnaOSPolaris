set dotenv-load

IMAGE_NAME := "lunnaos-polaris"
TAG := "dev"

check:
    @./build_files/validate.sh

build:
    podman build --pull=newer -t localhost/{{IMAGE_NAME}}:{{TAG}} .

build-iso:
    ./scripts/build-iso.sh localhost/{{IMAGE_NAME}}:{{TAG}}

build-qcow2:
    ./scripts/build-disk.sh localhost/{{IMAGE_NAME}}:{{TAG}} qcow2

build-raw:
    ./scripts/build-disk.sh localhost/{{IMAGE_NAME}}:{{TAG}} raw
