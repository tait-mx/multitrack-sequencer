var o, p;
o = [
	Dictionary.prNew,  Array.prNew(64),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(2),  Array.prNew(7),  Array.prNew(11),  Array.prNew(2),  
	Array.prNew(2),  Array.prNew(8),  Array.prNew(6),  Array.prNew(6),  
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
		'bpm',  131.94444444444,  'indices',  o[10],  
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
	2, [ true,  false,  false,  true,  
		false,  false ],  
	// Array
	3, [ o[4],  o[5],  o[6],  o[7],  
		o[8],  o[9] ],  
	// Array
	4, [ 0.5,  0.5 ],  
	// Array
	5, [ 0.66666666666667,  0.66666666666667,  0.33333333333333,  0.66666666666667,  
		0.66666666666667,  0.66666666666667,  0.33333333333333 ],  
	// Array
	6, [ 0.5,  0.25,  0.5,  0.5,  
		0.25,  0.5,  0.5,  0.25,  
		0.25,  0.25,  0.25 ],  
	// Array
	7, [ 0.5,  0.5 ],  
	// Array
	8, [ 1,  1 ],  
	// Array
	9, [ -1.0,  -0.33333333333333,  0.33333333333333,  0.33333333333333,  
		-1.0,  -0.33333333333333,  0.33333333333333,  0.33333333333333 ],  
	// Array
	10, [ 0,  2,  3,  0,  
		15,  8 ],  
	// Array
	11, [ 0.096610169491525,  0.096610169491525,  0.096610169491525,  0.096610169491525,  
		0.096610169491525,  0.096610169491525 ],  
	// Array
	12, [ 60,  65.0,  51.0,  60,  
		59.0,  64.0 ],  
	// Array
	13, [ 0,  0,  0,  0,  
		0,  0 ],  
	// Array
	14, [ 0.50118723362727,  0.58538536481818,  1.0,  0.38655322624632,  
		0.43025005075584,  0.38141287482832 ],  
	// Array
	15, [ 0,  0,  0,  0,  
		0.72727272727273,  0 ],  
	// Array
	16, [ 0,  3,  0,  0,  
		4,  2 ]
];
prUnarchive(o,p);
