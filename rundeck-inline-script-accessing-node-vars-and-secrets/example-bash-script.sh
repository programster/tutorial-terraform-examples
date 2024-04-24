#!/bin/bash

# This example inline script simply demonstrates accessing information we can retrieve from the nodes definition
# as well as a secret we passed through specifying an option.

echo "My node's nodes custom data point is:"
echo @nodes.myCustomVariable@

echo "My rundeck secret is:"
echo @option.my_inline_script_secret@