ACTION=$1

if [ -z "$ACTION" ];
  then
    echo "usage: $0 <build|run|stop|start|remove|rerun|attach|logs>";
    exit 1;
fi

_build() {
  # Download config.json
  wget https://gist.githubusercontent.com/samir1/0a9013e3466de6f4a5f0fba04a3a13b6/raw/891251cdc9a60213398cc1520b1b76e52cdf73f8/config.json

  # Generate Dockerfile
  echo $FROM > Dockerfile
  cat Dockerfile.common >> Dockerfile
  eval $SED_COMMAND

  # Build
  docker build --tag="samir1/homebridge:$VERSION" .
}

_run() {
  # Run (first time)
  docker run -d -p 0.0.0.0:51826:51826 -v /etc/homebridge:/root/.homebridge --net=host --name $IMAGE_NAME samir1/homebridge:$VERSION
}

_stop() {
  # Stop
  docker stop $IMAGE_NAME
}

_start() {
  # Start (after stopping)
  docker start $IMAGE_NAME
}

_remove() {
  # Remove
  docker rm $IMAGE_NAME
}

_rerun() {
  _stop
  _remove
  _run
}

_attach() {
  docker exec -ti $IMAGE_NAME bash
}

_logs() {
  docker logs $IMAGE_NAME
}

eval _$ACTION
