# Updating List of PO's in DefenseFlow version 4.x

This script updates the thresholds of multiple PO's in DefenseFlow version 4.x and above using REST API.

The script includes 2 main functions:

1. Creating an Excel file which includes a table of the PO's that configured on the DefenseFlow
by using REST API Calls.

2. Updating all the PO's thresholds which configured in the DefenseFlow 


## Requirements 
Python 3.8:
  - Requests
  - Xlsxwriter
  - Pandas
  - Xlrd
  - Openpyxl

## Installation
```
# apt-get install python3.8
```

## Example Usage

Run the script and follow the Menu:

1.  Create New Po File
2.  Update existing PO's From a file 
3.  Exit

Press 1, to create the Excel File (enter vision IP, user, pass), this function fetches all the PO’s names from the DefenseFlow
And creates an Excel file called: PO_Thresholds_File.xls 

Edit this file with the desired thresholds for each PO's

**Any threshold field that should not be configured needs to be filled with 0 value**

**Dont leave any empty cell in the PO's Excel file**

Run the script again:
Press 2 in order to apply the new thresholds configuration.

**The script should run from the path where the file was created**

## Copyright

Copyright 2021 Radware LTD

## License
GNU General Public License v3.0
