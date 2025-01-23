#!/bin/bash
set -xe

rm -rf Storge.xcworkspace
rm -rf Storge.xcodeproj
rm -rf $HOME/Library/Developer/Xcode/DerivedData
rm -rf Derived/
tuist clean

