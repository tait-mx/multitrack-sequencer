var o, p;
o = [
	Dictionary.prNew,  Array.prNew(64),  Array.prNew(7),  Array.prNew(7),  
	Array.prNew(5),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(2),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(11),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(2),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(15),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(6),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(7),  
	Array.prNew(7),  Array.prNew(7),  Array.prNew(7),  Array.prNew(7),  
	Array.prNew(7),  Array.prNew(7)
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
		'bpm',  128.68338557994,  'indices',  o[51],  
		nil,  nil,  'humAmp',  o[52],  
		nil,  nil,  nil,  nil,  
		'pitches',  o[53],  'humTime',  o[54],  
		nil,  nil,  'volumes',  o[55],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[56],  nil,  nil,  
		nil,  nil,  'sampleIndices',  o[57],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ false,  true,  false,  false,  
		false,  false,  true ],  
	// Array
	3, [ o[4],  o[10],  o[13],  o[25],  
		o[28],  o[44],  o[4] ],  
	// Array
	4, [ o[5],  o[6],  o[7],  o[8],  
		o[9] ],  
	// Array
	5, [ 0.75,  2,  1 ],  
	// Array
	6, [ 1,  2,  1 ],  
	// Array
	7, [ 0.7,  2,  1 ],  
	// Array
	8, [ 0.55,  2,  1 ],  
	// Array
	9, [ 1,  2,  1 ],  
	// Array
	10, [ o[11],  o[12] ],  
	// Array
	11, [ 0.5,  0,  1 ],  
	// Array
	12, [ 0.5,  0,  1 ],  
	// Array
	13, [ o[14],  o[15],  o[16],  o[17],  
		o[18],  o[19],  o[20],  o[21],  
		o[22],  o[23],  o[24] ],  
	// Array
	14, [ 0.25,  0,  1 ],  
	// Array
	15, [ 0.5,  0,  1 ],  
	// Array
	16, [ 0.25,  0,  1 ],  
	// Array
	17, [ 0.25,  0,  1 ],  
	// Array
	18, [ 0.5,  0,  1 ],  
	// Array
	19, [ 0.25,  0,  1 ],  
	// Array
	20, [ 0.5,  0,  1 ],  
	// Array
	21, [ 0.5,  0,  1 ],  
	// Array
	22, [ 0.25,  0,  1 ],  
	// Array
	23, [ 0.5,  0,  1 ],  
	// Array
	24, [ 0.25,  0,  1 ],  
	// Array
	25, [ o[26],  o[27] ],  
	// Array
	26, [ 1.75,  7,  1 ],  
	// Array
	27, [ 0.25,  8,  1 ],  
	// Array
	28, [ o[29],  o[30],  o[31],  o[32],  
		o[33],  o[34],  o[35],  o[36],  
		o[37],  o[38],  o[39],  o[40],  
		o[41],  o[42],  o[43] ],  
	// Array
	29, [ 0.25,  1,  0.25 ],  
	// Array
	30, [ 0.25,  10,  0.25 ],  
	// Array
	31, [ 0.25,  10,  0.25 ],  
	// Array
	32, [ 0.25,  1,  0.25 ],  
	// Array
	33, [ 0.25,  1,  0.25 ],  
	// Array
	34, [ 0.25,  10,  0.25 ],  
	// Array
	35, [ 0.25,  10,  0.25 ],  
	// Array
	36, [ 0.25,  10,  0.75 ],  
	// Array
	37, [ 0.5,  3,  1 ],  
	// Array
	38, [ 0.25,  10,  0.5 ],  
	// Array
	39, [ 0.25,  1,  0.5 ],  
	// Array
	40, [ 0.25,  1,  0.25 ],  
	// Array
	41, [ 0.25,  10,  0.25 ],  
	// Array
	42, [ 0.25,  10,  0.25 ],  
	// Array
	43, [ 0.25,  1,  0.25 ],  
	// Array
	44, [ o[45],  o[46],  o[47],  o[48],  
		o[49],  o[50] ],  
	// Array
	45, [ 1,  1,  0.135 ],  
	// Array
	46, [ 0.5,  1,  0.135 ],  
	// Array
	47, [ 0.5,  3,  1 ],  
	// Array
	48, [ 1,  1,  0.135 ],  
	// Array
	49, [ 0.5,  1,  0.135 ],  
	// Array
	50, [ 0.5,  3,  1 ],  
	// Array
	51, [ 0,  0,  4,  18,  
		14,  10,  0 ],  
	// Array
	52, [ 0.035593220338983,  0.035593220338983,  0.035593220338983,  0.035593220338983,  
		0.035593220338983,  0.035593220338983,  0.035593220338983 ],  
	// Array
	53, [ 46.0,  60,  62.0,  60,  
		62.0,  59.0,  46.0 ],  
	// Array
	54, [ 0.0027118644067797,  0.0027118644067797,  0.0027118644067797,  0.0027118644067797,  
		0.0027118644067797,  0.0027118644067797,  0.0027118644067797 ],  
	// Array
	55, [ 0.54130277195509,  0.7,  1.4962356560944,  0.7,  
		1.2242673728577,  0.84838200482362,  1.0913271240502 ],  
	// Array
	56, [ 0.19067796610169,  0.19067796610169,  0.19067796610169,  0.19067796610169,  
		0.19067796610169,  0.19067796610169,  0.19067796610169 ],  
	// Array
	57, [ 0,  1,  2,  3,  
		4,  5,  0 ]
];
prUnarchive(o,p);
