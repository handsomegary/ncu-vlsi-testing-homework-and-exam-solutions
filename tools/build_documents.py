"""Rebuild every editable report/exam in a separate output directory."""
import argparse
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent.parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / '.build/documents')
    parser.add_argument('--compiler', default='pdflatex')
    args = parser.parse_args()
    target = args.output.resolve()
    documents = sorted(path for path in ROOT.rglob('main.tex')
                       if not any(part in ('.git', '.build', 'qa') for part in path.relative_to(ROOT).parts))
    for source in documents:
        relative = source.parent.relative_to(ROOT)
        build = target / relative
        build.mkdir(parents=True, exist_ok=True)
        command = [args.compiler, '-interaction=nonstopmode', '-halt-on-error',
                   '-file-line-error', '-output-directory=' + str(build), source.name]
        for _ in range(2):
            result = subprocess.run(command, cwd=source.parent, capture_output=True, text=True,
                                    errors='replace', timeout=180)
            if result.returncode:
                raise RuntimeError(f'{relative}: LaTeX failed\n{result.stdout[-6000:]}\n{result.stderr[-1000:]}')
        log = (build / 'main.log').read_text(encoding='utf-8', errors='replace')
        if 'Overfull \\hbox' in log or 'Overfull \\vbox' in log:
            raise RuntimeError(f'{relative}: overfull box; inspect {build / "main.log"}')
        print(f'Built {relative / "main.pdf"}', flush=True)
    print(f'PASS: rebuilt {len(documents)} documents')


if __name__ == '__main__':
    main()
