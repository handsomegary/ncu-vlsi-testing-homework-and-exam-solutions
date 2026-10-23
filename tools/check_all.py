"""Run exam models and student-reference regressions, including known failures."""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--iverilog', default='iverilog')
    parser.add_argument('--vvp', default='vvp')
    parser.add_argument('--cxx', default='g++')
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix='vlsi-testing-checks-') as temporary:
        temporary = Path(temporary)
        commands = [
            ['exams/verify.py'],
            ['tools/check_recent_exams.py'],
            ['homework/quartz-4b7e/verify.py', '--iverilog', args.iverilog, '--vvp', args.vvp,
             '--cxx', args.cxx, '--json', str(temporary / 'quartz.json')],
            ['homework/cedar-8f2c/verification/run_checks.py', '--iverilog', args.iverilog,
             '--vvp', args.vvp, '--output', str(temporary / 'cedar.json')]]
        for command in commands:
            result = subprocess.run([sys.executable, str(ROOT / command[0]), *command[1:]],
                                    cwd=ROOT, capture_output=True, text=True, errors='replace', timeout=300)
            if result.returncode:
                raise RuntimeError(f'{command[0]} failed\n{result.stdout[-6000:]}\n{result.stderr[-2000:]}')
            print(f'PASS {command[0]}', flush=True)
        quartz = json.loads((temporary / 'quartz.json').read_text(encoding='utf-8'))
        assert quartz['total_checks'] == 1900
        cedar = json.loads((temporary / 'cedar.json').read_text(encoding='utf-8'))
        counts = {item['name']: item.get('counts') for item in cedar['tests']}
        assert counts['sweep-bist'] == {'normal_bad': 0, 'detection_bad': 0,
                                       'location_bad': 0, 'repair_bad': 0, 'faults': 160}
        assert counts['sweep-bisr'] == {'normal_bad': 0, 'detection_bad': 0,
                                       'location_bad': 34, 'repair_bad': 37, 'faults': 160}
        print('PASS known counterexamples reproduced; student programs remain reference material')


if __name__ == '__main__':
    main()
