#!/bin/bash

# Function to display the contents of the current directory
function display_directory_contents {
    
    echo
    echo "Select a directory:"
    local count=1
    local directories=()

    for item in ./*; do
        if [[ -d "$item" ]]; then
            echo "  [$count] $(basename "$item")"
            directories+=("$item")
            count=$((count + 1))
        fi
    done

    echo "  [$count] Go to parent directory"
    echo "  [0] Confirm directory"
    echo
    echo "Current directory: $(pwd)"
    read -r -p "Enter the number of the directory to navigate to, or 0 to confirm the current directory: " choice

    if [[ "$choice" -eq 0 ]]; then
        return 0
    elif [[ "$choice" -eq "$count" ]]; then
        cd .. || exit
        display_directory_contents
    elif [[ "$choice" -gt 0 ]] && [[ "$choice" -lt "$count" ]]; then
        cd "${directories[$((choice - 1))]}" || exit
        display_directory_contents
    else
        echo "Invalid choice. Please try again."
        display_directory_contents
    fi
}

# Start the directory navigator
display_directory_contents

# Get the starting block title from the user
echo "Enter the text part of the starting block title (e.g., Instructor Demo: API vs. HTML Routes):"
read start_title
if [[ $start_title == *"Instructor Do: Stoke Curiosity"* ]]; then
    while true; do
        echo "Warning: The title contains 'Instructor Do: Stoke Curiosity'. Do you want to continue? (yes/no)"
        read response
        if [[ $response == "no" ]]; then
            exit
        elif [[ $response == "yes" ]]; then
            break
        else
            echo "Please type 'yes' or 'no'."
        fi
    done
fi
start_title="### [0-9]*\. .*"$start_title

# Get the new content from the user
echo "Enter the new content:"
read new_content

# Get the ending block title from the user
echo "Enter the text part of the ending block title (e.g., Instructor Demo: Query Parameters):"
read end_title
if [[ $end_title == *"Instructor Do: Stoke Curiosity"* ]]; then
    while true; do
        echo "Warning: The title contains 'Instructor Do: Stoke Curiosity'. Do you want to continue? (yes/no)"
        read response
        if [[ $response == "no" ]]; then
            exit
        elif [[ $response == "yes" ]]; then
            break
        else
            echo "Please type 'yes' or 'no'."
        fi
    done
fi
end_title="### [0-9]*\. .*"$end_title

# Temp file
temp_file="temp.md"

# Initialize a counter for modified files
count=0

# Loop through each markdown file in all subdirectories
while IFS= read -r -d '' file
do
    # Print everything before the start pattern, the new content, and everything after the end pattern
    awk -v start_title="$start_title" -v new_content="$new_content" -v end_title="$end_title" '
    BEGIN {print_before=1; replace=0}
    $0 ~ start_title {print_before=0; replace=1; print $0; next}
    replace && $0 ~ end_title {print_before=1; replace=0; print new_content; print $0; next}
    print_before' "$file" > "$temp_file"
    
    # If the original file does not end with a newline, remove the newline at the end of the temp file
    if [[ $(tail -c1 "$file" | wc -l) -eq 0 ]] && [ "$(tail -c1 "$temp_file")" == "" ]; then
        perl -pi -e 'chomp if eof' "$temp_file"
    fi
    
    # Replace the original file with the temp file and increment count
    if cmp -s "$file" "$temp_file"; then
        rm "$temp_file"
    else
        mv "$temp_file" "$file" 
        ((count++))
        echo "Modified file: $file"
    fi

done < <(find . -name "*.md" -print0)

echo "Total files modified: $count"
