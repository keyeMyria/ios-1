#! /bin/bash

# if [ -d "Carthage" ]; then
carthage update --new-resolver --platform ios --no-use-binaries --no-build
rm -rf Carthage/Checkouts/GRDB.swift/GRDBCipher.xcodeproj
rm -rf Carthage/Checkouts/GRDB.swift/GRDBCustom.xcodeproj
rm -rf Carthage/Checkouts/apollo-ios/ApolloSQLite.xcodeproj
rm -rf Carthage/Checkouts/apollo-ios/ApolloWebSocket.xcodeproj
# rm -rf Carthage/Checkouts/Starscream
# rm -rf Carthage/Checkouts/SQLite.swift
carthage build --platform ios --cache-builds
# fi
