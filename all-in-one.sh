#!/bin/bash
set -e

################################################################################
# BASE CONFIGURATION                                                           #
################################################################################
MODULE_NAME=    #This is not a module, but a use-case script


source $(dirname $0)/common/common.sh

PARAMS="-i" # All subscripts are not interactive
if $REBUILD; then
    PARAMS = "$PARAMS -r"
fi
if $BUILD_ONLY; then
    PARAMS = "$PARAMS -b"
fi


# Product Catalog
echo_header "Bulding and deploying the Product Catalog service"
$BASE_DIR/coolstore-catalog/deploy.sh -i > /dev/null

# Product Inventory
echo_header "Buiding and deploying the Inventory service"
$BASE_DIR/coolstore-inventory/deploy.sh -i > /dev/null

# Shopping-cart
echo_header "Buiding and deploying the Cart service"
$BASE_DIR/coolstore-shoppingcart/deploy.sh -i > /dev/null

# Gateway
echo_header "Buiding and deploying the Gateway service"
$BASE_DIR/coolstore-gateway/deploy.sh -i > /dev/null

if $INSTALL_SSO; then
  echo_header "Deploy Red Hat Single Sign-on"
  $BASE_DIR/coolstore-sso/deploy.sh -i > /dev/null
  # UI
  echo_header "Buiding and deploying the WEB UI service"
  $BASE_DIR/coolstore-ui/deploy.sh -i -g ${COOLSTORE_GW_ENDPOINT} -s ${SSO_URL}> /dev/null
else 
  # UI
  echo_header "Buiding and deploying the WEB UI service"
  $BASE_DIR/coolstore-ui/deploy.sh -i -g ${COOLSTORE_GW_ENDPOINT} > /dev/null
fi


