<!DOCTYPE html>
<html lang="cs">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Jenny Nails — Karlovy Vary</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --gold:#C9A96E;
  --gold2:#E8D5B0;
  --dark:#0A0805;
  --dark2:#12100D;
  --dark3:#1C1915;
  --cream:#F5EDD8;
  --text:#C8BEA8;
  --white:#FDFAF4;
}

html{scroll-behavior:smooth}
body{background:var(--dark);color:var(--text);font-family:'DM Sans',sans-serif;overflow-x:hidden;cursor:none}

/* CUSTOM CURSOR */
.cursor{position:fixed;width:8px;height:8px;background:var(--gold);border-radius:50%;pointer-events:none;z-index:9999;transform:translate(-50%,-50%);transition:transform .1s}
.cursor-ring{position:fixed;width:36px;height:36px;border:1px solid rgba(201,169,110,.4);border-radius:50%;pointer-events:none;z-index:9998;transform:translate(-50%,-50%);transition:transform .15s,width .3s,height .3s,opacity .3s}
.cursor-ring.active{width:60px;height:60px;opacity:.5}

/* LOADER */
#loader{position:fixed;inset:0;background:var(--dark);z-index:9000;display:flex;align-items:center;justify-content:center;flex-direction:column;gap:2rem}
.loader-logo{font-family:'Cormorant Garamond',serif;font-size:clamp(3rem,8vw,7rem);color:var(--gold);letter-spacing:.15em;opacity:0;animation:fadeUp 1s ease .3s forwards}
.loader-line{width:0;height:1px;background:linear-gradient(90deg,transparent,var(--gold),transparent);animation:lineGrow 1.2s ease .8s forwards}
.loader-sub{font-size:.75rem;letter-spacing:.4em;text-transform:uppercase;color:var(--text);opacity:0;animation:fadeUp .8s ease 1.4s forwards}
.loader-progress{position:absolute;bottom:0;left:0;height:2px;background:var(--gold);animation:progress 2.2s ease forwards}

@keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
@keyframes lineGrow{to{width:300px}}
@keyframes progress{to{width:100%}}

/* NAV */
nav{position:fixed;top:0;width:100%;z-index:100;padding:1.5rem 4rem;display:flex;align-items:center;justify-content:space-between;transition:all .4s}
nav.scrolled{background:rgba(10,8,5,.92);backdrop-filter:blur(20px);padding:1rem 4rem;border-bottom:1px solid rgba(201,169,110,.1)}
.nav-logo{font-family:'Cormorant Garamond',serif;font-size:1.6rem;color:var(--gold);letter-spacing:.15em;text-decoration:none}
.nav-links{display:flex;gap:2.5rem;list-style:none;align-items:center}
.nav-links a{color:var(--text);text-decoration:none;font-size:.8rem;letter-spacing:.15em;text-transform:uppercase;transition:color .3s;position:relative}
.nav-links a::after{content:'';position:absolute;bottom:-4px;left:0;width:0;height:1px;background:var(--gold);transition:width .3s}
.nav-links a:hover{color:var(--gold)}
.nav-links a:hover::after{width:100%}
.lang-switch{display:flex;gap:.5rem}
.lang-btn{background:none;border:1px solid rgba(201,169,110,.3);color:var(--text);padding:.3rem .7rem;font-size:.7rem;letter-spacing:.1em;text-transform:uppercase;cursor:none;transition:all .3s;border-radius:2px;font-family:'DM Sans',sans-serif}
.lang-btn.active,.lang-btn:hover{background:var(--gold);color:var(--dark);border-color:var(--gold)}
.nav-burger{display:none;flex-direction:column;gap:5px;cursor:none;background:none;border:none;padding:.5rem}
.nav-burger span{width:24px;height:1px;background:var(--gold);display:block;transition:all .3s}
.mobile-menu{display:none;position:fixed;inset:0;background:var(--dark);z-index:90;flex-direction:column;align-items:center;justify-content:center;gap:2.5rem;opacity:0;transition:opacity .4s}
.mobile-menu.open{opacity:1}
.mobile-menu a{font-family:'Cormorant Garamond',serif;font-size:2.5rem;color:var(--cream);text-decoration:none;letter-spacing:.1em}

/* HERO */
#hero{height:100vh;display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden}
.hero-bg{position:absolute;inset:0;background:radial-gradient(ellipse at 30% 60%, rgba(201,169,110,.06) 0%, transparent 60%), radial-gradient(ellipse at 70% 20%, rgba(201,169,110,.04) 0%, transparent 50%)}
.hero-particles{position:absolute;inset:0;overflow:hidden}
.particle{position:absolute;width:1px;height:1px;background:var(--gold);border-radius:50%;animation:float linear infinite;opacity:0}
@keyframes float{0%{transform:translateY(100vh) translateX(0);opacity:0}10%{opacity:.6}90%{opacity:.4}100%{transform:translateY(-10vh) translateX(var(--drift));opacity:0}}
.hero-lines{position:absolute;inset:0;overflow:hidden}
.h-line{position:absolute;background:linear-gradient(180deg,transparent,rgba(201,169,110,.08),transparent);width:1px;animation:lineFloat 8s ease-in-out infinite}
.hero-content{text-align:center;z-index:2;padding:0 1rem}
.hero-eyebrow{font-size:.7rem;letter-spacing:.5em;text-transform:uppercase;color:var(--gold);opacity:0;animation:fadeUp 1s ease 2.5s forwards;margin-bottom:1.5rem;display:block}
.hero-title{font-family:'Cormorant Garamond',serif;font-size:clamp(4rem,10vw,10rem);font-weight:300;line-height:.9;color:var(--cream);opacity:0;animation:fadeUp 1s ease 2.7s forwards;letter-spacing:-.01em}
.hero-title em{font-style:italic;color:var(--gold)}
.hero-sep{width:60px;height:1px;background:linear-gradient(90deg,transparent,var(--gold),transparent);margin:2rem auto;opacity:0;animation:fadeUp .8s ease 3s forwards}
.hero-sub{font-size:clamp(.85rem,2vw,1.1rem);color:var(--text);letter-spacing:.1em;opacity:0;animation:fadeUp .8s ease 3.1s forwards;line-height:1.8}
.hero-cta{margin-top:3rem;opacity:0;animation:fadeUp .8s ease 3.3s forwards;display:flex;gap:1.5rem;justify-content:center;flex-wrap:wrap}
.btn-primary{padding:1rem 2.5rem;background:var(--gold);color:var(--dark);font-size:.8rem;letter-spacing:.2em;text-transform:uppercase;text-decoration:none;font-weight:500;transition:all .3s;position:relative;overflow:hidden}
.btn-primary::before{content:'';position:absolute;inset:0;background:var(--cream);transform:translateX(-101%);transition:transform .4s ease}
.btn-primary:hover::before{transform:translateX(0)}
.btn-primary:hover{color:var(--dark)}
.btn-primary span{position:relative;z-index:1}
.btn-outline{padding:1rem 2.5rem;border:1px solid rgba(201,169,110,.5);color:var(--gold);font-size:.8rem;letter-spacing:.2em;text-transform:uppercase;text-decoration:none;transition:all .3s}
.btn-outline:hover{border-color:var(--gold);background:rgba(201,169,110,.08)}
.hero-scroll{position:absolute;bottom:2.5rem;left:50%;transform:translateX(-50%);display:flex;flex-direction:column;align-items:center;gap:.8rem;opacity:0;animation:fadeUp .8s ease 3.5s forwards}
.scroll-line{width:1px;height:60px;background:linear-gradient(180deg,var(--gold),transparent);animation:scrollPulse 2s ease-in-out infinite}
@keyframes scrollPulse{0%,100%{opacity:.3;transform:scaleY(1)}50%{opacity:1;transform:scaleY(1.1)}}
.scroll-text{font-size:.65rem;letter-spacing:.3em;text-transform:uppercase;color:var(--text)}

/* SECTIONS COMMON */
section{padding:7rem 0}
.container{max-width:1200px;margin:0 auto;padding:0 4rem}
.section-eyebrow{font-size:.65rem;letter-spacing:.5em;text-transform:uppercase;color:var(--gold);display:block;margin-bottom:1rem}
.section-title{font-family:'Cormorant Garamond',serif;font-size:clamp(2.5rem,5vw,4rem);font-weight:300;color:var(--cream);line-height:1.1;margin-bottom:2rem}
.section-title em{font-style:italic;color:var(--gold)}
.gold-line{width:40px;height:1px;background:var(--gold);margin-bottom:3rem}

/* ABOUT / INTRO */
#about{background:var(--dark2)}
.about-grid{display:grid;grid-template-columns:1fr 1fr;gap:6rem;align-items:center}
.about-visual{position:relative}
.about-img-frame{aspect-ratio:3/4;background:var(--dark3);border:1px solid rgba(201,169,110,.15);position:relative;overflow:hidden}
.about-img-inner{position:absolute;inset:12px;background:linear-gradient(135deg,var(--dark3),rgba(201,169,110,.06));display:flex;align-items:center;justify-content:center}
.about-icon-big{font-size:5rem;opacity:.15}
.about-badge{position:absolute;bottom:-1.5rem;right:-1.5rem;background:var(--gold);color:var(--dark);padding:1.5rem;text-align:center;width:120px;height:120px;display:flex;flex-direction:column;align-items:center;justify-content:center}
.badge-num{font-family:'Cormorant Garamond',serif;font-size:2.5rem;font-weight:300;line-height:1}
.badge-text{font-size:.6rem;letter-spacing:.15em;text-transform:uppercase;margin-top:.3rem}
.about-text p{line-height:1.9;margin-bottom:1.5rem;font-size:.95rem;color:var(--text)}
.about-stats{display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;margin-top:2.5rem}
.stat-item{border-left:1px solid rgba(201,169,110,.3);padding-left:1.2rem}
.stat-num{font-family:'Cormorant Garamond',serif;font-size:2.5rem;color:var(--gold);font-weight:300}
.stat-label{font-size:.72rem;letter-spacing:.15em;text-transform:uppercase;color:var(--text);margin-top:.2rem}

/* ADVANTAGES */
#advantages{background:var(--dark)}
.adv-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:2px;margin-top:4rem}
.adv-card{background:var(--dark2);padding:3rem 2.5rem;position:relative;overflow:hidden;transition:background .4s}
.adv-card::before{content:'';position:absolute;bottom:0;left:0;width:0;height:2px;background:var(--gold);transition:width .5s}
.adv-card:hover{background:var(--dark3)}
.adv-card:hover::before{width:100%}
.adv-num{font-family:'Cormorant Garamond',serif;font-size:4rem;color:rgba(201,169,110,.1);font-weight:300;position:absolute;top:1.5rem;right:2rem;line-height:1}
.adv-icon{font-size:1.8rem;margin-bottom:1.5rem;display:block}
.adv-title{font-family:'Cormorant Garamond',serif;font-size:1.5rem;color:var(--cream);margin-bottom:1rem;font-weight:400}
.adv-text{font-size:.85rem;line-height:1.8;color:var(--text)}

/* SERVICES */
#services{background:var(--dark2)}
.services-intro{display:grid;grid-template-columns:1fr 1.5fr;gap:6rem;margin-bottom:5rem;align-items:end}
.services-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:2px}
.svc-card{background:var(--dark);padding:3rem;position:relative;cursor:none;overflow:hidden;transition:all .4s;group:true}
.svc-card::after{content:'';position:absolute;inset:0;background:linear-gradient(135deg,rgba(201,169,110,.04),transparent);opacity:0;transition:opacity .4s}
.svc-card:hover::after{opacity:1}
.svc-card:hover{background:var(--dark3)}
.svc-img{width:100%;aspect-ratio:16/9;background:var(--dark2);border:1px solid rgba(201,169,110,.08);display:flex;align-items:center;justify-content:center;font-size:3rem;margin-bottom:2rem;position:relative;overflow:hidden}
.svc-img-shine{position:absolute;inset:0;background:linear-gradient(135deg,rgba(201,169,110,.03),transparent);transition:transform .6s}
.svc-card:hover .svc-img-shine{transform:translateX(100%)}
.svc-title{font-family:'Cormorant Garamond',serif;font-size:1.8rem;color:var(--cream);margin-bottom:.8rem;font-weight:400}
.svc-text{font-size:.85rem;line-height:1.8;color:var(--text);margin-bottom:1.5rem}
.svc-price{font-family:'Cormorant Garamond',serif;font-size:1.3rem;color:var(--gold)}
.svc-price-label{font-size:.7rem;letter-spacing:.2em;text-transform:uppercase;color:var(--text);margin-right:.5rem}

/* PORTFOLIO */
#portfolio{background:var(--dark)}
.portfolio-intro{max-width:600px;margin-bottom:4rem}
.gallery-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:2px}
.gallery-item{aspect-ratio:3/4;background:var(--dark2);position:relative;overflow:hidden;cursor:none}
.gallery-item:nth-child(1){grid-row:span 2}
.gallery-item:nth-child(5){grid-column:span 2;aspect-ratio:2/1}
.gallery-inner{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;font-size:3rem;background:linear-gradient(135deg,var(--dark2),var(--dark3));transition:transform .6s ease}
.gallery-overlay{position:absolute;inset:0;background:linear-gradient(180deg,transparent 40%,rgba(10,8,5,.9));opacity:0;transition:opacity .4s;display:flex;align-items:flex-end;padding:1.5rem}
.gallery-label{color:var(--gold);font-size:.75rem;letter-spacing:.2em;text-transform:uppercase;transform:translateY(10px);transition:transform .4s}
.gallery-item:hover .gallery-overlay{opacity:1}
.gallery-item:hover .gallery-label{transform:translateY(0)}
.gallery-item:hover .gallery-inner{transform:scale(1.05)}

/* MAP */
#location{background:var(--dark2)}
.location-grid{display:grid;grid-template-columns:1fr 1.5fr;gap:0;align-items:stretch}
.location-info{padding:4rem;background:var(--dark3);border:1px solid rgba(201,169,110,.08)}
.location-detail{display:flex;gap:1rem;margin-bottom:2rem;align-items:flex-start}
.detail-icon{color:var(--gold);font-size:1rem;margin-top:.2rem;flex-shrink:0}
.detail-label{font-size:.65rem;letter-spacing:.25em;text-transform:uppercase;color:var(--gold);margin-bottom:.3rem}
.detail-value{font-size:.95rem;color:var(--cream);line-height:1.6}
.map-wrap{position:relative}
.map-wrap iframe{display:block;width:100%;height:100%;min-height:500px;filter:grayscale(80%) sepia(20%) contrast(1.1) brightness(.85);border:none}
.map-wrap::before{content:'';position:absolute;inset:0;pointer-events:none;z-index:1;border:1px solid rgba(201,169,110,.1)}

/* FOOTER */
footer{background:var(--dark);border-top:1px solid rgba(201,169,110,.1);padding:3rem 0 2rem}
.footer-inner{display:grid;grid-template-columns:1fr 1fr 1fr;gap:3rem;margin-bottom:3rem}
.footer-logo{font-family:'Cormorant Garamond',serif;font-size:2rem;color:var(--gold);letter-spacing:.15em;margin-bottom:1rem;display:block}
.footer-tagline{font-size:.8rem;color:var(--text);line-height:1.8}
.footer-title{font-size:.65rem;letter-spacing:.35em;text-transform:uppercase;color:var(--gold);margin-bottom:1.2rem}
.footer-links{list-style:none;display:flex;flex-direction:column;gap:.6rem}
.footer-links a{color:var(--text);text-decoration:none;font-size:.85rem;transition:color .3s}
.footer-links a:hover{color:var(--gold)}
.footer-bottom{border-top:1px solid rgba(201,169,110,.08);padding-top:1.5rem;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:1rem}
.footer-copy{font-size:.75rem;color:rgba(200,190,168,.4);letter-spacing:.05em}

/* REVEAL ANIMATIONS */
.reveal{opacity:0;transform:translateY(40px);transition:opacity .8s ease,transform .8s ease}
.reveal.visible{opacity:1;transform:translateY(0)}
.reveal-left{opacity:0;transform:translateX(-40px);transition:opacity .8s ease,transform .8s ease}
.reveal-left.visible{opacity:1;transform:translateX(0)}
.reveal-right{opacity:0;transform:translateX(40px);transition:opacity .8s ease,transform .8s ease}
.reveal-right.visible{opacity:1;transform:translateX(0)}

/* DIVIDER */
.ornament{text-align:center;margin:2rem 0;color:rgba(201,169,110,.3);font-family:'Cormorant Garamond',serif;font-size:1.5rem;letter-spacing:.5em}

/* RESPONSIVE */
@media(max-width:1024px){
  .container{padding:0 2.5rem}
  nav{padding:1.5rem 2.5rem}
  nav.scrolled{padding:1rem 2.5rem}
  .about-grid,.services-intro,.location-grid{grid-template-columns:1fr}
  .adv-grid{grid-template-columns:1fr 1fr}
  .gallery-grid{grid-template-columns:1fr 1fr}
  .gallery-item:nth-child(1){grid-row:span 1}
  .gallery-item:nth-child(5){grid-column:span 1;aspect-ratio:3/4}
  .about-badge{bottom:-1rem;right:0}
  .footer-inner{grid-template-columns:1fr 1fr}
}
@media(max-width:768px){
  nav{padding:1.2rem 1.5rem}
  nav.scrolled{padding:.8rem 1.5rem}
  .nav-links{display:none}
  .lang-switch{display:none}
  .nav-burger{display:flex}
  .mobile-menu{display:flex}
  section{padding:5rem 0}
  .container{padding:0 1.5rem}
  .adv-grid{grid-template-columns:1fr}
  .services-grid{grid-template-columns:1fr}
  .gallery-grid{grid-template-columns:1fr 1fr}
  .footer-inner{grid-template-columns:1fr}
  .footer-bottom{flex-direction:column;text-align:center}
  .about-stats{grid-template-columns:1fr 1fr}
  .hero-cta{flex-direction:column;align-items:center}
}
@media(max-width:480px){
  .gallery-grid{grid-template-columns:1fr}
  .gallery-item:nth-child(5){grid-column:span 1}
}
</style>
</head>
<body>

<!-- CURSOR -->
<div class="cursor" id="cursor"></div>
<div class="cursor-ring" id="cursorRing"></div>

<!-- LOADER -->
<div id="loader">
  <div style="text-align:center">
    <div class="loader-logo">Jenny Nails</div>
    <div class="loader-line"></div>
    <div class="loader-sub" data-cs="Nail Studio · Karlovy Vary" data-en="Nail Studio · Karlovy Vary" data-de="Nail Studio · Karlsbad" data-ru="Nail Studio · Карловы Вары">Nail Studio · Karlovy Vary</div>
  </div>
  <div class="loader-progress"></div>
</div>

<!-- NAV -->
<nav id="navbar">
  <a href="#hero" class="nav-logo">Jenny Nails</a>
  <ul class="nav-links">
    <li><a href="#about" data-cs="O nás" data-en="About" data-de="Über uns" data-ru="О нас">O nás</a></li>
    <li><a href="#advantages" data-cs="Výhody" data-en="Why us" data-de="Vorteile" data-ru="Преимущества">Výhody</a></li>
    <li><a href="#services" data-cs="Služby" data-en="Services" data-de="Leistungen" data-ru="Услуги">Služby</a></li>
    <li><a href="#portfolio" data-cs="Galerie" data-en="Gallery" data-de="Galerie" data-ru="Галерея">Galerie</a></li>
    <li><a href="#location" data-cs="Kontakt" data-en="Contact" data-de="Kontakt" data-ru="Контакт">Kontakt</a></li>
  </ul>
  <div class="lang-switch">
    <button class="lang-btn active" data-lang="cs">CS</button>
    <button class="lang-btn" data-lang="en">EN</button>
    <button class="lang-btn" data-lang="de">DE</button>
    <button class="lang-btn" data-lang="ru">RU</button>
  </div>
  <button class="nav-burger" id="burger" aria-label="Menu">
    <span></span><span></span><span></span>
  </button>
</nav>

<!-- MOBILE MENU -->
<div class="mobile-menu" id="mobileMenu">
  <a href="#about" data-cs="O nás" data-en="About" data-de="Über uns" data-ru="О нас">O nás</a>
  <a href="#advantages" data-cs="Výhody" data-en="Why us" data-de="Vorteile" data-ru="Преimущества">Výhody</a>
  <a href="#services" data-cs="Služby" data-en="Services" data-de="Leistungen" data-ru="Услуги">Služby</a>
  <a href="#portfolio" data-cs="Galerie" data-en="Gallery" data-de="Galerie" data-ru="Галерея">Galerie</a>
  <a href="#location" data-cs="Kontakt" data-en="Contact" data-de="Kontakt" data-ru="Контакт">Kontakt</a>
  <div class="lang-switch" style="margin-top:1rem">
    <button class="lang-btn active" data-lang="cs">CS</button>
    <button class="lang-btn" data-lang="en">EN</button>
    <button class="lang-btn" data-lang="de">DE</button>
    <button class="lang-btn" data-lang="ru">RU</button>
  </div>
</div>

<!-- HERO -->
<section id="hero">
  <div class="hero-bg"></div>
  <div class="hero-particles" id="particles"></div>
  <div class="hero-lines" id="heroLines"></div>
  <div class="hero-content">
    <span class="hero-eyebrow" data-cs="Nail Studio v Karlových Varech" data-en="Nail Studio in Karlovy Vary" data-de="Nail Studio in Karlsbad" data-ru="Nail Studio в Карловых Варах">Nail Studio v Karlových Varech</span>
    <h1 class="hero-title"><em>Jenny</em><br>Nails</h1>
    <div class="hero-sep"></div>
    <p class="hero-sub" data-cs="Profesionální péče o nehty · Manikúra · Pedikúra<br>Sokolovská 299/42, Rybáře, Karlovy Vary" data-en="Professional nail care · Manicure · Pedicure<br>Sokolovská 299/42, Rybáře, Karlovy Vary" data-de="Professionelle Nagelpflege · Maniküre · Pediküre<br>Sokolovská 299/42, Rybáře, Karlsbad" data-ru="Профессиональный уход за ногтями · Маникюр · Педикюр<br>Sokolovská 299/42, Rybáře, Karlovy Vary">Profesionální péče o nehty · Manikúra · Pedikúra<br>Sokolovská 299/42, Rybáře, Karlovy Vary</p>
    <div class="hero-cta">
      <a href="#services" class="btn-primary"><span data-cs="Naše služby" data-en="Our Services" data-de="Unsere Leistungen" data-ru="Наши услуги">Naše služby</span></a>
      <a href="#location" class="btn-outline" data-cs="Rezervace" data-en="Book Now" data-de="Buchen" data-ru="Записаться">Rezervace</a>
    </div>
  </div>
  <div class="hero-scroll">
    <span class="scroll-text" data-cs="Přejít dolů" data-en="Scroll" data-de="Scrollen" data-ru="Листать">Přejít dolů</span>
    <div class="scroll-line"></div>
  </div>
</section>

<!-- ABOUT -->
<section id="about">
  <div class="container">
    <div class="about-grid">
      <div class="about-visual reveal-left">
        <div class="about-img-frame">
          <div class="about-img-inner">
            <span style="font-size:6rem;opacity:.12">💅</span>
          </div>
        </div>
        <div class="about-badge">
          <div class="badge-num">5★</div>
          <div class="badge-text" data-cs="Hodnocení" data-en="Rating" data-de="Bewertung" data-ru="Рейтинг">Hodnocení</div>
        </div>
      </div>
      <div class="about-text reveal-right">
        <span class="section-eyebrow" data-cs="Náš příběh" data-en="Our Story" data-de="Unsere Geschichte" data-ru="Наша история">Náš příběh</span>
        <h2 class="section-title" data-cs="Krása v každém <em>detailu</em>" data-en="Beauty in every <em>detail</em>" data-de="Schönheit in jedem <em>Detail</em>" data-ru="Красота в каждой <em>детали</em>">Krása v každém <em>detailu</em></h2>
        <div class="gold-line"></div>
        <p data-cs="Jenny Nails je prémiové nail studio v samém srdci Karlových Varů. Nabízíme profesionální péči o nehty s důrazem na kvalitu, hygienu a individuální přístup ke každé klientce." data-en="Jenny Nails is a premium nail studio in the heart of Karlovy Vary. We offer professional nail care with a focus on quality, hygiene and individual approach to every client." data-de="Jenny Nails ist ein Premium Nail Studio im Herzen von Karlsbad. Wir bieten professionelle Nagelpflege mit Fokus auf Qualität, Hygiene und individuelle Betreuung." data-ru="Jenny Nails — это премиальная студия ногтевого сервиса в самом сердце Карловых Вар. Мы предлагаем профессиональный уход с акцентом на качество, гигиену и индивидуальный подход.">Jenny Nails je prémiové nail studio v samém srdci Karlových Varů. Nabízíme profesionální péči o nehty s důrazem na kvalitu, hygienu a individuální přístup ke každé klientce.</p>
        <p data-cs="Používáme pouze certifikované produkty prémiových značek. Každý zákrok je prováděn s maximální péčí a přesností — aby výsledek byl přesně takový, jaký si přejete." data-en="We use only certified premium brand products. Every procedure is performed with maximum care and precision — so the result is exactly as you desire." data-de="Wir verwenden nur zertifizierte Produkte von Premiummarken. Jede Behandlung wird mit größter Sorgfalt durchgeführt — damit das Ergebnis genau Ihren Wünschen entspricht." data-ru="Мы используем только сертифицированные продукты премиальных брендов. Каждая процедура выполняется с максимальной заботой и точностью — чтобы результат был именно таким, каким вы его хотите.">Používáme pouze certifikované produkty prémiových značek. Každý zákrok je prováděn s maximální péčí a přesností — aby výsledek byl přesně takový, jaký si přejete.</p>
        <div class="about-stats">
          <div class="stat-item">
            <div class="stat-num">500+</div>
            <div class="stat-label" data-cs="Spokojených klientek" data-en="Happy clients" data-de="Zufriedene Kunden" data-ru="Довольных клиентов">Spokojených klientek</div>
          </div>
          <div class="stat-item">
            <div class="stat-num">100%</div>
            <div class="stat-label" data-cs="Prémiové produkty" data-en="Premium products" data-de="Premium Produkte" data-ru="Премиум продукты">Prémiové produkty</div>
          </div>
          <div class="stat-item">
            <div class="stat-num">∞</div>
            <div class="stat-label" data-cs="Kreativních návrhů" data-en="Creative designs" data-de="Kreative Designs" data-ru="Творческих дизайнов">Kreativních návrhů</div>
          </div>
          <div class="stat-item">
            <div class="stat-num">1</div>
            <div class="stat-label" data-cs="Místo v Karlových Varech" data-en="Location in Karlovy Vary" data-de="Standort in Karlsbad" data-ru="Адрес в Карловых Варах">Místo v Karlových Varech</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ADVANTAGES -->
<section id="advantages">
  <div class="container">
    <div style="max-width:600px" class="reveal">
      <span class="section-eyebrow" data-cs="Proč si vybrat nás" data-en="Why choose us" data-de="Warum wir" data-ru="Почему мы">Proč si vybrat nás</span>
      <h2 class="section-title" data-cs="Naše <em>výhody</em>" data-en="Our <em>advantages</em>" data-de="Unsere <em>Vorteile</em>" data-ru="Наши <em>преимущества</em>">Naše <em>výhody</em></h2>
      <div class="gold-line"></div>
    </div>
    <div class="adv-grid">
      <div class="adv-card reveal" style="transition-delay:.1s">
        <span class="adv-num">01</span>
        <span class="adv-icon">✦</span>
        <div class="adv-title" data-cs="Prémiová kvalita" data-en="Premium Quality" data-de="Premium Qualität" data-ru="Премиум качество">Prémiová kvalita</div>
        <div class="adv-text" data-cs="Pracujeme výhradně s certifikovanými gely, laky a pomůckami od renomovaných výrobců. Žádné kompromisy — jen to nejlepší." data-en="We work exclusively with certified gels, polishes and tools from renowned manufacturers. No compromises — only the best." data-de="Wir arbeiten ausschließlich mit zertifizierten Gelen, Lacken und Werkzeugen renommierter Hersteller. Keine Kompromisse — nur das Beste." data-ru="Мы работаем исключительно с сертифицированными гелями, лаками и инструментами от известных производителей. Никаких компромиссов — только лучшее.">Pracujeme výhradně s certifikovanými gely, laky a pomůckami od renomovaných výrobců. Žádné kompromisy — jen to nejlepší.</div>
      </div>
      <div class="adv-card reveal" style="transition-delay:.2s">
        <span class="adv-num">02</span>
        <span class="adv-icon">◈</span>
        <div class="adv-title" data-cs="Maximální hygiena" data-en="Maximum Hygiene" data-de="Maximale Hygiene" data-ru="Максимальная гигиена">Maximální hygiena</div>
        <div class="adv-text" data-cs="Veškeré nástroje jsou sterilizovány po každém použití. Vaše bezpečnost a zdraví jsou pro nás na prvním místě." data-en="All tools are sterilized after each use. Your safety and health are our top priority." data-de="Alle Werkzeuge werden nach jeder Verwendung sterilisiert. Ihre Sicherheit und Gesundheit haben für uns höchste Priorität." data-ru="Все инструменты стерилизуются после каждого использования. Ваша безопасность и здоровье — наш главный приоритет.">Veškeré nástroje jsou sterilizovány po každém použití. Vaše bezpečnost a zdraví jsou pro nás na prvním místě.</div>
      </div>
      <div class="adv-card reveal" style="transition-delay:.3s">
        <span class="adv-num">03</span>
        <span class="adv-icon">❋</span>
        <div class="adv-title" data-cs="Individuální přístup" data-en="Individual Approach" data-de="Individueller Ansatz" data-ru="Индивидуальный подход">Individuální přístup</div>
        <div class="adv-text" data-cs="Každá klientka je jedinečná. Přizpůsobíme návrh, tvar i barvu přesně vašemu přání a životnímu stylu." data-en="Every client is unique. We will tailor the design, shape and color exactly to your wishes and lifestyle." data-de="Jede Kundin ist einzigartig. Wir passen Design, Form und Farbe genau Ihren Wünschen und Ihrem Lebensstil an." data-ru="Каждая клиентка уникальна. Мы подберём дизайн, форму и цвет именно под ваши пожелания и образ жизни.">Každá klientka je jedinečná. Přizpůsobíme návrh, tvar i barvu přesně vašemu přání a životnímu stylu.</div>
      </div>
      <div class="adv-card reveal" style="transition-delay:.4s">
        <span class="adv-num">04</span>
        <span class="adv-icon">◇</span>
        <div class="adv-title" data-cs="Profesionální tým" data-en="Professional Team" data-de="Professionelles Team" data-ru="Профессиональная команда">Profesionální tým</div>
        <div class="adv-text" data-cs="Naše specialistky pravidelně absolvují školení a sledují nejnovější trendy v nail art, abyste vždy dostaly to nejmodernější." data-en="Our specialists regularly attend training and follow the latest nail art trends so you always get the most modern look." data-de="Unsere Spezialistinnen absolvieren regelmäßig Schulungen und verfolgen die neuesten Nail-Art-Trends." data-ru="Наши специалисты регулярно проходят обучение и следят за последними трендами в nail art, чтобы вы всегда получали самое современное.">Naše specialistky pravidelně absolvují školení a sledují nejnovější trendy v nail art, abyste vždy dostaly to nejmodernější.</div>
      </div>
      <div class="adv-card reveal" style="transition-delay:.5s">
        <span class="adv-num">05</span>
        <span class="adv-icon">✧</span>
        <div class="adv-title" data-cs="Příjemná atmosféra" data-en="Pleasant Atmosphere" data-de="Angenehme Atmosphäre" data-ru="Приятная атмосфера">Příjemná atmosféra</div>
        <div class="adv-text" data-cs="Studio je navrženo tak, abyste se cítily pohodlně a mohly si plně vychutnat chvíle pro sebe. Relax a krása v jednom." data-en="The studio is designed so that you feel comfortable and can fully enjoy your personal moments. Relaxation and beauty in one." data-de="Das Studio ist so gestaltet, dass Sie sich wohl fühlen und die Zeit für sich genießen können. Entspannung und Schönheit in einem." data-ru="Студия создана так, чтобы вы чувствовали себя комфортно и могли в полной мере насладиться временем для себя. Релакс и красота в одном.">Studio je navrženo tak, abyste se cítily pohodlně a mohly si plně vychutnat chvíle pro sebe. Relax a krása v jednom.</div>
      </div>
      <div class="adv-card reveal" style="transition-delay:.6s">
        <span class="adv-num">06</span>
        <span class="adv-icon">⬡</span>
        <div class="adv-title" data-cs="Skvělá dostupnost" data-en="Great Accessibility" data-de="Gute Erreichbarkeit" data-ru="Отличная доступность">Skvělá dostupnost</div>
        <div class="adv-text" data-cs="Jsme snadno dostupní v centru Karlových Varů, poblíž zastávek MHD. Parkování v okolí je bez problémů." data-en="We are easily accessible in the center of Karlovy Vary, near public transport stops. Parking in the area is easy." data-de="Wir sind leicht erreichbar im Zentrum von Karlsbad, in der Nähe von öffentlichen Verkehrsmitteln." data-ru="Мы легко доступны в центре Карловых Вар, вблизи остановок общественного транспорта. Парковка поблизости без проблем.">Jsme snadno dostupní v centru Karlových Varů, poblíž zastávek MHD. Parkování v okolí je bez problémů.</div>
      </div>
    </div>
  </div>
</section>

<!-- SERVICES -->
<section id="services">
  <div class="container">
    <div class="services-intro">
      <div class="reveal">
        <span class="section-eyebrow" data-cs="Naše služby" data-en="Our Services" data-de="Unsere Leistungen" data-ru="Наши услуги">Naše služby</span>
        <h2 class="section-title" data-cs="Kompletní <em>péče</em> o nehty" data-en="Complete nail <em>care</em>" data-de="Komplette Nagel<em>pflege</em>" data-ru="Полный уход за <em>ногтями</em>">Kompletní <em>péče</em> o nehty</h2>
        <div class="gold-line"></div>
      </div>
      <div class="reveal" style="transition-delay:.2s">
        <p style="font-size:.95rem;line-height:1.9;color:var(--text)" data-cs="Od klasické manikúry po luxusní nail art — nabízíme kompletní spektrum služeb péče o nehty. Každý výkon provádíme s precizností a láskou k detailu." data-en="From classic manicure to luxurious nail art — we offer a complete spectrum of nail care services. Every procedure is performed with precision and love for detail." data-de="Von der klassischen Maniküre bis zum luxuriösen Nail Art — wir bieten ein komplettes Spektrum an Nagelpflegeservices. Jede Behandlung wird mit Präzision durchgeführt." data-ru="От классического маникюра до роскошного nail art — мы предлагаем полный спектр услуг по уходу за ногтями. Каждая процедура выполняется с точностью и любовью к деталям.">Od klasické manikúry po luxusní nail art — nabízíme kompletní spektrum služeb péče o nehty. Každý výkon provádíme s precizností a láskou k detailu.</p>
      </div>
    </div>
    <div class="services-grid">
      <div class="svc-card reveal" style="transition-delay:.1s">
        <div class="svc-img"><span>💅</span><div class="svc-img-shine"></div></div>
        <div class="svc-title" data-cs="Manikúra" data-en="Manicure" data-de="Maniküre" data-ru="Маникюр">Manikúra</div>
        <div class="svc-text" data-cs="Klasická i gelová manikúra, úprava nehtů, zábal, hydratace. Precizní péče pro zdravé a krásné nehty." data-en="Classic and gel manicure, nail shaping, wraps, hydration. Precise care for healthy and beautiful nails." data-de="Klassische und Gel-Maniküre, Nagelformung, Umhüllung, Hydratation. Präzise Pflege für gesunde und schöne Nägel." data-ru="Классический и гелевый маникюр, придание формы, обёртывание, увлажнение. Точный уход для здоровых и красивых ногтей.">Klasická i gelová manikúra, úprava nehtů, zábal, hydratace. Precizní péče pro zdravé a krásné nehty.</div>
        <div><span class="svc-price-label" data-cs="od" data-en="from" data-de="ab" data-ru="от">od</span><span class="svc-price">350 Kč</span></div>
      </div>
      <div class="svc-card reveal" style="transition-delay:.2s">
        <div class="svc-img"><span>🦶</span><div class="svc-img-shine"></div></div>
        <div class="svc-title" data-cs="Pedikúra" data-en="Pedicure" data-de="Pediküre" data-ru="Педикюр">Pedikúra</div>
        <div class="svc-text" data-cs="Kompletní péče o nohy a nehty — koupel, peeling, zábal, lakování. Vaše nohy si zaslouží tu nejlepší péči." data-en="Complete foot and nail care — bath, peeling, wrap, nail polish. Your feet deserve the best care." data-de="Komplette Fuß- und Nagelpflege — Bad, Peeling, Umhüllung, Lackierung. Ihre Füße verdienen die beste Pflege." data-ru="Комплексный уход за ногами и ногтями — ванночка, пилинг, обёртывание, лакирование. Ваши ноги заслуживают лучшего ухода.">Kompletní péče o nohy a nehty — koupel, peeling, zábal, lakování. Vaše nohy si zaslouží tu nejlepší péči.</div>
        <div><span class="svc-price-label" data-cs="od" data-en="from" data-de="ab" data-ru="от">od</span><span class="svc-price">450 Kč</span></div>
      </div>
      <div class="svc-card reveal" style="transition-delay:.3s">
        <div class="svc-img"><span>✨</span><div class="svc-img-shine"></div></div>
        <div class="svc-title" data-cs="Gel nehty" data-en="Gel Nails" data-de="Gel Nägel" data-ru="Гелевые ногти">Gel nehty</div>
        <div class="svc-text" data-cs="Modeláž a prodlužování nehtů pomocí gelu. Trvanlivý výsledek, přirozený vzhled, zdravé nehty pod gelem." data-en="Nail sculpting and extension with gel. Long-lasting result, natural look, healthy nails under the gel." data-de="Nagelmodellierung und -verlängerung mit Gel. Langlebiges Ergebnis, natürlicher Look, gesunde Nägel unter dem Gel." data-ru="Моделирование и наращивание ногтей с помощью геля. Долговечный результат, натуральный вид, здоровые ногти под гелем.">Modeláž a prodlužování nehtů pomocí gelu. Trvanlivý výsledek, přirozený vzhled, zdravé nehty pod gelem.</div>
        <div><span class="svc-price-label" data-cs="od" data-en="from" data-de="ab" data-ru="от">od</span><span class="svc-price">600 Kč</span></div>
      </div>
      <div class="svc-card reveal" style="transition-delay:.4s">
        <div class="svc-img"><span>🎨</span><div class="svc-img-shine"></div></div>
        <div class="svc-title" data-cs="Nail Art" data-en="Nail Art" data-de="Nail Art" data-ru="Nail Art">Nail Art</div>
        <div class="svc-text" data-cs="Kreativní zdobení nehtů — od jednoduchých vzorů po složité umělecké kreace. Kamínky, fólie, 3D efekty, ombre." data-en="Creative nail decoration — from simple patterns to complex artistic creations. Rhinestones, foils, 3D effects, ombre." data-de="Kreative Nageldekoration — von einfachen Mustern bis zu komplexen künstlerischen Kreationen. Strasssteine, Folien, 3D-Effekte, Ombre." data-ru="Творческое украшение ногтей — от простых узоров до сложных художественных творений. Стразы, фольга, 3D эффекты, омбре.">Kreativní zdobení nehtů — od jednoduchých vzorů po složité umělecké kreace. Kamínky, fólie, 3D efekty, ombre.</div>
        <div><span class="svc-price-label" data-cs="od" data-en="from" data-de="ab" data-ru="от">od</span><span class="svc-price">200 Kč</span></div>
      </div>
    </div>
  </div>
</section>

<!-- GALLERY -->
<section id="portfolio">
  <div class="container">
    <div class="portfolio-intro reveal">
      <span class="section-eyebrow" data-cs="Naše práce" data-en="Our Work" data-de="Unsere Arbeit" data-ru="Наши работы">Naše práce</span>
      <h2 class="section-title" data-cs="<em>Galerie</em> krásy" data-en="Gallery of <em>beauty</em>" data-de="Galerie der <em>Schönheit</em>" data-ru="Галерея <em>красоты</em>"><em>Galerie</em> krásy</h2>
      <div class="gold-line"></div>
    </div>
    <div class="gallery-grid">
      <div class="gallery-item reveal">
        <div class="gallery-inner" style="background:linear-gradient(135deg,#1a1510,#2a2018)">
          <span style="font-size:4rem;opacity:.2">💅</span>
        </div>
        <div class="gallery-overlay">
          <span class="gallery-label" data-cs="Gelová manikúra" data-en="Gel Manicure" data-de="Gel Maniküre" data-ru="Гелевый маникюр">Gelová manikúra</span>
        </div>
      </div>
      <div class="gallery-item reveal" style="transition-delay:.1s">
        <div class="gallery-inner" style="background:linear-gradient(135deg,#18120f,#241c16)">
          <span style="font-size:3rem;opacity:.2">✨</span>
        </div>
        <div class="gallery-overlay">
          <span class="gallery-label" data-cs="Nail Art" data-en="Nail Art" data-de="Nail Art" data-ru="Nail Art">Nail Art</span>
        </div>
      </div>
      <div class="gallery-item reveal" style="transition-delay:.2s">
        <div class="gallery-inner" style="background:linear-gradient(135deg,#16130e,#221a12)">
          <span style="font-size:3rem;opacity:.2">🌸</span>
        </div>
        <div class="gallery-overlay">
          <span class="gallery-label" data-cs="Francouzská manikúra" data-en="French Manicure" data-de="Französische Maniküre" data-ru="Французский маникюр">Francouzská manikúra</span>
        </div>
      </div>
      <div class="gallery-item reveal" style="transition-delay:.15s">
        <div class="gallery-inner" style="background:linear-gradient(135deg,#1c1610,#28200a)">
          <span style="font-size:3rem;opacity:.2">🦋</span>
        </div>
        <div class="gallery-overlay">
          <span class="gallery-label" data-cs="Ombre efekt" data-en="Ombre Effect" data-de="Ombre Effekt" data-ru="Омбре эффект">Ombre efekt</span>
        </div>
      </div>
      <div class="gallery-item reveal" style="transition-delay:.3s">
        <div class="gallery-inner" style="background:linear-gradient(135deg,#141110,#201a0e)">
          <span style="font-size:3rem;opacity:.2">💎</span>
        </div>
        <div class="gallery-overlay">
          <span class="gallery-label" data-cs="3D Zdobení" data-en="3D Decoration" data-de="3D Dekoration" data-ru="3D Украшение">3D Zdobení</span>
        </div>
      </div>
      <div class="gallery-item reveal" style="transition-delay:.25s">
        <div class="gallery-inner" style="background:linear-gradient(135deg,#181410,#241c14)">
          <span style="font-size:3rem;opacity:.2">🌺</span>
        </div>
        <div class="gallery-overlay">
          <span class="gallery-label" data-cs="Pedikúra" data-en="Pedicure" data-de="Pediküre" data-ru="Педикюр">Pedikúra</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- LOCATION / MAP -->
<section id="location" style="padding:0">
  <div class="container" style="padding:7rem 4rem 0">
    <div class="reveal">
      <span class="section-eyebrow" data-cs="Kde nás najdete" data-en="Find Us" data-de="Wo Sie uns finden" data-ru="Где нас найти">Kde nás najdete</span>
      <h2 class="section-title" data-cs="Navštivte naše <em>studio</em>" data-en="Visit our <em>studio</em>" data-de="Besuchen Sie unser <em>Studio</em>" data-ru="Посетите наше <em>студио</em>">Navštivte naše <em>studio</em></h2>
      <div class="gold-line"></div>
    </div>
  </div>
  <div style="margin-top:3rem">
    <div class="location-grid">
      <div class="location-info reveal-left" style="padding:3rem 4rem">
        <div class="location-detail">
          <span class="detail-icon">📍</span>
          <div>
            <div class="detail-label" data-cs="Adresa" data-en="Address" data-de="Adresse" data-ru="Адрес">Adresa</div>
            <div class="detail-value">Sokolovská 299/42<br>Rybáře, 360 05<br>Karlovy Vary, Česká republika</div>
          </div>
        </div>
        <div class="location-detail">
          <span class="detail-icon">🕐</span>
          <div>
            <div class="detail-label" data-cs="Otevírací doba" data-en="Opening Hours" data-de="Öffnungszeiten" data-ru="Часы работы">Otevírací doba</div>
            <div class="detail-value" data-cs="Po–Pá: 9:00 – 19:00<br>So: 9:00 – 17:00<br>Ne: zavřeno" data-en="Mon–Fri: 9:00 – 19:00<br>Sat: 9:00 – 17:00<br>Sun: closed" data-de="Mo–Fr: 9:00 – 19:00<br>Sa: 9:00 – 17:00<br>So: geschlossen" data-ru="Пн–Пт: 9:00 – 19:00<br>Сб: 9:00 – 17:00<br>Вс: закрыто">Po–Pá: 9:00 – 19:00<br>So: 9:00 – 17:00<br>Ne: zavřeno</div>
          </div>
        </div>
        <div class="location-detail">
          <span class="detail-icon">📞</span>
          <div>
            <div class="detail-label" data-cs="Telefon" data-en="Phone" data-de="Telefon" data-ru="Телефон">Telefon</div>
            <div class="detail-value"><a href="tel:" style="color:var(--gold);text-decoration:none" data-cs="Volejte pro rezervaci" data-en="Call for reservation" data-de="Anrufen für Reservierung" data-ru="Звоните для записи">Volejte pro rezervaci</a></div>
          </div>
        </div>
        <div class="location-detail">
          <span class="detail-icon">🚌</span>
          <div>
            <div class="detail-label" data-cs="Jak se dostat" data-en="Getting Here" data-de="Anfahrt" data-ru="Как добраться">Jak se dostat</div>
            <div class="detail-value" data-cs="Autobusová zastávka Rybáře v bezprostřední blízkosti. Parkování před budovou k dispozici." data-en="Rybáře bus stop in immediate vicinity. Parking in front of the building available." data-de="Bushaltestelle Rybáře in unmittelbarer Nähe. Parken vor dem Gebäude verfügbar." data-ru="Автобусная остановка Rybáře в непосредственной близости. Парковка перед зданием доступна.">Autobusová zastávka Rybáře v bezprostřední blízkosti. Parkování před budovou k dispozici.</div>
          </div>
        </div>
        <a href="https://maps.app.goo.gl/riVb7uLXSacHQntV7" target="_blank" class="btn-primary" style="display:inline-block;margin-top:1rem;text-decoration:none">
          <span data-cs="Otevřít v Google Maps" data-en="Open in Google Maps" data-de="In Google Maps öffnen" data-ru="Открыть в Google Maps">Otevřít v Google Maps</span>
        </a>
      </div>
      <div class="map-wrap reveal-right">
        <iframe
          src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2573.4380428!2d12.8899!3d50.2103!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47a09900390aeec5%3A0x1b26b994c5dfed4c!2sJenny%20Nails!5e0!3m2!1scs!2scz!4v1680000000000!5m2!1scs!2scz"
          allowfullscreen=""
          loading="lazy"
          referrerpolicy="no-referrer-when-downgrade"
          title="Jenny Nails - Karlovy Vary">
        </iframe>
      </div>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div class="container">
    <div class="footer-inner">
      <div>
        <span class="footer-logo">Jenny Nails</span>
        <p class="footer-tagline" data-cs="Prémiové nail studio v Karlových Varech.<br>Krása v každém detailu." data-en="Premium nail studio in Karlovy Vary.<br>Beauty in every detail." data-de="Premium Nail Studio in Karlsbad.<br>Schönheit in jedem Detail." data-ru="Премиальная студия ногтевого сервиса в Карловых Варах.<br>Красота в каждой детали.">Prémiové nail studio v Karlových Varech.<br>Krása v každém detailu.</p>
      </div>
      <div>
        <div class="footer-title" data-cs="Navigace" data-en="Navigation" data-de="Navigation" data-ru="Навигация">Navigace</div>
        <ul class="footer-links">
          <li><a href="#about" data-cs="O nás" data-en="About" data-de="Über uns" data-ru="О нас">O nás</a></li>
          <li><a href="#advantages" data-cs="Výhody" data-en="Advantages" data-de="Vorteile" data-ru="Преимущества">Výhody</a></li>
          <li><a href="#services" data-cs="Služby" data-en="Services" data-de="Leistungen" data-ru="Услуги">Služby</a></li>
          <li><a href="#portfolio" data-cs="Galerie" data-en="Gallery" data-de="Galerie" data-ru="Галерея">Galerie</a></li>
          <li><a href="#location" data-cs="Kontakt" data-en="Contact" data-de="Kontakt" data-ru="Контакт">Kontakt</a></li>
        </ul>
      </div>
      <div>
        <div class="footer-title" data-cs="Studio" data-en="Studio" data-de="Studio" data-ru="Студия">Studio</div>
        <ul class="footer-links">
          <li><span style="font-size:.85rem;color:var(--text)">Sokolovská 299/42</span></li>
          <li><span style="font-size:.85rem;color:var(--text)">Rybáře, 360 05 Karlovy Vary</span></li>
          <li style="margin-top:.5rem"><a href="https://maps.app.goo.gl/riVb7uLXSacHQntV7" target="_blank" style="color:var(--gold)" data-cs="Google Maps →" data-en="Google Maps →" data-de="Google Maps →" data-ru="Google Maps →">Google Maps →</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <span class="footer-copy">© 2025 Jenny Nails · Karlovy Vary</span>
      <div class="lang-switch">
        <button class="lang-btn active" data-lang="cs">CS</button>
        <button class="lang-btn" data-lang="en">EN</button>
        <button class="lang-btn" data-lang="de">DE</button>
        <button class="lang-btn" data-lang="ru">RU</button>
      </div>
    </div>
  </div>
</footer>

<script>
// CURRENT LANG
let currentLang = 'cs';

// CURSOR
const cursor = document.getElementById('cursor');
const ring = document.getElementById('cursorRing');
document.addEventListener('mousemove', e => {
  cursor.style.left = e.clientX + 'px';
  cursor.style.top = e.clientY + 'px';
  ring.style.left = e.clientX + 'px';
  ring.style.top = e.clientY + 'px';
});
document.querySelectorAll('a,button').forEach(el => {
  el.addEventListener('mouseenter', () => ring.classList.add('active'));
  el.addEventListener('mouseleave', () => ring.classList.remove('active'));
});

// LOADER
setTimeout(() => {
  const loader = document.getElementById('loader');
  loader.style.opacity = '0';
  loader.style.transition = 'opacity .8s ease';
  setTimeout(() => { loader.style.display = 'none'; }, 800);
}, 2400);

// NAV SCROLL
const navbar = document.getElementById('navbar');
window.addEventListener('scroll', () => {
  navbar.classList.toggle('scrolled', window.scrollY > 50);
});

// BURGER
const burger = document.getElementById('burger');
const mobileMenu = document.getElementById('mobileMenu');
let menuOpen = false;
burger.addEventListener('click', () => {
  menuOpen = !menuOpen;
  mobileMenu.style.display = menuOpen ? 'flex' : 'none';
  setTimeout(() => { if(menuOpen) mobileMenu.classList.add('open'); else mobileMenu.classList.remove('open'); }, 10);
  const spans = burger.querySelectorAll('span');
  if(menuOpen) {
    spans[0].style.transform = 'rotate(45deg) translate(4px,4px)';
    spans[1].style.opacity = '0';
    spans[2].style.transform = 'rotate(-45deg) translate(4px,-4px)';
  } else {
    spans[0].style.transform = '';
    spans[1].style.opacity = '';
    spans[2].style.transform = '';
  }
});
mobileMenu.querySelectorAll('a').forEach(a => {
  a.addEventListener('click', () => {
    menuOpen = false;
    mobileMenu.style.display = 'none';
    mobileMenu.classList.remove('open');
    const spans = burger.querySelectorAll('span');
    spans[0].style.transform = ''; spans[1].style.opacity = ''; spans[2].style.transform = '';
  });
});

// PARTICLES
const pContainer = document.getElementById('particles');
for(let i = 0; i < 30; i++) {
  const p = document.createElement('div');
  p.className = 'particle';
  const x = Math.random() * 100;
  const delay = Math.random() * 10;
  const dur = 8 + Math.random() * 12;
  const drift = (Math.random() - 0.5) * 200;
  p.style.cssText = `left:${x}%;animation-duration:${dur}s;animation-delay:${delay}s;--drift:${drift}px;${Math.random()>.5?`width:2px;height:2px`:''}`;
  pContainer.appendChild(p);
}

// HERO LINES
const lContainer = document.getElementById('heroLines');
for(let i = 0; i < 6; i++) {
  const l = document.createElement('div');
  l.className = 'h-line';
  const x = 10 + i * 15;
  const delay = i * 1.5;
  const dur = 6 + i * 2;
  const h = 30 + Math.random() * 50;
  l.style.cssText = `left:${x}%;top:${Math.random()*100}%;height:${h}%;animation-delay:${delay}s;animation-duration:${dur}s;`;
  lContainer.appendChild(l);
}

// SMOOTH ANCHOR SCROLL
document.querySelectorAll('a[href^="#"]').forEach(a => {
  a.addEventListener('click', e => {
    const target = document.querySelector(a.getAttribute('href'));
    if(target) { e.preventDefault(); target.scrollIntoView({behavior:'smooth'}); }
  });
});

// REVEAL ON SCROLL
const revealEls = document.querySelectorAll('.reveal,.reveal-left,.reveal-right');
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if(entry.isIntersecting) {
      entry.target.classList.add('visible');
    }
  });
}, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });
revealEls.forEach(el => observer.observe(el));

// LANGUAGE SYSTEM
function applyLang(lang) {
  currentLang = lang;
  document.documentElement.lang = lang === 'cs' ? 'cs' : lang === 'de' ? 'de' : lang === 'ru' ? 'ru' : 'en';
  document.querySelectorAll(`[data-${lang}]`).forEach(el => {
    const val = el.getAttribute(`data-${lang}`);
    if(val) {
      if(el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') el.placeholder = val;
      else el.innerHTML = val;
    }
  });
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.getAttribute('data-lang') === lang);
  });
}

document.querySelectorAll('.lang-btn').forEach(btn => {
  btn.addEventListener('click', () => applyLang(btn.getAttribute('data-lang')));
});
</script>
</body>
</html>
