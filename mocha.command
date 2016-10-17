###############################################################################
#   Script by Joseph Burger 2016 - candyapplecorn@gmail.com
###############################################################################

# When opening a .command, the first shell command is simply
# the name of the file. We can use this to extract the 
# directory.
open_dir=`history | tail -n 1`
open_dir=`echo $open_dir | awk '{print $2}'`

# Finally, remove the filename ( /open.command )
WORKING_DIRECTORY=${open_dir%/*}


cd $WORKING_DIRECTORY;

# TEST #1 - Did they rename assessment.js?
if [[ ! -e "assessment.js" ]]; then
    echo
    echo "    ERROR: 'assessment.js' not found. Your work "
    echo "            must be in the file 'assessment.js'"
    echo

    for maybe in `ls | egrep ".*js$"`; 
        do echo "    Perhaps $maybe should be named to assessment.js?"
    done

    echo

    bash
    exit
fi
#
# TEST #2 b - Do they have test/test.js?
if [[ ! -e 'test/test.js' ]]; then
    if [[ ! -e 'test' ]]; then
        msg='test/'
    else
        msg='test/test.js'
    fi

    echo
    echo "      ERROR:                                        "
    echo "          $msg not found.                   "
    echo 
    echo "          There should be a folder called 'test',   "
    echo "          with a file inside named 'test.js'. This  "
    echo "          folder and file came with the original    "
    echo "          assessment.zip                            "
    echo

    bash
    exit
fi

# TEST #3 - Does their assessment run or is there a syntax/semantics error?
# Run mocha just to get passing and failing 
res=`mocha | sed -n -e '/passing/ p' -e '/failing/ p'`

if [[ ! $res ]]; then
    err=`mocha 2>&1 | grep -i "Error"` 

    echo
    echo "      ERROR:                                        "
    echo "       Mocha was unable to run. There was an error  "
    echo "       when attempting to run assessment.js:        "
    echo
    echo "          $err "
    echo
    echo "       If you cannot fix the error, ask for help. "
    echo

    bash
    exit
fi


# Actually run the mocha test
echo Running mocha test in $WORKING_DIRECTORY
mocha

echo $res
echo "Type 'mocha' into your shell to run another test."
bash
