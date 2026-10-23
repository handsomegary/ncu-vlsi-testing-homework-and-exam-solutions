"""Check original assignment bytes, source integrity, and required deliverables."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def main():
    assignments = json.loads((ROOT / 'original-assignment-manifest.json').read_text(encoding='utf-8'))
    for item in assignments:
        data = (ROOT / item['path']).read_bytes()
        assert len(data) == item['bytes'] and hashlib.sha256(data).hexdigest() == item['sha256'], item['path']
    quartz = ROOT / 'homework/quartz-4b7e'
    for item in json.loads((quartz / 'source-manifest.json').read_text(encoding='utf-8')):
        assert hashlib.sha256((quartz / item['path']).read_bytes()).hexdigest() == item['sha256'], item['path']
    documents = sorted(path for path in ROOT.rglob('main.tex')
                       if not any(part in ('.git', '.build', 'qa') for part in path.relative_to(ROOT).parts))
    assert len(documents) == 14, f'Expected 14 editable documents, got {len(documents)}'
    for source in documents:
        assert source.with_suffix('.pdf').is_file() or (
            'quartz-4b7e' in source.parts and (source.parent.parent / 'student-reference.pdf').is_file()), source
    for hw in (1, 2, 3):
        assert (ROOT / f'homework/cedar-8f2c/hw{hw}/student-report-anonymized.pdf').is_file()
        assert (quartz / f'hw{hw}/student-reference-original.pdf').is_file()
    forbidden = {'.xpr', '.exe', '.o', '.obj', '.vvp', '.vcd', '.wdb', '.fsdb', '.zip', '.rar', '.pptx'}
    published = [path for path in ROOT.rglob('*') if path.is_file()
                 and not any(part in ('.git', '.build', 'qa', '__pycache__') for part in path.relative_to(ROOT).parts)]
    assert not [str(path.relative_to(ROOT)) for path in published if path.suffix.lower() in forbidden]
    verilog = [path for path in published if path.suffix == '.v']
    assert len(verilog) == 32, f'Expected 32 preserved Verilog source/testbench files, got {len(verilog)}'
    print(f'PASS: {len(assignments)} original assignments; 20 Quartz source hashes; '
          f'{len(documents)} editable documents; {len(verilog)} Verilog files')


if __name__ == '__main__':
    main()
