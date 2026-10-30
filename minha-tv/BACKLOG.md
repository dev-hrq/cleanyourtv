# Backlog: TV da sala (TCL 65C6K)

## Volume segurado junto com os botões de app

**Situação hoje (30/10/2026):** os botões YouTube (190), Prime Video (4099), Netflix (4062), Disney+ (4141) e a
engrenagem (83) só funcionam com o `InputKeyService` ligado. Com ele ligado, segurar Volume +/− anda um passo
por toque. Isso foi testado nesta TV: sem o serviço, o volume sobe direto. Ver `docs/devices/tcl-55p71b-g09-key-repeat.md`.

**O que analisar:** o fork [Premium Minimal Home](https://github.com/Lzchyi/cleanyourtv/tree/v2.6.0-redesign)
(SHOWCASE.md) diz manter a repetição nativa do volume porque um "layout salvo do controle Sony" abre a Biblioteca
sem o filtro de acessibilidade. Ele foi testado só numa Sony KD-55X9000H com Android 12.

**Pista desta TV:** com o serviço desligado, o sistema da TCL ainda entrega 190, 4099, 4062, 4141 e 83 à janela em
foco (no log: `publishKeyEvent ... com.gathin.tvhome`). Ou seja, o launcher recebe esses botões **quando está na
tela inicial**, sem precisar de serviço nenhum. Botões tratados na própria tela, sem acessibilidade, funcionariam
só a partir da tela inicial, e não de dentro de outro app. Falta conferir:

1. Como o Premium Minimal Home faz isso: se trata as teclas na Activity, se usa outro mecanismo, e se funciona fora da tela inicial.
2. Se o resultado na TCL G15 seria o mesmo: botões só a partir da tela inicial, com o volume normal.
3. Quanto código muda no launcher. Seria uma mudança local, fora do launcher oficial; ver AGENTS.md antes de propor ao repositório.

**Depois de:** confirmar na TV o tema novo, o protetor de tela de relógio e o cartão Sources.

## Recomendações de filmes ("destaques para você", top 10)

**Pedido:** um bloco com recomendações de filmes e séries, no estilo "destaques para você" ou "top 10".

**O que já foi visto (30/10/2026):**
- O launcher deste repositório não tem e não vai ter isso: não tem permissão de internet, e o CONTRIBUTING.md
  diz que "recommendation rows, content feeds" não entram no launcher. O mais próximo é o "Última abertura" da
  faixa de cinema, que já está ligada.
- Não existe add-on de recomendações em `addons/`. O add-on de clima mostrou o limite dos cartões: o texto do
  bloco é fixo, e o conteúdo só aparece depois de abrir. Por isso o Weather foi removido.
- Projetos de outras pessoas com recomendações (SHOWCASE.md):
  - **CleanYourTV UI** (matheus-caldeira): tela "Explorar" com TMDB, top 10 do dia, catálogos, páginas de título
    e "Assistir em" Netflix/Prime/Max. Em português, testado numa TCL 55C725. É um fork que mantém este repositório
    e acrescenta uma segunda tela como app separado. Rede: TMDB, Wikidata e Open-Meteo.
  - **TCL GTV Launcher** (alexkev): imitação do Google TV sem anúncios, com Continuar assistindo (Watch Next),
    fileiras do YouTube e Plex. Substitui a tela inicial.
  - **Vibe Launcher** (maydings): o app em foco mostra os títulos dele em tela cheia. Substitui a tela inicial.

**Sugestão a analisar primeiro:** verificar se a tela "Explorar" do **CleanYourTV UI** pode ser instalada **ao lado**
do launcher atual, como um app aberto pela grade ou pelo dock, sem trocar a tela inicial. Assim continuam o tema de
New York, a saudação, a faixa de cinema e o mapeamento dos botões. Conferir:

1. Qual é o pacote da segunda tela, se ela declara HOME (e tentaria virar a tela inicial) e se abre como app comum.
2. Que permissões pede (internet, conta TMDB opcional por QR code) e que dados envia.
3. Se roda bem nesta TV (G15, Android 14) e se o "Assistir em" abre o Prime e o Globoplay.
4. Se precisa compilar do código (regra do repositório: nada de APK pronto de fora) e quanto custa manter atualizado.

Os outros dois só se o CleanYourTV UI não servir, porque obrigam a refazer o tema e os botões em outro launcher.
