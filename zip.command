###############################################################################
#   Script by Joseph Burger 2016 - candyapplecorn@gmail.com
###############################################################################
#
#   This script prompts the user for their first and last name. 
#   It then creates a zipped archive file of the directory the
#   script was called from, and names it using the user's fn & ln.
#

# When opening a .command, the first shell command is simply
# the name of the file. We can use this to extract the 
# directory.
open_dir=`history | tail -n 1`
open_dir=`echo $open_dir | awk '{print $2}'`

# Finally, remove the filename ( /zip.command )
WORKING_DIRECTORY=${open_dir%/*}

cd $WORKING_DIRECTORY;

# Prompt the user for their first and last name.
#
echo "Attempting to create an archive file of your assessment."
echo "Please provide your first and last name."
read -p "First name: " first
read -p "Last name: "  last

# Check to see if both the first and last names were provided.
#
if [[ ! $first ]]; then echo "First name not provided. Exiting script."; exit; fi
if [[ ! $last ]]; then echo "Last name not provided. Exiting script."; exit; fi

# Replace spaces
#
first=${first// /_}
last=${last// /_}

# Concatenate the fn, ln and 'archive'
#
fnln=($first $last archive);
fnln=`echo ${fnln[@]} | tr ' ' '_'`

# Delete previous archive files
#
find . -name "*archive*" -delete

####
# Go up a level, make a copy, archive that, move it to old dir, and delete the copy
cd ..
cp -r $WORKING_DIRECTORY ${fnln%_archive}
zip -r "$WORKING_DIRECTORY/$fnln" ${fnln%_archive}
rm -r ${fnln%_archive}
echo "Created archive file '$fnln.zip'"
###

# Create the zip file.
#
#zip -r "$WORKING_DIRECTORY/$fnln" $WORKING_DIRECTORY
#echo "Created archive file '$fnln.zip'"

# Close the window.
#
echo -n -e "\033]0;Create Archive File\007"
osascript -e 'tell application "Terminal" to close (every window whose name contains "Create Archive File")' &
