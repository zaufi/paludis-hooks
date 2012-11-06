#!/bin/sh

xsltproc \
    --stringparam 'PN' cmake \
    --stringparam 'PF' cmake-2.8.9-r4 \
    --stringparam 'PR' r4 \
    --stringparam 'PV' 2.8.9 \
    --stringparam 'PVR' 2.8.9-r4 \
    --stringparam 'CATEGORY' dev-utils \
    --stringparam 'REPOSITORY' zaufi-overlay \
    --stringparam 'SLOT' 0 \
    --stringparam 'debug' yes \
    filesystem-manager.xsl sample.xml
