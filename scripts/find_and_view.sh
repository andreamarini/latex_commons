#! /bin/tcsh
#
set temp=(`getopt -s tcsh -o g:p:f:h -- $argv:q`)
if ($? != 0) then 
  echo "Terminating..." >/dev/stderr
  exit 1
endif
#
eval set argv=\($temp:q\)
#
while (1)
	switch($1:q)
	case -f:
 		set file=$2:q
		shift; shift
		breaksw
	case -p:
 		set pat=$2:q
		shift; shift
		breaksw
	case -h:
		echo "find_and_view.tcsh:"
		echo " "
                echo "          -f(ile)     <STR>"
                echo "          -p(attern)  <STR>"
		echo " "
                exit 
	case --:
		shift
		break
	endsw
end
if ( $?pat ) then
 find . -name "*.tex" | xargs grep  $pat | awk '{na=split($0,a,":");print a[1]}' | awk '\!seen[$0]++' | xargs gvim -p
endif
if ( $?file ) then
 set str=`echo $file | sed 's/\.o/.F/'`
 f $str | xargs gvim -p
endif

