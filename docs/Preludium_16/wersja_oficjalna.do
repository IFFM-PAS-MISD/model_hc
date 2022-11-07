













































	
	
	
	


	
		
			
				








	
	
		
		
	








	




















	







<!doctype html>
<html lang="pl">
	<head>
		<meta charset="UTF-8">
		<title>Logowanie do systemu ZSUN/OSF</title>
		<meta name="viewport" content="width=device-width" />
		<link href="/favicon.ico?v=5274995228900373381" rel="shortcut icon" type="image/x-icon">
	<!--CZY_ZALOGOWANY_W_OSF:NIE-->
		



<script type="text/javascript">
    var jsvTimeStartLoading = new Date().getTime();
    var jsvIsProduction = 'true' === 'true';
    var jsvIsPopup = false;
    var jsvIsAjaxActionForm = 'true' === 'false';
    var jsvContextPath = '/app';
    var jsvSessionLocale = 'pl';
    var jsvDatepickerYearRange = '-99:+99';
    var jsvKontrolaDostepnosciPrzedWyslaniemAktywna = 'false';
    var jsvAktywnoscUzytkownikaUrlPrzedluzBlokade = '/app/adm/blokadaWniosku.do?do=przedluzBlokade&zablokowanyRekord=&zablokowanaTablica=&liczbaSekund=';
    var jsvKontrolaLogowaniaUrl = '/app/adm/kontrolaLogowania.do?do=sprawdz';
    var jsvAktywnoscUzytkownikaCzasSesji = 1800000; 
    var jsvAktywnoscUzytkownikaOkresSprawdzania = 1500000; 
    var jsvBlokadyZablokowanyRekord = '';
    var jsvBlokadyZablokowanaTablica = '';
    var jsvWniosekBiezacyWniosekId = '';
    var jsvAdresOdblokujIZamknij = '/app/adm/blokadaWniosku.do?do=odblokujIZamknij';
    var jsvAdresOdblokujPrzyZamknieciu = '/app/adm/blokadaWniosku.do?do=odblokujPrzyZamknieciu';
    var jsoCurrentPopup = {};
    var jsoMaskingPageLoading;
    document.documentElement.setAttribute("data-documentready", "false");
</script>
<script src="/app/opicore/js/libs/browserdetect/browserdetect.min.js?v=5274995228900373381" type="text/javascript"></script>
		<link href="/app/opicore/css/misc.css?v=5274995228900373381" rel="stylesheet">
		<link href="/app/osf3/layout/assets/css/stylesheet.css?v=5274995228900373381" rel="stylesheet">
		<link href="/app/osf3/layout/assets-osf/css/style.css?v=5274995228900373381" rel="stylesheet">
		<script src="/app/osf3/layout/assets/js/jquery-1.12.4.min.js?v=5274995228900373381"></script>
		<script src="/app/osf3/layout/assets/js/jquery-ui-1.12.1.min.js?v=5274995228900373381"></script>
		<script src="/app/opicore/js/our/core.min.js?v=5274995228900373381" type="text/javascript"></script>
		<script src="/app/osf3/layout/assets-osf/js/function.js?v=5274995228900373381"></script>
		<script src="/app/opicore/js/our/replace.common.js?v=5274995228900373381"></script>
		<link rel="icon" type="image/svg+xml" href="/app/osf3/layout/assets/img/opi.svg">
	</head>
	<body class="layout-fluid small">
		

















<div id="skipLinks" role="navigation">
	<ul>
		<li><a href="javascript:jQuery(String.fromCharCode(35)+'loginId')[0].focus();" class="skipLink" onclick="">Logowanie</a></li>
		<li><a href="#info_PomocTechniczna" class="skipLink" onclick="">Kontakty do pomocy technicznej</a></li>
		<li><a href="#info_MNiSW" class="skipLink" onclick="">Kontakty z MNiSW</a></li>
		<li><a href="#info_NCBR" class="skipLink" onclick="">Kontakty z NCBR</a></li>
		<li><a href="#info_NCN" class="skipLink" onclick="">Kontakty z NCN</a></li>
	</ul>
</div>
		



<div id="mplMaskingPageLoading">
	<div id="mplWczytujeStroneProszeCzekac" class="mplHidden">Wczytuję stronę...<br>Proszę czekać</div>
	
	<div id="mplMaskCurtain" data-noresizecheck></div>
	<div id="mplCenter" data-noresizecheck>
		<div>
			<div id="mplWrapper">
				<div>
					<div id="mplSpinner"></div>
				</div>
				<div id="mplInfo"></div>
				
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	(function () {
	    if (typeof jsfInitializeMaskingPageLoading === 'function') {
            jsfInitializeMaskingPageLoading();
		}
	})();
</script>


		<main>























<div id="systemMessageWrapper" class="messenger wrapper" style="display: none;">
	<div class="message -oldfashion -size-sm ">
		<div id="systemMessage" class="message__body bold"
			 data-interval-minutes="20"
			 data-ajax-url="/app/adm/komunikat.do"
			 data-institution-id=""></div>
	</div>
</div>










<div class="spaceWithoutLine" ><hr  ></div>

<script type="text/javascript">
    (function () {
        function showHideMessage(data) {
            var isHidden = messageBody.is(':hidden');
            var oldData = messageBody.html();
            messageBody.html(data);
            if (data.length === 0) {
                systemMessageWrapper.hide();
            } else {
                systemMessageWrapper.show();
                if (isHidden || data !== oldData) {
                    if (isAjax) {
                        jsfScroolToTopPage();
					} else {
                        jQuery(window).load(function () {
                            setTimeout(function () {
                                jsfScroolToTopPage();
                            }, 200);
                        });
					}
				}
            }
        } //showHideMessage
        function getMessage() {
            jQuery.ajax({
                url: url,
                data: {
                    'instId': institution
                }
            }).done(function (data) {
                isAjax = true;
                showHideMessage(data);
            });
        }
        var systemMessageWrapper = jQuery("#systemMessageWrapper");
        var messageBody = jQuery("#systemMessage[data-interval-minutes][data-ajax-url][data-institution-id]");
        if (systemMessageWrapper.length > 0 && messageBody.length > 0) {
            var isAjax = false;
            var minute = 60 * 1000;
            var interval = messageBody.attr('data-interval-minutes') * minute;
            var url = messageBody.attr('data-ajax-url');
            var institution = messageBody.attr('data-institution-id');
            showHideMessage(messageBody.html());
            if (interval > 0) {
                var messengerInterval = setInterval(function () {
                    getMessage();
                }, interval);
            }
            if (window.jsfBlinkClassesOfElement) {
                jsfBlinkClassesOfElement({
                    id: 'systemMessage',
                    css: [['message'],['messageOff']],
                    period: 0.5
                });
            }
        }
    })();
</script>

    
    
        










<div class="layout-fluid">
	<div class="module -tom">
		<header class="wrapper layout-table">
			<div class="layout-table__cell -width-25 [ module -sm ] -vertical-align-middle">

				<figure class="header__figure">
					<a href="/">Strona główna</a>
				</figure>
				<figure class="header__figure2"></figure>

			</div><!--/ layout-table__cell -->
			<div class="layout-table__cell -width-40  [ module -sm ] headline">
				<p class="header__title color-beta">Zintegrowany System Usług dla Nauki<br>Obsługa Strumieni Finansowania</p>
				<!--<p class="font-12 color-beta">Pierwszy raz w OSF? <a href="">Przeczytaj krótki poradnik</a></p>-->
			</div><!--/ layout-table__cell -->
			<div class="layout-table__cell -width-45">

				<div class="grid gap-15 -flexible accessibility__bar  -padding-top-35" >
					<div class="grid__item -width-60">
						
						<p>
							<a href="javascript:;" id="cookies-trigger" class="font-12 -padding-right-10">Cookies w ZSUN/OSF</a>
							<a href="/app/adm/start.do?changeLang=en" data-openpopup="false" class="header__en" title="English Version">English Version</a>
						</p>
					</div><!--/ grid__item -->
					<div class="grid__item  -width-40">
						<img class="-inline footer__logo2" src="/app/osf3/layout/assets/img/ue.svg"  alt="" />
					</div><!-- grid__item -->
				</div><!--/ grid -->

				<p class="font-20 line-height-24 color-opi -text-center">
					
				</p>

			</div><!-- layout-table__cell -->


		</header><!--/ wrapper-->

	</div><!--/ module-->

	












	<div class="module -anna -padding-top-5 -padding-bottom-5">
		<div class="wrapper module -lg -roger ">
			<h1 class="font-24 color-beta font-slim">Ważne informacje</h1>
			<hr class="push-10" />
			<div class="accordion">
				
					<div class="accordion__trigger">
						<a href="javascript:" >Informacja o naborze wniosków do strumieni finansowania ogłoszonych na podstawie ustawy o zasadach finansowania nauki</a>&nbsp;&nbsp;(publikacja od: 2018-10-31 13:38 do: 2018-12-31 23:59)
					</div>
					<div class="accordion__item"><div class="ckeditor_contents"><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Ministerstwo Nauki i Szkolnictwa Wyższego informuje, że w dniu 1 października 2018 roku wchodzi w&nbsp;życie ustawa <em>Prawo o szkolnictwie wyższym i nauce</em>. Zgodnie z przepisami wprowadzającymi ustawę &ndash; <em>Prawo o szkolnictwie wyższym i nauce</em>, z dniem wejścia w życie ww.&nbsp; ustawy traci moc m. in. ustawa z dnia 30 kwietnia 2010 r. o zasadach finansowania nauki (Dz. U. z 2018 r. poz. 87).</span></span></span></span><br />
<span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Ministerstwo Nauki i Szkolnictwa Wyższego przedstawia szczeg&oacute;łowe informacje w sprawie termin&oacute;w nabor&oacute;w wniosk&oacute;w do strumieni finansowania nauki, ogłoszonych na podstawie ww. ustawy o&nbsp;zasadach finansowania nauki:</span></span></span></span>
<ol>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek o przyznanie dotacji na utrzymanie potencjału badawczego oraz na badania naukowe lub prace rozwojowe i zadania z nimi związane, służące rozwojowi młodych naukowc&oacute;w oraz uczestnik&oacute;w studi&oacute;w doktoranckich &ndash; zgodnie z dotychczasowymi przepisami wniosek był składany w&nbsp;terminie od 1 do 31 października. W nowej ustawie nie przewiduje się wymogu składania wniosku o przyznanie ww. środk&oacute;w &ndash; jej wejście w życie z dniem 1 października 2018 r. spowoduje, że nab&oacute;r wniosk&oacute;w o przyznanie ww. środk&oacute;w nie zostanie uruchomiony;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek o przyznanie dotacji na utrzymanie specjalnego urządzenia badawczego &ndash; wnioski złożone do 15 września 2018 r. będą rozpatrywane;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek o przyznanie dotacji na zapewnienie dostępu do informacji naukowej &ndash; postępowania wszczęte wnioskami złożonymi do 15 września 2018 r. i nierozpatrzonymi do dnia 31 grudnia 2018 r. zostaną umorzone;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek o przyznanie dotacji na restrukturyzację &ndash; wnioski złożone do 30 września 2018 r. będą rozpatrywane na podstawie przepis&oacute;w dotychczasowych do dnia 31 grudnia 2018 r. Postępowania niezakończone do dnia 31 grudnia 2018 r. zostaną umorzone;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek o przyznanie dotacji na utrzymanie specjalnego urządzenia badawczego z zakresu infrastruktury informatycznej nauki &ndash; wnioski złożone do 15 września 2018 r. będą rozpatrywane;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek o przyznanie dotacji na utrzymanie potencjału badawczego z tytułu zdarzenia losowego &ndash; wnioski złożone do 30 września 2018 r. będą rozpatrywane na podstawie przepis&oacute;w dotychczasowych. Postępowania niezakończone do dnia 31 grudnia 2018 r. zostaną umorzone;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek o zwiększenie dotacji na utrzymanie potencjału badawczego &ndash; do dnia 31 grudnia 2018 r. wnioski będą rozpatrywane na podstawie przepis&oacute;w dotychczasowych. Postępowania niezakończone do dnia 31 grudnia 2018 r. zostaną umorzone, dlatego też &ndash; z uwagi na konieczność zaopiniowania wniosku przez zesp&oacute;ł specjalistyczny - wniosek powinien zostać złożony odpowiednio wcześniej;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek o przyznanie środk&oacute;w na realizację projektu międzynarodowego wsp&oacute;łfinansowanego &ndash; wnioski złożone do 30 września 2018 r. będą rozpatrywane na podstawie przepis&oacute;w dotychczasowych;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek &bdquo;Granty na granty: promocja jakości II&rdquo; - wnioski złożone do 30 września 2018 r. będą rozpatrywane na podstawie przepis&oacute;w dotychczasowych;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek o finansowanie działalności upowszechniającej naukę &ndash; wnioski złożone do 30 września 2018 r. będą rozpatrywane na podstawie przepis&oacute;w dotychczasowych. Postępowania w sprawie wniosk&oacute;w złożonych po 30 września 2018 r. zostaną umorzone;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wnioski o finansowanie projektu w ramach programu &bdquo;Narodowy Program Rozwoju Humanistyki&rdquo; &ndash; rozpatrywane na zasadach dotychczasowych;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wnioski na inwestycję budowlaną lub inwestycję budowlaną dotyczącą strategicznej infrastruktury badawczej - złożone do 31 sierpnia 2018 r. rozpatrywane będą na zasadach dotychczasowych do 31 grudnia 2018 r. Do niezakończonych postępowań stosuje się przepisy nowej ustawy;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wnioski na zakup, wytworzenie lub rozbudowę aparatury naukowo &ndash; badawczej stanowiącej dużą lub strategiczną infrastrukturę badawczą - złożone do 31 sierpnia 2018 r. rozpatrywane będą na zasadach dotychczasowych do 31 grudnia 2018 r. Do niezakończonych postępowań stosuje się przepisy nowej ustawy;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wnioski na rozbudowę infrastruktury informatycznej nauki stanowiącej dużą lub strategiczną infrastrukturę badawczą - złożone do 31 sierpnia 2018 r. rozpatrywane będą na zasadach dotychczasowych do 31 grudnia 2018 r. Do niezakończonych postępowań stosuje się przepisy nowej ustawy;</span></span></span></span></li>
 <li><span style="font-size:11pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:12.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">Wniosek do konkursu w ramach programu pod nazwą &bdquo;DIALOG&rdquo; - wnioski złożone do 30 września 2018 r. będą rozpatrywane na podstawie przepis&oacute;w dotychczasowych.</span></span></span></span></li>
</ol>
</div></div>
				
			</div>
		</div><!--/ wrapper-->
	</div><!--/ module-->



	<div>
		<hr />

		<div class="overAll">

			<div class="main module  -sm">
				<div class="wrapper ">
					<div class="-padding-top-20 -padding-bottom-20">
						<form name="autentykacjaForm" id="autentykacjaForm" method="post" action="/app/adm/autentykacja.do?do=loguj">
							
							<div class="layout-table">

								<input type="hidden" name="errorIp">
								<input type="hidden" id="errorKomunikat" name="errorKomunikat" value="">

								<div class="layout-table__cell -width-45 register__info">

									<h1 class="font-18 font-slim push-10 -margin-right-10">System ZSUN/OSF przeznaczony jest do rejestrowania i obsługi wniosków o finansowanie nauki wpływających do:</h1>
									<ul class="-dotted push-20 push-in-10">
										<li class="color-beta font-slim">Ministra Nauki i Szkolnictwa Wyższego</li>
										<li class="color-beta font-slim">Narodowego Centrum Nauki</li>
										<li class="color-beta font-slim">Narodowego Centrum Badań i Rozwoju</li>
									</ul>
									<div class="font-14 module -padding-left-0">
										<a href="/app/aawi/wynikiKonkursowNcn.do?kryteriaWyszukiwania="><strong>Wnioski zakwalifikowane do finansowania w NCN</strong></a>
									</div>
								</div><!-- layout-table__cell -->
								<div class="layout-table__cell -width-55 -border-left login__form">
									<p class="font-20 color-beta push-5  font-slim">
										Dostęp do systemu
									</p>
									
									
									
									<hr class="push-10" />
									<div class="grid  -gap-15 push-in-40 form-grid">
										<div class="grid__item -width-50">
											<div class="form-text">
												<label for="loginId">Login</label>
												<input type="text" name="login" value="" id="loginId">
													
											</div>
										</div><!-- grid__item
                                    --><div class="grid__item -width-50">
										<div class="form-text">
											<label for="haslo">Hasło</label>
											<input type="password" name="haslo" value="" id="haslo">
												
											<div class="push-5"></div>
											<a class="font-12 line-height-30 -text-right -block" href="/app/adm/zapomnianeHaslo.do?do=startuj">Pobierz login i hasło</a>
										</div>
									</div><!-- grid__item
                                    -->

									</div><!-- grid -->
									
									<div class="grid -flexible -gap-15 form-grid">
										<div class="grid__item">
											<a class="button -secondary -md " href="/app/adm/daneOsoby.do?do=zalozKonto">
												Zarejestruj się jako redaktor wniosków
											</a>
											
												<div class="push-5"></div>
												<!-- // @GV { 't':'action', 'n':'Zarejestruj się przez Profil Zaufany', 'id':'Zec7f59ec24d', 'ctg':'', 'cmnt':'', 'par':[ 'Z53490cab240,-' ], 'sub':[ 'Zeb231d16249' ] } @VG -->
												<!-- <a class="font-12 line-height-30 -block" href="/app/zsun1/pz/pz-reg-info.xhtml">Zarejestruj się przez Profil Zaufany</a> -->
												<a class="font-12 line-height-30 -block"
												   href="/app/adm/daneOsobyPz.do?do=rejestracjaPzPre">
													Zarejestruj się przez Profil Zaufany
												</a>
											
										</div><!-- grid__item
                                    --><div class="grid__item -text-right">
										<button type="submit" class="button -primary -md" id="buttonZapisz">Zaloguj</button>
										
											<div class="push-5"></div>
											<!-- // @GV { 't':'action', 'n':'Zaloguj się przez Profil Zaufany', 'id':'Zae4e5392944', 'ctg':'', 'cmnt':'', 'par':[ 'Z53490cab240,-' ], 'sub':[ ] } @VG -->
											<a class="font-12 line-height-30 -block"
											   href="/app/adm/daneOsobyPz.do?do=zalogujPzPre">
												Zaloguj się przez Profil Zaufany
											</a>
										
									</div><!-- grid__item
                                    -->
									</div><!-- grid -->
								</div><!-- layout-table__cell -->

							</div>  <!-- layout-table -->

							
						</form>
					</div><!-- padding -->


				</div><!-- wrapper -->
			</div>
			<hr />
			<div class=" module -xs -tom">
				<div class="wrapper">
					<div id="info_PomocTechniczna" class="grid gap-10 -flexible -middle help__bar">
						<div class="grid__item font-14 font-slim color-beta -text-right">
							Potrzebujesz pomocy technicznej?
						</div><!-- grid__item -->
						<div class="grid__item -text-center">
							<a class="button -secondary -sm" href="javascript:void(0);"
							   onclick="jsfOpenPopupWindow('/app/adm/uwagi.do');">
								<em class="icon-envelope-2 font-12"></em>
								Napisz do nas
							</a>
						</div><!-- grid__item -->
						<div class="grid__item font-14">
							<p class="push-5">Zadzwoń do nas: <span data-title="Pracujemy w dni powszednie w godzinach 8:15 - 16:15" class="tooltip font-14"><em class="icon-help"></em></span>
								<a href="tel:0048223517101">+48 (22) 35 17 101</a> lub <a href="tel:0048223517104">+48 (22) 35 17 104</a> lub <a href="tel:0048223517089">+48 (22) 35 17 089</a></p>
						</div><!-- grid__item -->
					</div><!-- grid -->
				</div><!-- wrapper -->
			</div>  <!-- module -->
			<hr />
			<div class="main module -sm">
				<div class="wrapper ">
					<div class="-padding-top-20 -padding-bottom-20">
						<p class="-text-center color-beta font-30 font-slim push-10">Kontakt merytoryczny</p>
						<p class="-text-center color-gamma font-12 font-slim push-40">rozwiń sekcję klikając w nagłówek</p>
						<div class="layout-table">

							<div id="info_MNiSW" class="layout-table__cell -width-1/3  module -sm -border-right">
								<div class="-text-center push-20">
									<img class="module -sm column__logo" src="/app/osf3/layout/assets/img/mnisw.svg" alt="" />
								</div>

								<div class="font-20 font-slim push-20">Departament Nauki</div>
								<div class="hiddenReadable">rozwiń sekcję klikając w nagłówek</div>
								<div class="accordion push-30">
									<div class="accordion__trigger">
										<a href="javascript:;" >wnioski międzynarodowe współfinansowane</a>
									</div>
									<div class="accordion__item">
										(22) 50 17 843<br>
										(22) 50 17 840<br>
										(22) 52 92 493<br>
										(22) 52 92 458
									</div>
									
									<div class="accordion__trigger">
										<a href="javascript:;" >program "Iuventus Plus"</a>
									</div>
									<div class="accordion__item">
										+48 (22) 52 92 490<br>
										+48 (22) 52 92 454
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >program Mobilność Plus</a>
									</div>
									<div class="accordion__item">
										+48 (22) 52 92 490<br>
										+48 (22) 52 92 380
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >program Diamentowy Grant</a>
									</div>
									<div class="accordion__item">
										+48 (22) 52 92 452
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >inwestycje aparaturowe</a>
									</div>
									<div class="accordion__item">
										• podstawowe jednostki organizacyjne uczelni<br> oraz jednostki naukowe Polskiej Akademii Nauk<br>
										&nbsp;&nbsp;&nbsp;+48 (22) 50-17-860<br>
										&nbsp;&nbsp;&nbsp;+48 (22) 52-92-425<br>
										• instytuty badawcze<br>
										&nbsp;&nbsp;&nbsp;+48 (22) 52-92-344<br>
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >inwestycje budowlane</a>
									</div>
									<div class="accordion__item">
										+48 (22) 52-92-344
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >inwestycje informatyczne</a>
									</div>
									<div class="accordion__item">
										+48 (22) 50-17-145<br>
										+48 (22) 52-92-425
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >Narodowy Program Rozwoju Humanistyki</a>
									</div>
									<div class="accordion__item">
										+48 (22) 52 92 368<br>
										+48 (22) 52 92 358<br>
										+48 (22) 50 17 107
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >Program Ministra: Filozofia</a>
									</div>
									<div class="accordion__item">
										+48 (22) 52 92 368<br>
										+48 (22) 52 92 358<br>
										+48 (22) 50 17 107<br>
										+48 (22) 52 92 349
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >wniosek o przyznanie stypendium naukowego dla wybitnego młodego naukowca</a>
									</div>
									<div class="accordion__item">
										+48 (22) 52 92 427
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >Rozwój Sportu Akademickiego</a>
									</div>
									<div class="accordion__item">
										+48 (22) 50 17 107
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >wniosek o finansowanie działalności upowszechniającej naukę</a>
									</div>
									<div class="accordion__item">
										drogą mailową pod adresem: <a href="mailto:pytania.dun@mnisw.gov.pl">pytania.dun@mnisw.gov.pl</a>
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >Granty na granty: promocja jakości</a>
									</div>
									<div class="accordion__item">
										+48 (22) 50 17 150
									</div>

								</div>
								<div class="font-20 font-slim push-20">Departament Innowacji i Rozwoju</div>
								<div class="accordion">
									<div class="accordion__trigger">
										<a href="javascript:;" >Premia na Horyzoncie</a>
									</div>
									<div class="accordion__item">
										drogą mailową: <a href="mailto:premianahoryzoncie@nauka.gov.pl">premianahoryzoncie@nauka.gov.pl</a><br><br>
										lub telefonicznie:<br>
										+48 (22) 52 92 246<br>
										+48 (22) 52 92 645
									</div>
									<div class="accordion__trigger">
										<a href="javascript:;" >wnioski o finansowanie kosztów wkładu krajowego na rzecz udziału w programie międzynarodowym:
											telefonicznie</a>
									</div>
									<div class="accordion__item">
										+48 (22) 52 92 271<br>
										+48 (22) 52 92 270<br><br>
										lub drogą mailową:
										<a href="mailto:michal.rybinski@nauka.gov.pl">michal.rybinski@nauka.gov.pl</a>
										<a href="mailto:konrad.debski@nauka.gov.pl">konrad.debski@nauka.gov.pl</a>
									</div>
								</div>


							</div><!-- layout-table__cell -->
							<div id="info_NCBR" class="layout-table__cell -width-1/3  module -sm -border-right">
								<div class="push-20">
									<img class="module -sm  column__logo" src="/app/osf3/layout/assets/img/ncbr.svg" alt="" />
								</div>
								<div class="font-20 font-slim push-20">Kontakt w sprawach:</div>
								<div class="hiddenReadable">rozwiń sekcję klikając w nagłówek</div>
								<div class="accordion">

									<div class="accordion__trigger">
										<a href="javascript:;" >wniosków o dofinansowanie projektów w ramach Programu CyberSecIdent Cyberbezpieczeństwo i e-Tożsamość</a>
									</div>
									<div class="accordion__item">
										informacje i dokumentacja związana z programem:<br><a href="http://www.ncbr.gov.pl/programy-krajowe/cybersecident/">http://www.ncbr.gov.pl/programy-krajowe/cybersecident/</a><br><br>
										kontakt:<br><a href="http://www.ncbr.gov.pl/programy-krajowe/cybersecident/kontakt/">http://www.ncbr.gov.pl/programy-krajowe/cybersecident/kontakt/</a>
									</div>

									<div class="accordion__trigger">
										<a href="javascript:;" >wniosków o finansowanie wykonania projektów realizowanych na rzecz obronności i bezpieczeństwa państwa</a>
									</div>
									<div class="accordion__item">
										Jeżeli masz pytanie zadaj je mailowo:<br><a href="mailto:dobr@ncbr.gov.pl">dobr@ncbr.gov.pl</a>
									</div>

									<div class="accordion__trigger">
										<a href="javascript:;" >wniosków o dofinansowanie w ramach strategicznego programu badań naukowych i prac rozwojowych "Środowisko naturalne, rolnictwo i leśnictwo BIOSTRATEG"</a>
									</div>
									<div class="accordion__item">
										W pierwszej kolejności sprawdź, czy ktoś już zadał takie pytanie odwiedzając stronę:<br>
										<a href="http://www.ncbir.pl/programy-strategiczne/srodowisko-naturalne-rolnictwo-i-lesnictwo---biostrateg/">http://www.ncbir.pl/programy-strategiczne/srodowisko-naturalne-rolnictwo-i-lesnictwo---biostrateg/</a><br><br>
										Jeżeli nie możesz znaleźć odpowiedzi na swoje pytanie zadaj je mailowo:<br><a href="mailto:biostrateg@ncbr.gov.pl">biostrateg@ncbr.gov.pl</a><br><br>
										Jeżeli i to zawiodło, zadzwoń:<br>
										+ 48 22 39 07 470<br>
										+ 48 22 39 07 491<br>
										+ 48 22 39 07 127
									</div>

								</div>



							</div><!-- layout-table__cell -->
							<div id="info_NCN" class="layout-table__cell -width-1/3  module -sm">
								<div class="push-20 column__logo">
									<img class="module -sm" src="/app/osf3/layout/assets/img/ncn.svg" alt="" />
								</div>

								<div class="font-20 font-slim">Kontakt w sprawach:</div>
								<div class="font-14 push-in-15 module -md">

									<p>– wniosków badawczych z zakresu badań podstawowych</p>
									<p>– projektów międzynarodowych niewspółfinansowanych</p>
									<ol  class="-numeric push-in-15">
										<li> poszukaj odpowiedzi w sekcji „Najczęściej zadawane pytania” <br>
											<a href="http://www.ncn.gov.pl/finansowanie-nauki/faq">na stronie</a>
										</li>
										<li> jeśli nie znalazłeś interesujących Cię informacji, napisz na adres: <a href="mailto:biuro@ncn.gov.pl">biuro@ncn.gov.pl</a>
										</li>
										<li> jeśli nadal masz pytania, skontaktuj się z odpowiednim pracownikiem NCN, postępując według instrukcji  <a href="http://www.ncn.gov.pl/kontakt">na stronie</a>
										</li>
									</ol>





								</div><!-- layout-table__cell -->


							</div>  <!-- layout-table -->


						</div><!-- padding -->
					</div>


				</div><!-- wrapper -->

			</div><!-- main -->

		</div>

		<hr />
		<div class="main module -lg -tom">
			<div class="wrapper ">




				<div class="layout-table" id="ue">
					<div class="layout-table__cell -width-20 module -sm">
						<img class="footer__logo  -text-left" src="/app/osf3/layout/assets/img/ig.svg" alt="Logo Innowacyjna Gospodarka" />
					</div>
					<div class="layout-table__cell -width-60 -text-center">
						<p class="font-30 color-opi -text-center -padding-top-20">
                                <span class="opi-link -pointer"  onClick="location.href='https://www.opi.org.pl';">
                                    <em class="icon-opi-logo"></em>
                                </span>
						</p>
					</div>
					<div class="layout-table__cell -width-20 module -sm -text-right">
						<img class="-inline footer__logo2" src="/app/osf3/layout/assets/img/ue.svg"  alt="Logo Unia Europejska" />
					</div>
				</div>
				<p  class="font-12 color-gamma push-20 -text-center">Projekt ZSUN współfinansowany ze środków Europejskiego Funduszu Rozwoju Regionalnego w ramach Programu Operacyjnego Polska Cyfrowa
				</p>
				<p class="font-12 color-gamma push-20 -text-center">
					System OSF został zaprojektowany i wykonany oraz jest utrzymywany i administrowany przez Ośrodek Przetwarzania Informacji - Państwowy Instytut Badawczy w
					Warszawie zgodnie z wymaganiami określanymi przez MNiSW, NCN i NCBiR. W latach 2011- 2015 współfinansowany ze środków Programu Innowacyjna Gospodarka.
				</p>
				<p class="font-10 color-gamma push-20 -text-center">
					System ZSUN/OSF jest zoptymalizowany dla przeglądarek: <script type="text/javascript">document.write(jsfGetBrowsersInfo3().join(', '));</script> oraz ich nowszych wersji.<br>
					Logo systemu OSF przedstawia signed planar graph,
					grafikę dostępną na www.wikidot.com na licencji CC-BY-SA 3.0.<br>
					Build: 2018-12-14 14:26:31 CET<span class="-margin-left-20">Revision: <span id="revision" title="4d70e4588508c4f413bab5008a52723bdbf70970">4d70e4588508</span></span><span class="-margin-left-20">Node: Osf2Node-9</span>
				</p>
				<hr />
				<p class="font-12 color-beta push-20 -text-center">
					Copyright © 2005 - 2018
				</p>




			</div><!-- wrapper -->

		</div><!-- main -->
	</div>

</div>
<!--/ layout-fluid-->
<div class="modal" id="cookies-modal" style="display: none;">
    <div class="modal__content">
        <div class="modal__header">
            <div class="modal__close -pointer" id="cookies"><em class="icon-close"></em></div>
            <div class="modal__title">Cookies w ZSUN/OSF</div>
        </div>
        <hr/>
        <div class="modal__body">
            System ZSUN/OSF wykorzystuje dwa rodzaje „ciasteczek” (plików cookies):<br><br>
            <ol class="-numeric font-14 push-in-15 push-15">
                <li> tzw. identyfikator sesji użytkownika, czyli informację o tym, że użytkownik podał prawidłowy login
                    i hasło; informacja ta jest konieczna do prawidłowego działania serwisu - ewentualne wyłączenie
                    obsługi „ciasteczek” w przeglądarce uniemożliwi zalogowanie się do systemu;
                </li>
                <li> przechowujące pomocnicze ustawienia robocze (techniczne) użytkownika, takie jak numer aktualnego
                    rekordu w zestawieniu (liście), układ obiektów na danej stronie (żeby móc go szybko odtworzyć po
                    przeładowaniu strony) itp.
                </li>
            </ol>
            <p class="font-12">
                W żadnym przypadku „ciasteczka” te nie zawierają informacji, które mogłyby być wykorzystane do
                identyfikacji użytkownika ani badania jego zachowań w Internecie.
                Po zakończeniu pracy (po wylogowaniu się) można je skasować i nie będzie to miało wpływu na ewentualne
                kolejne sesje w systemie ZSUN/OSF.
            </p>
        </div>
    </div>
</div>

    

</main>
		<script src="/app/osf3/layout/assets/js/function.js?v=5274995228900373381"></script>
		<script src="/app/opicore/js/our/end.js?v=5274995228900373381" type="text/javascript"></script>
		


















	</body>
</html>


