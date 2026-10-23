"""Reproduce finite Boolean checks used by the rebuilt examination solutions.

No external packages. A circuit is an explicit topologically ordered netlist.
Faults include each signal stem and each individual gate-input branch.
This verifies the stated reconstruction, not the fidelity of a scanned drawing.
"""
from itertools import product
import json


def gate(kind, a):
    if kind == 'NOT': return 1-a[0]
    if kind == 'BUF': return a[0]
    v = {'AND': all, 'NAND': all, 'OR': any, 'NOR': any}.get(kind)
    if v:
        r = int(v(a))
        return 1-r if kind in ('NAND', 'NOR') else r
    r = sum(a) % 2
    return 1-r if kind == 'XNOR' else r


def evaluate(inputs, gates, outputs, bits, fault=None):
    d = dict(zip(inputs, bits))
    if fault and fault[0] == 'stem' and fault[1] in d: d[fault[1]] = fault[-1]
    for name, kind, args in gates:
        a = [d[x] for x in args]
        if fault and fault[0] == 'branch' and fault[1] == name: a[fault[2]] = fault[-1]
        d[name] = gate(kind, a)
        if fault and fault[0] == 'stem' and fault[1] == name: d[name] = fault[-1]
    return tuple(d[x] for x in outputs)


def complete_cover(inputs, gates, outputs):
    faults = [('stem', name, sa) for name in inputs + [g[0] for g in gates] for sa in (0, 1)]
    faults += [('branch', name, i, sa) for name, _, args in gates for i in range(len(args)) for sa in (0, 1)]
    patterns = list(product((0, 1), repeat=len(inputs)))
    detect = {}
    for bits in patterns:
        good = evaluate(inputs, gates, outputs, bits)
        detect[bits] = {f for f in faults if evaluate(inputs, gates, outputs, bits, f) != good}
    detectable = set().union(*detect.values())
    remaining = detectable.copy()
    cover = []
    while remaining:
        bits = max(patterns, key=lambda b: (len(detect[b] & remaining), tuple(-x for x in b)))
        cover.append(''.join(map(str, bits)))
        remaining -= detect[bits]
    assert set().union(*(detect[tuple(map(int, b))] for b in cover)) == detectable
    return {'patterns': cover, 'faults': len(faults), 'detected': len(detectable),
            'redundant': [list(f) for f in faults if f not in detectable]}


def scoap(inputs, gates, outputs):
    cc = {x: (1, 1) for x in inputs}
    for name, kind, args in gates:
        pairs = [cc[x] for x in args]
        if kind in ('AND', 'NAND'):
            z = min(v[0] for v in pairs)+1
            o = sum(v[1] for v in pairs)+1
            cc[name] = (o,z) if kind == 'NAND' else (z,o)
            continue
        if kind in ('OR', 'NOR'):
            z = sum(v[0] for v in pairs)+1
            o = min(v[1] for v in pairs)+1
            cc[name] = (o,z) if kind == 'NOR' else (z,o)
            continue
        costs = [[], []]
        for bits in product((0, 1), repeat=len(args)):
            costs[gate(kind, bits)].append(sum(pairs[i][b] for i, b in enumerate(bits))+1)
        cc[name] = tuple(min(x) for x in costs)
    co = {x: float('inf') for x in cc}
    co.update({x: 0 for x in outputs})
    branches = {}
    for name, kind, args in reversed(gates):
        for i, x in enumerate(args):
            best = float('inf')
            for others in product((0, 1), repeat=len(args)-1):
                a = list(others); a.insert(i, 0)
                b = a.copy(); b[i] = 1
                if gate(kind, a) != gate(kind, b):
                    best = min(best, sum(cc[y][a[k]] for k, y in enumerate(args) if k != i))
            branches[f'{x}->{name}'] = co[name]+best+1
            co[x] = min(co[x], branches[f'{x}->{name}'])
    return {'signals': {x: [*cc[x], co[x]] for x in cc}, 'branch_CO': branches}


def lfsr(word, year):
    galois_taps = (0, 3, 4, 5) if year == 2009 else (0, 2, 4, 5)
    fibonacci_taps = (0, 1, 2, 5) if year == 2009 else (0, 1, 3, 5)
    rows = {}
    for mode in ('galois', 'fibonacci'):
        r = [0]*6; out = []
        for ch in word[::-1]:
            u = int(ch); out.append(r[5])
            if mode == 'galois':
                old = r[5]; r = [u] + r[:5]
                for j in galois_taps: r[j] ^= old
            else:
                v = u
                for j in fibonacci_taps: v ^= r[j]
                r = [v]+r[:5]
        rows[mode] = {'serial_out_first_to_last': ''.join(map(str, out)),
                      'signature_r0_to_r5': ''.join(map(str, r))}
    return rows


def run():
    g09 = [('g1','XNOR',['X2','Q1']), ('g2','XNOR',['g1','Q2']),
           ('h','XNOR',['g2','Q3']), ('Y','OR',['X1','h']),
           ('D1','BUF',['g2']),('D2','BUF',['h']),('D3','BUF',['g1'])]
    g13 = [('g1','XNOR',['X2','Q1']), ('g2','XNOR',['g1','Q2']),
           ('h','XOR',['g2','Q3']), ('Y','NOR',['X1','h','Q4']),
           ('D1','BUF',['g2']),('D2','BUF',['Q1']),('D3','BUF',['g1']),('D4','BUF',['Q3'])]
    data = {'scan_2009': complete_cover(['X1','X2','Q1','Q2','Q3'], g09, ['D1','D2','D3','Y']),
            'scan_2013_2014': complete_cover(['X1','X2','Q1','Q2','Q3','Q4'], g13, ['D1','D2','D3','D4','Y'])}
    circuits = {
        'scoap_2009a': (['A','B'], [('n','NAND',['A','B']), ('u','NAND',['A','n']), ('v','NAND',['B','n']), ('Z','NAND',['u','v'])], ['Z']),
        'scoap_2009b': (['A','S','B'], [('n','NOT',['S']),('u','AND',['A','S']),('v','AND',['B','n']),('Z','OR',['u','v'])], ['Z']),
        'scoap_2013': (['X1','X2','X3','X4'], [('N','NAND',['X2','X3']),('E','AND',['X1','N']),('M','NAND',['N','X4']),('I','NOT',['X3']),('L','AND',['I','X4']),('F','OR',['E','M','L'])], ['E','F']),
        'scoap_2014': (['X1','X2','X3','X4'], [('N','AND',['X2','X3']),('J','NOT',['X4']),('I','NOT',['X3']),('E','AND',['X1','N']),('M','AND',['N','J']),('L','AND',['I','X4']),('F','OR',['E','M','L'])], ['F']),
    }
    for name,(inputs,gates,outputs) in circuits.items(): data[name] = scoap(inputs,gates,outputs)
    for y, w in [(2009,'10000111011001001110101'),(2013,'10000111011001001110101'),(2014,'10110111011001001000101')]:
        data[f'lfsr_{y}'] = lfsr(w,y)
        assert data[f'lfsr_{y}']['galois']['serial_out_first_to_last'] == data[f'lfsr_{y}']['fibonacci']['serial_out_first_to_last']
    assert data['scan_2009']['detected'] == data['scan_2009']['faults'] == 46
    assert data['scan_2013_2014']['detected'] == data['scan_2013_2014']['faults'] == 54
    assert data['scoap_2009a']['signals']['Z'] == [5,5,0]
    assert data['scoap_2013']['signals']['F'] == [9,3,0]
    assert data['scoap_2014']['signals']['F'] == [8,5,0]
    # The UDL XOR tree: fixed printed solution, including pin branches.
    ui=['a','b','c','d']
    ug=[('u','XOR',['a','b']),('v','XOR',['c','d']),('F','XOR',['u','v'])]
    uf=[('stem',x,s) for x in ui+['u','v','F'] for s in (0,1)]
    uf += [('branch',x,i,s) for x,_,args in ug for i in range(len(args)) for s in (0,1)]
    up=['0000','1000','0010','1111']
    assert all(any(evaluate(ui,ug,['F'],tuple(map(int,p)),f)!=evaluate(ui,ug,['F'],tuple(map(int,p))) for p in up) for f in uf)
    # Printed deductive-fault examples, using ordinary serial simulation.
    di=list('ABCDEF')
    dg=[('N','NOR',['D','E']),('P','AND',['A','B']),('Q','AND',['C','N']),('R','AND',['F','N']),('Z','OR',['P','Q','R'])]
    df=[('stem','A',1),('stem','E',0),('branch','Q',1,1),('branch','R',1,1)]
    for p, expected in [('011011',[True,True,True,True]),('011111',[True,False,True,True])]:
        bits=tuple(map(int,p)); good=evaluate(di,dg,['Z'],bits)
        assert [evaluate(di,dg,['Z'],bits,f)!=good for f in df] == expected
    # Functional pin coverage can miss the inverter-output stuck-at-1.
    hi=['A','B','Sel']
    hg=[('n','NOT',['Sel']),('C','AND',['A','Sel']),('D','AND',['B','n']),('Z','OR',['C','D'])]
    hp=['000','001','010','101']
    for x in hi+['Z']:
        for sa in (0,1):
            assert any(evaluate(hi,hg,['Z'],tuple(map(int,p)),('stem',x,sa))!=evaluate(hi,hg,['Z'],tuple(map(int,p))) for p in hp)
    assert not any(evaluate(hi,hg,['Z'],tuple(map(int,p)),('stem','n',1))!=evaluate(hi,hg,['Z'],tuple(map(int,p))) for p in hp)
    # Independent truth-table checks for stated fault tests.
    for a,b,c in product((0,1),repeat=3):
        good = a*b*(1-c)
        observed = [0, a*(1-c), 0, 0]
        expected = [bool(a and b and not c), bool(a and not b and not c), bool(a and b and not c), bool(a and b and not c)]
        assert [good != v for v in observed] == expected
    # Eight constant-size adder-cell tests, including observation at all sum pins.
    for n in range(1,9):
        tests = [(xy,ci) for xy in [(0,0),(1,1),(0,1),(1,0)] for ci in (0,1)]
        vectors=[]
        for xy,ci in tests:
            if xy==(0,0) and ci==1: pairs=[(0,0) if i%2==0 else (1,1) for i in range(n)]
            elif xy==(1,1) and ci==0: pairs=[(1,1) if i%2==0 else (0,0) for i in range(n)]
            else: pairs=[xy]*n
            vectors.append((pairs,ci))
        for index in range(n):
            seen=set()
            for pairs,ci in vectors:
                c=ci
                for i,(x,y) in enumerate(pairs):
                    if i==index: seen.add((x,y,c))
                    c=int(x+y+c>=2)
            assert len(seen)==8
    data['assertions'] = 'scan, UDL, deductive simulation, hidden mux, SCOAP anchors, LFSR equivalence, dominance and adder-cell checks passed'
    return data


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
