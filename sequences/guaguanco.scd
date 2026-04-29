var o, p;
o = [
	Dictionary.prNew,  Array.prNew(64),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(5),  Array.prNew(1),  Array.prNew(11),  Array.prNew(2),  
	Array.prNew(1),  Array.prNew(6),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(6),  Array.prNew(6),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(6)
];
p = [
	// Dictionary
	0, [ array: o[1],  size: 10 ],  
	// Array
	1, [ nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'mutes',  o[2],  
		'rhythms',  o[3],  nil,  nil,  
		'bpm',  110.77160493827,  'indices',  o[10],  
		nil,  nil,  'humAmp',  o[11],  
		nil,  nil,  nil,  nil,  
		'pitches',  o[12],  'humTime',  o[13],  
		nil,  nil,  'volumes',  o[14],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[15],  nil,  nil,  
		nil,  nil,  'sampleIndices',  o[16],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ false,  false,  false,  false,  
		false,  false ],  
	// Array
	3, [ o[4],  o[5],  o[6],  o[7],  
		o[8],  o[9] ],  
	// Array
	4, [ 0.75,  1,  0.7,  0.55,  
		1 ],  
	// Array
	5, [ 0.5 ],  
	// Array
	6, [ 0.25,  0.5,  0.25,  0.25,  
		0.5,  0.25,  0.5,  0.5,  
		0.25,  0.5,  0.25 ],  
	// Array
	7, [ -1.75,  0.25 ],  
	// Array
	8, [ 2 ],  
	// Array
	9, [ -1,  -0.5,  0.5,  -1,  
		-0.5,  0.5 ],  
	// Array
	10, [ 0,  14,  3,  12,  
		11,  7 ],  
	// Array
	11, [ 0.0,  0.0,  0.0,  0.0,  
		0.0,  0.0 ],  
	// Array
	12, [ 58.0,  61.0,  58.0,  50.0,  
		55.0,  63.0 ],  
	// Array
	13, [ 0.015593220338983,  0.015593220338983,  0.015593220338983,  0.015593220338983,  
		0.015593220338983,  0.015593220338983 ],  
	// Array
	14, [ 1.0,  0.12359550561798,  1.0,  0.50118723362727,  
		0.50118723362727,  0.74719101123596 ],  
	// Array
	15, [ 0.27272727272727,  0.090909090909091,  0.31818181818182,  0.58474576271186,  
		0.58474576271186,  0.31818181818182 ],  
	// Array
	16, [ 1,  3,  0,  5,  
		4,  2 ]
];
prUnarchive(o,p);
