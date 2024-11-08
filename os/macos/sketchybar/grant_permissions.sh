#!/bin/bash

#!/bin/bash

# Define the directories where you want to apply the changes
directories=("/plugins" "/items")

# Define the file extensions you want to make executable
extensions=("sh" "applescript")

for dir in "${directories[@]}"; do
  for ext in "${extensions[@]}"; do
    for file in "$dir"/*."$ext"; do
      if [ -e "$file" ]; then
        echo "Granting execution permission: $file"
        chmod +x "$file"
      fi
    done
  done
done
