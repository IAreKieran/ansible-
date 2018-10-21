APP=$1

PROJECT_DIR=`git rev-parse --show-toplevel`
APP_DIR="$PROJECT_DIR/test-environment"

HOST_USER_ID=`id -u`
HOST_USER_GID=`id -g`

docker stop ansible-$APP

docker build \
  --build-arg "HOST_USER_ID=$HOST_USER_ID" \
  --build-arg "HOST_USER_GID=$HOST_USER_GID" \
  -t docker-apps:ansible-$APP \
  -f "$APP_DIR/Dockerfile.$APP" $APP_DIR

docker run --rm -d \
  -v $PROJECT_DIR:/home/kieran/projects/ansible-projects \
  --hostname=ansible-$APP \
  --name=ansible-$APP \
  docker-apps:ansible-$APP

docker exec -it ansible-$APP ansible-playbook -K -v --become workstation.yml
