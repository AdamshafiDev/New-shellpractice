#!/bin/bash

# echo -n  "enter the pin number  :"
  
#   read -s  PIN

#   echo "the number is:"$PIN




 echo -n "Enter PIN: "
 PIN=""

 while k = read -rsn1 key
  do
    
     if [[ $key == "" ]]; then
        break
     fi

    PIN+="$key"
    echo -n "*"
   done

# echo
# echo "Entered PIN: $PIN"







