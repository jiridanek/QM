    Jméno:   Jiří Daněk
    Fakulta: FI   Ročník: 3   Obor: BIO 

# Studium vybrané reakce pomocí semiemperické metody PM3

## Cíle

S využitím emperické kvantově chemické metody PB3 implementované v programu Gaussian 2003 určit aktivační a reakční energii vybrané reakce a identifikovat tranzitní stav.

## Úvod

Pro toto cvičení jsem si zvolil Diels-Alderovu reakci z článku [[1]]. Diels-Alderovy rekce patří mezi cykloadice. Reagují spolu dien (1) a dienofil (2). Dochází ke vzniku dvou vazeb mezi uhlíky a vzniku šestičlenného uhlíkového cyklu. [[2]]

<img src="http://jirkadanek.github.com/QM/F1.large.jpg" width="100%">

Pro účely tohoto cvičení jsem zjednodušil molekulu dienu, a to tak, že jsem nahradil methylem. Odpovídajícím způsobem pak byla modifikována i molekula produktu (4). Smyslem této změny je snížit časovou náročnost výpočtů a zpřehlednit manualní práci s molekulovými daty.

[1]: http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3241958/ "Computational design of an enzyme catalyst for a stereoselective bimolecular Diels-Alder reaction"
[2]: http://www.scribd.com/doc/57131646/42/Diels-Alderova-reakce

## Metody

PM3 je semiemperická kvantově mechanická metoda.

## Použitý software

### Avogadro

module add avogadro

### VMD

    module add vmd

Program VMD jsem použil pro analýzu trajektorií z optimalizací molekul v kroku 02.

### extract-\*\*\*-\*\*\*

    module add qmutil

Sada skriptů pro extrahování údajů z logů programu Gaussian

### Gaussian 03

    module add gaussian:03_E1

Gaussian je program pro výpočty v kvantové chemii. První verze, Gaussian 70, vyšla v roce 1970, v současnosti je aktualní verze Gaussian 09 z roku 2009.

Spouští se příkazem g03

### Molekel

    module add molekel

Program Molekel byl použit pro vizualizaci vibrací.

## Postup

### Určení reakční energie

Molekuly výchozích látek a molekulu produktu jsem namodeloval v programu Avogadro. Následně jsem v programu provedl optimalizaci každé z molekul pomocí silového pole MMFF94. Cílem tohoto kroku je urychlit následnou kvantově mechanickou optimalizaci. Molekuly zoptimalizované v programu Avogadro jsem uložil ve formátu xyz do složky "QM/01\_Molekuly"

Molekuly jsem dále optimalizoval v programu Gaussian 03 pomocí metody PM3. Výsledky optimalizace se nacházejí ve složce "QM/02\_QM_optimalizace" Pro ověření, že se molekuly nacházejí v lokálním minimu jsem provedl analýzu vibrací. Výsledky z analýzy vibrací jsou ve složce "QM/03\_F\_analyza"

Z vypočtených energií molekul jsem stanovil reakční energii reakce.

### Nalezení transitního stavu
Vyšel jsem z molekuly produktu a provedl jsem single coordinate driving mezi dvojcí uhlíkových atomů, mezi kterými při reakci vzniká vazba. Soubory z tohoto kroku se nacházejí ve složce "QM/04\_Transitni\_stav/produkt" Jelikož jsem tímto způsobem nenalezl tranzitní stav, zvolil jsem na trajektorii předchozího drivingu místo, kde prodlužovaná vazba pravděpodobně zaniká, zafixoval polohu atomů na jejich koncích a od tohoto místa nechal proběhnou single coordinate driving na druhé dvojici uhlíkových atomů. Výpočet proběhl ve složce "QM/04\_Transitni\_stav/produkt\_step1". To vedlo k nalezení transitního stavu, jak sem se přesvědčil optimalizací "QM/05\_Optimalizace\_TS/produkt\_step1" a následnou analýzou vibrací "QM/06\_F\_analyza_TS/produkt\_step1" tranzitního stavu.

Energii nalezeného optimalizovaného tranzitního stavu jsem použil k určení aktivační energie reakce.

## Průběh výpočtů

### 01 Molekuly
Modelování a optimalizace v programu Avogadro byla dostatečně popsána v předchozí části.

### 02 QM optimalizace
Pomocí programu Gaussian jsem provedl další optimalizaci, tentokrát pomocí kvantově mechanické metody . 

Program Gaussian odmítal běžet s chybou "buffer allocation failed in ntrext1.". Řešením je provádět výpočty v lokálním adresáři, například /scratch, namísto sdíleného /home. Zdroj FAQ na stránce [[3]]

[3]: http://metavo.metacentrum.cz/en/docs/aplikace/software/gaussian.html

    QM/02_QM_optimalizace$ grep "Stationary point found" */*.log
    produkt/produkt.log:    -- Stationary point found.
    reaktant1/reaktant1.log:    -- Stationary point found.
    reaktant2/reaktant2.log:    -- Stationary point found.

Optimalizace proběhla úspěšně.

### 03 Frekvenční analýza
Z výstupu předchozího kroku jsem pomocí skriptu QM/03_F_analyza/prepeareInput.bash přípravil `.com` soubory.
Opět pomocí programu Gaussian jsem provedl vibrační analýzu

    QM/03_F_analyza$ grep "Stationary point found" */*.log
    produkt/produkt.log:    -- Stationary point found.
    reaktant1/reaktant1.log:    -- Stationary point found.

Jak je vidět, reaktant2 se nenacházel ve stacionárním stavu.

Rešením bylo upravit soubor QM/03_F_analyza/produkt2/produkt2.com

    - # PM3 Freq NoSymm
    + # PM3 Opt Freq NoSymm

alternativně by bylo možno provést optimalizaci v kroku 02 dle přísnějších konvergenčních kritérii

    Opt=Tight

což je v dokumentaci programu Gaussian při následném počítání frekvence doporučovaný postup.

    QM/03_F_analyza$ grep "Stationary point found" */*.log
    produkt/produkt.log:    -- Stationary point found.
    reaktant1/reaktant1.log:    -- Stationary point found.
    reaktant2/reaktant2.log:    -- Stationary point found.

Díky této modifikaci byly už vibrace spočteny správně.

    QM/03_F_analyza$ grep Frequencies */*.log
    produkt/produkt.log: Frequencies --    24.8827                37.9026                49.0839
    …
    produkt/produkt.log: Frequencies --  3133.1610              3140.8731              3356.9662
    reaktant1/reaktant1.log: Frequencies --    46.5691                62.1951                91.4959
    …
    reaktant2/reaktant2.log: Frequencies --    35.9805                88.3567               123.1630
    …

Všechny vibrace jsou realné, "kladné".

    QM/03_F_analyza $ ../extractResults.bash

Pomocí uvedeného skriptu byly extrahovány souřadnice z výsledných `.log` souborů z kroku 03.

### Hledání transitního stavu

Souřadnice byly použity ze souboru `QM/03_F_analyza/produkt/produkt_last.xyz`

Pro určení toho, kde se nachází atom s kterým čislem byl použit program Avogadro

    View -> Properties -> Atom properties

zvolil jsem atomy 4 a 15, jelikož vazba mezi nimi je jedna ze dvou, které při modelované reakci vznikají

    QM/04_Transitni_stav/produkt$ g03 produkt &
    QM/04_Transitni_stav/produkt$ while true; do extract-gdrv-ene produkt.log; sleep 10; done;

když je TS nalezen

    39    3.4435             76.006 /       -0.070229762
    40    3.4935             76.088 /       -0.070099124
    41    3.5435             76.173 /       -0.069963508
    42    3.5935             76.265 /       -0.069817740
    43    3.6435             76.365 /       -0.069658264
    44    3.6935             38.507 \       -0.129988809
    45    3.7435             38.437 \       -0.130100657

můžeme gaussian ukončit.

V tomto případě Gaussian skončil vzápětí sám s chybou

    Incomplete coordinate system.  Try restarting with Geom=Check
    Guess=Read Opt=(ReadFC,NewRedundant) Error termination via Lnk1e in …

Průběh drivingu je možné přehledně zobrazit například v programu VMD, pokud zapneme dynamické přepočítávání vazeb

    Graphics -> Representations -> Drawing Method -> DynamicBonds

#### Grafy energií

Průběh změn energie během drivingu je vhodné vykreslit v grafu.

    QM/04_Transitni_stav/produkt $ ../graph.bash

<img src="http://jirkadanek.github.com/QM/04_Transitni_stav/produkt/produkt.png" width="100%">


Použití snímku 43 z tohoto drivingu nevede, jak bylo zjištěno po optimalizaci a vizualizaci vibrací, k dobrému tranzitnímu stavu.


### 04b Hledání transitního stavu

Z prvního drivingu jsem vibral snímek 21, zafixoval vzdálenost atomů (4,15) a nechal prodlužovat vazbu mezi atomy (1,13). Výpočet proběhl ve složce "QM/04\_Transitni\_stav/produkt\_step1"

<img src="http://jirkadanek.github.com/QM/04_Transitni_stav/produkt_step1/produkt_step1.png" width="100%">

Jako vstup pro optimalizaci TS jsem zvolil snímek číslo 9.

### 05b Optimalizace TS
Takto nalezený tranzitní stav jsem dále zoptimalizoval a zobrazil si imaginární vibraci v programu Molekel.

### 06b Frekvenční analýza
V této jediné imaginární vibraci je vidět vibrace atomů 4,15 a 1,13 proti sobě a stejným způsobem vibruje také dvojice atomů, které budou v produktu vázány kratší dvojnou namísto jednoduchou vazbou. Transitní stav byl tedy nalezen.

## Výsledky

    QM/02_QM_optimalizace$ for m in */*.log; do
        echo $m;
        extract-gopt-ene "$m" | tail -1;
    done

    produkt/produkt.log
         27            -38.032       -0.191353504
    reaktant1/reaktant1.log
         31             -5.609       -0.088498744
    reaktant2/reaktant2.log
         18             -5.466       -0.041637747

    Energie reakce = -E(výchozích látek) + E(produktů)
    E = -(-0.088498744-0.041637747) + -0.191353504 au
    E = -0.061217013 au = -38.4 kcal/mol

    QM/05_Optimalizace_TS/produkt_step1$ extract-gopt-ene produkt_step1.log | tail -1
         21             -0.694       -0.072882547

    Aktivační E = -E(výchozích látek) + E(TS)
    E_a = -(-0.088498744-0.041637747) + -0.072882547 au
    E_a = 0.057253944 au = 36.0 kcal/mol

## Závěr

Reakce je exotermická. Analýzou vibrací tranzitního stavu jsem určil, že reakce je synchronní. To odpovídá mechanizmu reakce popsaném v původním článku.

## Další použité zdroje
 - slajdy C7800-QM-Gaussian_001.pdf wolf.ncbr.muni.cz/home/kulhanek/C7800-QM-Gaussian_001.pdf
 - on-line přístupný archív manuálu Gaussian 03 http://iris.inc.bme.hu/common/g03_man/g_ur/g03mantop.htm