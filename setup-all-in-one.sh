#!/bin/bash
set -e

################################################################################
# BASE CONFIGURATION                                                           #
################################################################################
SCRIPT_DIR=$(cd $(dirname $0) && pwd)
SCRIPT_NAME=$(basename $0)
BASE_DIR=$(cd $SCRIPT_DIR/.. && pwd)
MODULE_NAME=    #This is not a module, but a use-case script

if [ ! -f ${BASE_DIR}/common/common.sh ]; then
  echo "Missing file ../common/common.sh. Please make sure that all required modules are downloaded or run the download.sh script."
  exit
fi

source ${BASE_DIR}/common/common.sh

PARAMS="-i" # All subscripts that are called from this script should use be none interactive
if $REBUILD; then
    PARAMS = "$PARAMS -r"
fi
if $BUILD_ONLY; then
    PARAMS = "$PARAMS -b"
fi


# Product Catalog
echo_header "Bulding and deploying the Product Catalog service"
$BASE_DIR/catalog/deploy.sh ${PARAMS} > /dev/null

# Product Inventory
echo_header "Buiding and deploying the Inventory service"
$BASE_DIR/inventory/deploy.sh ${PARAMS} > /dev/null

# Shopping-cart
echo_header "Buiding and deploying the Cart service"
$BASE_DIR/shoppingcart/deploy.sh ${PARAMS} > /dev/null

# Gateway
echo_header "Buiding and deploying the Gateway service"
$BASE_DIR/gateway/deploy.sh ${PARAMS} > /dev/null

if $INSTALL_SSO; then
  echo_header "Deploy Red Hat Single Sign-on"
  $BASE_DIR/sso/deploy.sh ${PARAMS} > /dev/null
  # UI
  echo_header "Buiding and deploying the WEB UI service"
  $BASE_DIR/web-ui/deploy.sh ${PARAMS} -g ${COOLSTORE_GW_ENDPOINT} -s ${SSO_URL}> /dev/null
else 
  # UI
  echo_header "Buiding and deploying the WEB UI service"
  $BASE_DIR/web-ui/deploy.sh ${PARAMS} -g ${COOLSTORE_GW_ENDPOINT} > /dev/null
fi


