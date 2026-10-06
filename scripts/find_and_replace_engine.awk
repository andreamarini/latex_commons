#
# INIT
#
if (NR==1) { report_fname = "yes" }
line=$0
find_task="no"
split($0, lchars, "")
split(find_pat, fchars, "")
split(replace_pat, rchars, "")
split(line,line_array)
n_line=asort(line_array,line_scratch)
gsub("#"," ",replace_pat)
#
# Anything to do?
#
loop=1
if (index ( line , find_pat ) == 0 || index (line_array[1] , "!") > 0 ){ loop =0 }
if ( grep_pat && index ( line , grep_pat ) == 0){loop=0}
if ( loop == 0 )
{
 if (doit ) { print line }
 next
}
#
# CALL pattern section
#
loop=0
if ( call_pat && index ( line , call_pat ) > 0 ) {loop=1}
if ( loop == 1 )
{ 
 j=1 
 n_blanks=match(line,line_array[1])
 new_line=""
 while ( j <= n_blanks-2 ){ new_line= new_line " " ; j=j+1} 
 j=1
 while ( j <= n_line )
 {
  piece=line_array[j]
  gsub("\\("," ",piece)
  gsub("\\)"," ",piece)
  #gsub(","," ",piece)
  gsub(";"," ",piece)
  gsub(":"," ",piece)
  gsub("="," ",piece)
  gsub("%"," ",piece)
  gsub(">"," ",piece)
  gsub("<"," ",piece)
  split(piece,piece_array)
  n_pieces=asort(piece_array,piece_scratch)
  k=1
  while ( k <= n_pieces )
  {
   if ( piece_array[k] == find_pat && line_array[j-1] == call_pat ) {find_task="yes"}
   if ( piece_array[k] == find_pat && piece_array[k-1] == call_pat ) {find_task="yes"}
   k=k+1
  }
  if (find_task == "yes" ) 
  { 
   if (overwrite) {
    for (i=index(line,find_pat); i <= index(line,find_pat)+length(replace_pat)-1; i++) {
     u=i-index(line,find_pat)+1
     lchars[i]=rchars[u]
    }
    for (i=index(line,find_pat)+length(replace_pat); i <= index(line,find_pat)+length(find_pat)-1; i++) {
     lchars[i]=" "
    }
    new_line=""
    for (i=1; i <= length($0); i++) {
     new_line= new_line lchars[i] 
    }
   }else{
    new_line=line
    gsub(find_pat,replace_pat,new_line) 
   }
  }
  j=j+1
 }
}
#
# GREP pattern section
#
if ( grep_pat && loop == 0  )
{
 find_task = "yes"
 if (grep_pat && index ( line , grep_pat ) == 0 ) { find_task="no" }
 if (find_task == "yes"){
  if (overwrite) {
   for (i=index(line,find_pat); i <= index(line,find_pat)+length(replace_pat)-1; i++) {
    j=i-index(line,find_pat)+1
    lchars[i]=rchars[j]
   }
   for (i=index(line,find_pat)+length(replace_pat); i <= index(line,find_pat)+length(find_pat)-1; i++) {
    lchars[i]=" "
   }
   new_line=""
   for (i=1; i <= length($0); i++) {
    new_line= new_line lchars[i] 
   }
  }else{
   new_line=line
   gsub(find_pat,replace_pat,new_line) 
  }
  loop=1
 }
}
#
# Simple replace
#
if ( loop == 0 && ! grep_pat && ! call_pat )
{
 find_task = "yes"
 if (overwrite) {
  for (i=index(line,find_pat); i <= index(line,find_pat)+length(replace_pat)-1; i++) {
   j=i-index(line,find_pat)+1
   lchars[i]=rchars[j]
  }
  for (i=index(line,find_pat)+length(replace_pat); i <= index(line,find_pat)+length(find_pat)-1; i++) {
   lchars[i]=" "
  }
  new_line=""
  for (i=1; i <= length($0); i++) {
   new_line= new_line lchars[i] 
  }
 }else{
  new_line=line
  gsub(find_pat,replace_pat,new_line) 
 }
 loop=1
}
#
#
# REMOVE pattern section
#
print_line = "yes"
if ( rm_pat && index ( line , rm_pat ) > 0 && index (line_array[1] , "!") ==0 )
{
 print_line=no
 find_task="yes"
 if ( grep_pat && index ( line , grep_pat ) == 0 )
 {
  print_line=yes
  find_task=no
 }
}
#
# Finalization
#
if (line_scratch[1] == "!")  find_task="no"

if (find_task == "yes")
{
 if (! doit ) {
  if ( report_fname == "yes" )
  {
    print "### Acting on " FILENAME  " ###"
    report_fname = "no"
  }
  print " Line " FNR
  print " OLD " line 
  if (print_line == "yes") print " NEW " new_line 
 }
 line=new_line
}
if (doit && print_line == "yes" ) { print line }
}
