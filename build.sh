#!/bin/bash

make stage -C substrate
cd nitoHelper
make stage
cd ..
make package install
