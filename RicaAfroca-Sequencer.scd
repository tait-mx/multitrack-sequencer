/*
Crear variaciones en el Golpe y poner un botón para dispararlas
botones físicos para tempo y respuestas golpe
*/


(
s.waitForBoot({

	/////////////////////////////////////////////////////////////////
	// VARIABLES
	/////////////////////////////////////////////////////////////////

	var win, startBtn, tempoSlid, tempoUp, tempoDown, bpmDisplay, saveBtn, loadBtn, presetNameField, presetMenu, refreshBtn, rhythmOptions, rhythmNames, masterMuteBtn, masterCol;

	~numTracks = 6;
	~tempo = TempoClock.new(120/60).permanent_(true);

	~muteButtons = Array.newClear(~numTracks);
	~rhythmMenus = Array.newClear(~numTracks);
	~pitchSliders = Array.newClear(~numTracks);
	~volSliders = Array.newClear(~numTracks);

	~rhythmIndices = Array.fill(~numTracks, { 0 });
	~rhythms = Array.fill(~numTracks, { [0.5, 0.5] });
	~mutes = Array.fill(~numTracks, { false });
	~pitches = Array.fill(~numTracks, { 60 });
	~volumes = Array.fill(~numTracks, { -6.dbamp });

	s.makeGui;
	s.meter;

	/////////////////////////////////////////////////////////////////
	// BUFFERS
	/////////////////////////////////////////////////////////////////

	~samples = [
		Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Clave.wav"),
		Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Cowbell.wav"),
		Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Cata.wav"),
		Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Shaker3.wav"),
		Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Shaker1.wav"),
		Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Conga.wav")
	];

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
		var path = "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/" ++ name ++ ".scd";
		data.put(\rhythms, ~rhythms);
		data.put(\mutes, ~mutes);
		data.put(\pitches, ~pitches);
		data.put(\bpm, ~tempo.tempo * 60);
		data.put(\indices, ~rhythmIndices);
		data.put(\volumes, ~volumes);
		data.writeArchive(path);
		("--- Saved to: " ++ name ++ " ---").postln;
	};

	~loadSettings = { |name|
		var path = "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/" ++ name ++ ".scd";
		var data = Object.readArchive(path);
		if(data.notNil) {
			~rhythms = data[\rhythms];
			~mutes = data[\mutes];
			~pitches = data[\pitches];
			~tempo.tempo = (data[\bpm] ?? {120}) / 60;
			~rhythmIndices = data[\indices] ?? { Array.fill(~numTracks, {0}) };
			~volumes = data[\volumes] ?? { Array.fill(~numTracks, { 0.7 }) };
			("--- Loaded: " ++ name ++ " ---").postln;
		} {
			("!!! Preset " ++ name ++ " not found !!!").warn;
		};
	};

	~updatePresetList = {
		var path = "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/*.scd";
		var files = path.pathMatch;
		var names = files.collect({ |p| PathName(p).fileNameWithoutExtension });
		if(names.isEmpty) { names = ["No Presets Found"] };
		{ presetMenu.items = names; }.defer;
	};

	/////////////////////////////////////////////////////////////////
	// TDEF GENERATION
	/////////////////////////////////////////////////////////////////

	~numTracks.do({ |i|
		Tdef( ("chan" ++ i).asSymbol, {
			var step = 0;
			loop {
				var delta = ~rhythms[i].wrapAt(step);
				if(delta > 0 && ~mutes[i].not) {
					s.makeBundle(s.latency, {
						Synth(\liveChannel, [
							\buf, ~samples[i],
							\freq, ~pitches[i].midicps,
							\amp, ~volumes[i],
							\rel, (delta.abs / ~tempo.tempo) * 0.8
						]);
					});
				};
				step = step + 1;
				delta.abs.wait;
			}
		}).quant = 4;
	});

	/////////////////////////////////////////////////////////////////
	// RHYTHMS
	/////////////////////////////////////////////////////////////////

	rhythmOptions = [
		[0.75, 1, 0.75, 0.5, 1], [2,2,1,2,2,2,1]/3,
		[0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25],
		[0.5, 0.25, 0.5, 0.5, 0.25, 0.5, 0.5, 0.25, 0.25, 0.25, 0.25],
		[-1, -0.5, 0.5], [-1.0, -0.33333333333333, 0.33333333333333, 0.33333333333333],
		[2], [-1.75, 0.25], [0.25], [0.5], [1, 1]
	];

	rhythmNames = ["Clave4/4", "Clave6/8", "Cascara1", "Cascara2", "Golpe", "GolpeCol", "ShekereT", "ShekereA", "16ths", "8ths", "Quarters"];

	/////////////////////////////////////////////////////////////////
	// GUI
	/////////////////////////////////////////////////////////////////

	win = Window("RicaAfroca Sequencer", Rect(100, 100, 950, 750)).front; // Increased width to 950
	win.view.decorator = FlowLayout(win.view.bounds, 15@15, 10@10);

	startBtn = Button(win, 800@40)
		.states_([["START ALL", Color.black, Color.green], ["STOP ALL", Color.white, Color.red]])
	    .canFocus_(false) // <--- ADD THIS
		.action_({ |b|
			~numTracks.do({ |i|
				if(b.value == 1) { Tdef(("chan"++i).asSymbol).play(~tempo) } { Tdef(("chan"++i).asSymbol).stop };
			});
		});


	bpmDisplay = NumberBox(win, 110@30).value_(~tempo.tempo * 60);

	tempoSlid = Slider(win, 590@30).value_(~tempo.tempo.linlin(1, 3.3, 0, 1)).action_({ |s|
    var bpm = s.value.linlin(0, 1, 60, 200);
    ~tempo.tempo = bpm / 60;
    bpmDisplay.value = bpm;
}).canFocus_(false); // <--- ADD THIS;

	tempoDown = Button(win, 40@30)
	.states_([["-1", Color.black, Color.grey(0.8)]])
	.canFocus_(false) // <--- ADD THIS
    .action_({
        var newBpm = (~tempo.tempo * 60) - 1;
        ~tempo.tempo = newBpm.max(20) / 60;
        {
            bpmDisplay.value = ~tempo.tempo * 60;
            tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1);
        }.defer;
    });

	tempoUp = Button(win, 40@30)
    .states_([["+1", Color.black, Color.grey(0.8)]])
	.canFocus_(false) // <--- ADD THIS
    .action_({
        var newBpm = (~tempo.tempo * 60) + 1;
        ~tempo.tempo = newBpm.min(300) / 60;
        {
            bpmDisplay.value = ~tempo.tempo * 60;
            tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1);
        }.defer;
    });

	win.view.decorator.nextLine;

	// TRACK LOOP
	~numTracks.do({ |i|
		var comp = CompositeView(win, 115@480).background_(Color.grey(0.7));
		comp.decorator = FlowLayout(comp.bounds, 5@5, 5@5);

		StaticText(comp, 105@20).string_("TRACK " + i).align_(\center).font_(Font(bold:true));

		~muteButtons[i] = Button(comp, 105@40)
			.states_([["ON", Color.black, Color.green], ["MUTE", Color.white, Color.red]])
		    .canFocus_(false) // <--- ADD THIS
			.value_(~mutes[i].asInteger)
			.action_({ |b| ~mutes[i] = (b.value == 1) });

		~rhythmMenus[i] = PopUpMenu(comp, 105@30)
			.items_(rhythmNames)
		    .canFocus_(false) // <--- ADD THIS
			.value_(~rhythmIndices[i])
			.action_({ |m|
				~rhythms[i] = rhythmOptions[m.value];
				~rhythmIndices[i] = m.value;
			});

		StaticText(comp, 105@20).string_("Pitch").align_(\center);
		~pitchSliders[i] = Slider(comp, 105@30)
	        .canFocus_(false) // <--- ADD THIS
			.value_(~pitches[i].linlin(36, 72, 0, 1))
			.action_({ |s| ~pitches[i] = s.value.linlin(0, 1, 36, 72).round; });

		StaticText(comp, 105@20).string_("Vol (dB)").align_(\center);
		~volSliders[i] = Slider(comp, 105@280)
			.value_(~volumes[i].ampdb.linlin(-30, 0, 0, 1))
			.action_({ |s|
				var db = s.value.linlin(0, 1, -30, 0);
				~volumes[i] = if(s.value <= 0.001) { 0 } { db.dbamp };
			});
	});

	// --- MASTER MUTE COLUMN (Aligned with tracks) ---
	masterCol = CompositeView(win, 115@480);
	masterCol.decorator = FlowLayout(masterCol.bounds, 5@5, 5@5);
	StaticText(masterCol, 105@20).string_(""); // Spacer for Track Label
	masterMuteBtn = Button(masterCol, 105@40)
		.states_([["MUTE ALL", Color.black, Color.yellow], ["UNMUTE ALL", Color.white, Color.red]])
	    .canFocus_(false) // <--- ADD THIS
		.action_({ |b|
			~numTracks.do({ |i| ~muteButtons[i].valueAction_(b.value); });
		});

	win.view.decorator.nextLine;

	// --- PRESET FOOTER ---
	presetNameField = TextField(win, 150@40).string_("newPreset").align_(\center).canFocus_(false); // <--- ADD THIS;;

	saveBtn = Button(win, 100@40).states_([["SAVE", Color.black, Color.yellow]]).action_({
		~saveSettings.value(presetNameField.string);
		~updatePresetList.value;
	}).canFocus_(false); // <--- ADD THIS;

	presetMenu = PopUpMenu(win, 200@40).items_(["Scanning..."]).background_(Color.white).canFocus_(false); // <--- ADD THIS;;

	loadBtn = Button(win, 100@40).states_([["LOAD", Color.black, Color.cyan]]).action_({
		var selectedName = presetMenu.item;
		if(selectedName.notNil && (selectedName != "No Presets Found")) {
			~loadSettings.value(selectedName);
			{
				bpmDisplay.value = ~tempo.tempo * 60;
				tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1);
				~numTracks.do({ |i|
					~rhythms[i] = rhythmOptions[~rhythmIndices[i]];
					~rhythmMenus[i].value = ~rhythmIndices[i];
					~muteButtons[i].value = ~mutes[i].asInteger;
					~pitchSliders[i].value = ~pitches[i].linlin(36, 72, 0, 1);
					~volSliders[i].value = if(~volumes[i] <= 0.001) { 0 } { ~volumes[i].ampdb.linlin(-30, 0, 0, 1) };
				});
			}.defer;
		};
	}).canFocus_(false); // <--- ADD THIS;

	refreshBtn = Button(win, 100@40).states_([["REFRESH", Color.white, Color.grey(0.3)]]).action_({ ~updatePresetList.value }).canFocus_(false); // <--- ADD THIS;

	~updatePresetList.value;

	// --- KEYBOARD SHORTCUTS ---
    win.view.keyDownAction = { |view, char, modifiers, unicode, keycode|
        // keycode 32 is Spacebar on most Linux/Mac/Win systems
        if (unicode == 32) {
            // .valueAction_ simulates a physical click on the Start button
            startBtn.valueAction = (startBtn.value + 1) % 2;
            "Spacebar: Toggle Start/Stop".postln;
        };
    };

	win.onClose = { ~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop }) };
});
)