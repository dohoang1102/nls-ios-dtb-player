#!/bin/sh

exit_code=0
test_dir=Tests/Automation
output_dir=tmp/tests


rm -rf $output_dir

for device in iphone ipad; do

  for test in $test_dir/*.js; do

    test_filename=$(basename "$test")

    echo "Running test $test_filename on $device"

    # Use special iphone target to force instruments to no use ipad sim
    if [ "$device" = "iphone" ]; then
      app="$BUILT_PRODUCTS_DIR/DTBPlayer-Phone.app" 
    else
      app="$BUILT_PRODUCTS_DIR/DTB Player.app" 
    fi

    # Ouput directory variables
    device_output=$output_dir/$device
    test_device_output=$device_output/$test_filename

    # Run tests and remember failure if any
    $test_dir/tuneup/run-test "$app" "$test" "$device_output"
    if [ $? -ne 0 ]; then
      exit_code=1
    fi

    # Reformat output directories
    mkdir -p $test_device_output
    mv -- $device_output/Run*/* $test_device_output
    mv -- $device_output/instruments*.trace $test_device_output/instrument.trace

    # Cleanup
    rm -rf $device_output/Run*
  done
done

# CONVERT PLISTS TO HTML

report_ruby_dir=$test_dir/automation-plist-to-html
ruby "$report_ruby_dir/automation-plist-to-html.rb" $output_dir
if [ $? -ne 0 ]; then exit 1; fi

open "$output_dir/report.html"

exit $exit_code

