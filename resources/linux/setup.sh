#!/bin/bash
cd lib/ruby
mkdir wr-gems
cp wr-gems.jar wr-gems
cd wr-gems
jar xf wr-gems.jar
rm wr-gems.jar
cd ..
mv wr-gems.jar wr-gems-unpacked.jar
echo Setup complete.