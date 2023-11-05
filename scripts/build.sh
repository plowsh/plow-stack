#!/usr/bin/env bash
set -e

DEFAULT_PREFIX=plow
DEFAULT_PLATFORM=amd64
DEFAULT_TAG=development

REPO_PREFIX=${DEFAULT_PREFIX}
PLATFORM=${DEFAULT_PLATFORM}
TAG=${DEFAULT_TAG}

usage() {
  echo "Usage: "
  echo "  $0 [-f <prefix>] [-p <platform>] [-t <tag>] <dir>"
  echo "    -f    prefix to use for images    (default: ${DEFAULT_PREFIX})"
  echo "    -p    platform to use for images  (default: ${DEFAULT_PLATFORM})"
  echo "    -t    tag to use for images       (default: ${DEFAULT_TAG})"
  echo "   <dir>  directory to build"
  exit 1;
}

while getopts "f:p:t:" o; do
  case "${o}" in
    f)
      REPO_PREFIX=${OPTARG}
      ;;
    p)
      PLATFORM=${OPTARG}
      ;;
    t)
      TAG=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    :)
      usage
      ;;
  esac
done

BASE_DIR=$(realpath base)

if [[ -z ${REPO_PREFIX} ]]; then
  echo "Prefix cannot be empty"
  echo
  usage
  exit 1
fi

if [[ -z ${BASE_DIR} ]]; then
  echo "Must specify directory"
  echo
  usage
  exit 1
fi

IMAGE_DIR=$(realpath "${BASE_DIR}")
BASE_IMAGE=${REPO_PREFIX}-base:${TAG}
RUN_IMAGE=${REPO_PREFIX}-run:${TAG}
BUILD_IMAGE=${REPO_PREFIX}-build:${TAG}
FROM_IMAGE=$(head -n1 "${IMAGE_DIR}"/Dockerfile | cut -d' ' -f2)

# Get target distro information
DISTRO_NAME=$(docker run --rm "${FROM_IMAGE}" cat /etc/os-release | grep '^ID=' | cut -d'=' -f2)
echo "DISTRO_NAME: ${DISTRO_NAME}"
DISTRO_VERSION=$(docker run --rm "${FROM_IMAGE}" cat /etc/os-release | grep '^VERSION_ID=' | cut -d'=' -f2)
echo "DISTRO_VERSION: ${DISTRO_VERSION}"
echo "TAG: ${TAG}"

echo "BUILDING ${BASE_IMAGE}..."
docker build --platform=${PLATFORM} \
--build-arg "distro_name=${DISTRO_NAME}" \
--build-arg "distro_version=${DISTRO_VERSION}" \
-t "${BASE_IMAGE}" \
"${IMAGE_DIR}"

echo "BUILDING ${BUILD_IMAGE}..."
docker build --platform=${PLATFORM} \
  --build-arg "base_image=${BASE_IMAGE}" \
  -t "${BUILD_IMAGE}" \
  "${IMAGE_DIR}/build"

echo "BUILDING ${RUN_IMAGE}..."
docker build --platform=${PLATFORM} \
  --build-arg "base_image=${BASE_IMAGE}" \
  -t "${RUN_IMAGE}" \
  "${IMAGE_DIR}/run"

echo
echo "BASE IMAGES BUILT!"
echo
echo "Images:"
for IMAGE in "${BASE_IMAGE}" "${BUILD_IMAGE}" "${RUN_IMAGE}"; do
  echo "    ${IMAGE}"
done
