#include<iostream>
using namespace std;

class Circuit{
public:
    bool golden_output[8];
    int golden_signature[2];
    int golden_parity[8];
    int golden_one;
    bool foward(int fault_location, bool a, bool b, bool c, bool d);
};

int* parity_test(bool data[8]);
void print(int fault);

int main(void){
    
    // circuit
    Circuit circuit;
    // 8 inputs
    bool a[8] = {1, 1, 1, 1, 0, 0, 0, 0};
    bool b[8] = {1, 1, 0, 0, 1, 1, 0, 0};
    bool c[8] = {1, 0, 1, 0, 1, 0, 1, 0};
    bool d[8] = {1, 0, 1, 0, 1, 1, 1, 0};
    

    bool result[8];
    cout << endl;
    for( int i = 0; i <= 14; i++ ){
        bool result[8];
        for( int j = 0; j < 8; j++ ){
            result[j] = circuit.foward(i, a[j], b[j], c[j], d[j]);
            if( i == 0 ) circuit.golden_output[j] = result[j];
        }
        int* signature = new int[2];
        signature = parity_test(result);
        print(i);
        cout << "Output: ";
        for(int j = 0; j < 8; j++ ){
            cout << result[j];
        }
        cout << endl;
        if(signature[0] == 0) cout << "Even parity.\n";
        else cout << "Odd parity.\n";
        cout << "One's count: " << signature[1] << endl;
        if( i == 0 ){
            circuit.golden_signature[0] = signature[0];
            circuit.golden_signature[1] = signature[1];
        }
        else{
            if( signature[0] != circuit.golden_signature[0] )
                cout << "Find fault by parity testing!\n";
            else
                cout << "Parity testing doesn't find any fault.\n";
            if( signature[1] != circuit.golden_signature[1] )
                cout << "Find fault by one's count!\n ";
            else
                cout << "One's count doens't find any fault.\n";
        }
        cout << endl;
    }
    
    return 0;
}

//  signature[0]: parity test, 0 for even, 1 for odd
//  signature[1]: one's test, count number of 1's
int* parity_test(bool data[8]){
    int *signature = new int[2];
    signature[1] = 0;
    for( int i = 0; i < 8; i++ ){
        if( data[i] == 1 ) signature[1] += 1;
    }
    if( signature[1] %2 == 0 ) signature[0] = 0;
    else signature[0] = 1;
    return signature;
}

// simulate circuit with fault free and falty
bool Circuit::foward(int fault_location, bool a, bool b, bool c, bool d){
    bool z, e, f;
    switch (fault_location)
    {
    case 0:     // fault free
        e = a & b;
        f = !(c & d);
        z = !(e | f);
        break;
    
    case 1:     // SA0 at a
        e = 0;
        f = !(c & d);
        z = !(e | f);
        break;
    
    case 2:     // SA1 at a
        e = b;
        f = !(c & d);
        z = !(e | f);
        break;

    case 3:     // SA0 at b
        e = 0;
        f = !(c & d);
        z = !(e | f);
        break;

    case 4:     // SA1 at b
        e = a;
        f = !(c & d);
        z = !(e | f);
        break;

    case 5:     // SA0 at c
        e = a & b;
        f = 1;
        z = !(e | f);
        break;
    
    case 6:     // SA1 at c
        e = a & b;
        f = !d;
        z = !(e | f);
        break;
    
    case 7:     // SA0 at d
        e = a & b;
        f = 1;
        z = !(e | f);
        break;
    
    case 8:     // SA1 at d
        e = a & b;
        f = !c;
        z = !(e | f);
        break;
    
    case 9:     // SA0 at e
        e = 0;
        f = !(c & d);
        z = !(e | f);
        break;
    
    case 10:     // SA1 at e
        e = 1;
        f = !(c & d);
        z = !(e | f);
        break;
    
    case 11:     // SA0 at f
        e = a & b;
        f = 0;
        z = !(e | f);
        break;
    
    case 12:     // SA1 at f
        e = a & b;
        f = 1;
        z = !(e | f);
        break;
    
    case 13:     // SA0 at z
        z = 0;
        break;
    
    case 14:     // SA1 at z
        z = 1;
        break;
    
    default:
        cout << "Error\n";
        break;
    }

    return z;
}

void print(int fault){
    switch (fault)
    {
    case 0:
        cout << "Fault free\n";
        break;
    case 1:
        cout << "SA0 at a\n";
        break;
    case 2:
        cout << "SA1 at a\n";
        break;
    case 3:
        cout << "SA0 at b\n";
        break;
    case 4:
        cout << "SA1 at b\n";
        break;
    case 5:
        cout << "SA0 at c\n";
        break;
    case 6:
        cout << "SA1 at c\n";
        break;
    case 7:
        cout << "SA0 at d\n";
        break;
    case 8:
        cout << "SA1 at d\n";
        break;
    case 9:
        cout << "SA0 at e\n";
        break;
    case 10:
        cout << "SA1 at e\n";
        break;
    case 11:
        cout << "SA0 at f\n";
        break;
    case 12:
        cout << "SA1 at f\n";
        break;
    case 13:
        cout << "SA0 at z\n";
        break;
    case 14:
        cout << "SA1 at z\n";
        break;
    default:
        break;
    }
}