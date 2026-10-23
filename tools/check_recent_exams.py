"""Independent finite-model checks for the 2020/2021 reconstructed finals.

Only Python's standard library is needed. These checks make the chosen circuit
netlist and single-fault assumptions explicit; they do not model transistor defects.
"""
import itertools
import json

INPUTS = ('x1', 'x2', 'q1', 'q2', 'q3', 'q4')
GATES = [('a', 'xnor', ('x2', 'q1')), ('b', 'xnor', ('a', 'q2')),
         ('c', 'xor', ('b', 'q3')), ('d1', 'buf', ('b',)),
         ('d2', 'buf', ('q1',)), ('d3', 'buf', ('a',)),
         ('d4', 'buf', ('q3',)), ('y', 'nor', ('x1', 'c', 'q4'))]
OUTPUTS = ('d1', 'd2', 'd3', 'd4', 'y')


def circuit(pattern, fault=None):
    values = dict(zip(INPUTS, pattern))
    if fault and fault[0] in INPUTS:
        values[fault[0]] = fault[1]
    for name, kind, inputs in GATES:
        args = [fault[1] if fault and fault[0] == f'{name}.in{i}' else values[node]
                for i, node in enumerate(inputs)]
        value = (args[0] if kind == 'buf' else
                 int(not any(args)) if kind == 'nor' else
                 (args[0] ^ args[1]) ^ int(kind == 'xnor'))
        values[name] = fault[1] if fault and fault[0] == name else value
    return tuple(values[name] for name in OUTPUTS)


def scan_faults():
    sites = list(INPUTS) + [name for name, _, _ in GATES]
    sites += [f'{name}.in{i}' for name, _, inputs in GATES for i in range(len(inputs))]
    return [(site, stuck) for site in sites for stuck in (0, 1)]


def scan_check():
    faults = scan_faults()
    patterns = list(itertools.product((0, 1), repeat=6))
    detected = [{i for i, fault in enumerate(faults)
                 if circuit(pattern) != circuit(pattern, fault)} for pattern in patterns]
    universe = set(range(len(faults)))
    assert set().union(*detected) == universe
    # NOR-input activation requires the three one-hot cases and the all-zero case.
    # Search one pattern from each class instead of enumerating 64 choose 4.
    classes = []
    for control in [(0, 0, 0), (0, 1, 0), (0, 0, 1), (1, 0, 0)]:
        candidates = []
        for i, pattern in enumerate(patterns):
            x1, x2, q1, q2, q3, q4 = pattern
            a = 1 ^ x2 ^ q1
            b = 1 ^ a ^ q2
            if (x1, b ^ q3, q4) == control:
                candidates.append(i)
        classes.append(candidates)
    four = next((indices for indices in itertools.product(*classes)
                 if set().union(*(detected[i] for i in indices)) == universe), None)
    assert four is None
    remaining = set(universe)
    selected = []
    while remaining:
        index = max(range(len(patterns)), key=lambda i: len(remaining & detected[i]))
        selected.append(index)
        remaining -= detected[index]
    assert len(selected) == 5
    return {'faults': len(faults), 'patterns': [''.join(map(str, patterns[i])) for i in selected],
            'expected_D1_D2_D3_D4_Y': [''.join(map(str, circuit(patterns[i]))) for i in selected],
            'detected': len(universe)}


def march(elements, fault=None, cells=2):
    memory = [0] * cells
    for direction, operations in elements:
        for address in (range(cells) if direction != 'down' else range(cells - 1, -1, -1)):
            for operation, bit in operations:
                if fault and fault[0] == 'state':
                    _, aggressor, victim, state, forced = fault
                    if memory[aggressor] == state:
                        memory[victim] = forced
                if operation == 'r':
                    if memory[address] != bit:
                        return False
                else:
                    old = memory[address]
                    if fault and fault[0] == 'stuck' and address == fault[1]:
                        memory[address] = fault[2]
                    elif fault and fault[0] == 'transition' and address == fault[1] and (old, bit) == fault[2:]:
                        pass
                    else:
                        memory[address] = bit
                    if fault and fault[0] in ('invert', 'force'):
                        kind, aggressor, victim, before, after, forced = fault
                        if address == aggressor and (old, memory[address]) == (before, after):
                            memory[victim] = 1 - memory[victim] if kind == 'invert' else forced
    return True


def elem(direction, *ops):
    return direction, [(text[0], int(text[1])) for text in ops]


MARCH_C_MINUS = [elem('up', 'w0'), elem('up', 'r0', 'w1'), elem('up', 'r1', 'w0'),
                 elem('down', 'r0', 'w1'), elem('down', 'r1', 'w0'), elem('up', 'r0')]


def march_checks():
    faults = [('stuck', cell, bit) for cell in range(2) for bit in (0, 1)]
    faults += [('transition', cell, before, 1 - before) for cell in range(2) for before in (0, 1)]
    for aggressor, victim in ((0, 1), (1, 0)):
        for before in (0, 1):
            faults.append(('invert', aggressor, victim, before, 1 - before, None))
            faults.extend(('force', aggressor, victim, before, 1 - before, forced) for forced in (0, 1))
            faults.extend(('state', aggressor, victim, before, forced) for forced in (0, 1))
    assert march(MARCH_C_MINUS)
    assert all(not march(MARCH_C_MINUS, fault) for fault in faults)
    candidates = [
        [elem('up', 'w0'), elem('up', 'r0', 'w1', 'r1'), elem('down', 'r0', 'w0', 'r0')],
        [elem('up', 'w0'), elem('up', 'r1', 'w0', 'r0'), elem('down', 'r1', 'w0', 'r0')],
        [elem('up', 'w1'), elem('up', 'r1', 'w0', 'r0'), elem('down', 'r0', 'w1', 'r1')],
        [elem('up', 'w1'), elem('up', 'r1', 'w1', 'r1'), elem('down', 'r1', 'w0', 'r0')]]
    assert [march(test) for test in candidates] == [False, False, True, True]
    test1 = [elem('up', 'w1'), elem('up', 'r1', 'w0'), elem('down', 'r0', 'w1', 'r1')]
    test2 = [elem('up', 'w0'), elem('up', 'r0', 'w1'), elem('down', 'r1', 'w0')]
    test3 = [elem('up', 'w0'), elem('up', 'r0', 'w1'), elem('down', 'r1', 'w0', 'r0')]
    single = faults[:8]
    assert all(not march(test1, fault) and not march(test3, fault) for fault in single)
    assert all(march(test2, ('transition', cell, 1, 0)) for cell in range(2))
    return {'March_C_minus_two_cell_single_faults': len(faults),
            'valid_tests_in_2020_Q5a': [3, 4], 'complete_SAF_TF_tests_in_Q5b': [1, 3]}


def tap_reset():
    # IEEE 1149.1 state transition table: entries are next states for TMS=0,1.
    transitions = [(1, 0), (1, 2), (3, 9), (4, 5), (4, 5), (6, 8), (6, 7), (4, 8),
                   (1, 2), (10, 0), (11, 12), (11, 12), (13, 15), (13, 14), (11, 15), (1, 2)]
    for state in range(16):
        for _ in range(5):
            state = transitions[state][1]
        assert state == 0
    return {'states_reset_by_five_TMS_ones': 16}


def schedule():
    lengths = [120, 240, 240, 120]
    # Assign each intact chain to one of three parallel TAM lanes, allowing serial concatenation.
    loads = [tuple(sum(length for length, lane in zip(lengths, allocation) if lane == i)
                   for i in range(3)) for allocation in itertools.product(range(3), repeat=4)]
    assert min(map(max, loads)) == 240
    return {'unrestricted_crossbar_lower_bound_bits': 240,
            'crossbar_example_not_available_in_exam_muxes': [[1, 4], [2], [3]],
            'exam_fixed_routes': [[1, 3], [2, 4]],
            'exam_internal_scan_lane_bits': max(lengths[0] + lengths[2], lengths[1] + lengths[3])}


if __name__ == '__main__':
    print(json.dumps({'scan_2021': scan_check(), 'march': march_checks(),
                      'TAP': tap_reset(), 'TAM_2020': schedule()}, indent=2))
