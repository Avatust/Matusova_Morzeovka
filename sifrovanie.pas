
{Tereza Javurkova  letni semestr 2015/16
zapoctovy program, programovani II }

const hesla: array [1..10] of string = ('autobus','monitor','telefon','brokolice','program','kostel','pohovka','heslo','sklenice','strom');
      cj: array [1..26] of real = (8.4548,1.5582,3.1412,3.6241,10.6751,0.2732,0.2729,1.8567,7.6227,2.1194,3.7367,3.8424,3.2267,

6.6167,8.6977,3.4127,0.0013,4.9136,5.3212,5.7694,3.9422,4.6616,0.0088,0.0755,1.9093,3.1939);

type Pstrom = ^Tstrom ;
     Tstrom = record
       tecka, carka, otec :Pstrom;
       pismeno: char;
     end;
var
txt,t,q,kolik,reseni,pole,i,j,cis,pom,hodnota,b, rozhodnuti,indexy,h : integer;
znak,znk,pis,pism:char;
vstup,vystup,vstup1, vystup1,hesl : text;
frekvence,frekvence1: array[1..26] of integer;
procenta,polerozdilu: array [1..26] of real;
poci:longint;
min,rozdil:real;
heslo: string;
mors,radek,s,rad,pos,ciis : integer;
k :pstrom;



PROCEDURE prevednaprocenta(coo,zkolika,pozic:integer);  {procedura prevede frekvenci vyskytu jednotlivych pismen v textu na procenta}
var g,h:integer;
begin
   procenta[pozic]:= (coo*100)/zkolika;



end;

PROCEDURE porovnej (pocet,pozic:integer;vyskyt:real);  {procedura vypocita rozdil mezi vyskytem pismen v ceskem jazyce a vzskytem v textu a ulozi tento koeficient do promenne 'rozdil'}
var
    g:integer;
begin
   rozdil:=rozdil+ abs(cj[pozic]-vyskyt);

end;

function morse : boolean;
begin
 mors := 0;
 while not eof (vstup) do
  begin
   read (vstup, znk);
   if ((ord (znk) > ord ('a')) and (ord (znk)< ord ('z'))) or ((ord(znk) > ord('A')) and (ord(znk) < ord ('Z'))) then
   begin
    mors := 1;

   end;
  end;
   if mors = 0 then morse := true;
   if mors = 1 then morse := false;

end;

function vytvor (z : char) : Pstrom;
 var vytvoreny : Pstrom;

 begin
  new (vytvoreny);
  vytvoreny^. pismeno := z;
  vytvoreny^. tecka := nil;
  vytvoreny^. carka := nil;
  vytvor := vytvoreny;
 end;


procedure strom;
begin
 k:= vytvor ('0');                       {binarni strom morseovky}
 k^. tecka := vytvor('e');
 k^. tecka^.tecka :=vytvor( 'i');
 k^. tecka^.tecka^.tecka :=vytvor( 's');
 k^. tecka^.tecka^.tecka^.tecka :=vytvor  ('h');
 k^. tecka^.carka :=vytvor ('a');
 k^. tecka^.tecka^.carka :=vytvor ('u');
 k^. tecka^.tecka^.tecka^.carka := vytvor ('v');
 k^. tecka^.tecka^.carka^.tecka := vytvor('f');
 k^. tecka^.carka^.tecka :=vytvor ('r');
 k^. tecka^.carka^.tecka^.tecka :=vytvor ('l');
 k^. tecka^.carka^.carka :=vytvor ('w');
 k^. tecka^.carka^.carka^.tecka :=vytvor ('p');
 k^. tecka^.carka^.carka^.carka :=vytvor ('j');
 k^. carka :=vytvor ('t');
 k^. carka^.carka :=vytvor ('m');
 k^. carka^.carka^.carka :=vytvor ('o');
 k^. carka^.carka^.tecka :=vytvor( 'g');
 k^. carka^.carka^.tecka^.tecka :=vytvor ('z');
 k^. carka^.carka^.tecka^.carka :=vytvor ('q');
 k^. carka^.tecka:= vytvor('n');
 k^. carka^.tecka^.tecka := vytvor('d');
 k^. carka^.tecka^.carka := vytvor('k');
 k^. carka^.tecka^.tecka :=vytvor ('d');
 k^. carka^.tecka^.tecka^.tecka :=vytvor ('b');
 k^. carka^.tecka^.tecka^.carka :=vytvor ('x');
 k^. carka^.tecka^.carka^.carka :=vytvor('y');
 k^. carka^.tecka^.carka^.tecka :=vytvor( 'c');
end;

procedure znic(koren:pstrom);
var list, odpad:pstrom;
begin
 while list^.tecka <> nil do
  begin
   list^.tecka ^. otec :=list;
   list:= list^.tecka;
  end;

 while list<> koren do
  if list^. carka <> nil then
   begin
    odpad:= list^.carka;
    odpad:= nil;
    dispose (odpad);
   end
   else
   begin
   odpad:=list;
   list:= list^.otec;
   odpad := nil;
   dispose (odpad);
   end;

 while list^.carka <> nil do
  begin
   list^.carka ^. otec :=list;
   list:= list^.carka;
  end;

 while list<> koren do
  if list^.tecka <> nil then
   begin
    odpad:= list^.tecka;
    odpad:= nil;
    dispose (odpad);
   end
   else
   begin
   odpad:=list;
   list:= list^.otec;
   odpad := nil;
   dispose (odpad);
   end;

end;

procedure rozmor;
var  poom :Pstrom;
    znak : char;
    mezera : boolean;

begin

 strom;

 reset (vstup);
 rewrite (vystup);

 writeln (vystup, 'Text byl zasifrovan Morseovou abecedou');
 poom  := k;

 while not eof (vstup) do
  begin
   read (vstup,znak);

   if znak <> ' ' then
    begin
     if znak = '.' then
     begin
      poom := poom^.tecka;
      mezera := false;

     end
     else
     if znak = '-' then
     begin
      poom := poom^.carka;
      mezera := false;
     end
     else
     if znak = '/' then
      begin

       if mezera = true then          {aby // byla mezera}
        begin
         write (vystup,' ');
         mezera := false;
        end
        else
        begin
       mezera := true;
       if poom^.pismeno <>'0' then          {0 v koreni stromu}
       write(vystup,poom^. pismeno);
       poom :=k;
       end;
      end
     else
      begin

       write (vystup,znak);
       mezera := false;
      end;
    end;
  end;
 close (vstup);
 close (vystup);
{ znic(k); }
end;

function jevelke (co: integer):boolean;
begin
 if ((co>96) and (co<123)) then
 jevelke := true
 else
 jevelke := false;
end;

function jemale (co: integer): boolean;
begin
 if ((co>64) and (co<91)) then
 jemale := true
 else
 jemale := false;
end;

procedure obraceni;

begin

reset (vstup);
   while not eof(vstup) do
    begin
     read (vstup,znak);
     cis:= ord(znak);
     if (cis>=ord ('A')) and (cis<=ord('Z')) then        {velka pismena}
      begin
       pole:=27-( cis-ord('A')+1);
       frekvence[pole]:= frekvence[pole]+1;
       poci:= poci+1;
      end;

     if (cis>=ord('a')) and (cis<=ord('z')) then         {mala pismena}
      begin
       pole:=27-( cis-ord('a')+1);
       frekvence[pole]:= frekvence[pole]+1;
       poci:= poci+1;
      end;
 end;


 rozdil:=0;
   for t:=1 to 26 do prevednaprocenta(frekvence[t],poci,t);

   for t:=1 to 26 do porovnej(poci,t,procenta[t]);

   polerozdilu[27]:=rozdil;

end;
procedure obratzpet;
var znacek : char;
begin

reset (vstup);
rewrite (vystup);
writeln (vystup,'Text byl zasifrovan obracenou abecedou');
   while not eof(vstup) do
    begin
     read (vstup,znak);
     cis:= ord(znak);
     if (cis>=ord ('A')) and (cis<=ord('Z')) then        {velka pismena}
      begin
       znacek:=chr(27- (cis- ord('A')+1)+ord('A')-1);

       write (vystup, znacek);
      end
      else
     if (cis>=ord('a')) and (cis<=ord('z')) then         {mala pismena}
      begin
       znacek:=chr(27-(cis-ord('a')+1)+ord('a')-1);

       write (vystup,znacek);
      end
      else
      begin
       write (vystup,znak);
      end;
 end;
 close(vystup);
end;

procedure  posunutizpet (okolik: integer);

begin

assign (vstup1,'vystup.txt');
reset (vstup1);
assign (vystup1,'rozsifrovani.txt');
rewrite (vystup1);


while not eof (vstup1) do
 begin
  read (vstup1, pis);
   hodnota:= ord(pis);

   if ((hodnota>64) and (hodnota<91))  then        {velka pismena}
    begin
     hodnota:= hodnota-okolik;
     if hodnota<65 then hodnota:= hodnota +26;
     pism:= chr(hodnota);
     write (vystup1,pism);

    end;

   if jevelke(hodnota) then         {mala pismena}
    begin
      hodnota:=hodnota-okolik;
     if hodnota<97 then hodnota:= hodnota +26;
     pism:= chr(hodnota);
     write (vystup1,pism);

    end;
   if ((hodnota<65) or ((hodnota>90)and (hodnota<97)) or (hodnota>122)) then
   write (vystup1,pis);
                                                    {ostatni znaky}

  end;
  writeln(vystup1);
  write (vystup1, 'text byl posunut o ',okolik);
  close (vstup1);
  close (vystup1);
end;




BEGIN
 assign (vstup,'vystup.txt');
 assign (vystup, 'rozsifrovani.txt');
 reset (vstup);
 rewrite (vystup);

 if morse = true then               {neobsahuje pismena, je to tedy morseovka}
  begin

  rozmor;

  end
  else
  begin



  writeln (' Chcete rozsifrovavat pomoci hesel?');
  writeln (' Ano - 1');
  writeln (' Ne - 2');
  read (rozhodnuti);



  if rozhodnuti = 1 then
  begin

  for b:= 1 to 10 do
  begin
  writeln;

  rozdil:=0;
  poci:= 0;
  for h:= 1 to 26 do procenta[h]:= 0;
  for h:= 1 to 26 do frekvence1[h]:= 0;
   reset (vstup);
   heslo:= hesla[b];




   while not eof (vstup) do
   begin
   read (vstup,znak);
   cis:= ord(znak);

   if (cis>=ord ('A')) and (cis<=ord('Z')) then        {velka pismena}
      begin
       poci:= poci+1;

       pos:= (poci-1) mod length(heslo)+1;

       ciis:= cis -(ord(heslo[pos])) + ord('A')-1+26+6;
       if ciis< ord('A') then ciis:=ciis + 26;
       indexy := ciis-ord('A') +1;
       frekvence1[indexy] := frekvence1[indexy] + 1;

       write (vystup,chr(ciis));


      end
      else
     if (cis>=ord('a')) and (cis<=ord('z')) then         {mala pismena}
      begin
       poci:= poci+1;
       pos:= (poci-1) mod length(heslo)+1;
       ciis:= cis - ord(heslo[pos]) + ord('a')-1;
       if ciis< ord('a') then ciis:=ciis +26;
       indexy:= ciis- ord('a') +1;
       frekvence1[indexy]:= frekvence1[indexy] +1;

       write (vystup,chr(ciis));
      end
      else
      write (vystup,chr(cis));
     end;


     for h:= 1 to 26 do prevednaprocenta(frekvence1[h],poci,h );
     for h:= 1 to 26 do porovnej (poci, h,procenta[h]);
     polerozdilu[b]:= rozdil;

   end;

  min:= polerozdilu[1];
  for b:= 1 to 10 do
   if polerozdilu[b]<= min then
    begin
      min := polerozdilu[b];
      heslo := hesla[b];            {heslo s nejmensim rozdilem od frekvence vyskytu v ceskem jazyce}
    end;
  poci := 0;
  reset (vstup);
  rewrite (vystup);
  writeln (vystup,' Heslo je ',heslo);   {rozsifrujeme pomoci vhodneho hesla}
  while not eof (vstup) do
  begin
   read (vstup,znak);
   cis:= ord(znak);
     if (cis>=ord ('A')) and (cis<=ord('Z')) then        {velka pismena}
      begin
       poci:= poci+1;
       pos:= (poci-1) mod length(heslo)+1;
       ciis:= cis -(ord(heslo[pos])) + ord('A')-1+26+6;
       if ciis< ord('A') then ciis:=ciis + 26;

       write (vystup,chr(ciis));


      end
      else
     if (cis>=ord('a')) and (cis<=ord('z')) then         {mala pismena}
      begin
       poci:= poci+1;
       pos:= (poci-1) mod length(heslo)+1;
       ciis:= cis - ord(heslo[pos]) + ord('a')-1;
       if ciis< ord('a') then ciis:=ciis +26;

       write (vystup,chr(ciis));
      end
      else
      write (vystup,chr(cis));



  end;



  close(vystup);
  end
  else
  begin

  if rozhodnuti = 2 then write ('Rozsifrovavam bez hesel');

   obraceni;


 poci:=0;




 for t:= 1 to 26 do frekvence[t]:= 0;


 reset(vstup);
 writeln;

   while not eof(vstup) do   {do pole 'frekvence' ulozime pocet jednotlivych pismen v textu}
    begin
     read (vstup,znak);

     cis:= ord(znak);
     if jevelke (cis) then        {velka pismena}
      begin
       pole:= cis-96;

       frekvence[pole]:= frekvence[pole]+1;

       poci:= poci+1;

      end;
     if jemale(cis) then         {mala pismena}
      begin
       pole:= cis-64;
       frekvence[pole]:= frekvence[pole]+1;

       poci:= poci+1;

      end;
    end;

 for q:=1 to 26 do
  begin

   rozdil:=0;

   for t:=1 to 26 do prevednaprocenta(frekvence[t],poci,t);

   for t:=1 to 26 do porovnej(poci,t,procenta[t]);

   polerozdilu[q]:=rozdil;


   begin
     pom:= frekvence[1];
     for i:=2 to 26 do frekvence[i-1]:= frekvence[i];
     frekvence[26]:=pom;
   end;

  end;

 min:=polerozdilu[1];               {nalezne hodnotu posunu, kdy je 'rozdil' nejmensi}
 reseni:=0;
 for q:= 1 to 27 do
  begin
  { write (q,'-',polerozdilu[q]);}
   if polerozdilu[q]<min then
    begin

     min:=polerozdilu[q];
     reseni:=q-1;
    end;
  end;

 if reseni = 26 then
  obratzpet;

 close (vystup);
 close(vstup);   {hodnota, o kterou je text posunutzyje ulozena v 'reseni'}
{////////////////////////////////////////////////////////////////////////////////////////////////////////////////////}

if reseni<26 then

posunutizpet (reseni);
end;

end;

END.
