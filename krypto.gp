\\ Czyszczenie zmiennych ktore bedziemy uzywali
n = "";e = "";ec = "";d = "";
no = "";eo = "";eoc = "";
nk = "";ek = "";
kodowanie = "";zasztfrowane = "";wynik_szyfrowania = "";
deszyfr = "";odszyfrowane = "";wynik_odszyfrowania = "";
bity = "";zmienna_nazwisko = "";zmienna_zapisac = "";p = "";q = "";

kill(n);kill(e);kill(ec);kill(d);
kill(no);kill(eo);kill(eoc);
kill(nk);kill(ek);
kill(kodowanie);kill(zasztfrowane);kill(wynik_szyfrowania);
kill(deszyfr);kill(odszyfrowane);kill(wynik_odszyfrowania);
kill(bity);kill(zmienna_nazwisko);kill(zmienna_zapisac);kill(p);kill(q);

\\ Sekcja pomocy
addhelp(krypto, "###################################################################################\n### Czesc! Poszyfrujemy? \t\t\t\t\t\t\t ###\n### Do poprawnego dzialania: \t\t\t\t\t\t\t ###\n### - wszystkie pliki trzymaj w glownym folderze PARI GP \t\t\t ###\n###   _n.txt, _pub.txt, _pub_cert.txt oraz _priv.txt jesli jestes wlascicielem \t ###\n### - swoj klucz prywatny rowniez tam trzymaj \t\t\t\t\t ###\n### - uruchomic PARI jako Administrator (jesli generujesz pare kluczy) \t\t ###\n### - do poprawnego dzialania nie zmieniaj stylu nazewnictwa plikow \t\t ###\n###################################################################################\n\n###################################################################################\n### \t\t\t\t ..::INSTRUKCJA::.. \t\t\t\t ###\n### 0. Jesli jeszcze nie masz pary kluczy, wygeneruj wpisujac generuj() \t\t ###\n### 1. Aby szyfrowac lub deszyfrowac wpisz start() i wypelnij pola \t\t ###\n### 2. Uzyj szyfruj() aby zaszyfrowac do wybranej w start() osoby \t\t ###\n### 3. Zeby odszyfrowac wiadomosc od osoby wybranej w start() wpisz deszyfruj() \t ###\n### 4. Certyfikat tej osoby sprawdzisz przy pomocy certyfikat() \t\t\t ###\n###################################################################################\nWyswietl ponownie instrukcje: ?krypto \nWiecej o danej funkcji: ?nazwa_funkcji (np. ?generuj).");
addhelp(generuj, "generuj(): Generator kluczy na podstawie podanych informacji tworzy i zapisuje klucze w glownym folderze instalacji PARI GP. Moze wymagac uruchomienia gp.exe jako administrator.");
addhelp(start, "start(): Wczytuje klucze potrzebne do wymieny wiadomosci miedzy toba a wybrana osoba i przypisuje je do zmiennych.");
addhelp(szyfruj, "szyfruj(): Zaszyfruje wiadomosc do osoby ustawionej w start().");
addhelp(deszyfruj, "deszyfruj(): Odszyfruje wiadomosc otrzymana od osoby ustawionej w start().");
addhelp(certyfikat, "certyfikat(): Sprawdza czy plik (nazwisko_pub_cert.txt) osoby wybranej w start() mozna odczytac za pomoca klucza publicznego centrum autoryzacji");

\\ Ustawianie ziarna
setrand(getwalltime());
\\while(#digits(randomize = nextprime(getwalltime()*random(2^15))*nextprime(random(2^22))) != 19,randomize = nextprime(getwalltime()*random(2^15))*nextprime(random(2^22)));
\\ printf(randomize);printf("\t"#digits(randomize));
\\setrand(randomize);

\\ https://www.mersenneforum.org/showthread.php?t=18036
\\ check if a number is b-PRP, if b missing then do 2-PRP test
isPRP(n=2,b=2)=
{
    return(Mod(b,n)^(n-1)==1);
}

\\ same for strong prp
isSPRP(n=2,b=2)=
{   
    my(s,d);
    d=n-1;
    s=0;
    while(!(d%2),d>>=1;s++);
    d=Mod(b,n)^d;
    if(d==1 || d==-1, 
        return(1)
    );
    for(r=1,s-1,
        if((d=d^2)==-1,
            return(1),
            if(d==1,
                return(0)
            )
        )
    );
    return(0);   
}

\\ return next odd sprp
nextSPRP(n=2,b=2)=
{
    n+=1-n%2;
    while(!isSPRP(n,b),n+=2);
    return(n);
}

\\ https://rosettacode.org/wiki/RSA_code#PARI.2FGP
stigid(V,b)=subst(Pol(V),'x,b); \\ inverse function digits(...)

print("")
print("db   dD d8888b. db    db d8888b. d888888b  .d88b.   d888b  d8888b.  .d8b.  d88888b d888888b  .d8b.  ")
print("88 ,8P' 88  `8D `8b  d8' 88  `8D `~~88~~' .8P  Y8. 88' Y8b 88  `8D d8' `8b 88'       `88'   d8' `8b ")
print("88,8P   88oobY'  `8bd8'  88oodD'    88    88    88 88      88oobY' 88ooo88 88ooo      88    88ooo88 ")
print("88`8b   88`8b      88    88~~~      88    88    88 88  ooo 88`8b   88~~~88 88~~~      88    88~~~88 ")
print("88 `88. 88 `88.    88    88         88    `8b  d8' 88. ~8~ 88 `88. 88   88 88        .88.   88   88 ")
print("YP   YD 88   YD    YP    88         YP     `Y88P'   Y888P  88   YD YP   YP YP      Y888888P YP   YP ")
print("")
print("###################################################################################")
print("### Czesc! Poszyfrujemy?                                                        ###")
print("### Do poprawnego dzialania:                                                    ###")
print("### - wszystkie pliki trzymaj w glownym folderze PARI GP                        ###")
print("###   _n.txt, _pub.txt, _pub_cert.txt oraz _priv.txt jesli jestes wlascicielem  ###")
print("### - swoj klucz prywatny rowniez tam trzymaj                                   ###")
print("### - uruchomic PARI jako Administrator (jesli generujesz pare kluczy)          ###")
print("### - do poprawnego dzialania nie zmieniaj stylu nazewnictwa plikow             ###")
print("###################################################################################")
print("")
print("###################################################################################")
print("###                             ..::INSTRUKCJA::..                              ###")
printf("### 0. Jesli jeszcze nie masz pary kluczy, wygeneruj wpisujac ");printf("\e[%d;%d;1mgeneruj()\e[0m", 30, 47);printf("         ###")
printf("### 1. Aby szyfrowac lub deszyfrowac wpisz ");printf("\e[%d;%d;1mstart()\e[0m", 30, 47);printf(" i wypelnij pola              ###")
printf("### 2. Uzyj ");printf("\e[%d;%d;1mszyfruj()\e[0m", 30, 47);printf(" aby zaszyfrowac do wybranej w start() osoby               ###")
printf("### 3. Zeby odszyfrowac wiadomosc od osoby wybranej w start() wpisz ");printf("\e[%d;%d;1mdeszyfruj()\e[0m", 30, 47);printf(" ###")
printf("### 4. Certyfikat tej osoby sprawdzisz przy pomocy ");printf("\e[%d;%d;1mcertyfikat()\e[0m", 30, 47);printf("                 ###")
print("###################################################################################")
printf("Wyswietl ponownie instrukcje: ");printf("\e[%d;%d;1m?krypto\e[0m", 30, 46)
printf("Wiecej o danej funkcji: ?");printf("\e[%d;%d;1mnazwa_funkcji\e[0m", 30, 47);printf(" (np. ");printf("\e[%d;%d;1m?generuj\e[0m", 30, 46);printf(").")
print("")
print("Szybkie opcje: generuj() start() szyfruj() deszyfruj() certyfikat()")
print("")

generuj() = {
	printf("\e[%d;%d;1mWpisz swoje nazwisko (wyniki zostana zapisane w formacie nazwisko_reszta.txt w folderze PARI GP):\e[0m\n", 30, 47);
		zmienna_nazwisko = input();
	\\ Generowanie naszej pary kluczy (publiczny i prywatny)
	printf("\e[%d;%d;1mIlu bitowe klucze chcesz wygenerowac? (dowolna wartosc dozwolona - CTRL + C aby przerwac\e[0m\n", 30, 47);
	printf("\e[%d;%d;1m512 = 155 cyfr (malo bezpieczny ale bardzo szybki)\e[0m\n", 30, 41);
	printf("\e[%d;%d;1m1024 = 309 cyfr (bezpieczny i szybki)\e[0m\n", 30, 43);
	printf("\e[%d;%d;1m2048 = 617 cyfr (bardzo bezpieczny i wolny)\e[0m\n", 30, 42);
		bity = input();
		if (
			bity<=10,printf("\e[%d;%d;1mPodaj wartosc wieksza od 10!\e[0m\n", 30, 41);
			bity = input();
		,	
			bity>=1024, print("");printf("\e[%d;%d;1mSzukanie "bity" bitowej liczby moze trwac dlugo.\e[0m\n", 30, 43);
		);
			\\ Magia
			print("Wykowywanie obliczen dla "bity" bitowych wartosci, poczekaj lub przerwij (CTRL + C) ...");print("");
			p = nextprime(nextSPRP(random(2^bity),random(2^bity)));
			q = nextprime(nextSPRP(random(2^bity),random(2^bity)));
			n = p * q;
			e = nextprime(nextSPRP(random(2^(bity/2)),random(2^(bity/2))));
			d = lift(Mod(e,(p-1)*(q-1))^-1);
			\\ Zapisz klucze
			write(zmienna_nazwisko"_pub.txt", e);
			write(zmienna_nazwisko"_priv.txt", d);
			write(zmienna_nazwisko"_n.txt", n);
			printf("\e[%d;%d;1mZrobione!\e[0m\n", 30, 42);
	printf("\e[%d;%d;1mCzy chcesz zapisac swoje p i q? Jesli zgubisz klucz prywatny bedziesz mogl go jeszcze raz policzyc. (t)ak/(n)ie\e[0m\n", 30, 47);
		zmienna_zapisac = input();
		if (
			zmienna_zapisac==t,
				write("_"zmienna_nazwisko"_p.txt", p);
				write("_"zmienna_nazwisko"_q.txt", q);
				printf("\e[%d;%d;1mZapisano!\e[0m\n", 30, 42);
		,	
			zmienna_zapisac==n, print("TYLKO TERAZ NIE ZGUB SWOJEGO KLUCZA PRYWATNEGO!!!");;
		,
			zmienna_zapisac!=t||n, printf("\e[%d;%d;1mNie rozumiem, (t)ak czy (n)ie?\e[0m\n", 30, 47);
			zmienna_zapisac = input();
		);
	print("Wszystko zrobione! Zapisane pliki:");
	print("TWOJ KLUCZ PUBLICZNY (mozesz go rozsylac gdzie tylko zechcesz) TO:");
	print("   "zmienna_nazwisko"_pub.txt");
	print("   "zmienna_nazwisko"_n.txt");
	print("TWOJ KLUCZ PRYWATNY (NIE DZIEL SIE NIM Z NIKIM!) TO:");
	print("   "zmienna_nazwisko"_priv.txt");
	print("   "zmienna_nazwisko"_n.txt");
	if (zmienna_zapisac==t,
				print("SKLADOWE KLUCZA (WYDRUKUJ I ZCHOWAJ GLEBOKO, NIE DZIEL SIE NIMI) TO:");
				print("   _"zmienna_nazwisko"_p.txt");
				print("   _"zmienna_nazwisko"_q.txt");
	);
	print("To wszystko! Wyslij "zmienna_nazwisko"_pub.txt do Centrum Autoryzacji.");
	print("Po otrzymaniu "zmienna_nazwisko"_pub_cert.txt mozesz przejsc do start() i zaczac szyfrowac.");
	printf("\e[%d;%d;1mUWAGA: Jesli bedzie brakowac ktoregos pliku w folderze PARI, otrzymasz blad!\e[0m\n", 30, 43);
	print("");
}

start() = {
	printf("\e[%d;%d;1mWpisz swoje nazwisko (tak jak podpisane sa pliki, np. kowalski),\e[0m", 30, 47);
	printf("\e[%d;%d;1mwymaga obecnosci pliku nazwisko_priv.txt:\e[0m\n", 30, 41);
		zmienna_nazwisko = input();
			n = read(zmienna_nazwisko"_n.txt");
			e = read(zmienna_nazwisko"_pub.txt");
			\\ec = read(zmienna_nazwisko"_pub_cert.txt");
			d = read(zmienna_nazwisko"_priv.txt");
	printf("\e[%d;%d;1mPodaj do kogo chcesz szyfrowac lub od kogo chcesz deszyfrowac (tak jak podpisane sa pliki, np. malinowski):\e[0m\n", 30, 47);
		zmienna_odbiorca = input();
			no = read(zmienna_odbiorca"_n.txt");
			eo = read(zmienna_odbiorca"_pub.txt");
	printf("\e[%d;%d;1mZrobione! Podazaj dalej za instrukcja.\e[0m\n", 30, 42);
	print("Szybkie opcje: szyfruj() deszyfruj() certyfikat()");
	print("");
}

szyfruj() = {
\\ jesli brakuje kluczy to przerwij
if(type(d) == "t_POL", \
  printf("\e[%d;%d;1mBrak zaladowanych kluczy. Najpierw uzyj start()\e[0m\n", 30, 41);break;start(););

	printf("\e[%d;%d;1mWpisz swoja wiadomosc,\e[0m", 30, 47);
	printf("\e[%d;%d;1mzaczynajac i konczac cudzyslowem (--> \" <--):\e[0m\n", 30, 41);
		wiadomosc = input();
		kodowanie = stigid(Vecsmall(wiadomosc),256); \\ message as an integer
	
	\\ SZYFROWANIE KLUCZEM PUBLICZNYM ODBIORCY
	zasztfrowane = lift(Mod(kodowanie,no)^eo);

	\\ PONOWNE SZYFROWANIE NASZYM KLUCZEM PRYWATNYM
	wynik_szyfrowania = lift(Mod(zasztfrowane,n)^d);

	print("-----POCZATEK ZASZYFROWANEJ WIADOMOSCI------");
	print("");
	print(wynik_szyfrowania);
	print("");
	print("-----KONIEC ZASZYFROWANEJ WIADOMOSCI------");
	print("");
}

deszyfruj() = {
\\ jesli brakuje kluczy to przerwij
if(type(d) == "t_POL", \
  printf("\e[%d;%d;1mNie ma zaladowanych kluczy. Najpierw uzyj start()\e[0m\n", 30, 41);break);

	printf("\e[%d;%d;1mWklej szyfrogram od "zmienna_odbiorca":\e[0m\n", 30, 47);
		deszyfr = input();
	
	\\ Odszyfrowanie wiadomosci do mnie kluczem publicznym nadawcy
	odszyfrowane = lift(Mod(deszyfr,no)^eo);

	\\  Odszyfrowanie wiadomosci do mnie
	wynik_odszyfrowania = lift(Mod(odszyfrowane,n)^d);
	
	wiadomosc_odkodowana = Strchr(digits(wynik_odszyfrowania, 256));	\\ readable message

	print("-----POCZATEK ODSZYFROWANEJ WIADOMOSCI od "zmienna_odbiorca"------");
	print("");
	print(wiadomosc_odkodowana);
	print("");
	print("-----KONIEC ODSZYFROWANEJ WIADOMOSCI od "zmienna_odbiorca"------");
	print("");
}

certyfikat() = {
	\\ dodajmy stala ktora jest klucz publiczny naszego "centrum autoryzacji"
	\\ nk = read("X:/PATH/kurkowski_n.txt");
	nk = 32317006071311007300714876688669951960444102669715484032130345427524655138867890893197201411522913463688717960921898019494119559150490921095088152386448283120630877367300996091750197750389652106796057638384067568276792218642619756161637918124398696123653359440462893276537212039622032236911476612945290930332538254858381126109951298955235655288250898562384170163078618487415513230697190028628066729303041750424907903214944322754043889240743096028516571325943630517231793886503346255309062169648428462353747357836805077305810675474668031298850689989317501952889789103537081097100948737975904069427347052730485725435277;
	\\ ek = read("X:/PATH/kurkowski_nowypub.txt");
	ek = 11110460360610540630450120720990390690610410540720630410360990910990410430690180760990580690160430360180760490740830990720250610630380120990029909109906105405406709809809800633;
	\\ wczytajmy certyfikat odbiorcy
	eoc = read(zmienna_odbiorca"_pub_cert.txt");
	\\ Sprawdz certyfikat nadawcy
	printf("\e[%d;%d;1mSprawdzanie poprawnosci certyfikatu "zmienna_odbiorca"...\e[0m\n", 30, 47);
	cert = lift(Mod(read(zmienna_odbiorca"_pub_cert.txt"),nk)^ek);
	if (cert - read(zmienna_odbiorca"_pub.txt") !=0, printf("\e[%d;%d;1mCERTYFIKAT NIEPOPRAWNY\e[0m\n", 30, 41),printf("\e[%d;%d;1mCERTYFIKAT POPRAWNY\e[0m\n", 30, 42));
}