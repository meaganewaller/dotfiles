#!/usr/bin/env bash

function usage() {
  echo "USAGE: $0 [check|fix]"
  exit 1
}

function ok() {
  echo -n "OK"
  [ -n "${1}" ] && echo -n " (${1})"
  echo
}

function problem() {
  echo "PROBLEM"
  [ -n "${1}" ] && echo "(${1})"
}

function checking() {
  printf "Checking %s... " "${1}"
}

function checking_header() {
  echo "----------------------------------------"
  printf " Checking %s...\n" "${1}"
  echo "----------------------------------------"
  echo
}

function checking_item() {
  printf "-- %s... " "${1}"
}

function fixing_header() {
  echo "----------------------------------------"
  printf " Fixing %s...\n" "${1}"
  echo "----------------------------------------"
  echo
}

function fixing() {
  printf "Fixing %s... " "${1}"
}
