OS=$1

if [ "$OS" == "" ]; then
  OS='fedora'
fi

PROJECT_DIR=`git rev-parse --show-toplevel`
TEST_DIR="$PROJECT_DIR/test-environment"

HOST_USER_ID=`id -u`
HOST_USER_GID=`id -g`

docker stop ansible-$OS

docker build \
  --build-arg "HOST_USER_ID=$HOST_USER_ID" \
  --build-arg "HOST_USER_GID=$HOST_USER_GID" \
  -t docker-apps:ansible-$OS \
  -f "$TEST_DIR/Dockerfile.$OS" $TEST_DIR

docker run --rm -d \
  -v $PROJECT_DIR:/home/kieran/projects/ansible-projects \
  --hostname=ansible-$OS \
  --name=ansible-$OS \
  docker-apps:ansible-$OS

docker exec -it ansible-$OS ansible-playbook -K -v --become workstation.yml
