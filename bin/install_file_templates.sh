#!/bin/bash
rm -rf ~/Library/Developer/Xcode/Templates
mkdir ~/Library/Developer/Xcode/Templates
mkdir ~/Library/Developer/Xcode/Templates/Source
cp -a ./file_templates/* ~/Library/Developer/Xcode/Templates/Source
