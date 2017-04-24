// MORZEOVKA
TYPE
	pStrom = ^tStrom;	// kostra struktury na desifrovanie morzeovky
	tStrom = record
		bodka, ciarka, otec : pStrom;
		znak : char;
	end;

VAR
	KOREN : pStrom;

{ Tabulka na priradenie kodu k zadanemu znaku. Pred znak, ktory nie je v tabulke bude vlozene # }
function TABULKA(znak : char) : string;
	begin
		// ak je znak male pismeno, preved na velke, inak nechaj tak
		if (('a' <= znak) and (znak <= 'z')) then
			znak := chr( ord(znak) + 32 );  // 32 je posun rozdiel medzi malym a velkym pismenom: ord('a')-ord('A')

		case znak of:
			'A' : TABULKA := '.-';
			'B' : TABULKA := '-...';
			'C' : TABULKA := '-.-.';
			'D' : TABULKA := '-..';
			'E' : TABULKA := '.';
			'F' : TABULKA := '..-.';
			'G' : TABULKA := '--.';
			'H' : TABULKA := '....';
			'I' : TABULKA := '..';
			'J' : TABULKA := '.---';
			'K' : TABULKA := '-.-';
			'L' : TABULKA := '.-..';
			'M' : TABULKA := '--';
			'N' : TABULKA := '-.';
			'O' : TABULKA := '---';
			'P' : TABULKA := '.--.';
			'Q' : TABULKA := '--.-';
			'R' : TABULKA := '.-.';
			'S' : TABULKA := '...';
			'T' : TABULKA := '-';
			'U' : TABULKA := '..-';
			'V' : TABULKA := '...-';
			'W' : TABULKA := '.--';
			'X' : TABULKA := '-..-';
			'Y' : TABULKA := '-.--';
			'Z' : TABULKA := '--..';

			'0' : TABULKA := '-----';
			'1' : TABULKA := '.----';
			'2' : TABULKA := '..---';
			'3' : TABULKA := '...--';
			'4' : TABULKA := '....-';
			'5' : TABULKA := '.....';
			'6' : TABULKA := '-....';
			'7' : TABULKA := '--...';
			'8' : TABULKA := '---..';
			'9' : TABULKA := '----.';
			else TABULKA := '#' + znak;
		end;
	end;

{ Vytvori strom opacny k morzeovej tabulke - na dekodovanie morzeovky  }
procedure vytvorStrom();
	var
		i, j : integer;
		s : string;
		otec : pStrom;
	begin
		{ Vytvori novu vetvu, aby storm mohol dalej pokracovat bodkou alebo ciarkou alebo tam obsahoval pismeno }
		function novaVetva(znak : char) : pStrom;
			begin
				new(novaVetva);
				novaVetva^.znak := znak;
				novaVetva^.bodka := nil;
				novaVetva^.ciarka := nil;
			end;
			
		KOREN := novaVetva(''); // zasadime stromcek
		for i:=1 to 255 do // prehladame vsetky znaky a zistime, ci je znak v kodovacej tabulke
			begin
				s := TABULKA(chr(i)); // najdeme kod znaku
				if ((s[1] = '.') or (s[1] = '-')) then // ak je v tabulke/morzeovke kod, zacina sa teda bodkou alebo ciarkou, tak vybuduje vetvy pre tento kod alebo dosadi pismeno
					begin
						otec := KOREN;
						for j:=1 to length(s) do
							begin
								case s[j] of:
									'.' : begin
										if (otec^.bodka = nil) then otec^.bodka := novaVetva('');
										otec := otec^.bodka;
										end;
									'-' : begin
										if (otec^.ciarka = nil) then otec^.ciarka := novaVetva('');
										otec := otec^.ciarka;
										end;
							end;
						if (otec^.znak <> '') then
							writeln('POZOR: znak ' + otec^.znak + ' a znak ' + chr(i) + ' maju rovnaky kod ' + s);
						otec^.znak := chr(i);
					end;
			end;

	end;

procedure prelozDoMorzeovky(vstupny_subor, vystupny_subor, konvencia);
	var
		vstup, vystup : text;
		znak : char;
	begin
		assign(vstup, vstupny_subor);
		reset(vstup);
		assign(vystup, vystupny_subor);
		rewrite(vystup);

		if (konvencia = 1) then // medzinarodna konvencia
			begin
			end
		else // vizualna konvencia
			while not eof(vstup) do
				begin
					read(vstup, znak);
					if (znak = ' ') then
						write(vystup, '   ')
					else
						write(vystup, TABULKA(znak) + ' ');
				end;
		close(vstup);
		close(vystup);
	end;

procedure prelozZMorzeovky(vstupny_subor, vystupny_subor);

function rozpoznajVstup(vstupny_subor) : integer;

VAR
	vstupny_subor, vystupny_subor,  : string;
	rezim, konvencia : integer;

BEGIN
	write('Zadaj nazov vstupneho suboru (predvolene je "vstup.txt"): ');
	read(vstupny_subor);
	if (length(vstupny_subor) = 0) then vstupny_subor := 'vstup.txt';

	write('Zadaj nazov vystupneho suboru (predvolene je "vystup.txt"): ');
	read(vystupny_subor);
	if (length(vystupny_subor) = 0) then vystupny_subor := 'vystup.txt';

	write('Zadaj 1 pre sifrovanie do morzeovky, zadaj 2 pre desifrovanie, ine cislo pre automaticky rezim: ');
	read(rezim);
	if ((rezim <> 1) and (rezim <> 2) then rezim := rozpoznajVstup(vstupny_subor);

	if (rezim = 1) then
		begin
			write('Aku konvenciu pouzit pre sifrovanie do morzeovky?\n'
			    + '1 - medzinarodna konvencia:\n'
			    + '    bodka (.) - jedna jednotka (znak)\n'
			    + '    ciarka (___) - tri jednotky\n'
			    + '    oddelenie znakov (   ) - tri jednotky\n'
			    + '    oddelenie slov (       ) - sedem jednotiek\n'
			    + '\n'
			    + '2 - vizualna konvencia:\n'
			    + '    bodka (.) - jeden znak\n'
			    + '    ciarka (-) - jeden znak\n'
			    + '    oddelenie znakov ( ) - jeden znak\n'
			    + '    oddelenie slov (   ) - tri znaky\n'
			    + '\n'
			    + 'Zadaj 1 alebo 2 (predvolena je vizualna konvencia): ');
			read(konvencia);
			if (konvencia <> 1) then konvencia := 2;
		end;
	
	if (rezim = 1) then
		prelozDoMorzeovky(vstupny_subor, vystupny_subor, konvencia)
	else
		prelozZMorzeovky(vstupny_subor, vystupny_subor);
END.
