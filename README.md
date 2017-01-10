# iris-matlab
Biometric iris authentication (demo)

## Status
<table>
<tr>
<th>Tests</th><th>TP</th><th>FP</th><th>TN</th><th>FN</th><th>Precision</th><th>Recall</th><th>Accuracy</th>
</tr>
<tr>
<td>44</td><td>4</td><td>0</td><td>36</td><td>4</td><td>0.10</td><td>0.50</td><td>0.91</td>
</tr>
</table>

## Requirements
* **GNU Octave** or **Matlab**
* **CASIA-Iris-Interval** dataset

## Instructions
* Create a folder **dataset**
* Copy content of **CASIA-Iris-Interval** into **dataset** folder

## Examples
### Iris comparison
```bash
$ cd code
$ octave-cli demo.m
```
### Running tests
Tests can be run in order to verify code correctness.
The output contains details of eye images as they are being processed in various stages of program pipeline.
Furthermore, iris code distances are being computed to see whether:
* Two images of an eye that belong to a same person have a low Hamming distance
* Two images of an eye that belong to two different people have high Hamming distance
```bash
$ cd code
$ octave-cli run_test.m
```
Folder **results** contains test output.
