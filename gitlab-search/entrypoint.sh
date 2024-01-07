#!/bin/sh
# Loop to continuously ask for search_text and execute the gitlab-search command
while true
do
    # Ask for input
    printf "\nEnter search_text: "
    read search_text

    # Execute gitlab-search [search_text]
    output="$( gitlab-search $search_text )"

    # Display the result
    printf "\nResult:\n$output\n"

    # Ask to continue or quit
    printf "\nPress any key to continue or 'q' to quit: "
    read -r -n 1 key

    # Check if 'q' is pressed to quit
    if [ "$key" = "q" ]; then
        break
    fi
done