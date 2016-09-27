x='bob+smith+william ghol+steve'
OLD_IFS=$IFS    # save internal field separator
IFS="+"         # set it to '+'
set -- $x       # make the result positional parameters
IFS=$OLD_IFS    # restore IFS
var1=$1
var2=$2
var3=$3
var4=$4
echo var1=$var1
echo var2=$var2
echo var3=$var3
echo var4=$var4
