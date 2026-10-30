> **Cópia publicada.** Estes guias são uma cópia sem dados pessoais (IP, nome do Wi-Fi, localização) dos arquivos
> que ficam em `work/` no PC, pasta que o git ignora. Os comandos usam `work/...` porque é lá que as fotos, o backup
> e as listas de verdade ficam. Troque `<tv ip>` pelo IP da TV.

# TV da sala: TCL 65C6K (Google TV)

Este arquivo registra a limpeza feita em **25/10/2026**, o que mudou, o que ficou como estava e como desfazer.
Ele fica na pasta `work/`, que o git ignora, junto com o backup (`backup/`) e os prints (`shots/`). Nada
disso vai para o repositório público.

## A TV

| | |
|---|---|
| Modelo | TCL 65C6K, de 65 polegadas (aparece como "Smart TV Pro") |
| Plataforma | TCL G15, chip Realtek |
| Sistema | Google TV, Android 14 (SDK 34) |
| Firmware | `G15-user 14 UTT2.250416.001 AU12` |
| Rede | Wi-Fi, IP `<tv ip>` |
| Lista parecida no repositório | `examples/tcl-65c7k-google-tv` (C7K brasileira, mesmo firmware, placa G08) |

## O que foi feito

1. **Backup antes de qualquer mudança**, na pasta `backup/`: lista completa de pacotes (nenhum estava
   desativado), `getprop`, todas as configurações (`global`, `secure`, `system`), qual app era a tela inicial,
   a resolução da tela e o dono da rede Wi-Fi salva.
2. **27 pacotes desativados** (eram 30; 3 foram religados depois, veja abaixo). Foram desativados (`pm disable-user`), nunca desinstalados, em 6 lotes, com um
   print da tela entre cada lote. A lista completa está em [`debloat-tcl-65c6k.txt`](debloat-tcl-65c6k.txt).
3. **Launcher novo instalado** (`com.gathin.tvhome`, compilado a partir do código do repositório) como tela inicial.
4. **Reboot e conferência**: a TV voltou direto para o launcher novo, nenhum pacote voltou a ser ativado sozinho, e
   os botões do controle remoto foram testados no controle físico. Todos funcionaram.

### O que foi desativado

| Grupo | Pacotes |
|---|---|
| Telemetria TCL e Google | `com.tcl.logkit`, `com.tcl.usercenter`, `com.google.android.feedback`, `com.android.tv.feedbackconsent` |
| Propaganda e conteúdo TCL | `com.tcl.tv.tclhome_passive`, `com.tcl.partnercustomizer`, `com.tcl.interactive`, `com.tcl.messagebox`, `com.tcl.useragreement` |
| Modo loja e hotel | `com.tcl.exhibit`, `com.tcl.esticker`, `com.tcl.hotelmenu` |
| Instaladores silenciosos de apps | `android.autoinstalls.config.google.gtvpai`, `com.google.android.partnersetup`, `com.tcl.smartlink.core` |
| Extras TCL | `com.tcl.ocean.instructions` (manual), `com.tcl.repairguide`, `com.tcl.guard` ("limpador") |
| Streaming que não é usado | Netflix (`com.netflix.ninja`), YouTube Music, Disney+, Max (`com.wbd.stream`), Paramount+ (`com.cbs.ca`), Viki, Claro TV+ |
| Tela inicial antiga | `com.google.android.apps.tv.launcherx` (Google TV) e `com.google.android.tungsten.setupwraith` (o assistente de configuração, que também disputava a tela inicial) |

### O que ficou ligado de propósito

- **Uso diário:** YouTube, Prime Video, Globoplay, Spotify, Pluto TV e Twitch; Google Assistente (botão do
  microfone); Chromecast; Miracast; AirPlay; T-Cast/MagiConnect.
- **TCL Channel**: o app (`com.tcl.waterfall.overseas`) e os canais ao vivo dele (`com.tcl.channelplus`) foram
  desativados na primeira limpeza e **reativados** no mesmo dia, porque o botão TCL Channel do controle abre esse app.
- **`com.netflix.tokenmanager`** (login da Netflix) foi reativado: só atende a Netflix e permite ligá-la pela Play Store
  sem mais nada.
- **`com.tcl.ttvs`** fica ligado porque é ele que roda o T-Cast. O lado ruim é que a coleta de audiência do
  Samba TV mora no mesmo pacote.
- **O que a TV precisa para funcionar:** app de TV, HDMI e antena (`com.tcl.tv`, `com.tcl.tvinput`), menu de
  fontes (`com.tcl.suspension`), Ginga, a interatividade da TV aberta (`com.mirakulo.astrotv.service`),
  teclado, controle e pareamento Bluetooth, Play Store e Play Services, Dolby e os serviços Realtek.
- **Recursos opcionais**, mantidos por escolha: Game Bar, atualização de soundbar TCL, T-Solo, HearAid, Media
  Player USB, proteção de tela ambiente, Play Games e TalkBack.
- **Atualização de firmware da TV:** não foi tocada.
- **Fire TV Stick:** usa o HDMI 4, e o HDMI não foi alterado. Ele estava alimentado pela USB da TV e foi
  desligado durante o processo, porque algumas TVs cortam a energia da USB enquanto a depuração está ligada.
  Pode religá-lo depois que a depuração for desligada (veja abaixo).
- O pacote de fábrica `com.tcl.factory.view` **não foi aberto nem alterado**. Nunca abra esse pacote: em algumas
  placas, abrir um app de fábrica ativa um modo que não dá para desfazer pelo ADB.

### O launcher novo

- Dock com 4 apps, nesta ordem: **YouTube, Prime Video, Globoplay, Spotify**. Os outros apps ficam na grade
  logo abaixo (aperte Down).
- No alto, à direita: **Entradas** (HDMI 1 a 4), **Wi-Fi** e **Configurações**.
- Sem internet, sem anúncios e sem telemetria.
- Opções da tela inicial, no `config.json` do tema de New York (30/10/2026): saudação "BOA TARDE, PH", faixa de
  cinema (arte 30%, fundo 60%), céu com a hora do dia (intensidade 30), relógio do protetor de tela sobre a foto
  (50%), menu dos blocos (segurar OK) e Biblioteca de apps.
- O céu segue o sol da cidade da TV: `latitude` e `longitude` da cidade no `config.xml`, arredondadas (só no PC; vazias na versão publicada).
- Protetor de tela da TV: o **Clock** do launcher (`com.gathin.tvhome/.ClockDream`). Para voltar ao do Google TV,
  escolha outro em Configurações → Sistema → Protetor de tela.
- Relógio em 24 horas (`time_12_24`): era 24 no backup, apareceu em 12 em 30/10 e foi voltado para 24.

### Add-ons (cartões na tela inicial)

| Add-on | Pacote | Observação |
|---|---|---|
| Sources | `io.github.maxhayim.sources` | Entradas pelo nome do aparelho (PS5, Fire TV); sem internet |

O Weather (clima) foi instalado e removido no mesmo dia: o cartão só mostra o clima depois de aberto, e a
temperatura não aparece na tela inicial.

Para remover um add-on: `TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "pm uninstall <pacote>"`.
Eles são apps comuns, não de sistema.

### Botões de app do controle

Os botões de app mandam códigos próprios da TCL, todos com o mesmo scancode (240):

| Botão | Código | Quem atende |
|---|---|---|
| YouTube | 190 | o launcher (`app_keys` em `config.xml`) |
| Prime Video | 4099 | o launcher |
| Netflix | 4062 | o launcher; não faz nada enquanto a Netflix estiver desativada |
| Disney+ | 4141 | o launcher; não faz nada enquanto o Disney+ estiver desativado |
| TCL Channel | 4020 | o firmware da TCL, que abre `com.tcl.waterfall.overseas` |
| Globoplay | 4097 | o firmware da TCL |
| Engrenagem (configurações) | 83 | o launcher (`83:settings`), abre as Configurações da TV |

O launcher atende os botões por meio de um serviço de acessibilidade (`InputKeyService`). O Android desliga esse
serviço quando o launcher é reinstalado, então ao reinstalar use sempre `INPUT_KEY_SERVICE=1`:

```
TV_HOST=<tv ip>:5555 INPUT_KEY_SERVICE=1 launcher/build-and-install.sh
```

**Troca conhecida: botões de app ou volume segurado, nunca os dois.** Com o serviço ligado, segurar Volume +/−
anda só um passo; é preciso apertar várias vezes. Isso vem do sistema da TV, não do launcher: qualquer serviço que
filtre teclas faz o Android descartar a repetição (detalhes em `docs/devices/tcl-55p71b-g09-key-repeat.md`).
Testado nesta TV em 25/10/2026: sem o serviço, o volume sobe direto. A escolha foi **manter os botões**.

Para mudar de ideia, sem reinstalar nada:

```
# volume segurado de volta; YouTube, Prime, Netflix e Disney+ param de abrir pelo botão
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "settings put secure enabled_accessibility_services ''; settings put secure accessibility_enabled 0"

# botões de volta; volume passo a passo
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "settings put secure enabled_accessibility_services com.gathin.tvhome/.InputKeyService; settings put secure accessibility_enabled 1"
```

Pela TV, sem computador: **Configurações → Sistema → Acessibilidade**, serviço "Início". Globoplay e TCL
Channel abrem pelo firmware e funcionam nos dois casos.

### Usar a Netflix ou o Disney+ sem o computador

1. Abra a **Play Store** na TV, procure o app e aperte **Ativar**. Outro caminho: **Configurações → Apps → Ver todos
   os apps**, abra os apps do sistema ou desativados, entre no app e escolha **Ativar**.
2. Use normalmente. O botão do controle já abre o app.
3. Para desativar de novo: **Configurações → Apps → Ver todos os apps → (o app) → Desativar**. Se a TV avisar que
   vai voltar à versão de fábrica, pode aceitar.

O `check.py --fix` desativa de novo tudo o que está na lista, inclusive a Netflix e o Disney+ se estiverem ativados.

## Fechar o ADB (falta fazer)

A porta 5555 da TV aceita comandos sem criptografia enquanto a depuração estiver ligada. Para fechar:

1. Na TV: **Configurações → Sistema → Opções do desenvolvedor**. Revogue as autorizações de depuração USB e
   desligue a **Depuração USB** e a depuração pela rede, ou a **Depuração sem fio**, se aparecer.
2. Reinicie a TV.
3. No computador, na pasta do repositório:
   ```
   tools/venv/Scripts/python tools/adb-closed.py <tv ip>
   ```
   O resultado tem que dizer que a porta está fechada (`Connection refused`).
4. Religue o Fire TV Stick na USB.

## Como restaurar

Todos os comandos abaixo precisam da depuração ligada outra vez na TV (Opções do desenvolvedor → Depuração USB,
e aceite o aviso "Permitir depuração USB?" na tela). Rode no **Git Bash**, na pasta do repositório.

### Restaurar tudo (a TV volta a ser como era antes)

```
TV_HOST=<tv ip>:5555 tools/restore.sh work/debloat-tcl-65c6k.txt com.google.android.apps.tv.launcherx
```

Esse comando reativa os pacotes da lista, devolve a tela inicial ao Google TV e mantém as animações em 1.0, como
estavam. Como não havia nenhum pacote desativado antes da limpeza, reativar a lista inteira é exatamente o
estado original.

No PowerShell, o equivalente é:

```
tools\restore.ps1 -TvHost <tv ip>:5555 work\debloat-tcl-65c6k.txt -Stock com.google.android.apps.tv.launcherx
```

Se quiser também remover o launcher novo, depois da restauração rode:

```
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "pm uninstall com.gathin.tvhome"
```

O launcher novo é um app comum que você instalou, não um app de sistema, então pode ser removido.

### Religar só um app

Exemplo com a Netflix:

```
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "pm enable com.netflix.ninja"
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "pm enable com.netflix.tokenmanager"
```

Rode um comando por pacote. Os nomes estão na tabela acima e em `debloat-tcl-65c6k.txt`.

### Voltar só para a tela inicial do Google TV

```
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "pm enable com.google.android.apps.tv.launcherx"
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "cmd package set-home-activity --user 0 com.google.android.apps.tv.launcherx/.home.HomeActivity"
```

### Conferir se algo voltou a ser ativado sozinho (depois de uma atualização, por exemplo)

```
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/check.py work/debloat-tcl-65c6k.txt com.gathin.tvhome
```

Para desativar de novo o que voltou, troque `check.py` por `check.py --fix` no mesmo comando.

## Mudar o dock ou o papel de parede

- **Ordem do dock:** edite a lista `dock_apps` em `launcher/app/src/main/res/values/config.xml` e rode de novo
  `TV_HOST=<tv ip>:5555 launcher/build-and-install.sh`, com `JAVA_HOME` apontando para o JDK 17 e
  `ANDROID_HOME` para `%LOCALAPPDATA%/Android/Sdk`.
- **Suas próprias fotos (coleção com troca automática):** veja
  [`wallpapers/README-WALLPAPER.md`](wallpapers/README-WALLPAPER.md). O tema de New York já está pronto em
  `work/wallpapers/tema-newyork/`.
- **Papel de parede e visual:** use um dos temas prontos em `themes/` (por exemplo `aurora`, `glass` ou `scenes`):
  ```
  TV_HOST=<tv ip>:5555 tools/theme.sh themes/aurora
  ```
  `tools/theme.sh --reset` volta ao visual padrão. Para usar uma foto sua, veja `themes/README.md`.

## Arquivos desta limpeza

| Onde | O quê |
|---|---|
| `backup/` | Estado da TV antes de qualquer mudança |
| `work/debloat-tcl-65c6k.txt` | A lista aplicada (use esta para restaurar) |
| `work/lote*.txt` | Os 6 lotes, na ordem em que foram aplicados |
| `shots/` | Prints da TV antes, entre os lotes e com o launcher novo |
| `%USERPROFILE%\.cleanyourtv\` | Registros de recuperação gravados pelos scripts |
| `%LOCALAPPDATA%\Android\Sdk` | Android SDK usado para compilar o launcher (pode apagar se não for mais compilar) |

## Opcional: DNS com bloqueio de anúncios

Não foi configurado. Se quiser, o DNS Privado com o AdGuard bloqueia parte dos anúncios e rastreadores nos apps,
mas não os anúncios do YouTube:

```
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "settings put global private_dns_specifier dns.adguard-dns.com"
TV_HOST=<tv ip>:5555 tools/venv/Scripts/python tools/tv.py "settings put global private_dns_mode hostname"
```

Para desfazer: `settings put global private_dns_mode opportunistic`. Se o roteador já filtra DNS (Pi-hole,
AdGuard Home), não use: o DNS Privado passa por cima do filtro do roteador.

## Manter a TV atualizada com o projeto

Sempre que o repositório original (Gathin23/cleanyourtv) tiver novidades, faça isto no **Git Bash**, na pasta
`cleanyourtv`, com a depuração da TV ligada:

1. Guarde a latitude e a longitude locais, que ficam fora do commit:
   ```
   git stash push -m latlong-local launcher/app/src/main/res/values/config.xml
   ```
2. Traga o original e reaplique o seu commit por cima:
   ```
   git fetch origin main
   git rebase origin/main
   ```
   Se aparecer conflito, pare e peça ajuda: `git rebase --abort` volta tudo como estava.
3. Envie para o seu GitHub (a branch local fica igual à remota):
   ```
   git push --force-with-lease fork minha-tv-tcl-65c6k
   ```
4. Devolva a latitude e a longitude:
   ```
   git stash pop
   ```
5. Recompile e instale o launcher na TV, sempre com o serviço dos botões:
   ```
   cd launcher
   TV_HOST=<tv ip>:5555 INPUT_KEY_SERVICE=1 \
     JAVA_HOME="<pasta do JDK 17>" ANDROID_HOME="%LOCALAPPDATA%/Android/Sdk" \
     ./build-and-install.sh
   cd ..
   ```
   No fim ele deve dizer `InputKeyService enabled` e `Installed`. As configurações (dock, botões, tema de New York)
   continuam: elas vêm do `config.xml` e do tema que já está na TV.
6. Aperte Home no controle e confira a tela inicial e os botões do controle.
7. **Desligue a depuração** de novo: Depuração USB e depuração pela rede desligadas, e reinicie a TV.

Para ver o que mudou antes de atualizar: `git log --oneline HEAD..origin/main` depois do `git fetch`.
