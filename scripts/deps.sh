#! /bin/bash

set -e

function install_ios_frameworks() {
  carthage update --new-resolver --platform ios --no-use-binaries --no-build
  rm -rf Carthage/Checkouts/GRDB.swift/GRDBCipher.xcodeproj
  rm -rf Carthage/Checkouts/GRDB.swift/GRDBCustom.xcodeproj
  rm -rf Carthage/Checkouts/apollo-ios/ApolloSQLite.xcodeproj
  rm -rf Carthage/Checkouts/apollo-ios/ApolloWebSocket.xcodeproj
  rm -rf Carthage/Checkouts/Starscream
  rm -rf Carthage/Checkouts/SQLite.swift
  carthage build --platform ios --cache-builds
}

install_ios_frameworks

set +e
