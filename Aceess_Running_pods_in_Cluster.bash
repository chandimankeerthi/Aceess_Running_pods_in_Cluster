#!/bin/bash

# Retrieve the pod names in running state and store them in an array
pod_names=($(kubectl get po --field-selector=status.phase=Running --no-headers=true -o custom-columns=:metadata.name))

# Check if there are any running pods
if [ ${#pod_names[@]} -eq 0 ]; then
  echo "No running pods found."
  exit 1
fi

# Display the available pod names
echo "Available running pods:"
for ((i=0; i<${#pod_names[@]}; i++)); do
  echo "$(($i+1)). ${pod_names[$i]}"
done

# Prompt the user to select a pod
read -p "Enter the number of the pod to access: " pod_number

# Validate the user input
if [[ $pod_number =~ ^[0-9]+$ ]] && [ $pod_number -ge 1 ] && [ $pod_number -le ${#pod_names[@]} ]; then
  selected_pod=${pod_names[$((pod_number-1))]}
  echo "Selected pod: $selected_pod"

  # Execute the command to get into the pod's bash shell
  kubectl exec -it $selected_pod -- bash
else
  echo "Invalid input. Please enter a valid number."
  exit 1
fi