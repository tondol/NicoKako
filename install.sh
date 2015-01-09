#!/bin/sh
SYSTEM_DIR=`dirname $0`
cd $SYSTEM_DIR
if type ruby > /dev/null 2>&1; then
  :
else
  echo "please install Ruby 1.9 or above"
  exit 1  
fi
if type bundle > /dev/null 2>&1; then
  :
else
  echo "please install bundler"
  exit 1
fi
if type php > /dev/null 2>&1; then
  :
else
  echo "please install PHP 5.5 or above"
  exit 1
fi
if type rtmpdump > /dev/null 2>&1; then
  :
else
  echo "please install rtmpdump"
  exit 1  
fi
ruby install.rb
