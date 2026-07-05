var o, p;
o = [
	Dictionary.prNew,  Array.prNew(128),  Array.prNew(8),  Array.prNew(7),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(11),  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(2),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(6),  Array.prNew(3),  Array.prNew(3),  
	"llsp",  Array.prNew(3),  "llsp",  Array.prNew(3),  
	Array.prNew(3),  "llaf",  Array.prNew(3),  "llsp",  
	Array.prNew(6),  Array.prNew(3),  "llcp",  Array.prNew(3),  
	"llcp",  Array.prNew(3),  "llap",  Array.prNew(3),  
	"llcp",  Array.prNew(3),  "llcp",  Array.prNew(3),  
	"llap",  Array.prNew(4),  Array.prNew(3),  "llcmf",  
	Array.prNew(3),  "llcmf",  Array.prNew(3),  "llcmf",  
	Array.prNew(3),  "llamf",  Array.prNew(1),  Array.prNew(3),  
	Array.prNew(8),  "Clave",  "Cáscara",  "Shekere",  
	"----",  "----",  "Llamador",  "Golpe",  
	"CORO",  Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  
	Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  
	Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  
	Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  
	Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  Array.prNew(8)
];
p = [
	// Dictionary
	0, [ array: o[1],  size: 17 ],  
	// Array
	1, [ nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'chorusRefBpm',  105,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'rhythms',  o[2],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'trackNames',  o[72],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'pitches',  o[81],  'temaBpm',  85.235109717868,  
		nil,  nil,  nil,  nil,  
		'seccion',  'tema',  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'currentSongIdx',  -1,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'solos',  o[82],  
		nil,  nil,  nil,  nil,  
		'eqParams',  o[83],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'mutes',  o[92],  
		nil,  nil,  nil,  nil,  
		'indices',  o[93],  nil,  nil,  
		nil,  nil,  'humAmp',  o[94],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'humTime',  o[95],  
		nil,  nil,  'volumes',  o[96],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[97],  nil,  nil,  
		'montunoIndices',  o[98],  'sampleIndices',  o[99],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ o[3],  o[11],  o[34],  o[37],  
		o[48],  o[37],  o[61],  o[70] ],  
	// Array
	3, [ o[4],  o[5],  o[6],  o[7],  
		o[8],  o[9],  o[10] ],  
	// Array
	4, [ 0.75,  2,  1 ],  
	// Array
	5, [ 0.25,  2,  1 ],  
	// Array
	6, [ 0.75,  2,  1 ],  
	// Array
	7, [ 0.25,  2,  1 ],  
	// Array
	8, [ 0.5,  2,  1 ],  
	// Array
	9, [ 0.5,  2,  1 ],  
	// Array
	10, [ 1,  2,  1 ],  
	// Array
	11, [ o[12],  o[14],  o[16],  o[18],  
		o[20],  o[22],  o[24],  o[26],  
		o[28],  o[30],  o[32] ],  
	// Array
	12, [ 0.25,  o[13],  1 ],  
	// Array
	14, [ 0.5,  o[15],  1 ],  
	// Array
	16, [ 0.25,  o[17],  1 ],  
	// Array
	18, [ 0.25,  o[19],  1 ],  
	// Array
	20, [ 0.5,  o[21],  1 ],  
	// Array
	22, [ 0.25,  o[23],  1 ],  
	// Array
	24, [ 0.5,  o[25],  1 ],  
	// Array
	26, [ 0.5,  o[27],  1 ],  
	// Array
	28, [ 0.25,  o[29],  1 ],  
	// Array
	30, [ 0.5,  o[31],  1 ],  
	// Array
	32, [ 0.25,  o[33],  1 ],  
	// Array
	34, [ o[35],  o[36] ],  
	// Array
	35, [ 1.75,  7,  1 ],  
	// Array
	36, [ 0.25,  8,  1 ],  
	// Array
	37, [ o[38],  o[39],  o[41],  o[43],  
		o[44],  o[46] ],  
	// Array
	38, [ 0.46875,  0,  0 ],  
	// Array
	39, [ 0.28125,  o[40],  1 ],  
	// Array
	41, [ 0.25,  o[42],  1 ],  
	// Array
	43, [ 0.46875,  0,  0 ],  
	// Array
	44, [ 0.28125,  o[45],  1 ],  
	// Array
	46, [ 0.25,  o[47],  1 ],  
	// Array
	48, [ o[49],  o[51],  o[53],  o[55],  
		o[57],  o[59] ],  
	// Array
	49, [ 1,  o[50],  0.25 ],  
	// Array
	51, [ 0.5,  o[52],  0.25 ],  
	// Array
	53, [ 0.5,  o[54],  1 ],  
	// Array
	55, [ 1,  o[56],  0.25 ],  
	// Array
	57, [ 0.5,  o[58],  0.25 ],  
	// Array
	59, [ 0.5,  o[60],  1 ],  
	// Array
	61, [ o[62],  o[64],  o[66],  o[68] ],  
	// Array
	62, [ 0.75,  o[63],  0.35 ],  
	// Array
	64, [ 0.25,  o[65],  0.35 ],  
	// Array
	66, [ 0.5,  o[67],  0.35 ],  
	// Array
	68, [ 0.5,  o[69],  1 ],  
	// Array
	70, [ o[71] ],  
	// Array
	71, [ 4,  0,  0 ],  
	// Array
	72, [ o[73],  o[74],  o[75],  o[76],  
		o[77],  o[78],  o[79],  o[80] ],  
	// Array
	81, [ 47.0,  56.0,  59.0,  60,  
		59.0,  59.0,  57.0,  47.0 ],  
	// Array
	82, [ false,  false,  false,  false,  
		false,  false,  false,  false ],  
	// Array
	83, [ o[84],  o[85],  o[86],  o[87],  
		o[88],  o[89],  o[90],  o[91] ],  
	// Array
	84, [ 200,  0,  0.707,  811.17744821837,  
		4.810973251498,  2.9566466888436,  5000,  0,  
		0.707,  false,  0.7 ],  
	// Array
	85, [ 200,  0,  0.707,  1299.9385962009,  
		8.294843746021,  3.2967066223129,  5000,  0,  
		0.707,  false,  0.0 ],  
	// Array
	86, [ 200,  0,  0.707,  1089.6207143201,  
		18.019178391686,  3.0063920688831,  4285.0935175701,  6.763790240975,  
		2.4200599334693,  false,  0 ],  
	// Array
	87, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	88, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	89, [ 265.38633706149,  9.8223264534456,  4.1733533111564,  3716.4022491013,  
		11.450408188332,  4.4644258363731,  10019.005919989,  10.566001764067,  
		5.1287361530028,  false,  3.0 ],  
	// Array
	90, [ 150.88225517816,  22.978503709466,  0.595,  200,  
		-12.154201045132,  0.44984272328515,  6269.2440658644,  18.019178391686,  
		4.6767722283573,  false,  7.6 ],  
	// Array
	91, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	92, [ false,  false,  false,  true,  
		true,  false,  false,  false ],  
	// Array
	93, [ 2,  5,  11,  25,  
		15,  25,  16,  0 ],  
	// Array
	94, [ 0.027966101694915,  0.027966101694915,  0.027966101694915,  0.027966101694915,  
		0.027966101694915,  0.027966101694915,  0.027966101694915,  0.027966101694915 ],  
	// Array
	95, [ 0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  
		0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  0.0088135593220339 ],  
	// Array
	96, [ 1.1057207257138,  1.0346965601279,  0.73837713440461,  1.3971321692305,  
		0.7,  1.0346965601279,  0.96603200137215,  0.71496983465007 ],  
	// Array
	97, [ 0.15254237288136,  0.15254237288136,  0.15254237288136,  0.15254237288136,  
		0.15254237288136,  0.15254237288136,  0.15254237288136,  0.15254237288136 ],  
	// Array
	98, [ 2,  5,  12,  25,  
		15,  26,  17,  0 ],  
	// Array
	99, [ 0,  1,  2,  3,  
		4,  5,  0,  0 ]
];
prUnarchive(o,p);
