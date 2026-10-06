{
 #
 if (FNR==1){
  A=0;
  system("rm -f *.l ALL");
#  CMD="abs.l ";
 }
 if (match($0,"abstract")>0 && A==0)
  {A=1}
 else if (match($0,"abstract")>0 && A==1) 
  {A=2;
   system("wc -w abs.l");
  };
 if (A==1) {print $0 >> "abs.l"};
#
# if (match($0,"input")>0 && A==2 && match($0,"acknowledgments")==0 )
 if (match($0,"input")>0 && A==2 )
 {
  gsub("\\\\input{","");
  gsub("}","");
  system("cat "$0".tex | grep -v % > "$0".l");
  system("wc -w "$0".l");
  CMD=CMD " " $0".l";
 }
 #
 if (match($0,"end")>0 && match($0,"document")>0) 
 {
  system("echo "CMD);
  system("cat "CMD" > ALL");
  system("wc -w ALL");
 }

 #
}
