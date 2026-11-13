#! /bin/tcsh
#
# License-Identifier: GPL
#
# Copyright (C) 2020 The Yambo Team
#
# Authors (see AUTHORS file for details): AM
#
#
# command line parsing
#----------------------
#
set temp=(`getopt -s tcsh -o c:dg:m:f:r:oh --long call:,do_it,grep:,remove:fine:,replace:,overwrite,help -- $argv:q`)
if ($? != 0) then 
  echo "Terminating..." >/dev/stderr
  exit 1
endif
#
eval set argv=\($temp:q\)
#
while (1)
	switch($1:q)
	case -c:
	case --call:
 		set CALL_pat=$2:q
		shift; shift
		breaksw
	case -d:
	case --do_it:
 		set DOIT="yes"
		shift 
		breaksw
	case -o:
	case --overwrite:
 		set OVER="yes"
		shift 
		breaksw
	case -g:
	case --grep:
 		set GREP_pat=$2:q
		shift; shift
		breaksw
	case -m:
	case --remove:
 		set RM_pat=$2:q
		shift; shift
		breaksw
	case -f:
	case --find:
 		set find_pat=$2:q
		shift; shift
		breaksw
	case -r:
	case --replace:
 		set replace_pat=$2:q
		shift;shift
		breaksw
	case -h:
		echo "find_and_replaace.tcsh:"
		echo " "
                echo "          -f(ind)    <STR>"
                echo "          -r(eplace) <STR>"
		echo " "
		echo "optionals: "
                echo "          -g(rep)    <STR>"
                echo "          -re(m)ove  <STR>"
                echo "          -(c)al)    <STR>"
                echo "          -d(o_it)"
                echo "          -o(ovrewrite)"
		echo " "
                exit 
	case --:
		shift
		break
	endsw
end

set candidates = `find . -name '*.tex'`

set file_list=""
foreach file ($candidates)
 set MATCH=`grep $find_pat $file | wc -l`
 if ( $MATCH > 0 )  then
   set file_list="$file_list $file"
 endif
end

rm -f find_and_replace.awk
echo "{" > find_and_replace.awk
if ( $?find_pat ) echo 'find_pat="'$find_pat'"' >> find_and_replace.awk
if ( $?replace_pat ) echo 'replace_pat="'$replace_pat'"' >> find_and_replace.awk
if ( $?CALL_pat ) then
  echo 'call_pat="'$CALL_pat'"' >> find_and_replace.awk
endif
if ( $?GREP_pat ) then
  echo 'grep_pat="'$GREP_pat'"' >> find_and_replace.awk
endif
if ( $?RM_pat ) then
  echo 'rm_pat="'$RM_pat'"' >> find_and_replace.awk
endif
if ( $?DOIT ) then
 echo 'doit="'$DOIT'"' >> find_and_replace.awk
endif
if ( $?OVER ) then
 echo 'overwrite="yes"' >> find_and_replace.awk
endif
cat ./scripts/find_and_replace_engine.awk  >> find_and_replace.awk

unalias cp
unalias mv
foreach file  ($file_list)
 if ( $?DOIT ) then
  awk -f ./find_and_replace.awk $file > "${file}_new"
  set is_different = `diff ${file}_new $file | wc -l`
  if ( $is_different != 0 ) then
    mv ${file}_new $file
  else
    rm -f ${file}_new
  endif
 else
  awk -f ./find_and_replace.awk $file 
 endif
end
rm -f ./find_and_replace.awk 
exit 0
