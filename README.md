#GettingAndCleaningData-201408
##Corse project for the Getting and Cleaning Data cource on Coursera, august 2014.

My run_analysis script runs in verbose mode, i.e. text is printed in the prompt explaining what's happening (instead of just having to wait it out and hope everything works fine). To allow for easier reading of these lines, after each of them is printed R is instructed to wait for 1 second before continuing execution.

Code segments such as the following can therefore be found in many key points of the script:

```
print("")
Sys.sleep(1)
```