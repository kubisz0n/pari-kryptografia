\\ Lepsza widocznosc w CLI
default(colors,darkbg);
\\ Wstepne ustawienie ziarna losowosci na obecny unix timestamp
setrand(getwalltime());
\\ Maskowanie powyższego ziarna
\\ Szukam liczby pierwszej stworzonej z:
\\ obecny timestamp * losowa liczba * losowa liczba pierwsza ALE TYLKO 19-cyfrowa, jesli nie to powtorz do skutku
while(#digits(randomize = nextprime(getwalltime()*random(2^15)+1)*nextprime(random(2^22)+1)) != 19,randomize = nextprime(getwalltime()*random(2^15)+1)*nextprime(random(2^22)+1));
\\ Ustawienie nowej liczby jako ziarno
setrand(randomize); \\getrand() aby sprawdzic

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\             TRYB SKRYPTU              \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
podstawowy() = { kill(Tryb); Tryb = PODSTAWOWY; printf("\e[%d;%d;1m\nUstawiono tryb PODSTAWOWY!\n\e[0m", 0, 90); }
zaawansowany() = { Tryb = ZAAWANSOWANY; printf("\e[%d;%d;1m\nUWAGA: Wlaczono tryb ZAAWANSOWANY!\n\e[0m", 0, 33); }

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\               GENERUJ()               \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
generuj() = {
printf("\nJestes w ");printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mgeneruj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\n\e[0m", 0, 92);
	\\ Jaki klucz chcesz wygenerowac
	printf("\n\e[%d;%d;1mJakiego algorytmu chcesz uzyc:\n\e[0m", 0, 93);
	printf("\t\e[%d;%d;1m1\e[0m", 0, 96);printf(". Asymetryczny (na bazie RSA)\n");
	printf("\t\e[%d;%d;1m2\e[0m", 0, 96);printf(". Symetryczny (autorstwa Michala Mazura)\n");
	while(1,
		kill(Wybor);printf("\e[%d;%d;1mWybor (1 lub 2): \e[0m", 0, 90);Wybor = input();
		if(Wybor == 1, generuj_asymetryczny();break;, Wybor == 2, generuj_symetryczny();break;, printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41););
	);
}

generuj_asymetryczny() = {
	printf("\e[%d;%d;1m\nWpisz swoje nazwisko (wyniki zostana zapisane w formacie <nazwisko>.private/public w odpowiednich folderach). Nie uzywaj spacji oraz znakow specjalnych.\n\e[0m", 0, 93);
	while(1,
		kill(Alice);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Alice = Str(input());
		if(type(Alice) != "t_STR" || Alice == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	kill(ERROR);iferr(read(".keychain/"Alice".public"),Y,
	\\print("Plik "Alice".public nie istnieje, kontynuuj");
	ERROR = 0);
	if(ERROR != 0, printf("\e[%d;%d;1mBLAD: Taki plik juz istnieje... przerywam!\e[0m", 0, 41);break;);
	
	if(Tryb == ZAAWANSOWANY, \\ jesli
		printf("\n\e[%d;%d;1mIlu bitowe klucze chcesz wygenerowac? Minimalna dozwolona wartosc to 830.\n\e[0m", 0, 93);
		printf("\t\e[%d;%d;1m862 = 260 cyfr (malo bezpieczny ale szybki)\e[0m", 30, 41);printf("\e[%d;%d;1m.\n\e[0m", 0, 0);
		printf("\t\e[%d;%d;1m1024 = 309 cyfr (bezpieczny i szybki na wiekszoci komputerow)\e[0m", 30, 43);printf("\e[%d;%d;1m.\n\e[0m", 0, 0);
		printf("\t\e[%d;%d;1m2048 = 617 cyfr (bardzo bezpieczny i wolny)\e[0m", 30, 42);printf("\e[%d;%d;1m.\n\e[0m", 0, 0);
		while(1,
			kill(Bity);printf("\e[%d;%d;1mOdpowiedz (numer): \e[0m", 0, 90);Bity = input();
			if(type(Bity) != "t_INT", printf("\e[%d;%d;1mBLAD: Dozwolone sa tylko cyfry!\n\e[0m", 0, 41););
			if(type(Bity) == "t_INT" && Bity < 830,
				printf("\e[%d;%d;1mBLAD: Podaj wartosc wieksza od 829!\n\e[0m", 0, 41);
				printf("\e[%d;%d;1mRSA Factoring Challenge:\e[0m", 0, 37);printf("\e[%d;%d;1m https://en.wikipedia.org/wiki/RSA_Factoring_Challenge\n\e[0m", 0, 92);
			);
			if(type(Bity) == "t_INT" && Bity > 829, break);
		);
		if (Bity >= 1024, printf("\e[%d;%d;1mUWAGA: Szukanie "Bity" bitowej liczby moze chwile zajac. Poczekaj lub przerwij (CTRL + C)\n\e[0m", 0, 33));
		printf("\e[%d;%d;1m\nWykowywanie obliczen dla "Bity" bitowych wartosci...\n\n\e[0m", 0, 37);
		while(1, \\ Sprawdz czy liczba jest tylu bitowa co byc powinna
			p = nextprime(random(2^Bity));
			if(floor(log(p)/log(2))+1==Bity, break);
		); 
		while(1, \\ Sprawdz czy liczba jest tylu bitowa co byc powinna
			q = nextprime(random(2^Bity-10));
			if(floor(log(q)/log(2))+1==Bity, break);
		);
		n = p * q;
		N = (p - 1) * (q - 1);
	, \\ inaczej
		kill(Bity);Bity = 1024;
		printf("\e[%d;%d;1m\nWykowywanie obliczen potrzebnych do kluczy...\n\n\e[0m", 0, 37);
		while(1, \\ Sprawdz czy liczba jest tylu bitowa co byc powinna
			p = nextprime(random(2^Bity));
			if(floor(log(p)/log(2))+1==Bity, break);
		); 
		while(1, \\ Sprawdz czy liczba jest tylu bitowa co byc powinna
			q = nextprime(random(2^Bity-10));
			if(floor(log(q)/log(2))+1==Bity, break);
		);
		n = p * q;
		N = (p - 1) * (q - 1);
	); \\ koniec jesli
	printf("\e[%d;%d;1mMamy to! Dalej...\n\e[0m", 0, 32);
	printf("\e[%d;%d;1m\nTwoja wiadomosc zakodowana w kluczu publicznym (koniecznie w cudzyslowiu \"_\" i bez polskich znakow, np. \"Jan Kowalski 1234 email@dot.pl\" lub pozostaw puste i wcisnij enter aby zostawic jako losowa liczbe\n\e[0m", 0, 93);
	
	kill(Ukryta_wiadomosc);printf("\e[%d;%d;1mWiadomosc: \e[0m", 0, 90);Ukryta_wiadomosc = input();
	
\\	while(1,
\\		kill(Ukryta_wiadomosc);printf("\e[%d;%d;1mWiadomosc: \e[0m", 0, 90);Ukryta_wiadomosc = input();
\\		if(type(Ukryta_wiadomosc) != "t_POL" || type(Ukryta_wiadomosc) != "t_STR",
\\			printf("\e[%d;%d;1mBLAD: Wpisano niedozwolona wartosc!\n\e[0m", 0, 41);
\\		,
\\			break;
\\		);
\\	);

	if(type(Ukryta_wiadomosc) == "t_STR",
		e = eval(concat(zamiana(Ukryta_wiadomosc), "6383838365")); \\ zamiana wiadomosci na liczbe
	,
		e = random(N/2);
	);
	while(gcd(e,N) != 1, e++;);
	\\ d = lift(Mod(e,N)^-1);
	d = (1/e)%N;
	
	\\ Zapisz klucze
	write(".keychain/"Alice".public","e = "e";");
	write(".keychain/"Alice".public","n = "n";");
	write(".private/"Alice".private","d = "d";");
	write(".private/"Alice".private","n = "n";");
	\\pprintf("\e[%d;%d;1m\nZrobione!\n\e[0m", 0, 32);
		if(Tryb == ZAAWANSOWANY, \\ jesli
			printf("\e[%d;%d;1m\nCzy chcesz zapisac swoje p i q? Jesli zgubisz klucz prywatny bedziesz mogl go jeszcze raz policzyc. Odpowiedz (T)ak lub (N)ie\n\e[0m", 0, 93);
				while(1,
					kill(Zapisac_pq);printf("\e[%d;%d;1mOdpowiedz [\e[0m", 0, 90);printf("\e[%d;%d;1mT\e[0m", 0, 92);printf("\e[%d;%d;1m/\e[0m", 0, 90);printf("\e[%d;%d;1mN\e[0m", 0, 91);printf("\e[%d;%d;1m]: \e[0m", 0, 90);Zapisac_pq = input();
						if(Zapisac_pq == t || Zapisac_pq == T || Zapisac_pq == n || Zapisac_pq == N, break);
					printf("\e[%d;%d;1mBLAD: Nie rozumiem, (T)ak czy (N)ie?\e[0m", 0, 41);
				);
			if (Zapisac_pq == t || Zapisac_pq == T,
				write(".private/_"Alice".pq","p = "p";");
				write(".private/_"Alice".pq","q = "q";");
				printf("\e[%d;%d;1m\nZapisano p i q w folderze .private!\n\e[0m", 0, 32);
			);	
			if (Zapisac_pq == n || Zapisac_pq == N, printf("\e[%d;%d;1m\nTYLKO TERAZ NIE ZGUB SWOJEGO KLUCZA PRYWATNEGO!!!\n\e[0m", 0, 33););
		, \\ inaczej
			write(".private/_"Alice".pq","p = "p";");
			write(".private/_"Alice".pq","q = "q";");
		); \\ koniec jesli
	printf("\e[%d;%d;1m\nWszystko gotowe!\e[0m", 0, 32);printf(" Zapisane pliki:\n");
	print("TWOJ KLUCZ PUBLICZNY (mozesz go rozsylac gdzie tylko zechcesz) TO:");
	print("\t.keychain/"Alice".public");
	print("TWOJ KLUCZ PRYWATNY (NIE DZIEL SIE NIM Z NIKIM!) TO:");
	print("\t.private/"Alice".private");
		if (Zapisac_pq == t || Zapisac_pq == T || type(Zapisac_pq) == "t_POL",
			print("SKLADOWE KLUCZA (WYDRUKUJ I ZCHOWAJ GLEBOKO, NIE DZIEL SIE NIMI) TO:");
			print("\t.private/_"Alice".pq");
		);
	printf("\e[%d;%d;1m\nPamietaj! Wyslij "Alice".public do Centrum Autoryzacji.\n\e[0m", 0, 33);
	printf("Bez certyfikatu odbiorca nie sprawdzi czy jestes tym za kogo sie podajesz (");printf("\e[%d;%d;1mcertyfikat()\e[0m", 0, 90);printf(").\n");
	printf("\e[%d;%d;1mUWAGA: Jesli bedzie brakowac ktoregos pliku w folderze PARI, moga wystapic problemy!\e[0m", 0, 33);
	printf("\n\nSzybkie opcje: ");printf("\e[%d;%d;1m\e[0m", 0, 97);printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mgeneruj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\e[0m", 0, 92);printf("\e[%d;%d;1m szyfruj() odszyfruj() podpisz() zweryfikuj()\n\e[0m", 0, 97);
}

generuj_symetryczny() = {
	printf("\e[%d;%d;1m\nWpisz nazwe dla wspolnego klucza (wyniki zostana zapisane w formacie <nazwa>.sym w .keychain). Nie uzywaj spacji oraz znakow specjalnych.\n\e[0m", 0, 93);
	while(1,
		kill(Alice);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Alice = Str(input());
		if(type(Alice) != "t_STR" || Alice == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	kill(ERROR);iferr(read(".keychain/"Alice".sym"),Y,
	\\print("Plik "Alice".sym nie istnieje, kontynuuj");
	ERROR = 0);
	if(ERROR != 0, printf("\e[%d;%d;1mBLAD: Taki plik juz istnieje... przerywam!\e[0m", 0, 41);break;);
	
	n = random([30,70]);
	k = random([30, n!]);
	write(".keychain/"Alice".sym","n = "n";");
	write(".keychain/"Alice".sym","k = "k";");
	printf("\e[%d;%d;1m\nKlucz zostal zapisany w folderze .keychain jako \e[0m", 0, 92);printf("\e[%d;%d;1m"Alice".sym\e[0m", 0, 37);
	printf("\n\nSzybkie opcje: ");printf("\e[%d;%d;1m\e[0m", 0, 97);printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mgeneruj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\e[0m", 0, 92);printf("\e[%d;%d;1m szyfruj() odszyfruj() podpisz() zweryfikuj()\n\e[0m", 0, 97);
}

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\               SZYFRUJ()               \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
szyfruj() = {
printf("\nJestes w ");printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mszyfruj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\n\e[0m", 0, 92);
	printf("\n\e[%d;%d;1mJakiego algorytmu chcesz uzyc:\n\e[0m", 0, 93);
	printf("\t\e[%d;%d;1m1\e[0m", 0, 96);printf(". Asymetryczny (na bazie RSA)\n");
	printf("\t\e[%d;%d;1m2\e[0m", 0, 96);printf(". Symetryczny (autorstwa Michala Mazura)\n");
	while(1,
		kill(Wybor);printf("\e[%d;%d;1mWybor (1 lub 2): \e[0m", 0, 90);Wybor = input();
		if(Wybor == 1, szyfruj_asymetryczny();break;, Wybor == 2, szyfruj_symetryczny();break;, printf("\e[%d;%d;1mBLAD: Wpisz 1 lub 2!\n\e[0m", 0, 41););
	);
}

szyfruj_asymetryczny() = {
	printf("\e[%d;%d;1m\nWpisz swoje nazwisko (tak jak podpisane sa pliki, np. kowalski), \e[0m", 0, 93);printf("\e[%d;%d;1mwymaga obecnosci pliku nazwisko.private\n\e[0m", 0, 93);
	while(1,
		kill(Alice);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Alice = Str(input());
		if(type(Alice) != "t_STR" || Alice == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	read(".private/"Alice".private");Alice_d = d; Alice_n = n;
	read(".keychain/"Alice".public");Alice_e = e; Alice_n = n; smietnik = ec;
	
	
	printf("\e[%d;%d;1m\nPodaj do kogo chcesz szyfrowac (tak jak podpisane sa pliki, np. malinowski)\n\e[0m", 0, 93);
	while(1,
		kill(Bob);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Bob = Str(input());
		if(type(Bob) != "t_STR" || Bob == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	read(".keychain/"Bob".public");Bob_e = e; Bob_n = n;
	
	printf("\e[%d;%d;1m\nWpisz swoja wiadomosc,\e[0m", 0, 93);printf("\e[%d;%d;1m koniecznie zamykajac ja w cudzyslowiu (--> \"_\" <--)\n\e[0m", 0, 91);
	while(1,
		kill(wiadomosc);printf("\e[%d;%d;1mWiadomosc: \e[0m", 0, 90); wiadomosc = Str(input());
		if(#digits(zamiana(wiadomosc)) >= #digits(Alice_n),
			printf("\e[%d;%d;1mBLAD: Wiadomosc nie moze byc dluzsza od najkrotszego klucza! Obecnie: "#digits(zamiana(wiadomosc))/2" znakow ze spacjami na "round(#digits(Alice_n)/2.)-1" dozwolonych.\n\e[0m", 0, 41);
		,
			break;
		);
	);
	\\kodowanie = subst(Pol(Vecsmall(wiadomosc)),'x,256);	\\ text --> int
	kodowanie = zamiana(wiadomosc);	\\ text --> int
	
	printf("\n\e[%d;%d;1mJak chcesz zaszyfrowac wiadomosc:\n\e[0m", 0, 93);
	printf("\t\e[%d;%d;1m1\e[0m", 0, 96);printf(". Kluczem prywatnym (podpis)\n");
	printf("\t\e[%d;%d;1m2\e[0m", 0, 96);printf(". Kluczem publicznym odbiorcy (szyfrowanie)\n");
	printf("\t\e[%d;%d;1m3\e[0m", 0, 96);printf(". Kluczem publicznym odbiorcy i prywatnym nadawcy (szyfrowanie z podpisem)\n");
	printf("\e[%d;%d;1mUWAGA: Pamietaj zeby poinformowac odbiorce, ktory sposob wybrales!\n\e[0m", 0, 33);
	while(1,
		kill(Wybor);printf("\e[%d;%d;1mWybor (1, 2 lub 3): \e[0m", 0, 90);Wybor = input();
			if(Wybor == 1, wynik_szyfrowania = lift(Mod(kodowanie,Alice_n)^Alice_d); break;);
			if(Wybor == 2, wynik_szyfrowania = lift(Mod(kodowanie,Bob_n)^Bob_e); break;);
			if(Wybor == 3,
				if(Alice_n > Bob_n, \\ najpierw mniejszym kluczem zeby zapobiec gubieniu liczb
					zaszyfrowane = lift(Mod(kodowanie,Bob_n)^Bob_e);
					wynik_szyfrowania = lift(Mod(zaszyfrowane,Alice_n)^Alice_d);
					break;
				,
					zaszyfrowane = lift(Mod(kodowanie,Alice_n)^Alice_d);
					wynik_szyfrowania = lift(Mod(zaszyfrowane,Bob_n)^Bob_e);
					break;
				);
			
			);
		printf("\e[%d;%d;1mBLAD: Wpisz 1, 2 lub 3!\n\e[0m", 0, 41);
	);
	printf("\e[%d;%d;1m\n----- POCZATEK ZASZYFROWANEJ WIADOMOSCI DO \e[0m", 0, 90);printf("\e[%d;%d;1m"Bob"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n"wynik_szyfrowania"\n");
	printf("\e[%d;%d;1m\n----- KONIEC ZASZYFROWANEJ WIADOMOSCI DO \e[0m", 0, 90);printf("\e[%d;%d;1m"Bob"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n\nSzybkie opcje: ");printf("\e[%d;%d;1mgeneruj() \e[0m", 0, 97);printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mszyfruj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\e[0m", 0, 92);printf("\e[%d;%d;1m odszyfruj() podpisz() zweryfikuj()\n\e[0m", 0, 97);
}

szyfruj_symetryczny() = {
	printf("\e[%d;%d;1m\nWpisz nazwe klucza (tak jak podpisany jest plik, np. naszklucz), \e[0m", 0, 93);printf("\e[%d;%d;1mwymaga obecnosci pliku nazwa.sym\n\e[0m", 0, 93);
	while(1,
		kill(Alice);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Alice = Str(input());
		if(type(Alice) != "t_STR" || Alice == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);

	printf("\e[%d;%d;1m\nWpisz swoja wiadomosc,\e[0m", 0, 93);printf("\e[%d;%d;1m koniecznie zamykajac ja w cudzyslowiu (--> \"_\" <--)\n\e[0m", 0, 91);
	while(1,
		kill(wiadomosc);printf("\e[%d;%d;1mWiadomosc: \e[0m", 0, 90); wiadomosc = Str(input());
		if(#digits(zamiana(wiadomosc)) >= #digits(Alice_n),
			printf("\e[%d;%d;1mBLAD: Wiadomosc nie moze byc dluzsza od najkrotszego klucza! Obecnie: "#digits(zamiana(wiadomosc))/2" znakow ze spacjami na "round(#digits(Alice_n)/2.)-1" dozwolonych.\n\e[0m", 0, 41);
		,
			break;
		);
	);
	\\kodowanie = subst(Pol(Vecsmall(wiadomosc)),'x,256);	\\ text --> int
	kodowanie = zamiana(wiadomosc);	\\ text --> int
	
	N = kodowanie;
	read(".keychain/"Alice".sym");sym_n = n; sym_k = k;
	N = digits(N);

	if(round(length(N)/sym_n)*sym_n > length(N), q = round(length(N)/sym_n);, q = round(length(N)/sym_n) + 1;);
	M = matrix(q,sym_n);
	for(i = 1, q, i; for(j = 1, sym_n , j; if( (sym_n*i + j - sym_n) <= length(N), M[i,j] = N[sym_n*i+j-sym_n], M[i,j] = 0);););

	klucz = numtoperm(sym_n,sym_k);

	V = vector(q-1);
	for(i = 1, q-1, i; V[i] = Vecsmall(M[i,]););
	szyfr = matrix(q,sym_n);
	for(i = 1, q-1, i; szyfr[i,] = Vec(V[i]*klucz););
	szyfr[q,] = M[q,];
	W = vector(length(N));
	for(i = 1, q, i; for(j = 1, sym_n , j; if(((sym_n*i + j - sym_n) <= length(N)), W[sym_n*i+j-sym_n] = szyfr[i,j]);););
	szyfrogram = fromdigits(W);
	
	printf("\e[%d;%d;1m\n----- POCZATEK ZASZYFROWANEJ WIADOMOSCI KLUCZEM \e[0m", 0, 90);printf("\e[%d;%d;1m"Alice"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n"szyfrogram"\n");
	printf("\e[%d;%d;1m\n----- KONIEC ZASZYFROWANEJ WIADOMOSCI KLUCZEM \e[0m", 0, 90);printf("\e[%d;%d;1m"Alice"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n\nSzybkie opcje: ");printf("\e[%d;%d;1mgeneruj() \e[0m", 0, 97);printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mszyfruj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\e[0m", 0, 92);printf("\e[%d;%d;1m odszyfruj() podpisz() zweryfikuj()\n\e[0m", 0, 97);
}

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\              ODSZYFRUJ()              \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
odszyfruj() = {
printf("\nJestes w ");printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1modszyfruj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\n\e[0m", 0, 92);
	printf("\n\e[%d;%d;1mJakiego algorytmu chcesz uzyc:\n\e[0m", 0, 93);
	printf("\t\e[%d;%d;1m1\e[0m", 0, 96);printf(". Asymetryczny (na bazie RSA)\n");
	printf("\t\e[%d;%d;1m2\e[0m", 0, 96);printf(". Symetryczny (autorstwa Michala Mazura)\n");
	while(1,
		kill(Wybor);printf("\e[%d;%d;1mWybor (1 lub 2): \e[0m", 0, 90);Wybor = input();
		if(Wybor == 1, odszyfruj_asymetryczny();break;, Wybor == 2, odszyfruj_symetryczny();break;, printf("\e[%d;%d;1mBLAD: Wpisz 1 lub 2!\n\e[0m", 0, 41););
	);
}
	
odszyfruj_asymetryczny() = {
	printf("\e[%d;%d;1m\nWpisz swoje nazwisko (tak jak podpisane sa pliki, np. kowalski), \e[0m", 0, 93);printf("\e[%d;%d;1mwymaga obecnosci pliku nazwisko.private\n\e[0m", 0, 93);
	while(1,
		kill(Alice);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Alice = Str(input());
		if(type(Alice) != "t_STR" || Alice == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	read(".private/"Alice".private");Alice_d = d; Alice_n = n;
	read(".keychain/"Alice".public");Alice_e = e; Alice_n = n; smietnik = ec;
	
	
	printf("\e[%d;%d;1m\nPodaj od kogo chcesz odszyfrowac (tak jak podpisane sa pliki, np. malinowski)\n\e[0m", 0, 93);
	while(1,
		kill(Bob);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Bob = Str(input());
		if(type(Bob) != "t_STR" || Bob == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	read(".keychain/"Bob".public");Bob_e = e; Bob_n = n;
	
	printf("\e[%d;%d;1m\nWklej (prawy przycisk myszy) szyfrogram\n\e[0m", 0, 93);
	while(1,
		kill(szyfrogram);printf("\e[%d;%d;1mWklej szyfrogram: \e[0m", 0, 90); szyfrogram = input();
		if(type(szyfrogram) == "t_INT", break);
		printf("\e[%d;%d;1mTutaj powinny byc same cyfry! Upewnij sie, ze jest dobrze skopiowane bez dodatkowych znakow.\e[0m", 0, 31);
	);
	
	printf("\n\e[%d;%d;1mJak chcesz odszyfrowac wiadomosc:\n\e[0m", 0, 93);
	printf("\t\e[%d;%d;1m1\e[0m", 0, 96);printf(". Kluczem publicznym (weryfikacja podpisu)\n");
	printf("\t\e[%d;%d;1m2\e[0m", 0, 96);printf(". Kluczem prywatnym (deszyfrowanie)\n");
	printf("\t\e[%d;%d;1m3\e[0m", 0, 96);printf(". Kluczem publicznym nadawcy i prywatnym odbiorcy (deszyfrowanie ze sprawdzeniem podpisu)\n");
	printf("\e[%d;%d;1mUWAGA: Uzyj tej samej opcji, ktora wybral Twoj rozmowca wysylajac ta wiadomosc!\n\e[0m", 0, 33);
	while(1,
		kill(Wybor);printf("\e[%d;%d;1mWybor (1, 2 lub 3): \e[0m", 0, 90); Wybor = input();
			if(Wybor == 1, wynik_odszyfrowania = lift(Mod(szyfrogram,Bob_n)^Bob_e); break;);
			if(Wybor == 2, wynik_odszyfrowania = lift(Mod(szyfrogram,Alice_n)^Alice_d); break;);
			if(Wybor == 3, \\ ta sama zasada co przy szyfrowaniu tylko odwrotnie
				if(Alice_n > Bob_n,
					odszyfrowane = lift(Mod(szyfrogram,Alice_n)^Alice_d);
					wynik_odszyfrowania = lift(Mod(odszyfrowane ,Bob_n)^Bob_e);
					break;
				,
					odszyfrowane = lift(Mod(szyfrogram,Bob_n)^Bob_e);
					wynik_odszyfrowania = lift(Mod(odszyfrowane,Alice_n)^Alice_d);
					break;
				);
			);
		printf("\e[%d;%d;1mBLAD: Wpisz 1, 2 lub 3!\n\e[0m", 0, 41);
	);
	\\wiadomosc_odkodowana = Strchr(digits(wynik_odszyfrowania,256));
	wiadomosc_odkodowana = odmiana(wynik_odszyfrowania);

	printf("\e[%d;%d;1m\n----- POCZATEK ODSZYFROWANEJ WIADOMOSCI OD \e[0m", 0, 90);printf("\e[%d;%d;1m"Bob"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n"wiadomosc_odkodowana"\n");
	printf("\e[%d;%d;1m\n----- KONIEC ODSZYFROWANEJ WIADOMOSCI OD \e[0m", 0, 90);printf("\e[%d;%d;1m"Bob"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n\nSzybkie opcje: ");printf("\e[%d;%d;1mgeneruj() szyfruj() \e[0m", 0, 97);printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1modszyfruj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\e[0m", 0, 92);printf("\e[%d;%d;1m podpisz() zweryfikuj()\n\e[0m", 0, 97);
}

odszyfruj_symetryczny() = {
	printf("\e[%d;%d;1m\nWpisz nazwe klucza (tak jak podpisany jest plik, np. naszklucz), \e[0m", 0, 93);printf("\e[%d;%d;1mwymaga obecnosci pliku nazwa.sym\n\e[0m", 0, 93);
	while(1,
		kill(Alice);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Alice = Str(input());
		if(type(Alice) != "t_STR" || Alice == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	
	printf("\e[%d;%d;1m\nWklej (prawy przycisk myszy) szyfrogram\n\e[0m", 0, 93);
	while(1,
		kill(szyfrogram);printf("\e[%d;%d;1mWklej szyfrogram: \e[0m", 0, 90); szyfrogram = input();
		if(type(szyfrogram) == "t_INT", break);
		printf("\e[%d;%d;1mTutaj powinny byc same cyfry! Upewnij sie, ze jest dobrze skopiowane bez dodatkowych znakow.\e[0m", 0, 31);
	);
	
	N = szyfrogram;
	read(".keychain/"Alice".sym");sym_n = n; sym_k = k;
	N = digits(N);

	if(round(length(N)/sym_n)*sym_n > length(N), q = round(length(N)/sym_n);, q = round(length(N)/sym_n) + 1;);

	M = matrix(q,sym_n);
	for(i = 1, q, i; for(j = 1, sym_n , j; if( (sym_n*i + j - sym_n) <= length(N), M[i,j] = N[sym_n*i+j-sym_n], M[i,j] = 0);););

	klucz = numtoperm(sym_n,sym_k);

	V = vector(q-1);
	for(i = 1, q-1, i; V[i] = Vecsmall(M[i,]););

	szyfr = matrix(q,sym_n);
	for(i = 1, q-1, i; szyfr[i,] = Vec(V[i]*klucz^(-1)););
	szyfr[q,] = M[q,];

	for(i = 1, q, i; for(j = 1, sym_n , j; if(((sym_n*i + j - sym_n) <= length(N)), N[sym_n*i+j-sym_n] = szyfr[i,j]););); \\, N[sym_n*i+j-sym_n] = 0););

	wiadomosc = fromdigits(N);
	\\wiadomosc_odkodowana = Strchr(digits(wiadomosc,256));
	wiadomosc_odkodowana = odmiana(wynik_odszyfrowania);
	
	printf("\e[%d;%d;1m\n----- POCZATEK ODSZYFROWANEJ WIADOMOSCI KLUCZEM \e[0m", 0, 90);printf("\e[%d;%d;1m"Alice"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n"wiadomosc_odkodowana"\n");
	printf("\e[%d;%d;1m\n----- KONIEC ODSZYFROWANEJ WIADOMOSCI KLUCZEM \e[0m", 0, 90);printf("\e[%d;%d;1m"Alice"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n\nSzybkie opcje: ");printf("\e[%d;%d;1mgeneruj() szyfruj() \e[0m", 0, 97);printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1modszyfruj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\e[0m", 0, 92);printf("\e[%d;%d;1m podpisz() zweryfikuj()\n\e[0m", 0, 97);
}

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\               PODPISZ()               \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
podpisz() = {
printf("\nJestes w ");printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mpodpisz()\e[0m", 0, 90);printf("\e[%d;%d;1m<\n\e[0m", 0, 92);
	printf("\n\e[%d;%d;1mWpisz swoje nazwisko (tak jak podpisane sa pliki, np. kowalski), \e[0m", 0, 93);printf("\e[%d;%d;1mwymaga obecnosci pliku nazwisko.private\n\e[0m", 0, 93);
	while(1,
		kill(Alice);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Alice = Str(input());
		if(type(Alice) != "t_STR" || Alice == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	read(".private/"Alice".private");Alice_d = d; Alice_n = n;
	
	printf("\e[%d;%d;1m\nWpisz swoja wiadomosc,\e[0m", 0, 93);printf("\e[%d;%d;1m koniecznie zamykajac ja w cudzyslowiu (--> \"_\" <--)\n\e[0m", 0, 91);
	while(1,
		kill(wiadomosc);printf("\e[%d;%d;1mWiadomosc: \e[0m", 0, 90); wiadomosc = Str(input());
		if(#digits(zamiana(wiadomosc)) >= #digits(Alice_n),
			printf("\e[%d;%d;1mBLAD: Wiadomosc nie moze byc dluzsza od najkrotszego klucza! Obecnie: "#digits(zamiana(wiadomosc))/2" znakow ze spacjami na "round(#digits(Alice_n)/2.)-1" dozwolonych.\n\e[0m", 0, 41);
		,
			break;
		);
	);
	\\kodowanie = subst(Pol(Vecsmall(wiadomosc)),'x,256);	\\ text --> int
	kodowanie = zamiana(wiadomosc);	\\ text --> int
	
	data = externstr("powershell Get-Date -UFormat \"%d.%m.%G\"")[1];
	godzina = externstr("powershell Get-Date -UFormat \"%T\"")[1];
	strefa = externstr("powershell Get-Date -UFormat \"%Z\"")[1];
	data_godzina_strefa = Str("dnia ",data," o ", godzina," UTC", strefa);
	wiadomosc_cala = Str("Wiadomosc podpisana przez "Alice" "data_godzina_strefa".\n---\n"wiadomosc"");
	\\kodowanie = subst(Pol(Vecsmall(wiadomosc_cala)),'x,256);	\\ text --> int
	kodowanie = zamiana(wiadomosc_cala);	\\ text --> int
	wynik_szyfrowania = lift(Mod(kodowanie,Alice_n)^Alice_d);
	
	printf("\e[%d;%d;1m\n----- POCZATEK PODPISU \e[0m", 0, 90);printf("\e[%d;%d;1m"Alice"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n"wynik_szyfrowania"\n");
	printf("\e[%d;%d;1m\n----- KONIEC PODPISU \e[0m", 0, 90);printf("\e[%d;%d;1m"Alice"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n\nSzybkie opcje: ");printf("\e[%d;%d;1mgeneruj() szyfruj() odszyfruj() \e[0m", 0, 97);printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mpodpisz()\e[0m", 0, 90);printf("\e[%d;%d;1m<\e[0m", 0, 92);printf("\e[%d;%d;1m zweryfikuj()\n\e[0m", 0, 97);
}

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\              ZWERYFIKUJ()             \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
zweryfikuj() = {
printf("\nJestes w ");printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mzweryfikuj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\n\e[0m", 0, 92);
	\\ Jaki klucz chcesz wygenerowac
	printf("\n\e[%d;%d;1mCo chcesz zweryfikowac:\n\e[0m", 0, 93);
	printf("\t\e[%d;%d;1m1\e[0m", 0, 96);printf(". Klucz\n");
	printf("\t\e[%d;%d;1m2\e[0m", 0, 96);printf(". Podpis/wiadomosc\n");
	while(1,
		kill(Wybor);printf("\e[%d;%d;1mWybor (1 lub 2): \e[0m", 0, 90);Wybor = input();
		if(Wybor == 1, weryfikuj_klucz();break;, Wybor == 2, weryfikuj_podpis();break;, printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41););
	);
}

weryfikuj_klucz() = {
	printf("\e[%d;%d;1m\nCzyj klucz chcesz sprawdzic:\n\e[0m", 0, 93);
	while(1,
		kill(Bob);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Bob = Str(input());
		if(type(Bob) != "t_STR" || Bob == 0, 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	kill(ERROR);iferr(read(".keychain/"Bob".public"),err,
	\\print("Plik "Alice".sym nie istnieje, kontynuuj");
	ERROR = 1);
	if(ERROR == 1, printf("\e[%d;%d;1mBLAD: Nie ma takiego klucza w folderze .keychain... przerywam!\e[0m", 0, 41);break;);
	ec = X; kill(ec); \\ usuwamy zmienna ec z pamieci
	read(".keychain/"Bob".public");cert_e = e; smietnik = n; ec = ec;
	\\ Sprawdz certyfikat nadawcy
	printf("\n\e[%d;%d;1mSprawdzanie poprawnosci certyfikatu "Bob"...\n\e[0m", 0, 97);
	if (type(ec) != "t_INT", printf("\e[%d;%d;1mUWAGA: Nie znaleziono certyfikatu w pliku .keychain/"Bob".public \n\e[0m", 0, 33);ec = 1);
	read(".keychain/lewit.public");Kurkowski_e = e; Kurkowski_n = n;
	\\Kurkowski_e = 11110460360610540630450120720990390690610410540720630410360990910990410430690180760990580690160430360180760490740830990720250610630380120990029909109906105405406709809809800633;
	\\Kurkowski_n = 32317006071311007300714876688669951960444102669715484032130345427524655138867890893197201411522913463688717960921898019494119559150490921095088152386448283120630877367300996091750197750389652106796057638384067568276792218642619756161637918124398696123653359440462893276537212039622032236911476612945290930332538254858381126109951298955235655288250898562384170163078618487415513230697190028628066729303041750424907903214944322754043889240743096028516571325943630517231793886503346255309062169648428462353747357836805077305810675474668031298850689989317501952889789103537081097100948737975904069427347052730485725435277;
	cert = lift(Mod(ec,Kurkowski_n)^Kurkowski_e);
	if (cert - cert_e !=0, printf("\e[%d;%d;1mCERTYFIKAT NIEPOPRAWNY\n\e[0m", 0, 31);,printf("\e[%d;%d;1mCERTYFIKAT POPRAWNY\n\e[0m", 0, 32));

	printf("\e[%d;%d;1m\n----- POCZATEK UKRYTEJ WIADOMOSCI \e[0m", 0, 90);printf("\e[%d;%d;1m"Bob"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	iferr(printf("\n"odmiana(cert_e)"\n");,err,printf("\e[%d;%d;1m\nBLAD: Nie udalo sie odczytac wiadomosci\n\e[0m", 0, 31););
	printf("\e[%d;%d;1m\n----- KONIEC UKRYTEJ WIADOMOSCI \e[0m", 0, 90);printf("\e[%d;%d;1m"Bob"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n\nSzybkie opcje: ");printf("\e[%d;%d;1mgeneruj() szyfruj() odszyfruj() podpisz() \e[0m", 0, 97);printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mzweryfikuj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\e[0m", 0, 92);printf("\e[%d;%d;1m\n\e[0m", 0, 97);
}

weryfikuj_podpis() = {
	printf("\e[%d;%d;1m\nPodaj czyj podpis chcesz sprawdzic\n\e[0m", 0, 93);
	while(1,
		kill(Bob);printf("\e[%d;%d;1mOdpowiedz: \e[0m", 0, 90);Bob = Str(input());
		if(type(Bob) != "t_STR" || Bob == "0", 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	read(".keychain/"Bob".public");Bob_e = e; Bob_n = n;
	
	printf("\e[%d;%d;1m\nWklej (prawy przycisk myszy) szyfrogram\n\e[0m", 0, 93);
	while(1,
		kill(szyfrogram);printf("\e[%d;%d;1mWklej szyfrogram: \e[0m", 0, 90); szyfrogram = input();
		if(type(szyfrogram) == "t_INT", break);
		printf("\e[%d;%d;1mTutaj powinny byc same cyfry! Upewnij sie, ze jest dobrze skopiowane bez dodatkowych znakow.\e[0m", 0, 31);
	);
	
	wynik_odszyfrowania = lift(Mod(szyfrogram,Bob_n)^Bob_e);
	\\wiadomosc_odkodowana = Strchr(digits(wynik_odszyfrowania,256));
	wiadomosc_odkodowana = odmiana(wynik_odszyfrowania);

	printf("\e[%d;%d;1m\n----- POCZATEK PODPISU \e[0m", 0, 90);printf("\e[%d;%d;1m"Bob"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n"wiadomosc_odkodowana"\n");
	printf("\e[%d;%d;1m\n----- KONIEC PODPISU \e[0m", 0, 90);printf("\e[%d;%d;1m"Bob"\e[0m", 0, 36);printf("\e[%d;%d;1m ------\n\e[0m", 0, 90);
	printf("\n\nSzybkie opcje: ");printf("\e[%d;%d;1mgeneruj() szyfruj() odszyfruj() podpisz() \e[0m", 0, 97);printf("\e[%d;%d;1m>\e[0m", 0, 92);printf("\e[%d;%d;1mzweryfikuj()\e[0m", 0, 90);printf("\e[%d;%d;1m<\e[0m", 0, 92);printf("\e[%d;%d;1m\n\e[0m", 0, 97);
}

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\              ADMINADMIN()             \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
adminadmin() = {
	\\ wczytujemy prywanty klucz naszego centrum autoryzacji
	read(".private/lewit.private");Kurkowski_d = d; Kurkowski_n = n; \\ ZMIENIĆ NA KURKOWSKI PO ZAKOŃCZENIU TESTÓW
	printf("\e[%d;%d;1mCzyj klucz certyfikowac?\n\e[0m", 0, 93);
		while(1,
		kill(cert_nazwisko);printf("\e[%d;%d;1mNazwisko: \e[0m", 0, 90);cert_nazwisko = Str(input());
		if(type(cert_nazwisko) != "t_STR" || cert_nazwisko == 0, 
			printf("\e[%d;%d;1mBLAD: To pole jest wymagane!\n\e[0m", 0, 41);
		,
			break;
		);
	);
	ec = X; kill(ec); \\ usuwamy zmienna ec z pamieci
	read(".keychain/"cert_nazwisko".public");no_cert_e = e; smietnik = n; \\ wczytujemy e, n ignorujemy
	ec_podpisane = lift(Mod(no_cert_e,Kurkowski_n)^Kurkowski_d); \\ generujemy certyfikat
	
	\\ jesli ec juz jest "UWAGA: CERTYFIKA JUZ JEST W PLIKU" i break
	if(type(ec) == "t_INT",
		if(ec != ec_podpisane, printf("\e[%d;%d;1mPRZERYWAM! NIEZGODNY CERTYFIKAT JEST JUZ W PLIKU - USUN \e[0m", 0, 31);printf("\e[%d;%d;1mec = xxx;\e[0m", 0, 90);printf("\e[%d;%d;1m Z PLIKU \e[0m", 0, 31);printf("\e[%d;%d;1m.keychain/"cert_nazwisko".public\e[0m", 0, 90);printf("\e[%d;%d;1m ABY WYGENEROWAC NOWY!\e[0m", 0, 31);break;);
		if(ec == ec_podpisane, printf("\e[%d;%d;1mPRZERYWAM! Poprawny certyfikat jest juz w pliku - nie ma potrzeby generowac nowego\e[0m", 0, 33);break;);
	);
	if(type(ec) == "t_POL",
		write(".keychain/"cert_nazwisko".public","ec = "ec_podpisane";"); \\ podpisujemy plik
		printf("\e[%d;%d;1mZrobione!\e[0m", 0, 32);
	);
}

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\            ZAMIANA/ODMIANA            \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
ltrlcz(a) = {
	if(
		a == "A", a = 11;,
		a == "a", a = 12;,
		a == "B", a = 13;,
		a == "b", a = 14;,
		a == "C", a = 15;,
		a == "c", a = 16;,
		a == "D", a = 17;,
		a == "d", a = 18;,
		a == "E", a = 19;,
		a == "e", a = 20;,
		a == "F", a = 21;,
		a == "f", a = 22;,
		a == "G", a = 23;,
		a == "g", a = 24;,
		a == "H", a = 25;,
		a == "h", a = 26;,
		a == "I", a = 27;,
		a == "i", a = 28;,
		a == "J", a = 29;,
		a == "j", a = 30;,
		a == "K", a = 31;,
		a == "k", a = 32;,
		a == "L", a = 33;,
		a == "l", a = 34;,
		a == "M", a = 35;,
		a == "m", a = 36;,
		a == "N", a = 37;,
		a == "n", a = 38;,
		a == "O", a = 39;,
		a == "o", a = 40;,
		a == "P", a = 41;,
		a == "p", a = 42;,
		a == "Q", a = 43;,
		a == "q", a = 44;,
		a == "R", a = 45;,
		a == "r", a = 46;,
		a == "S", a = 47;,
		a == "s", a = 48;,
		a == "T", a = 49;,
		a == "t", a = 50;,
		a == "U", a = 51;,
		a == "u", a = 52;,
		a == "V", a = 53;,
		a == "v", a = 54;,
		a == "W", a = 55;,
		a == "w", a = 56;,
		a == "X", a = 57;,
		a == "x", a = 58;,
		a == "Y", a = 59;,
		a == "y", a = 60;,
		a == "Z", a = 61;,
		a == "z", a = 62;,
		a == " ", a = 63;,
		a == "\n", a = 64;,
		a == "0", a = 65;,
		a == "1", a = 66;,
		a == "2", a = 67;,
		a == "3", a = 68;,
		a == "4", a = 69;,
		a == "5", a = 70;,
		a == "6", a = 71;,
		a == "7", a = 72;,
		a == "8", a = 73;,
		a == "9", a = 74;,
		a == ".", a = 75;,
		a == ",", a = 76;,
		a == "!", a = 77;,
		a == "?", a = 78;,
		a == "(", a = 79;,
		a == ")", a = 80;,
		a == ";", a = 81;,
		a == ":", a = 82;,
		a == "-", a = 83;,
		a == "\"", a = 84;,
		a == "\'", a = 85;,
		a == "@", a = 86;,
		a == "%", a = 87;,
		a == "#", a = 88;,
		a == "$", a = 89;,
		a == "^", a = 90;,
		a == "&", a = 91;,
		a == "*", a = 92;,
		a == "_", a = 93;,
		a == "+", a = 94;,
		a == "=", a = 95;,
		a == "[", a = 96;,
		a == "]", a = 97;,
		a == "<", a = 98;,
		a == ">", a = 99;
	);
}
	
lczltr(a) = {
	if(
		a == 11, a = "A";,
		a == 12, a = "a";,
		a == 13, a = "B";,
		a == 14, a = "b";,
		a == 15, a = "C";,
		a == 16, a = "c";,
		a == 17, a = "D";,
		a == 18, a = "d";,
		a == 19, a = "E";,
		a == 20, a = "e";,
		a == 21, a = "F";,
		a == 22, a = "f";,
		a == 23, a = "G";,
		a == 24, a = "g";,
		a == 25, a = "H";,
		a == 26, a = "h";,
		a == 27, a = "I";,
		a == 28, a = "i";,
		a == 29, a = "J";,
		a == 30, a = "j";,
		a == 31, a = "K";,
		a == 32, a = "k";,
		a == 33, a = "L";,
		a == 34, a = "l";,
		a == 35, a = "M";,
		a == 36, a = "m";,
		a == 37, a = "N";,
		a == 38, a = "n";,
		a == 39, a = "O";,
		a == 40, a = "o";,
		a == 41, a = "P";,
		a == 42, a = "p";,
		a == 43, a = "Q";,
		a == 44, a = "q";,
		a == 45, a = "R";,
		a == 46, a = "r";,
		a == 47, a = "S";,
		a == 48, a = "s";,
		a == 49, a = "T";,
		a == 50, a = "t";,
		a == 51, a = "U";,
		a == 52, a = "u";,
		a == 53, a = "V";,
		a == 54, a = "v";,
		a == 55, a = "W";,
		a == 56, a = "w";,
		a == 57, a = "X";,
		a == 58, a = "x";,
		a == 59, a = "Y";,
		a == 60, a = "y";,
		a == 61, a = "Z";,
		a == 62, a = "z";,
		a == 63, a = " ";,
		a == 64, a = "\n";,
		a == 65, a = "0";,
		a == 66, a = "1";,
		a == 67, a = "2";,
		a == 68, a = "3";,
		a == 69, a = "4";,
		a == 70, a = "5";,
		a == 71, a = "6";,
		a == 72, a = "7";,
		a == 73, a = "8";,
		a == 74, a = "9";,
		a == 75, a = ".";,
		a == 76, a = ",";,
		a == 77, a = "!";,
		a == 78, a = "?";,
		a == 79, a = "(";,
		a == 80, a = ")";,
		a == 81, a = ";";,
		a == 82, a = ":";,
		a == 83, a = "-";,
		a == 84, a = "\"";,
		a == 85, a = "\'";,
		a == 86, a = "@";,
		a == 87, a = "%";,
		a == 88, a = "#";,
		a == 89, a = "$";,
		a == 90, a = "^";,
		a == 91, a = "&";,
		a == 92, a = "*";,
		a == 93, a = "_";,
		a == 94, a = "+";,
		a == 95, a = "=";,
		a == 96, a = "[";,
		a == 97, a = "]";,
		a == 98, a = "<";,
		a == 99, a = ">";
	);
}
	
zamiana(Alice) = {

	Alice = Vec(Str(Alice));
	for(i = 1, length(Alice), i; Alice[i] = ltrlcz(Alice[i]); );

	q = 0;
	for(i = 1, length(Alice), i; q = q + Alice[length(Alice) - i + 1]*10^(2*(i-1)); );
	Alice = q;

}

odmiana(Alice) = {

	Alice = digits(Alice);
	v = vector(length(Alice)/2);
	for(i = 1, length(v), i; v[i] = Alice[2*i-1]*10 + Alice[2*i]; );
	Alice = v;

	for(i = 1, length(Alice), i; Alice[i] = lczltr(Alice[i]); );
	v = "";
	for(i = 1, length(Alice), i; v = concat(v,Alice[i]); );
	Alice = v;

}
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\             Sekcja pomocy             \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
addhelp(wymagania, "###################################################################################\n ###\t\t\t..::DO POPRAWNEGO DZIALANIA::..\t\t\t\t###\n ### - wszystkie pliki .public i .sym trzymaj w folderze .keychain a swoje pliki ###\n ###   w .private (oba musza znajdowac sie w glownym folderze instalacji PARI)\t###\n ### - uruchom gp.exe jako Administrator, zeby mozna bylo tworzyc nowe pliki\t###\n ###   w folderze PARI\t\t\t\t\t\t\t\t###\n ### - do poprawnego dzialania nie zmieniaj stylu nazewnictwa plikow oraz nie\t###\n ###   zmieniaj ich tresci (PPM -> Wlasciwosci -> Tylko do odczytu -> Zastosuj\t###\n ###################################################################################" );
addhelp(instrukcja, "###################################################################################\n ### \t\t\t\t ..::INSTRUKCJA::.. \t\t\t\t ###\n ### 0. Jesli jeszcze nie masz swoich kluczy, wygeneruj je wpisujac generuj() \t ###\n ### 1. Uzyj szyfruj() aby zaszyfrowac wiadomosc \t\t\t\t\t ###\n ### 2. Zeby odszyfrowac wiadomosc wpisz odszyfruj() \t\t\t\t ###\n ### 3. Aby stworzyc specjalna wiadomosc \"podpis\", podpisz() \t\t\t###\n ### 4. Czyjas wiadomosc \"podpis\" oraz informacje zawarte w kluczu, zweryfikuj() ###\n ###################################################################################\n\nAby przejsc na tryb z wieksza iloscia opcji uzyj: zaawansowany()\nJesli chcesz wrocic do trybu podstawowego: podstawowy()\n\nWyswietl ponownie instrukcje: ?instrukcja \n Wiecej o danej funkcji: ?nazwa_funkcji (np. ?generuj)" );
addhelp(generuj, "generuj(): Generator kluczy na podstawie podanych informacji tworzy i zapisuje klucze w glownym folderze instalacji PARI GP. Moze wymagac uruchomienia gp.exe jako administrator.");
addhelp(start, "start(): Wczytuje klucze potrzebne do wymieny wiadomosci miedzy toba a wybrana osoba i przypisuje je do zmiennych.");
addhelp(szyfruj, "szyfruj(): Zaszyfruje wiadomosc do osoby ustawionej w start().");
addhelp(odszyfruj, "odszyfruj(): Odszyfruje wiadomosc otrzymana od osoby ustawionej w start().");
addhelp(certyfikat, "certyfikat(): Sprawdza czy w pliku (nazwisko.public) znajduje sie certyfikat oraz czy mozna odczytac go za pomoca klucza publicznego centrum autoryzacji.");
addhelp(podstawowy, "podstawowy(): Ustawia tryb podstawowy.");
addhelp(zaawansowany, "zaawansowany(): Przechodzi w tryb zaawansowany z dodatkowymi ustawieniami.");

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\            Ekran powitalny            \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
printf("\n\e[%d;%d;1mdb   dD d8888b. db    db d8888b. d888888b  .d88b.   d888b  d8888b.  .d8b.  d88888b d888888b  .d8b.  \n\e[0m", 0, 31);printf("\e[%d;%d;1m88 ,8P' 88  `8D `8b  d8' 88  `8D `~~88~~' .8P  Y8. 88' Y8b 88  `8D d8' `8b 88'       `88'   d8' `8b \n\e[0m", 0, 91);printf("\e[%d;%d;1m88,8P   88oobY'  `8bd8'  88oodD'    88    88    88 88      88oobY' 88ooo88 88ooo      88    88ooo88 \n\e[0m", 0, 33);printf("\e[%d;%d;1m88`8b   88`8b      88    88~~~      88    88    88 88  ooo 88`8b   88~~~88 88~~~      88    88~~~88 \n\e[0m", 0, 92);printf("\e[%d;%d;1m88 `88. 88 `88.    88    88         88    `8b  d8' 88. ~8~ 88 `88. 88   88 88        .88.   88   88 \n\e[0m", 0, 94);printf("\e[%d;%d;1mYP   YD 88   YD    YP    88         YP     `Y88P'   Y888P  88   YD YP   YP YP      Y888888P YP   YP \n\e[0m", 0, 35);
\\print("");
\\printf("\e[%d;%d;1m###################################################################################\e[0m", 0, 93);
\\printf("\e[%d;%d;1m###                       \e[0m", 0, 93);printf("\e[%d;%d;1m..::DO POPRAWNEGO DZIALANIA::..\e[0m", 90, 103);printf("\e[%d;%d;1m                       ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m### - wszystkie pliki .public i .sym trzymaj w folderze .keychain a swoje pliki ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m###   w .private (oba musza znajdowac sie w glownym folderze instalacji PARI)   ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m### - uruchom gp.exe jako Administrator, zeby mozna bylo zapisywac nowe pliki   ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m###   w folderze PARI                                                           ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m### - do poprawnego dzialania nie zmieniaj stylu nazewnictwa plikow oraz nie    ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m###   zmieniaj ich tresci (PPM -> Wlasciwosci -> Tylko do odczytu -> Zastosuj   ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m###################################################################################\e[0m", 0, 93);
\\print("");
\\printf("\e[%d;%d;1m###################################################################################\e[0m", 0, 93);printf("\e[%d;%d;1m.\e[0m", 0, 0);
\\printf("\e[%d;%d;1m###                             \e[0m", 0, 93);printf("\e[%d;%d;1m..::INSTRUKCJA::..\e[0m", 90, 103);printf("\e[%d;%d;1m                              ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m### 0. Jesli jeszcze nie masz pary kluczy, wygeneruj wpisujac \e[0m", 0, 93);printf("\e[%d;%d;1mgeneruj()\e[0m", 0, 36);printf("\e[%d;%d;1m         ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m### 1. Aby szyfrowac lub deszyfrowac wpisz \e[0m", 0, 93);printf("\e[%d;%d;1mstart()\e[0m", 0, 36);printf("\e[%d;%d;1m i wypelnij pola              ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m### 2. Uzyj \e[0m", 0, 93);printf("\e[%d;%d;1mszyfruj()\e[0m", 0, 36);printf("\e[%d;%d;1m aby zaszyfrowac do wybranej w start() osoby               ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m### 3. Zeby odszyfrowac wiadomosc od osoby wybranej w start() wpisz \e[0m", 0, 93);printf("\e[%d;%d;1mdeszyfruj()\e[0m", 0, 36);printf("\e[%d;%d;1m ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m### 4. Certyfikaty sprawdzisz przy pomocy \e[0m", 0, 93);printf("\e[%d;%d;1mcertyfikat()\e[0m", 0, 36);printf("\e[%d;%d;1m                          ###\e[0m", 0, 93);
\\printf("\e[%d;%d;1m###################################################################################\e[0m", 0, 93);
\\printf("Wiecej o danej funkcji: ");printf("\e[%d;%d;1m?\e[0m", 0, 91);printf("\e[%d;%d;1mnazwa_funkcji\e[0m", 0, 90);printf(" (np. ");printf("\e[%d;%d;1m?generuj\e[0m", 0, 92);printf(").");
printf("\nPrzed rozpoczeciem przeczytaj:\n");printf("- wymagania: ");printf("\e[%d;%d;1m?wymagania\n\e[0m", 0, 92);printf("- instrukcje: ");printf("\e[%d;%d;1m?instrukcja\n\e[0m", 0, 92);printf("\nSzybkie opcje: ");printf("\e[%d;%d;1mgeneruj() szyfruj() odszyfruj() podpisz() zweryfikuj()\n\e[0m", 0, 97);

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\ Czyszczenie zmiennych ktore bedziemy uzywac \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Tryb = X;					kill(Tryb);
Alice = X;					kill(Alice);
Wybor = X;					kill(Wybor);
Bity = X;					kill(Bity);
p = X;						kill(p);
q = X;						kill(q);
n = X;						kill(n);
k = X;						kill(k);
N = X;						kill(N);
M = X;						kill(M);
e = X;						kill(e);
d = X;						kill(d);
klucz = X;					kill(klucz);
V = X;						kill(V);
W = X;						kill(W);
Ukryta_wiadomosc = X;		kill(Ukryta_wiadomosc);
Zapisac_pq = X;				kill(Zapisac_pq);
ERROR = X;					kill(ERROR);
kodowanie = X;				kill(kodowanie);
wiadomosc = X;				kill(wiadomosc);
wynik_szyfrowania = X;		kill(wynik_szyfrowania);
zaszyfrowane = X;			kill(zaszyfrowane);
szyfrogram = X;				kill(szyfrogram);
wynik_odszyfrowania = X;	kill(wynik_odszyfrowania);
odszyfrowane = X;			kill(odszyfrowane);
wiadomosc_odkodowana = X;	kill(wiadomosc_odkodowana);
Bob = X;					kill(Bob);
ec = X;						kill(ec);
cert = X;					kill(cert);
cert_e = X;					kill(cert_e);
Kurkowski_e = X;			kill(Kurkowski_e);
Kurkowski_n = X;			kill(Kurkowski_n);
smietnik = X;				kill(smietnik);
cert_nazwisko = X;			kill(cert_nazwisko);
no_cert_e = X;				kill(no_cert_e);
ec_podpisane = X;			kill(ec_podpisane);

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\    TABLICA POMYSLOW I DO ZROBIENIA    \\
\\ - Właściciel może zapisać swoje klu-  \\
\\  cze, tak żeby nie musiał wpisywać    \\
\\  kto szyfruje.                        \\
\\ - Zapisywanie zaszyfrowanych wiadomo- \\
\\  ści w pliku .txt w udostępnionym nam \\
\\  folderze dropbox/onedrive adresata.  \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\               ja() TBD                \\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
ja() = {
	printf("\e[%d;%d;1m\nCzy chcesz automatycznie wczytywac swoje klucze asymetryczne? Nie zalecane dla wspoldzielonych komputerow. Odpowiedz (T)ak lub (N)ie\n\e[0m", 0, 93);
	while(1,
		kill(Zapisac_profil);printf("\e[%d;%d;1mOdpowiedz [\e[0m", 0, 90);printf("\e[%d;%d;1mT\e[0m", 0, 92);printf("\e[%d;%d;1m/\e[0m", 0, 90);printf("\e[%d;%d;1mN\e[0m", 0, 91);printf("\e[%d;%d;1m]: \e[0m", 0, 90);Zapisac_profil = input();
		if(Zapisac_profil == t || Zapisac_profil == T || Zapisac_profil == n || Zapisac_profil == N, break);
		printf("\e[%d;%d;1mBLAD: Nie rozumiem, (T)ak czy (N)ie?\e[0m", 0, 41);
	);
	if(Zapisac_profil == t || Zapisac_profil == T,
		write("ustawienia.krypto","\r .private/"Alice".private");
		write("ustawienia.krypto","\r .private/"Alice".private");
	);
}