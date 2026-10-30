# Papéis de parede da TV (TCL 65C6K)

Guia para trocar ou acrescentar fotos na tela inicial do launcher. Tudo aqui fica em `work/wallpapers/`, que o
git ignora.

## Como funciona

O launcher mostra uma **coleção** de até 100 fotos e troca de foto sozinho de tempos em tempos. A coleção vai para
a TV dentro de um **tema**: uma pasta com um `config.json` (as regras) e uma subpasta `wallpapers/` (as fotos).
As fotos ficam guardadas na própria TV, então a troca funciona sem internet e sem o computador ligado.

```
work/wallpapers/
├── README-WALLPAPER.md        este guia
├── preparar.sh                reduz, corta e renomeia as fotos
├── originais/
│   └── newyork/               suas fotos originais (nunca são alteradas)
└── tema-newyork/              o tema que vai para a TV
    ├── config.json            as regras: intervalo, ordem, escurecimento...
    └── wallpapers/
        ├── ny-01.jpg ... ny-14.jpg
        └── captions.txt       crédito de cada foto
```

## Passo a passo: colocar fotos novas

### 1. Separe as fotos

Crie uma pasta em `work/wallpapers/originais/` e coloque as fotos lá. Por exemplo, para um tema de praia:

```
work/wallpapers/originais/praia/
```

As melhores fotos para isso são **na horizontal**, **escuras ou noturnas** (o relógio e os nomes dos apps são
brancos) e **grandes** (1920x1080 ou maiores). Podem ser JPG, PNG ou WebP, com qualquer nome.

### 2. Prepare as fotos

No **Git Bash**, na pasta do repositório (`cleanyourtv`):

```
work/wallpapers/preparar.sh work/wallpapers/originais/praia work/wallpapers/tema-praia praia
```

Os três argumentos são: a pasta das fotos, a pasta do tema (é criada se não existir) e um prefixo curto para os
nomes. Esse exemplo gera `praia-01.jpg`, `praia-02.jpg` e assim por diante.

O script:
- gira as fotos de celular para a posição certa;
- corta no centro para o formato da TV (16:9);
- reduz para 1920x1080 e no máximo 350 KB cada, porque a TV carrega a foto na memória sempre que abre a tela inicial;
- apaga os metadados (localização GPS, modelo da câmera);
- escreve o crédito de cada foto em `captions.txt`;
- cria um `config.json` com valores padrão, se a pasta do tema ainda não tiver um.

Fique de olho nos **avisos** que ele mostra:

| Aviso | O que fazer |
|---|---|
| `foto em pé` | O corte vai perder muito do topo e da base. Use outra foto ou aceite o corte |
| `menor que 1920x1080` | Vai ficar borrada na TV. Procure uma versão maior da foto |
| `clara (brilho ...)` | Suba o `wallpaper_dim` no `config.json`, ou tire essa foto |

Ajustes opcionais, antes do comando: `MAX_KB=250 work/wallpapers/preparar.sh ...` deixa os arquivos menores, e
`LARGURA=3840 ALTURA=2160` gera em 4K, mas não vale a pena: a TV desenha a tela inicial em 1920x1080.

### 3. Ajuste as regras (opcional)

Abra `work/wallpapers/tema-praia/config.json`:

```json
{
  "wallpaper": true,
  "wallpaper_rotation_minutes": 30,
  "wallpaper_order": "shuffle",
  "wallpaper_dim": 35,
  "wallpaper_captions": true,
  "dock_opacity": 70
}
```

| Chave | O que faz | Valores |
|---|---|---|
| `wallpaper` | Liga ou desliga as fotos | `true` / `false` |
| `wallpaper_rotation_minutes` | De quanto em quanto tempo troca de foto | `1` a `1440` (`0` = não troca) |
| `wallpaper_order` | Ordem da troca | `shuffle` (aleatória) / `sequential` (pela ordem dos nomes) |
| `wallpaper_dim` | Escurece a foto, em %, para o texto aparecer | `0` a `90` |
| `wallpaper_captions` | Mostra o crédito da foto embaixo dos botões do canto superior direito | `true` / `false` |
| `dock_opacity` | Transparência da faixa do dock, em % (100 = sólida) | `30` a `100` |

**Foto diferente por hora do dia.** Acrescente `wallpaper_moods` com os nomes dos arquivos:

```json
  "wallpaper_moods": {
    "morning": ["ny-02.jpg", "ny-05.jpg"],
    "evening": ["ny-07.jpg", "ny-10.jpg"],
    "night":   ["ny-01.jpg", "ny-12.jpg", "ny-14.jpg"]
  }
```

Morning vai do nascer do sol até meio-dia, evening até meia hora depois do pôr do sol, e night é o resto. Sem
latitude e longitude configuradas, o launcher usa 07:00 e 18:30. Um grupo que ficar faltando usa todas as fotos.
Atenção à vírgula na linha anterior: o JSON não aceita vírgula sobrando nem faltando.

### 4. Envie para a TV

1. Na TV: **Configurações → Sistema → Opções do desenvolvedor → Depuração USB** e, se aparecer, a depuração pela
   rede ou a **Depuração sem fio**. Ligue.
2. No computador:
   ```
   TV_HOST=<tv ip>:5555 tools/theme.sh work/wallpapers/tema-praia
   ```
   Se aparecer na TV o aviso "Permitir depuração USB?", aceite.
3. A tela inicial reinicia sozinha já com as fotos novas.
4. **Desligue a depuração de novo** quando terminar.

Enviar um tema **substitui a coleção inteira** que está na TV. Também desfaz as escolhas feitas no menu do
launcher na TV (colunas, movimento, foto fixa).

## Trocar, substituir ou misturar coleções

A TV mostra **um tema por vez**: enviar um tema substitui a coleção que está nela. A escolha entre as opções
abaixo depende de você querer **guardar** a coleção atual para voltar a ela depois. O exemplo usa fotos do
GTA VI no lugar das de New York.

**Importante:** o `config.json` do tema de New York também guarda as opções da tela inicial: saudação "PH",
faixa de cinema, céu, relógio sobre a foto, menu dos blocos e biblioteca de apps. Um tema enviado **sem** essas
linhas desliga essas opções. Por isso, sempre copie o `config.json` do tema atual para o tema novo (passo 2 abaixo).

### Opção 1 (recomendada): um tema novo, guardando o antigo

O tema de New York continua guardado no computador, e você troca entre os dois com um comando.

1. Crie a pasta das fotos e coloque as imagens dentro:

   ```
   work/wallpapers/originais/gta6/
   ```

2. Copie as regras do tema atual, para manter o mesmo intervalo, escurecimento e assim por diante. Este passo é
   opcional: sem ele, o script cria um `config.json` com os valores padrão.

   ```
   mkdir -p work/wallpapers/tema-gta6
   cp work/wallpapers/tema-newyork/config.json work/wallpapers/tema-gta6/
   ```

3. Prepare as fotos. Elas saem como `gta-01.jpg`, `gta-02.jpg` e assim por diante:

   ```
   work/wallpapers/preparar.sh work/wallpapers/originais/gta6 work/wallpapers/tema-gta6 gta
   ```

4. Ligue a depuração na TV e envie:

   ```
   TV_HOST=<tv ip>:5555 tools/theme.sh work/wallpapers/tema-gta6
   ```

5. Desligue a depuração.

Para **voltar para New York** depois, repita o passo 4 com o tema antigo:

```
TV_HOST=<tv ip>:5555 tools/theme.sh work/wallpapers/tema-newyork
```

### Opção 2: substituir as fotos de um tema existente

Use quando não quiser mais as fotos antigas.

1. Apague as fotos de `work/wallpapers/originais/newyork/` e coloque as novas no lugar.
2. Rode o script com o mesmo prefixo. Ele apaga os `ny-*.jpg` antigos e gera os novos:

   ```
   work/wallpapers/preparar.sh work/wallpapers/originais/newyork work/wallpapers/tema-newyork ny
   ```

3. Envie com `TV_HOST=<tv ip>:5555 tools/theme.sh work/wallpapers/tema-newyork`.

Funciona, mas as pastas continuam com o nome "newyork" e os arquivos com o prefixo "ny", o que confunde depois.
Por isso a opção 1 é melhor.

### Opção 3: misturar duas coleções num tema só

Rode o script para a mesma pasta de tema, com outro prefixo:

```
work/wallpapers/preparar.sh work/wallpapers/originais/gta6 work/wallpapers/tema-newyork gta
```

O tema fica com as fotos de New York (`ny-*`) e as do GTA (`gta-*`), e a troca automática passa por todas.
O limite é de 100 fotos no total. Rodar de novo com um prefixo refaz só as fotos e os créditos daquele prefixo.
Depois, envie o tema normalmente.

### Cuidados com imagens que não vieram do Unsplash (GTA VI, por exemplo)

- **Créditos:** o script só reconhece o nome dos fotógrafos em arquivos do Unsplash. Para outras imagens, o
  "crédito" que aparece na tela é o nome do arquivo. Há duas saídas:
  - edite o `wallpapers/captions.txt` do tema e escreva o texto que quiser em cada linha: o nome do arquivo, um
    **Tab** e o texto (por exemplo `gta-01.jpg<Tab>Vice City`);
  - ou desligue os créditos, trocando `"wallpaper_captions": true` por `false` no `config.json`.

  Rodar o `preparar.sh` de novo com o mesmo prefixo reescreve as legendas desse prefixo, então edite o
  `captions.txt` só depois de preparar as fotos.
- **Brilho:** artes de jogos costumam ser claras e muito coloridas. Se aparecerem avisos de `clara`, suba o
  `"wallpaper_dim"` para 50 ou 60 no `config.json` antes de enviar.
- **Formato:** prefira imagens na horizontal e com pelo menos 1920x1080. Wallpapers "4K" ou "desktop"
  geralmente já vêm assim.
- **Direitos:** a arte do GTA VI é da Rockstar. Usar na sua TV não tem problema, mas não publique essas imagens.
  Como a pasta `work/` fica fora do git, elas não vão para o repositório.

## Outras situações

**Acrescentar fotos a um tema que já existe.** Coloque as fotos novas na mesma pasta de originais e rode o
`preparar.sh` de novo, com o mesmo prefixo. Ele refaz a numeração toda, sem deixar sobras. Depois envie o tema
(passo 4).

**Tirar uma foto.** Apague o original em `originais/...`, rode o `preparar.sh` de novo e envie o tema.

**Escolher uma foto fixa pelo controle, sem computador.** Na tela inicial, vá até o botão **Configurações**
(canto superior direito), **segure OK**, escolha **Configurações do launcher** e depois **Papel de parede**. Ali você escolhe uma foto da coleção (a troca automática para), escolhe **Nenhum**, ou
volta para o padrão do tema, e a troca recomeça.

**Trocar de tema.** Envie a outra pasta com `tools/theme.sh`. Os temas que vêm com o repositório também servem,
como `themes/scenes` (14 paisagens ilustradas) e `themes/aurora`.

**Voltar ao visual original do launcher**, sem fotos:
```
TV_HOST=<tv ip>:5555 tools/theme.sh --reset
```

## Se algo der errado

| Problema | Causa provável |
|---|---|
| `TimeoutError: timed out` | A TV está desligada ou em standby, ou a depuração está desligada |
| `unsupported wallpaper filename` | Um arquivo em `wallpapers/` tem espaço ou acento no nome. Gere de novo com o `preparar.sh` |
| `not valid JSON` | Vírgula ou aspas erradas no `config.json` |
| Uma foto não aparece | Arquivo corrompido ou maior que 10 MB; o launcher pula e mantém a anterior |
| Texto difícil de ler | Suba o `wallpaper_dim` (por exemplo para 50) e envie de novo |
| A foto não troca | A troca só acontece com a tela inicial visível. Ao voltar de um app, a foto atrasada troca na hora |
| `falta o Pillow` | `tools/venv/Scripts/pip install pillow==11.3.0` |

## Sobre as fotos de New York

As 14 fotos vieram do Unsplash, cuja licença permite uso pessoal sem pedir permissão. Os créditos dos fotógrafos
estão em `tema-newyork/wallpapers/captions.txt`, e aparecem na tela com `wallpaper_captions` ligado. Não suba
essas fotos para o repositório público.
