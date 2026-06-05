/*
RicaAfroca Sequencer - Pro Version 2.5 (7-Track Edition)
*/

(
s.waitForBoot({

	/////////////////////////////////////////////////////////////////
	// VARIABLES & INITIALIZATION
	/////////////////////////////////////////////////////////////////

	var win, startBtn, tempoSlid, bpmDisplay, saveBtn, loadBtn,
	presetNameField, presetMenu, refreshBtn,
	masterMuteBtn, masterCol, peakMeter, meterRoutine, hLayout, vRuler,
	masterHumTime, masterHumPitch, masterHumAmp, humGroup, woodImg,
	currentPresetName = "newPreset";

	// Variables locales para el Round Robin de todos los golpes (camelCase)
	var llamadorAbiertos, lastLlamadorIdx = -1;
	var llamadorSlaps, lastSlapIdx = -1;
	var llamadorPuntas, lastPuntaIdx = -1;
	var llamadorCentros, lastCentroIdx = -1;
	var llamadorTapados, lastTapadoIdx = -1;

	// Scaled from 6 to 7 tracks (Indices 0 to 6)
	~numTracks = 7;
	~tempo = TempoClock.new(120/60).permanent_(true);
	~masterVol = 0.8;
	~dbSpec = ControlSpec(-60, 3.5, \db, 0, 0);

	// Logic arrays
	~rhythmIndices = Array.fill(~numTracks, { 0 });
	~rhythms = Array.fill(~numTracks, { [[0.5, 0, 1], [0.5, 0, 1]] });
	~mutes = Array.fill(~numTracks, { false });
	~pitches = Array.fill(~numTracks, { 60 });
	~volumes = Array.fill(~numTracks, { 0.7 });
	~sampleIndices = Array.fill(~numTracks, { |i| i });
	~varRequests = Array.fill(~numTracks, { false });

	// Humanize Logic Arrays
	~humanizeTime = Array.fill(~numTracks, { 0.0 });
	~humanizePitch = Array.fill(~numTracks, { 0.0 });
	~humanizeAmp = Array.fill(~numTracks, { 0.0 });

	// GUI arrays (UPDATED: ~sampleMenus changed to ~trackLabels)
	~muteButtons = Array.newClear(~numTracks);
	~rhythmMenus = Array.newClear(~numTracks);
	~pitchSliders = Array.newClear(~numTracks);
	~volSliders = Array.newClear(~numTracks);
	~trackMeters = Array.newClear(~numTracks);
	~trackLabels = Array.newClear(~numTracks);
	~varButtons = Array.newClear(~numTracks);
	~humTimeSliders = Array.newClear(~numTracks);
	~humPitchSliders = Array.newClear(~numTracks);
	~humAmpSliders = Array.newClear(~numTracks);

	/////////////////////////////////////////////////////////////////
	// RHYTHMS AND VARIATIONS
	/////////////////////////////////////////////////////////////////
	~rhythmAndNames = [
		// Claves
		["Clave4/4", [[0.75,2,1], [1,2,1], [0.7,2,1], [0.55,2,1], [1,2,1]]],
		["ClaveMatanzas", [[0.75,2,1], [0.25,2,1], [0.75,2,1], [0.25,2,1], [0.5,2,1], [0.5,2,1], [1,2,1]]],
		["Clave6/8", [[2/3,4,1], [3/3,4,1], [2/3,4,1], [2/3,4,1], [3/3,4,1]]],
		["ClaveAfricana", [[2/3,4,1], [2/3,4,1], [1/3,4,1], [2/3,4,1], [2/3,4,1], [2/3,0,1], [1/3,0,1]]],

		// Cáscaras
		["Cascara1", [[0.25,0,1], [0.5,0,1], [0.25,0,1], [0.25,0,1], [0.5,0,1], [0.25,0,1], [0.5,0,1], [0.5,0,1], [0.25,0,1], [0.5,0,1], [0.25,0,1]]],
		["Cascara2", [[0.5,0,1], [0.25,0,1], [0.5,0,1], [0.5,0,1],[0.25,0,1], [0.5,0,1], [0.5,0,1], [0.25,0,1], [0.5,0,1], [0.25,0,1]]],
		["CascaraColumbia", [[0.5,0,1], [0.25,0,1], [0.5,0,1], [0.5,0,1], [0.25,0,1], [0.5,0,1], [0.5,0,1], [0.25,0,1], [0.25,0,1], [0.25,0,1], [0.25,0,1]]],
		["cascara Yuka", [[2/3,0,1], [2/3,0,1], [2/3,0,1], [1/3,0,1], [1/3,0,1], [4/3,0,1]]],
		["cascara2 Yuka", [[2/3,0,1], [2/3,0,1], [2/3,0,1], [6/3,0,1]]],

		// Shékeres
		["ShekereBin 1/1", [[2+1.75,7,1], [0.25,8,1]]],
		["ShekereBin 1/2", [[1.75,7,1], [0.25,8,1]]],
		["ShekereBin 1/4 ", [[0.75,7,1], [0.25,8,1]]],
		["Shekere6/8", [[2/3,7,1], [1/3,8,1]]],

		// Golpes
		["PaloYukaGolpe", [[0.75,0,1], [0.25,0,1], [-1,0,0]]],
		["GolpeGuaguanco", [[1,1,0.135], [0.5,1,0.135], [0.5,3,1], [1,1,0.135], [0.5,1,0.135], [0.5,3,1]]],
		["GolpeMatancera", [[0.75,1,0.35], [0.25,1,0.35], [0.5,1,0.35], [0.5,3,1], [0.75,1,0.35], [0.25,1,0.35], [0.5,1,0.35], [0.5,3,1]]],
		["GolpeCol", [[2/3,1,0.43], [1/3,9,1],  [1/3,1,0.43], [1/3,3,1], [1/3,3,1], [2/3,1,0.43], [1/3,9,1], [1/3,1,0.43], [1/3,3,1], [1/3,3,1]]],
		["GolpePalo", [[1/3,1,0], [1/3,9,1],  [1/3,9,1], [1/3,3,0], [1/3,3,1], [1/3,9,1]]],
		["Yuka Golpe", [[1,1,0.43], [1,3,1]]],

		// Llamadores
		["LlamadorGuaguanco", [[0.25,1,0.25], [0.25,10,0.25], [0.25,10,0.25], [0.25,1,0.25], [0.25,1,0.25], [0.25,10,0.25], [0.25,10,0.25], [0.25,10,1], [0.5,3,1], [0.25,10,0.5],[0.25,1,0.5], [0.25,1,0.25], [0.25,10,0.25], [0.25,10,0.25], [0.25,1,0.25]]],
		["Llamador Matancera", [[15/32, 0, 0],  [9/32, "lls", 1], [8/32, "lls", 1], [15/32, 0, 0],  [9/32, "lla", 1], [8/32, "lls", 1]]],
		["Llamador Columbia", [[2/3,1,0.43], [1/3,3,1],  [1,3,1]]],
		["Yuka Llamador", [[1,1,0.43], [0.5,1,0.43], [0.5,3,1]]],

		// Pulsos
		["16ths", [[0.25,0,1]]],
		["8ths", [[0.5,0,1]]],
		["Quarters", [[1,0,1], [1,0,1]]]
	];

	~variations = [
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		// Track 5 (Golpe Variations)
		[
			/* Var 1 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [1, 1, 0.5]] ++ ([0.25, 3, 1]!3)
			.addFirst([0.25, 3, 0]) ++ [[1, 3, 1], [0.5,1,0.5], [0.5,3,1], [1,1,0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 2 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1]] ++ ([0.25, 3, 1]!7)
			.addFirst([0.25, 3, 0]) ++ [[1, 3, 1], [0.5,1,0.5], [0.5,3,1], [1,1,0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 3 */
			[[1, 1, 0.5]] ++ ([0.25, 3, 1]!11)
			.addFirst([0.25, 3, 0]) ++ [[1, 3, 1], [0.5,1,0.5], [0.5,3,1], [1,1,0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 4 */
			([0.25, 3, 1]!15)
			.addFirst([0.25, 3, 0]) ++ [[1, 3, 1], [0.5,1,0.5], [0.5,3,1], [1,1,0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 5 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.25,3,1], [0.25,3,1],
			 [0.5,3,0.5], [0.25,3,1], [0.25,3,1], [0.5,3,0.5], [0.5,3,0.5], [1, 1, 0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 6 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [1, 1, 0.5], [0.25,1,0.5], [0.5,3,1], [0.25,3,1],
			 [1,10,0.75], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]],
			/* Var 7 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [1, 1, 0.5], [0.25,1,0.5], [0.5,10,1], [0.25,10,1],
			 [1,3,1], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]],
			/* Var 8 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [0.25,1,0.5], [0.5,10,1], [0.5,10,1], [0.5,10,1], [0.25,10,1],
			 [1,3,1], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]],
			/* Var 9 */
			[[1, 1, 0.5], [0.25,1,0.5], [0.5,10,1], [0.5,10,1], [0.5,10,0.5], [0.5,10,1], [0.5,10,1], [0.25,10,1],
			 [1,3,1], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]],
			/* Var 10 */
			[[0.25, 1, 0.5], [0.5,10,0.5], [0.5,10,1], [0.5,10,1], [0.5,10,0.5], [0.5,10,1], [0.5,10,1], [0.5,10,1], [0.25,10,1],
			 [1,3,1], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]]
		],
		// Default Variation Array for Track 6
		[
			[[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]]
		]
	];

	/////////////////////////////////////////////////////////////////
	// PATHS & ASSET LOADING (100% RELATIVAS)
	/////////////////////////////////////////////////////////////////

	~projectPath = if(thisProcess.nowExecutingPath.notNil) {
		PathName(thisProcess.nowExecutingPath).pathOnly;
	} {
		Platform.userHomeDir +/+ "multitrack-sequencer";
	};

	~samplePath = ~projectPath +/+ "samples";
	~presetPath = ~projectPath +/+ "sequences";
	~imagePath  = ~projectPath +/+ "images";

	File.mkdir(~presetPath);

	~sampleFiles = (~samplePath +/+ "*.wav").pathMatch;
	~sampleNames = ~sampleFiles.collect({ |path| PathName(path).fileNameWithoutExtension });
	~samples = ~sampleFiles.collect({ |path| Buffer.read(s, path) });

	if(~samples.isEmpty) {
		~sampleNames = ["empty"];
		~samples = [Buffer.alloc(s, 44100, 1)];
	};

	~loadRoundRobinFolder = { |subPath, logLabel|
		var folderPath = PathName(~samplePath +/+ subPath);
		var loadedBuffers = Array.new;
		if(File.exists(folderPath.fullPath)) {
			var files = (folderPath.fullPath +/+ "*.wav").pathMatch;
			if(files.size > 0) {
				loadedBuffers = files.collect({ |path| Buffer.read(s, path) });
				("--- RicaAfroca: Cargadas" + loadedBuffers.size + "muestras para" + logLabel).postln;
			} {
				("ALERTA RicaAfroca: Sin archivos .wav en:" + folderPath.fullPath).postln;
			};
		} {
			("ALERTA RicaAfroca: Directorio no existe:" + folderPath.fullPath).postln;
		};
		loadedBuffers;
	};

	~llamadorAbiertos = ~loadRoundRobinFolder.value("llamador/abierto/f", "Abiertos (\"lla\")");
	~llamadorSlaps    = ~loadRoundRobinFolder.value("llamador/slap/f", "Slaps (\"lls\")");
	~llamadorPuntas   = ~loadRoundRobinFolder.value("llamador/punta/f", "Puntas (\"llp\")");
	~llamadorCentros  = ~loadRoundRobinFolder.value("llamador/centro/f", "Centros (\"llc\")");
	~llamadorTapados  = ~loadRoundRobinFolder.value("llamador/tapado/f", "Tapados (\"llt\")");

	if(File.exists(~imagePath +/+ "wood-size.jpg")) {
		woodImg = Image.new(~imagePath +/+ "wood-size.jpg");
	} {
		woodImg = nil;
	};

	/////////////////////////////////////////////////////////////////
	// FUNCTION: SELECTOR EVOLUCIONADO MULTI-GOLPE (Round Robin)
	/////////////////////////////////////////////////////////////////
	~getBufferForStep = { |bufVal, fallbackIdx|
		var chosenBuffer, strVal = bufVal.asString;

		case
		{ strVal == "lla" } {
			if(~llamadorAbiertos.size > 0) {
				if(~llamadorAbiertos.size > 1) {
					var available = (0..(~llamadorAbiertos.size - 1));
					available.remove(~lastLlamadorIdx);
					~lastLlamadorIdx = available.choose;
					chosenBuffer = ~llamadorAbiertos[~lastLlamadorIdx];
				} { chosenBuffer = ~llamadorAbiertos[0] };
			} { chosenBuffer = ~samples[fallbackIdx.asInteger.wrap(0, ~samples.size-1)] };
		}
		{ strVal == "lls" } {
			if(~llamadorSlaps.size > 0) {
				if(~llamadorSlaps.size > 1) {
					var available = (0..(~llamadorSlaps.size - 1));
					available.remove(~lastSlapIdx);
					~lastSlapIdx = available.choose;
					chosenBuffer = ~llamadorSlaps[~lastSlapIdx];
				} { chosenBuffer = ~llamadorSlaps[0] };
			} { chosenBuffer = ~samples[fallbackIdx.asInteger.wrap(0, ~samples.size-1)] };
		}
		{ strVal == "llp" } {
			if(~llamadorPuntas.size > 0) {
				if(~llamadorPuntas.size > 1) {
					var available = (0..(~llamadorPuntas.size - 1));
					available.remove(~lastPuntaIdx);
					~lastPuntaIdx = available.choose;
					chosenBuffer = ~llamadorPuntas[~lastPuntaIdx];
				} { chosenBuffer = ~llamadorPuntas[0] };
			} { chosenBuffer = ~samples[fallbackIdx.asInteger.wrap(0, ~samples.size-1)] };
		}
		{ strVal == "llc" } {
			if(~llamadorCentros.size > 0) {
				if(~llamadorCentros.size > 1) {
					var available = (0..(~llamadorCentros.size - 1));
					available.remove(~lastCentroIdx);
					~lastCentroIdx = available.choose;
					chosenBuffer = ~llamadorCentros[~lastCentroIdx];
				} { chosenBuffer = ~llamadorCentros[0] };
			} { chosenBuffer = ~samples[fallbackIdx.asInteger.wrap(0, ~samples.size-1)] };
		}
		{ strVal == "llt" } {
			if(~llamadorTapados.size > 0) {
				if(~llamadorTapados.size > 1) {
					var available = (0..(~llamadorTapados.size - 1));
					available.remove(~lastTapadoIdx);
					~lastTapadoIdx = available.choose;
					chosenBuffer = ~llamadorTapados[~lastTapadoIdx];
				} { chosenBuffer = ~llamadorTapados[0] };
			} { chosenBuffer = ~samples[fallbackIdx.asInteger.wrap(0, ~samples.size-1)] };
		}
		{ true } {
			chosenBuffer = ~samples[bufVal.asInteger.wrap(0, ~samples.size-1)];
		};

		chosenBuffer;
	};

	/////////////////////////////////////////////////////////////////
	// FUNCTIONS (UPDATED: Added \trackNames persistence)
	/////////////////////////////////////////////////////////////////

	~saveSettings = { |name|
		var data = Dictionary.new;
		var path = ~presetPath +/+ (name ++ ".scd");

		data.put(\rhythms, Array.fill(~numTracks, { |i| ~rhythms[i] }));
		data.put(\mutes, Array.fill(~numTracks, { |i| ~mutes[i] }));
		data.put(\pitches, Array.fill(~numTracks, { |i| ~pitches[i] }));
		data.put(\bpm, ~tempo.tempo * 60);
		data.put(\indices, Array.fill(~numTracks, { |i| ~rhythmIndices[i] }));
		data.put(\volumes, Array.fill(~numTracks, { |i| ~volumes[i] }));
		data.put(\sampleIndices, Array.fill(~numTracks, { |i| ~sampleIndices[i] }));
		data.put(\humTime, Array.fill(~numTracks, { |i| ~humanizeTime[i] }));
		data.put(\humPitch, Array.fill(~numTracks, { |i| ~humanizePitch[i] }));
		data.put(\humAmp, Array.fill(~numTracks, { |i| ~humanizeAmp[i] }));

		// CHANGED: Captura y guarda los strings escritos en la interfaz
		data.put(\trackNames, Array.fill(~numTracks, { |i| ~trackLabels[i].string }));

		data.writeArchive(path);
		("--- Preservado Preset Sólido de 7 Canales: " ++ name).postln;
	};

	~loadSettings = { |name|
		var path = ~presetPath +/+ (name ++ ".scd");
		var data = Object.readArchive(path);
		if(data.notNil) {
			currentPresetName = name;
			~tempo.tempo = (data[\bpm] ?? {120}) / 60;

			~rhythms = Array.fill(~numTracks, { |i| data[\rhythms].wrapAt(i) ?? [[0.5, 0, 1], [0.5, 0, 1]] });
			~mutes = Array.fill(~numTracks, { |i| data[\mutes].wrapAt(i) ?? false });
			~pitches = Array.fill(~numTracks, { |i| data[\pitches].wrapAt(i) ?? 60 });
			~rhythmIndices = Array.fill(~numTracks, { |i| data[\indices].wrapAt(i) ?? 0 });
			~volumes = Array.fill(~numTracks, { |i| data[\volumes].wrapAt(i) ?? 0.7 });
			~sampleIndices = Array.fill(~numTracks, { |i| data[\sampleIndices].wrapAt(i) ?? i });
			~humanizeTime = Array.fill(~numTracks, { |i| data[\humTime].wrapAt(i) ?? 0.0 });
			~humanizePitch = Array.fill(~numTracks, { |i| data[\humPitch].wrapAt(i) ?? 0.0 });
			~humanizeAmp = Array.fill(~numTracks, { |i| data[\humAmp].wrapAt(i) ?? 0.0 });

			{
				win.name = "RicaAfroca Sequencer Wood - Editing: " ++ name;
				presetNameField.string = name;
				presetMenu.value = presetMenu.items.indexOfEqual(name);
				bpmDisplay.value = ~tempo.tempo * 60;
				tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1);

				~numTracks.do({ |i|
					~rhythmMenus[i].value = ~rhythmIndices[i];
					~muteButtons[i].value = ~mutes[i].asInteger;

					// CORRECCIÓN CLAVE: Blindaje absoluto si data[\trackNames] viene vacío de versiones previas
					if (data[\trackNames].notNil && (data[\trackNames].size > 0)) {
						~trackLabels[i].string = data[\trackNames].wrapAt(i) ?? ("Track " ++ i);
					} {
						~trackLabels[i].string = "Track " ++ i;
					};

					~pitchSliders[i].value = ~pitches[i].linlin(36, 72.0, 0, 1);
					~volSliders[i].value = ~dbSpec.unmap(~volumes[i].ampdb);
					~humTimeSliders[i].value = ~humanizeTime[i].linlin(0, 0.08, 0, 1);
					~humPitchSliders[i].value = ~humanizePitch[i].linlin(0, 1.5, 0, 1);
					~humAmpSliders[i].value = ~humanizeAmp[i].linlin(0, 0.3, 0, 1);
				});
			}.defer;
		};
	};

	~updatePresetList = {
		var files = (~presetPath +/+ "*.scd").pathMatch;
		var names = files.collect({ |p| PathName(p).fileNameWithoutExtension });
		var currentIndex;

		if(names.isEmpty) { names = ["No Presets Found"] };

		currentIndex = names.indexOfEqual(currentPresetName) ?? 0;
		{ if(presetMenu.notNil) { presetMenu.items = names; presetMenu.value = currentIndex; } }.defer;
	};

	/////////////////////////////////////////////////////////////////
	// SERVER SIDE
	/////////////////////////////////////////////////////////////////

	~peakBus = Bus.control(s, 1);
	~trackPeakBuses = Array.fill(~numTracks, { Bus.control(s, 1) });

	SynthDef(\masterOut, {
		arg amp=0.8;
		var sig = In.ar(0, 2);
		sig = sig * amp;
		sig = Limiter.ar(sig, 0.98);
		Out.kr(~peakBus, PeakFollower.kr(sig[0].abs.max(sig[1].abs), 0.999));
		ReplaceOut.ar(0, sig);
	}).add;

	SynthDef(\liveChannel, {
		arg out=0, buf=0, rate=1, amp=0.5, pan=0, rel=0.3, peakOut;
		var sig, env;
		env = EnvGen.kr(Env.perc(0.005, rel), 1, doneAction: 2);
		sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, loop: 0);
		sig = sig * 0.8 * env * amp;
		Out.kr(peakOut, PeakFollower.kr(sig.abs.max(sig.abs), 0.999));
		OffsetOut.ar(out, Pan2.ar(sig, pan));
	}).add;

	s.sync;
	Synth(\masterOut, [\amp, ~masterVol], addAction: \addAfter);

	/////////////////////////////////////////////////////////////////
	// ENGINE (EVENT-DRIVEN MATRIX PLAYER)
	/////////////////////////////////////////////////////////////////

	~numTracks.do({ |i|
		Tdef( ("chan" ++ i).asSymbol, {
			var step = 0;
			loop {
				var currentEvent, delta, bufOff, hitAmp, pbRate, targetBuffer;

				currentEvent = ~rhythms[i].wrapAt(step);
				delta  = currentEvent[0];
				bufOff = currentEvent[1];
				hitAmp = currentEvent[2];

				// VARIATION LOGIC
				if (~varRequests[i] && ((~tempo.beats % 4) < 0.01)) {
					~varRequests[i] = false;
					{ if(~varButtons[i].notNil) { ~varButtons[i].value = 0 } }.defer;
					step = 0;

					~variations.wrapAt(i).choose.do({ |vEvent|
						var vDelta = vEvent[0];
						var vBuf   = vEvent[1];
						var vAmp   = vEvent[2];
						var vTargetBuffer;

						if(vDelta > 0 && ~mutes[i].not) {
							pbRate = (~pitches[i] + ~humanizePitch[i].rand2 - 60).midiratio;
							vTargetBuffer = ~getBufferForStep.value(vBuf, ~sampleIndices[i]);

							s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
								Synth(\liveChannel, [
									\buf, vTargetBuffer,
									\rate, pbRate,
									\amp, (vAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol,
									\rel, (vDelta.abs / ~tempo.tempo) * 0.8,
									\peakOut, ~trackPeakBuses[i]
								]);
							});
						};
						vDelta.abs.wait;
					});

					currentEvent = ~rhythms[i].wrapAt(step);
					delta = currentEvent[0]; bufOff = currentEvent[1]; hitAmp = currentEvent[2];
				};

				// NORMAL NOTE LOGIC
				if(delta > 0 && ~mutes[i].not) {
					pbRate = (~pitches[i] + ~humanizePitch[i].rand2 - 60).midiratio;
					targetBuffer = ~getBufferForStep.value(bufOff, ~sampleIndices[i]);

					s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
						Synth(\liveChannel, [
							\buf, targetBuffer,
							\rate, pbRate,
							\amp, (hitAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol,
							\rel, (delta.abs / ~tempo.tempo) * 0.8,
							\peakOut, ~trackPeakBuses[i]
						]);
					});
				};

				step = step + 1;
				if(step >= ~rhythms[i].size) { step = 0 };
				delta.abs.wait;
			}
		}).quant = 4;
	});

	/////////////////////////////////////////////////////////////////
	// GUI
	/////////////////////////////////////////////////////////////////

	if(File.exists(~imagePath +/+ "wood-size.jpg")) {
		woodImg = Image.new(~imagePath +/+ "wood-size.jpg");
	};

	win = Window("RicaAfroca Sequencer Wood", Rect(50, 50, 1140, 920)).front;

	if(woodImg.notNil) {
		var backgroundCanvas = UserView(win, win.view.bounds)
			.resize_(5)
			.drawFunc_({ |view| woodImg.drawInRect(view.bounds); });
		backgroundCanvas.canFocus_(false);
	};

	win.view.decorator = FlowLayout(win.view.bounds, 15@15, 10@10);

	win.view.keyDownAction_({ |view, char, modifiers, unicode, keycode|
		if(keycode == 32) { startBtn.valueAction = 1 - startBtn.value };
	});

	startBtn = Button(win, 800@40).states_([["START ALL", Color.black, Color.green], ["STOP ALL", Color.white, Color.red]]).action_({ |b| ~numTracks.do({ |i| if(b.value == 1) { Tdef(("chan"++i).asSymbol).play(~tempo) } { Tdef(("chan"++i).asSymbol).stop }; }); });
	startBtn.canFocus_(true);
	startBtn.focus;

	win.view.decorator.nextLine;

	Button(win, 30@30).states_([["-", Color.black, Color.grey(0.8)]]).action_({ var newBpm = (~tempo.tempo * 60) - 1; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); }).canFocus_(false);
	bpmDisplay = NumberBox(win, 60@30).value_(~tempo.tempo * 60);
	Button(win, 30@30).states_([["+", Color.black, Color.grey(0.8)]]).action_({ var newBpm = (~tempo.tempo * 60) + 1; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); }).canFocus_(false);
	tempoSlid = Slider(win, 660@30).value_(~tempo.tempo.linlin(1, 3.3, 0, 1)).action_({ |s| var bpm = s.value.linlin(0, 1, 60, 200); ~tempo.tempo = bpm / 60; bpmDisplay.value = bpm; }).canFocus_(false);

	win.view.decorator.nextLine;

	~numTracks.do({ |i|
		var comp = CompositeView(win, 115@700).background_(Color.grey(0.7));
		comp.decorator = FlowLayout(comp.bounds, 5@5, 5@5);

		// TextField interactivo con desenfoque automático al presionar Enter
		~trackLabels[i] = TextField(comp, 105@25)
			.string_("Track " ++ i)
			.align_(\center)
			.font_(Font(bold: true, size: 12))
			.action_({ |tf|
				// 1. Guarda el texto inmediatamente en la variable lógica si lo deseas
				("Track " ++ i ++ " renombrado a: " ++ tf.string).postln;

				// 2. Le quita el foco al TextField devolviéndoselo al botón START ALL
				if(startBtn.notNil) { startBtn.focus };
			});
		~muteButtons[i] = Button(comp, 105@40).states_([["ON", Color.black, Color.green], ["MUTE", Color.white, Color.red]]).action_({ |b| ~mutes[i] = (b.value == 1) });
		~rhythmMenus[i] = PopUpMenu(comp, 105@30).items_(~rhythmAndNames.collect({ |item| item[0] })).action_({ |m| ~rhythms[i] = ~rhythmAndNames[m.value][1]; ~rhythmIndices[i] = m.value; });
		~varButtons[i] = Button(comp, 105@40).states_([["VARIATION", Color.black, Color.grey(0.8)], ["QUEUED", Color.white, Color.red(0.6)]]).action_({ |b| ~varRequests[i] = (b.value == 1); });

		StaticText(comp, 105@20).string_("Pitch").align_(\center);
		~pitchSliders[i] = Slider(comp, 105@30).value_(0.5).action_({ |s| ~pitches[i] = s.value.linlin(0, 1, 36, 72).round; });

		StaticText(comp, 105@20).string_("Peak / dB").align_(\center).font_(Font(size:10));
		hLayout = CompositeView(comp, 105@200);
		hLayout.decorator = FlowLayout(hLayout.bounds, 0@0, 2@0);

		~trackMeters[i] = LevelIndicator(hLayout, 15@200).warning_(0.8).critical_(0.95).background_(Color.black);

		vRuler = CompositeView(hLayout, 25@200);
		[3.5, 0, -12, -24, -40, -60].do({ |db|
			var yPos = ~dbSpec.unmap(db);
			StaticText(vRuler, Rect(0, (1 - yPos) * 180, 25, 20)).string_(db.asString).font_(Font(size: 7)).align_(\right).stringColor_(if(db > 0) { Color.red } { Color.white });
		});

		~volSliders[i] = Slider(hLayout, 55@200).value_(~dbSpec.unmap(0.7.ampdb)).action_({ |s| ~volumes[i] = ~dbSpec.map(s.value).dbamp; });

		humGroup = CompositeView(comp, 105@140).background_(Color.grey(0.6));
		humGroup.decorator = FlowLayout(humGroup.bounds, 2@2, 2@2);
		StaticText(humGroup, 100@15).string_("HUMANIZATION").align_(\center).font_(Font(size:9, bold:true));
		StaticText(humGroup, 40@15).string_("Time").font_(Font(size:9));
		~humTimeSliders[i] = Slider(humGroup, 55@15).value_(0.0).action_({ |s| ~humanizeTime[i] = s.value.linlin(0, 1, 0, 0.08); });
		StaticText(humGroup, 40@15).string_("Pitch").font_(Font(size:9));
		~humPitchSliders[i] = Slider(humGroup, 55@15).value_(0.0).action_({ |s| ~humanizePitch[i] = s.value.linlin(0, 1, 0, 1.5); });
		StaticText(humGroup, 40@15).string_("Amp").font_(Font(size:9));
		~humAmpSliders[i] = Slider(humGroup, 55@15).value_(0.0).action_({ |s| ~humanizeAmp[i] = s.value.linlin(0, 1, 0, 0.3); });

		// Se remueven focos innecesarios excepto para las cajas de texto que sí requieren tipeo
		[~muteButtons[i], ~rhythmMenus[i], ~varButtons[i], ~pitchSliders[i], ~volSliders[i], ~humTimeSliders[i], ~humPitchSliders[i], ~humAmpSliders[i]].do(_.canFocus_(false));
	});

	masterCol = CompositeView(win, 150@700).background_(Color.grey(0.6));
	masterCol.decorator = FlowLayout(masterCol.bounds, 5@5, 5@5);
	StaticText(masterCol, 140@20).string_("MASTER").align_(\center).font_(Font(bold:true));
	masterMuteBtn = Button(masterCol, 140@40).states_([["MUTE ALL", Color.black, Color.yellow], ["UNMUTE ALL", Color.white, Color.red]]).action_({ |b| ~numTracks.do({ |i| ~muteButtons[i].valueAction_(b.value); }); }).canFocus_(false);
	StaticText(masterCol, 140@15).string_("GLOBAL HUMAN").align_(\center).font_(Font(size:9, bold:true));
	StaticText(masterCol, 140@12).string_("Time").font_(Font(size:8));
	Slider(masterCol, 140@15).value_(0.0).action_({ |s| ~numTracks.do({ |i| ~humanizeTime[i] = s.value.linlin(0, 1, 0, 0.08); {~humTimeSliders[i].value = s.value}.defer; }); }).canFocus_(false);
	StaticText(masterCol, 140@12).string_("Pitch").font_(Font(size:8));
	Slider(masterCol, 140@15).value_(0.0).action_({ |s| ~numTracks.do({ |i| ~humanizePitch[i] = s.value.linlin(0, 1, 0, 1.5); {~humPitchSliders[i].value = s.value}.defer; }); });
	StaticText(masterCol, 140@12).string_("Amp").font_(Font(size:8));
	Slider(masterCol, 140@15).value_(0.0).action_({ |s| ~numTracks.do({ |i| ~humanizeAmp[i] = s.value.linlin(0, 1, 0, 0.3); {~humAmpSliders[i].value = s.value}.defer; }); });
	StaticText(masterCol, 140@20).string_("Peak / dB / Master").align_(\center).font_(Font(size:10));
	hLayout = CompositeView(masterCol, 140@310);
	hLayout.decorator = FlowLayout(hLayout.bounds, 0@0, 2@0);
	peakMeter = LevelIndicator(hLayout, 20@305).warning_(0.8).critical_(0.95).background_(Color.black);
	vRuler = CompositeView(hLayout, 40@305);
	[3.5, 0, -6, -12, -24, -40, -60].do({ |db|
		var yPos = ~dbSpec.unmap(db);
		StaticText(vRuler, Rect(0, (1 - yPos) * 285, 40, 20)).string_(db.asString).font_(Font(size: 10)).align_(\right).stringColor_(if(db > 0) { Color.red } { Color.white });
	});
	Slider(hLayout, 70@305).value_(~dbSpec.unmap(0)).action_({ |s| var db = ~dbSpec.map(s.value); ~masterVol = db.dbamp; }).canFocus_(false);

	meterRoutine = {
		loop {
			~peakBus.get({ |val| { if(peakMeter.notNil) { peakMeter.value = val } }.defer; });
			~numTracks.do({ |i|
				~trackPeakBuses[i].get({ |val| { if(~trackMeters[i].notNil) { ~trackMeters[i].value = val; }; }.defer; });
			});
			0.05.wait;
		}
	}.fork(AppClock);

	win.view.decorator.nextLine;
	presetNameField = TextField(win, 150@40).string_(currentPresetName);
	saveBtn = Button(win, 100@40).states_([["SAVE", Color.black, Color.yellow]]).action_({ var n = presetNameField.string.stripWhiteSpace; if(n == "") { n = currentPresetName }; ~saveSettings.value(n); currentPresetName = n; ~updatePresetList.value; });
	presetMenu = PopUpMenu(win, 200@40)
		.items_(["Scanning..."])
		.action_({ |menu| if(menu.item != "No Presets Found") { ~loadSettings.value(menu.item); } });
	loadBtn = Button(win, 100@40).states_([["LOAD", Color.black, Color.cyan]]).action_({ if(presetMenu.item != "No Presets Found") { ~loadSettings.value(presetMenu.item) }; });
	refreshBtn = Button(win, 100@40).states_([["REFRESH", Color.white, Color.grey(0.3)]]).action_({ ~updatePresetList.value });

	[tempoSlid, presetMenu, loadBtn, saveBtn, refreshBtn, masterMuteBtn].do(_.canFocus_(false));

	~updatePresetList.value;

	s.doWhenBooted({
		{
			if(File.exists(~presetPath +/+ "guaguanco.scd")) { ~loadSettings.value("guaguanco"); };
		}.defer(0.5);
	});

	win.onClose = {
		meterRoutine.stop;
		if(~serialRoutine.notNil) { ~serialRoutine.stop };
		if(~myPort.notNil) { ~myPort.close };
		~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop });
		"Sequencer and Serial Port closed safely.".postln;
	};

	/////////////////////////////////////////////////////////////////
	// ARDUINO
	/////////////////////////////////////////////////////////////////
	try {
		~myPort = SerialPort("COM3", baudrate: 9600, crtscts: true);
		~serialRoutine = {
			var byte;
			while { ~myPort.notNil } {
				byte = ~myPort.read;
				if (byte.notNil) {
					byte = byte.asAscii;
					{
						case
						{ byte == $s } { startBtn.valueAction = 1 - startBtn.value }
						{ byte == $p } { var newBpm = (~tempo.tempo * 60) + 1; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); }
						{ byte == $m } { var newBpm = (~tempo.tempo * 60) - 1; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); }
						{ byte == $v } { if(~varButtons[5].notNil) { ~varButtons[5].valueAction = 1 - ~varButtons[5].value; } };
					}.defer;
				};
				0.001.wait;
			};
		}.fork(AppClock);
	} { |error|
		"WARNING: Arduino port exception. Sequencer running in GUI mode.".postln;
		~myPort = nil;
	};

});
)