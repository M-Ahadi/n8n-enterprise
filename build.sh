#!/bin/bash
set -e

RELEASE=$(python3 check_new_release.py)
if [ -z "$RELEASE" ]; then
  echo "*********************************"
  echo ""
  echo ""
  echo "There is no new release! Stopping workflow."
  echo ""
  echo ""
  echo "*********************************"
  exit 0
fi
echo "*********************************"
echo ""
echo ""
echo "Building n8n Enterprise Docker image with tag: $RELEASE"
echo ""
echo ""
echo "*********************************"

export RELEASE=$RELEASE
export IMAGE_TAG=$RELEASE
export IMAGE_BASE_NAME=mojtabaahadi/n8n
./patch.sh


docker push mojtabaahadi/n8n:$RELEASE
docker tag mojtabaahadi/n8n:$RELEASE mojtabaahadi/n8n:enterprise
docker push mojtabaahadi/n8n:enterprise
docker image rm mojtabaahadi/n8n:$RELEASE
docker image rm mojtabaahadi/n8n:enterprise
docker system prune -f

python3 send_message.py