#!/bin/bash
set -e

python -c "
import numpy as np
np.random.seed(42)
n = 50
A = np.random.uniform(-50, 50, (n, n))
true_x = np.random.uniform(-10, 10, n)
B = A.dot(true_x)
AB = np.column_stack((A, B))
np.savetxt('test_input_AB.csv', AB, delimiter=',', fmt='%.10f')
np.savetxt('test_expected_X.csv', true_x, delimiter=',', fmt='%.10f')
"

./gauss test_input_AB.csv test_output_X.csv

python -c "
import sys
import numpy as np
try:
    expected = np.loadtxt('test_expected_X.csv')
    output = np.loadtxt('test_output_X.csv')
    
    if np.allclose(expected, output, atol=1e-5):
        print('[OK] Integration test passed! The outputs match numerically.')
        sys.exit(0)
    else:
        print('[FAILED] The output differs from the expected result.')
        print('Max difference:', np.max(np.abs(expected - output)))
        sys.exit(1)
except Exception as e:
    print('[FAILED] Error during comparison: ' + str(e))
    sys.exit(1)
"

rm -f test_input_AB.csv test_expected_X.csv test_output_X.csv