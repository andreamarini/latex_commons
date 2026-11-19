#! /bin/tcsh
#
set filename="lattice.zip"
set LOCAL="Lattice_MBPT"
set REMOTE="overleaf"
#
while ($#argv > 0)
    switch ($argv[1])
        case -c:
            set clean = 1
            shift argv
            breaksw

        case -d:
            set download = 1
            shift argv
            breaksw

        case -u:
            set upload = 1
            shift argv
            breaksw

        default:
            break
    endsw
end

if (!  $?upload && ! $?download && ! $?clean ) then
  echo "Usage: $0 [-u]pload [-d]ownload [-c]lean"
  exit 1
endif
#
if ( -f "paper.pdf" )  make clean
#
if ($?clean) then
 rm -fr TO_UPLOAD ../$REMOTE
 exit 0
endif
#
cd ..
#
if ( ! -d $REMOTE ) then
 echo "Unzipping..."
 rm -fr $REMOTE
 mkdir $REMOTE
 cd $REMOTE/
 mv ~/Desktop/Downloads/$filename .
 unzip $filename
 rm -f $filename
 cd ..
endif
#
if (! -d $REMOTE ) exit 0
#
if ($?download) then
 foreach f ($REMOTE/*)
    set base = $f:t
    if (-e $LOCAL/$base) then
       diff $REMOTE/$base $LOCAL/$base > /dev/null
       if ($status == 1) then
         echo "Comparing $REMOTE/$base"
         meld $REMOTE/$base $LOCAL/$base
       endif
    else
       echo "$base exists only in $REMOTE"
       cp $REMOTE/$base $LOCAL/$base
    endif
 end
endif
#
if ($?upload) then
 foreach f ($LOCAL/*)
    set base = $f:t 
    if ( "$base" == "compare.tcsh") continue
    if (-e $REMOTE/$base) then
       diff $LOCAL/$base $REMOTE/$base > /dev/null
       if ($status == 1) then
         echo "Comparing $LOCAL/$base"
         #meld $LOCAL/$base $REMOTE/$base
         mkdir -p $LOCAL/TO_UPLOAD
         cp $LOCAL/$base $LOCAL/TO_UPLOAD
       endif
    else
       mkdir -p $LOCAL/TO_UPLOAD
       echo "$base exists only in $LOCAL"
       cp $LOCAL/$base $LOCAL/TO_UPLOAD
    endif
 end
endif

