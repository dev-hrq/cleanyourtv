#!/usr/bin/env bash
# Prepara fotos para a coleção de papéis de parede do launcher (tema com pasta wallpapers/).
#
# Para cada imagem da pasta de origem (jpg, jpeg, png, webp):
#   - gira conforme o EXIF (fotos de celular) e corta no centro para 16:9;
#   - reduz para 1920x1080 (ou LARGURA x ALTURA);
#   - salva como JPEG sem metadados (sem GPS, sem câmera), até MAX_KB por arquivo;
#   - dá um nome que o launcher aceita: <prefixo>-01.jpg, <prefixo>-02.jpg...
#   - escreve o crédito de cada foto em wallpapers/captions.txt (fotos do Unsplash viram "Foto: Nome Sobrenome").
# Os originais nunca são alterados. Se a pasta do tema não tiver config.json, cria um com valores padrão.
#
# Uso (no Git Bash, a partir da raiz do repositório):
#   work/wallpapers/preparar.sh <pasta com as fotos> <pasta do tema> [prefixo]
#   work/wallpapers/preparar.sh work/wallpapers/originais/newyork work/wallpapers/tema-newyork ny
#
# Ajustes opcionais por variável de ambiente:
#   LARGURA=1920 ALTURA=1080   tamanho final (a TV trabalha em 1920x1080)
#   MAX_KB=350                 tamanho máximo de cada arquivo; a qualidade cai até caber
#
# Depois, para enviar à TV:  TV_HOST=<tv ip>:5555 tools/theme.sh <pasta do tema>
set -euo pipefail

ORIGEM="${1:?uso: preparar.sh <pasta com as fotos> <pasta do tema> [prefixo]}"
TEMA="${2:?uso: preparar.sh <pasta com as fotos> <pasta do tema> [prefixo]}"
PREFIXO="${3:-foto}"
[[ "$PREFIXO" =~ ^[A-Za-z0-9_-]+$ ]] || { echo "prefixo inválido: use só letras, números, - e _" >&2; exit 1; }
[ -d "$ORIGEM" ] || { echo "pasta de origem não existe: $ORIGEM" >&2; exit 1; }

RAIZ="$(cd "$(dirname "$0")/../.." && pwd)"
PY="$RAIZ/tools/venv/Scripts/python.exe"
[ -x "$PY" ] || PY="$RAIZ/tools/venv/bin/python"
[ -x "$PY" ] || { echo "falta o venv: python -m venv tools/venv && tools/venv/Scripts/pip install -r tools/requirements.txt" >&2; exit 1; }
"$PY" -I -c "import PIL" 2>/dev/null || { echo "falta o Pillow: tools/venv/Scripts/pip install pillow==11.3.0" >&2; exit 1; }

mkdir -p "$TEMA/wallpapers"
if [ ! -f "$TEMA/config.json" ]; then
  cat > "$TEMA/config.json" <<'JSON'
{
  "wallpaper": true,
  "wallpaper_rotation_minutes": 30,
  "wallpaper_order": "shuffle",
  "wallpaper_dim": 35,
  "wallpaper_captions": true,
  "dock_opacity": 70
}
JSON
  echo "criado $TEMA/config.json (valores padrão; edite à vontade)"
fi

LARGURA="${LARGURA:-1920}" ALTURA="${ALTURA:-1080}" MAX_KB="${MAX_KB:-350}" \
"$PY" -I - "$ORIGEM" "$TEMA/wallpapers" "$PREFIXO" <<'PYTHON'
import io, os, re, sys
from pathlib import Path
from PIL import Image, ImageOps, ImageStat

origem, destino, prefixo = Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3]
W, H = int(os.environ["LARGURA"]), int(os.environ["ALTURA"])
MAX = int(os.environ["MAX_KB"]) * 1024
LIMITE_COLECAO = 100  # o launcher considera no máximo 100 imagens

fotos = sorted(p for p in origem.iterdir()
               if p.is_file() and p.suffix.lower() in (".jpg", ".jpeg", ".png", ".webp"))
if not fotos:
    sys.exit(f"nenhuma imagem em {origem}")

# Uma nova rodada com o mesmo prefixo substitui a anterior, sem deixar sobras.
for velho in destino.glob(f"{prefixo}-*.jpg"):
    velho.unlink()

def credito(nome):
    # Unsplash: "nome-sobrenome-<id de 11 caracteres>-unsplash.jpg"
    m = re.match(r"^(.+)-[A-Za-z0-9_-]{11}-unsplash$", nome)
    if m:
        return "Foto: " + " ".join(p.capitalize() for p in m.group(1).split("-")) + " / Unsplash"
    return nome

legendas = []
for i, foto in enumerate(fotos, 1):
    with Image.open(foto) as img:
        img = ImageOps.exif_transpose(img).convert("RGB")
        w0, h0 = img.size
        avisos = []
        if h0 > w0:
            avisos.append("foto em pé: o corte 16:9 vai perder bastante do topo e da base")
        if w0 < W or h0 < H:
            avisos.append(f"menor que {W}x{H}: vai ser ampliada e pode ficar borrada")
        img = ImageOps.fit(img, (W, H), Image.LANCZOS, centering=(0.5, 0.5))
        brilho = ImageStat.Stat(img.convert("L")).mean[0]
        if brilho > 110:
            avisos.append(f"clara (brilho {brilho:.0f}/255): suba wallpaper_dim no config.json se o texto sumir")
        for q in range(88, 49, -4):
            buf = io.BytesIO()
            img.save(buf, "JPEG", quality=q, optimize=True, progressive=True)
            if buf.tell() <= MAX:
                break
    nome = f"{prefixo}-{i:02d}.jpg"
    (destino / nome).write_bytes(buf.getvalue())
    legendas.append(f"{nome}\t{credito(foto.stem)}")
    print(f"{nome}  {buf.tell() // 1024:>4} KB  q{q}  de {w0}x{h0}  <- {foto.name}")
    for a in avisos:
        print(f"         aviso: {a}")

# Mantém as legendas de outros prefixos e troca só as deste.
cap = destino / "captions.txt"
outras = []
if cap.exists():
    outras = [l for l in cap.read_text(encoding="utf-8").splitlines()
              if l.strip() and not l.startswith(f"{prefixo}-")]
cap.write_text("\n".join(outras + legendas) + "\n", encoding="utf-8")

total = len(list(destino.glob("*.jpg")))
print(f"\n{len(fotos)} imagens prontas em {destino} ({total} no tema ao todo)")
if total > LIMITE_COLECAO:
    print(f"aviso: o launcher usa no máximo {LIMITE_COLECAO} imagens; as excedentes são ignoradas")
PYTHON

echo
echo "Próximo passo (com a depuração ligada na TV):"
echo "  TV_HOST=<tv ip>:5555 tools/theme.sh $TEMA"
