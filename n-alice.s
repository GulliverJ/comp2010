s1:string := "Alice in Wonderland";
s2:string := "Gilgamesh";
s3:string := "One Thousand and One Nights";

fdef foo()
{
	jack : int := 10;
	jack := 5;
};

main {
  key:string := "ic";  
  books:seq<string> := [s1,s2,s3];

  found:bool  := F;
  i:int := 0;
  tmp:string;

  while (i<len(books)) do 
     tmp := books[i];
     if (key in tmp) then found := T; 
     else fi
     i := i + 1;
  od

  return;
}