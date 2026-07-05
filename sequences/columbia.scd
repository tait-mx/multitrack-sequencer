var o, p;
o = [
	Dictionary.prNew,  Array.prNew(128),  Array.prNew(8),  Array.prNew(5),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(1),  Array.prNew(3),  Array.prNew(11),  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(2),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  "llcmf",  
	Array.prNew(3),  "llamf",  Array.prNew(3),  "llamf",  
	Array.prNew(5),  Array.prNew(3),  "llcmf",  Array.prNew(3),  
	"llsmf",  Array.prNew(3),  "llcmf",  Array.prNew(3),  
	"llamf",  Array.prNew(3),  "llamf",  Array.prNew(1),  
	Array.prNew(3),  Array.prNew(8),  "CAMPANA",  "-----",  
	"CATA",  "SHEKERE",  "LLAMADOR",  "GOLPE",  
	"-----",  "CHORO",  Array.prNew(8),  Array.prNew(8),  
	Array.prNew(8),  Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  
	Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  
	Array.prNew(11),  Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  
	Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  
	Array.prNew(8)
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
		'trackNames',  o[57],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'pitches',  o[66],  'temaBpm',  139.43573667712,  
		nil,  nil,  nil,  nil,  
		'seccion',  'tema',  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'currentSongIdx',  -1,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'solos',  o[67],  
		nil,  nil,  nil,  nil,  
		'eqParams',  o[68],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'mutes',  o[77],  
		nil,  nil,  nil,  nil,  
		'indices',  o[78],  nil,  nil,  
		nil,  nil,  'humAmp',  o[79],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'humTime',  o[80],  
		nil,  nil,  'volumes',  o[81],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[82],  nil,  nil,  
		'montunoIndices',  o[83],  'sampleIndices',  o[84],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ o[3],  o[9],  o[11],  o[34],  
		o[37],  o[44],  o[9],  o[55] ],  
	// Array
	3, [ o[4],  o[5],  o[6],  o[7],  
		o[8] ],  
	// Array
	4, [ 0.66666666666667,  4,  1 ],  
	// Array
	5, [ 1.0,  4,  1 ],  
	// Array
	6, [ 0.66666666666667,  4,  1 ],  
	// Array
	7, [ 0.66666666666667,  4,  1 ],  
	// Array
	8, [ 1.0,  4,  1 ],  
	// Array
	9, [ o[10] ],  
	// Array
	10, [ 4,  0,  0 ],  
	// Array
	11, [ o[12],  o[14],  o[16],  o[18],  
		o[20],  o[22],  o[24],  o[26],  
		o[28],  o[30],  o[32] ],  
	// Array
	12, [ 0.5,  o[13],  1 ],  
	// Array
	14, [ 0.25,  o[15],  1 ],  
	// Array
	16, [ 0.5,  o[17],  1 ],  
	// Array
	18, [ 0.5,  o[19],  1 ],  
	// Array
	20, [ 0.25,  o[21],  1 ],  
	// Array
	22, [ 0.5,  o[23],  1 ],  
	// Array
	24, [ 0.5,  o[25],  1 ],  
	// Array
	26, [ 0.25,  o[27],  1 ],  
	// Array
	28, [ 0.25,  o[29],  1 ],  
	// Array
	30, [ 0.25,  o[31],  1 ],  
	// Array
	32, [ 0.25,  o[33],  1 ],  
	// Array
	34, [ o[35],  o[36] ],  
	// Array
	35, [ 0.66666666666667,  7,  1 ],  
	// Array
	36, [ 0.33333333333333,  8,  1 ],  
	// Array
	37, [ o[38],  o[40],  o[42] ],  
	// Array
	38, [ 0.66666666666667,  o[39],  1 ],  
	// Array
	40, [ 0.33333333333333,  o[41],  1 ],  
	// Array
	42, [ 1,  o[43],  1 ],  
	// Array
	44, [ o[45],  o[47],  o[49],  o[51],  
		o[53] ],  
	// Array
	45, [ 0.66666666666667,  o[46],  0.43 ],  
	// Array
	47, [ 0.33333333333333,  o[48],  1 ],  
	// Array
	49, [ 0.33333333333333,  o[50],  0.43 ],  
	// Array
	51, [ 0.33333333333333,  o[52],  1 ],  
	// Array
	53, [ 0.33333333333333,  o[54],  1 ],  
	// Array
	55, [ o[56] ],  
	// Array
	56, [ 4,  0,  0 ],  
	// Array
	57, [ o[58],  o[59],  o[60],  o[61],  
		o[62],  o[63],  o[64],  o[65] ],  
	// Array
	66, [ 60,  54.0,  54.0,  57.0,  
		60.0,  55.0,  60,  60 ],  
	// Array
	67, [ false,  false,  false,  false,  
		false,  false,  false,  false ],  
	// Array
	68, [ o[69],  o[70],  o[71],  o[72],  
		o[73],  o[74],  o[75],  o[76] ],  
	// Array
	69, [ 200,  0,  0.707,  811.17744821837,  
		4.810973251498,  2.9566466888436,  5000,  8.1449825782033,  
		0.707,  false,  4.4 ],  
	// Array
	70, [ 200,  0,  0.707,  1299.9385962009,  
		8.294843746021,  3.2967066223129,  5000,  0,  
		0.707,  false,  0.0 ],  
	// Array
	71, [ 200,  0,  0.707,  768.89672351334,  
		10.149591811668,  3.0063920688831,  5314.9064824299,  21.877712734229,  
		9.5701728223591,  false,  0 ],  
	// Array
	72, [ 200,  0,  0.707,  1160.0,  
		12.320861313293,  2.3482933776871,  5000,  0,  
		0.707,  false,  2.1 ],  
	// Array
	73, [ 205.22182670516,  24,  5.3343163900774,  1260.3790240975,  
		10.640229491848,  8.6055810827991,  2838.962086302,  0.70379285679928,  
		8.9888058669121,  false,  0 ],  
	// Array
	74, [ 206.09589195843,  24,  0.86329337768715,  1437.6643941802,  
		17.888225517816,  4.4644258363731,  2163.2091753506,  10.397297043504,  
		1.2033533111564,  false,  0.0 ],  
	// Array
	75, [ 150.88225517816,  22.978503709466,  0.595,  200,  
		-12.154201045132,  0.44984272328515,  6269.2440658644,  18.019178391686,  
		4.6767722283573,  false,  0 ],  
	// Array
	76, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	77, [ false,  true,  false,  false,  
		false,  false,  true,  false ],  
	// Array
	78, [ 3,  0,  7,  13,  
		27,  18,  0,  0 ],  
	// Array
	79, [ 0.01271186440678,  0.01271186440678,  0.01271186440678,  0.01271186440678,  
		0.01271186440678,  0.01271186440678,  0.01271186440678,  0.01271186440678 ],  
	// Array
	80, [ 0.0027118644067797,  0.0027118644067797,  0.0027118644067797,  0.0027118644067797,  
		0.0027118644067797,  0.0027118644067797,  0.0027118644067797,  0.0027118644067797 ],  
	// Array
	81, [ 1.3014265162018,  0.65810331004478,  0.6360173901151,  0.96603200137215,  
		0.44503081328723,  0.61430900727822,  0.46353013083517,  0.72662629239073 ],  
	// Array
	82, [ 0.22727272727273,  0.27272727272727,  0.31818181818182,  0.11440677966102,  
		0.11440677966102,  0.11440677966102,  0.22727272727273,  0.22727272727273 ],  
	// Array
	83, [ 3,  0,  7,  13,  
		28,  19,  0,  0 ],  
	// Array
	84, [ 0,  1,  2,  3,  
		4,  5,  0,  0 ]
];
prUnarchive(o,p);
