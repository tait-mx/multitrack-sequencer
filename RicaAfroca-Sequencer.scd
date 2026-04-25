/*
RicaAfroca Sequencer - Multi-Variation Version
Independent variation buttons for every track.
*/

(
s.waitForBoot({

	/////////////////////////////////////////////////////////////////
	// VARIABLES & INITIALIZATION
	/////////////////////////////////////////////////////////////////

	var win, startBtn, tempoSlid, tempoUp, tempoDown, bpmDisplay, saveBtn, loadBtn, presetNameField, presetMenu, refreshBtn, rhythmOptions, rhythmNames, masterMuteBtn, masterCol;

	~numTracks = 6;
	~tempo = TempoClock.new(120/60).permanent_(true);

	// 1. Initialize logic arrays
	~rhythmIndices = Array.fill(~numTracks, { 0 });
	~rhythms = Array.fill(~numTracks, { [0.5, 0.5] });
	~mutes = Array.fill(~numTracks, { false });
	~pitches = Array.fill(~numTracks, { 60 });
	~volumes = Array.fill(~numTracks, { -6.dbamp });
	~sampleIndices = Array.fill(~numTracks, { |i| i });

	// NEW: Independent Variation Logic
	~varRequests = Array.fill(~numTracks, { false });
	~variations = [
		[0.25, 0.25, 0.25, 0.25],          // Var 0
		[0.5, 0.25, 0.25],                 // Var 1
		[0.33, 0.33, 0.34],                // Var 2
		[0.75, 0.25, 0.5, 0.5],            // Var 3
		[1, 1],                            // Var 4
		[-1, -0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.5] // Var 5 (Golpe)
	];

	// 2. Initialize GUI arrays
	~muteButtons = Array.newClear(~numTracks);
	~rhythmMenus = Array.newClear(~numTracks);
	~pitchSliders = Array.newClear(~numTracks);
	~volSliders = Array.newClear(~numTracks);
	~sampleMenus = Array.newClear(~numTracks);
	~varButtons = Array.newClear(~numTracks); // NEW: To reset button state via code

	// 3. Paths
	~projectPath = PathName(thisProcess.nowExecutingPath).pathOnly;
	~samplePath = ~projectPath ++ "samples/";
	~presetPath = ~projectPath ++ "sequences/";
	File.mkdir(~presetPath);

	~sampleFiles = (~samplePath ++ "*.wav").pathMatch;
	~sampleNames = ~sampleFiles.collect({ |path| PathName(path).fileNameWithoutExtension });
	~samples = ~sampleFiles.collect({ |path| Buffer.read(s, path) });

	if(~samples.isEmpty) {
		"!!! WARNING: No samples found !!!".postln;
		~sampleNames = ["empty"];
		~samples = [Buffer.alloc(s, 44100, 2)];
	};

	s.makeGui;
	s.meter;

	/////////////////////////////////////////////////////////////////
	// SYNTHDEF
	/////////////////////////////////////////////////////////////////

	SynthDef(\liveChannel, {
		arg out=0, buf=0, freq=440, amp=0.5, pan=0, rel=0.3;
		var sig, env, rate;
		rate = freq / 60.midicps;
		env = EnvGen.kr(Env.perc(0.005, rel), 1, doneAction: 2);
		sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, loop: 0);
		Out.ar(out, Pan2.ar(sig * 0.8 * env * amp, pan));
	}).add;

	/////////////////////////////////////////////////////////////////
	// SAVE & LOAD SETTINGS
	/////////////////////////////////////////////////////////////////

	~saveSettings = { |name|
		var data = Dictionary.new;
		var path = ~presetPath ++ name ++ ".scd";
		data.put(\rhythms, ~rhythms);
		data.put(\mutes, ~mutes);
		data.put(\pitches, ~pitches);
		data.put(\bpm, ~tempo.tempo * 60);
		data.put(\indices, ~rhythmIndices);
		data.put(\volumes, ~volumes);
		data.put(\sampleIndices, ~sampleIndices);
		data.writeArchive(path);
		("--- Saved: " ++ path).postln;
	};

	~loadSettings = { |name|
		var path = ~presetPath ++ name ++ ".scd";
		var data = Object.readArchive(path);
		if(data.notNil) {
			~rhythms = data[\rhythms];
			~mutes = data[\mutes];
			~pitches = data[\pitches];
			~tempo.tempo = (data[\bpm] ?? {120}) / 60;
			~rhythmIndices = data[\indices] ?? { Array.fill(~numTracks, {0}) };
			~volumes = data[\volumes] ?? { Array.fill(~numTracks, { 0.7 }) };
			if(data[\sampleIndices].notNil) { ~sampleIndices = data[\sampleIndices] };
			{
				bpmDisplay.value = ~tempo.tempo * 60;
				tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1);
				~numTracks.do({ |i|
					~rhythmMenus[i].value = ~rhythmIndices[i];
					~muteButtons[i].value = ~mutes[i].asInteger;
					if(data[\sampleIndices].notNil) { ~sampleMenus[i].value = ~sampleIndices[i] };
					~pitchSliders[i].value = ~pitches[i].linlin(36, 72, 0, 1);
					~volSliders[i].value = if(~volumes[i] <= 0.001) { 0 } { ~volumes[i].ampdb.linlin(-30, 0, 0, 1) };
				});
			}.defer;
		};
	};

	~updatePresetList = {
		var files = (~presetPath ++ "*.scd").pathMatch;
		var names = files.collect({ |p| PathName(p).fileNameWithoutExtension });
		if(names.isEmpty) { names = ["No Presets Found"] };
		{ if(presetMenu.notNil) { presetMenu.items = names } }.defer;
	};

	/////////////////////////////////////////////////////////////////
	// TDEF ENGINE (Independent Variations)
	/////////////////////////////////////////////////////////////////

	~numTracks.do({ |i|
		Tdef( ("chan" ++ i).asSymbol, {
			var step = 0;
			loop {
				var currentPattern, delta;

				// Check for individual variation request at start of pattern
				if (step == 0 && ~varRequests[i]) {
					~varRequests[i] = false;
					{ if(~varButtons[i].notNil) { ~varButtons[i].value = 0 } }.defer; // Reset button

					~variations[i].do({ |vDelta|
						if(vDelta > 0 && ~mutes[i].not) {
							s.makeBundle(s.latency, {
								Synth(\liveChannel, [
									\buf, ~samples[~sampleIndices[i].wrap(0, ~samples.size - 1)],
									\freq, ~pitches[i].midicps,
									\amp, ~volumes[i],
									\rel, (vDelta.abs / ~tempo.tempo) * 0.8
								]);
							});
						};
						vDelta.abs.wait;
					});
					step = 0; // Return to pattern start after variation
				};

				currentPattern = ~rhythms[i];
				delta = currentPattern.wrapAt(step);

				if(delta > 0 && ~mutes[i].not) {
					s.makeBundle(s.latency, {
						Synth(\liveChannel, [
							\buf, ~samples[~sampleIndices[i].wrap(0, ~samples.size - 1)],
							\freq, ~pitches[i].midicps,
							\amp, ~volumes[i],
							\rel, (delta.abs / ~tempo.tempo) * 0.8
						]);
					});
				};

				step = step + 1;
				if(step >= currentPattern.size) { step = 0 };
				delta.abs.wait;
			}
		}).quant = 4;
	});

	/////////////////////////////////////////////////////////////////
	// RHYTHM OPTIONS (Same as original)
	/////////////////////////////////////////////////////////////////

	rhythmOptions = [
		[0.75, 1, 0.75, 0.5, 1], [0.75, 0.25,0.75, 0.25, 0.5, 0.5, 1], [2,2,1,2,2,2,1]/3,
		[0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25], [0.5, 0.25, 0.5, 0.5, 0.25, 0.5, 0.5, 0.25, 0.25, 0.25, 0.25],
		[2, 2, 2, 1, 1, 4]/3, [-1, -0.5, 0.5, -1, -0.5, 0.5], [-1.0, -0.33, 0.33, 0.33], [-1, -0.5, 0.5],
		[-1, 1], [2], [-1.75, 0.25], [0.25], [0.5], [1, 1]
	];
	rhythmNames = ["Clave4/4", "ClaveMatanzas", "Clave6/8", "Cascara1", "Cascara2", "cascara Yuka", "Golpe", "GolpeCol", "Yuka Llamador", "Yuka Golpe", "ShekereT", "ShekereA", "16ths", "8ths", "Quarters"];

	/////////////////////////////////////////////////////////////////
	// GUI
	/////////////////////////////////////////////////////////////////

	win = Window("RicaAfroca Sequencer", Rect(100, 100, 950, 820)).front;
	win.view.decorator = FlowLayout(win.view.bounds, 15@15, 10@10);

	startBtn = Button(win, 800@40)
		.states_([["START ALL", Color.black, Color.green], ["STOP ALL", Color.white, Color.red]])
		.action_({ |b| ~numTracks.do({ |i| if(b.value == 1) { Tdef(("chan"++i).asSymbol).play(~tempo) } { Tdef(("chan"++i).asSymbol).stop }; }); });

	bpmDisplay = NumberBox(win, 110@30).value_(~tempo.tempo * 60);
	tempoSlid = Slider(win, 590@30).value_(~tempo.tempo.linlin(1, 3.3, 0, 1)).action_({ |s|
		var bpm = s.value.linlin(0, 1, 60, 200); ~tempo.tempo = bpm / 60; bpmDisplay.value = bpm;
	});

	win.view.decorator.nextLine;

	~numTracks.do({ |i|
		var comp = CompositeView(win, 115@520).background_(Color.grey(0.7));
		comp.decorator = FlowLayout(comp.bounds, 5@5, 5@5);

		StaticText(comp, 105@20).string_("TRACK " + i).align_(\center).font_(Font(bold:true));

		~sampleMenus[i] = PopUpMenu(comp, 105@25).items_(~sampleNames).value_(~sampleIndices[i].wrap(0, ~sampleNames.size-1)).action_({ |menu| ~sampleIndices[i] = menu.value });
		~muteButtons[i] = Button(comp, 105@40).states_([["ON", Color.black, Color.green], ["MUTE", Color.white, Color.red]]).value_(~mutes[i].asInteger).action_({ |b| ~mutes[i] = (b.value == 1) });
		~rhythmMenus[i] = PopUpMenu(comp, 105@30).items_(rhythmNames).value_(~rhythmIndices[i]).action_({ |m| ~rhythms[i] = rhythmOptions[m.value]; ~rhythmIndices[i] = m.value; });

		// INDEPENDENT VARIATION BUTTON
		~varButtons[i] = Button(comp, 105@40)
			.states_([["VARIATION", Color.black, Color.grey(0.8)], ["QUEUED", Color.white, Color.red(0.6)]])
			.canFocus_(false)
			.action_({ |b| ~varRequests[i] = (b.value == 1); });

		StaticText(comp, 105@20).string_("Pitch").align_(\center);
		~pitchSliders[i] = Slider(comp, 105@30).value_(~pitches[i].linlin(36, 72, 0, 1)).action_({ |s| ~pitches[i] = s.value.linlin(0, 1, 36, 72).round; });

		StaticText(comp, 105@20).string_("Vol (dB)").align_(\center);
		~volSliders[i] = Slider(comp, 105@240).value_(~volumes[i].ampdb.linlin(-30, 0, 0, 1)).action_({ |s|
			var db = s.value.linlin(0, 1, -30, 0); ~volumes[i] = if(s.value <= 0.001) { 0 } { db.dbamp };
		});
	});

	masterCol = CompositeView(win, 115@520);
	masterCol.decorator = FlowLayout(masterCol.bounds, 5@5, 5@5);
	StaticText(masterCol, 105@20).string_("");
	masterMuteBtn = Button(masterCol, 105@40).states_([["MUTE ALL", Color.black, Color.yellow], ["UNMUTE ALL", Color.white, Color.red]]).action_({ |b| ~numTracks.do({ |i| ~muteButtons[i].valueAction_(b.value); }); });

	win.view.decorator.nextLine;

	presetNameField = TextField(win, 150@40).string_("newPreset").action_({ win.view.focus; });
	saveBtn = Button(win, 100@40).states_([["SAVE", Color.black, Color.yellow]]).action_({ ~saveSettings.value(presetNameField.string); ~updatePresetList.value; });
	presetMenu = PopUpMenu(win, 200@40).items_(["Scanning..."]);
	loadBtn = Button(win, 100@40).states_([["LOAD", Color.black, Color.cyan]]).action_({ if(presetMenu.item.notNil) { ~loadSettings.value(presetMenu.item) }; });
	refreshBtn = Button(win, 100@40).states_([["REFRESH", Color.white, Color.grey(0.3)]]).action_({ ~updatePresetList.value });

	~updatePresetList.value;
	win.view.keyDownAction = { |view, char, modifiers, unicode, keycode| if (unicode == 32) { startBtn.valueAction = (startBtn.value + 1) % 2; }; };
	win.onClose = { ~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop }) };
});
)