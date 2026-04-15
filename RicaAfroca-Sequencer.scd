////////////////////////////////////////////////////////////
// 1. INITIAL CONDITIONS & VARIABLES
////////////////////////////////////////////////////////////

(
s.waitForBoot({
    // Local GUI variables
    var win, startBtn, tempoSlid, bpmDisplay, saveBtn, loadBtn, rhythmOptions;

    // Global variables
    ~numTracks = 6;
    ~tempo = TempoClock.new(120/60).permanent_(true);

    // Global arrays for GUI objects
    ~muteButtons = Array.newClear(~numTracks);
    ~rhythmMenus = Array.newClear(~numTracks);
    ~pitchSliders = Array.newClear(~numTracks);

    // State variables
    ~rhythmIndices = Array.fill(~numTracks, { 0 });
    ~rhythms = Array.fill(~numTracks, { [0.5, 0.5] });
    ~mutes = Array.fill(~numTracks, { false });
    ~pitches = Array.fill(~numTracks, { 60 });

    s.makeGui;
    s.meter;

    // Load Samples
    ~samples = [
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Clave.wav"),
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Cowbell.wav"),
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Cata.wav"),
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Shaker3.wav"),
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Shaker1.wav"),
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Conga.wav")
    ];

    // Updated SynthDef with Pitch Rate logic
    SynthDef(\liveChannel, {
        arg out=0, buf=0, freq=440, amp=0.5, pan=0, rel=0.3;
        var sig, env, rate;
        // Rate 1.0 = MIDI 60
        rate = freq / 60.midicps;
        env = EnvGen.kr(Env.perc(0.005, rel), 1, doneAction: 2);
        sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, loop: 0);
        Out.ar(out, Pan2.ar(sig * 0.8 * env * amp, pan));
    }).add;

    // --- SAVE & LOAD LOGIC ---
    ~saveSettings = {
        var data = Dictionary.new;
        data.put(\rhythms, ~rhythms);
        data.put(\mutes, ~mutes);
        data.put(\pitches, ~pitches);
        data.put(\bpm, ~tempo.tempo * 60);
        data.put(\indices, ~rhythmIndices);
        data.writeArchive("/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/mySettings.scd");
        "--- Settings Saved ---".postln;
    };

    ~loadSettings = {
        var data = Object.readArchive("/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/mySettings.scd");
        if(data.notNil) {
            ~rhythms = data[\rhythms];
            ~mutes = data[\mutes];
            ~pitches = data[\pitches];
            ~tempo.tempo = (data[\bpm] ?? {120}) / 60;
            ~rhythmIndices = data[\indices] ?? { Array.fill(~numTracks, {0}) };
            "--- Settings Loaded ---".postln;
        };
    };

    // Load settings from disk before building GUI or Tdefs
    ~loadSettings.value;

    // --- THE TDEF SEQUENCERS ---
    ~numTracks.do({ |i|
        Tdef( ("chan" ++ i).asSymbol, {
            var step = 0;
            loop {
                var delta = ~rhythms[i].wrapAt(step);
                if(delta > 0 && ~mutes[i].not) {
                    Synth(\liveChannel, [
                        \buf, ~samples[i],
                        \freq, ~pitches[i].midicps,
                        \amp, 0.7,
                        \rel, delta.abs * 0.8
                    ]);
                };
                step = step + 1;
                delta.abs.wait;
            }
        }).quant = 4;
    });

    // --- THE GUI (Widescreen Single Row) ---
    rhythmOptions = [
        [0.75, 1, 0.75, 0.5, 1], [0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25],
        [-1, -0.5, 0.5], [2], [-1.75, 0.25], [0.25], [0.5], [0.5, 0.25, 0.25], [1, 1], [0.75, 0.25], [0.33, 0.33, 0.34]
    ];

    win = Window("RicaAfroca Sequencer", Rect(100, 100, 830, 550)).front;
    win.view.decorator = FlowLayout(win.view.bounds, 15@15, 10@10);

    startBtn = Button(win, 800@40)
        .states_([["START ALL", Color.black, Color.green], ["STOP ALL", Color.white, Color.red]])
        .action_({ |b|
            ~numTracks.do({ |i|
                if(b.value == 1) { Tdef(("chan"++i).asSymbol).play(~tempo) } { Tdef(("chan"++i).asSymbol).stop };
            });
        });

    tempoSlid = Slider(win, 670@30).value_(~tempo.tempo.linlin(1, 3.3, 0, 1)).action_({ |s|
        var bpm = s.value.linlin(0, 1, 60, 200);
        ~tempo.tempo = bpm / 60;
        bpmDisplay.value = bpm;
    });
    bpmDisplay = NumberBox(win, 110@30).value_(~tempo.tempo * 60);

    win.view.decorator.nextLine;

    ~numTracks.do({ |i|
        var comp = CompositeView(win, 115@320).background_(Color.grey(0.7));
        comp.decorator = FlowLayout(comp.bounds, 5@5, 5@5);

        StaticText(comp, 105@20).string_("TRACK " + i).align_(\center).font_(Font(bold:true));

        ~muteButtons[i] = Button(comp, 105@40)
            .states_([["ON", Color.black, Color.green], ["MUTE", Color.white, Color.red]])
            .value_(~mutes[i].asInteger)
            .action_({ |b| ~mutes[i] = (b.value == 1) });

        ~rhythmMenus[i] = PopUpMenu(comp, 105@30)
            .items_(["Clave", "Cascara1", "Golpe", "ShekereT", "ShekereA", "16ths", "8ths", "Swing", "Quarters", "Dotted", "Triplets"])
            .value_(~rhythmIndices[i])
            .action_({ |m|
                ~rhythms[i] = rhythmOptions[m.value];
                ~rhythmIndices[i] = m.value;
            });

        StaticText(comp, 105@20).string_("Pitch").align_(\center);
        ~pitchSliders[i] = Slider(comp, 105@30)
            .value_(~pitches[i].linlin(36, 72, 0, 1))
            .action_({ |s|
                ~pitches[i] = s.value.linlin(0, 1, 36, 72).round;
            });
    });

    win.view.decorator.nextLine;

    saveBtn = Button(win, 395@40).states_([["SAVE", Color.black, Color.yellow]]).action_({ ~saveSettings.value });

    loadBtn = Button(win, 395@40).states_([["LOAD", Color.black, Color.cyan]]).action_({
        ~loadSettings.value;
        {
            bpmDisplay.value = ~tempo.tempo * 60;
            ~numTracks.do({ |i|
                if(~rhythmMenus[i].notNil) { ~rhythmMenus[i].value = ~rhythmIndices[i] };
                if(~muteButtons[i].notNil) { ~muteButtons[i].value = ~mutes[i].asInteger };
                if(~pitchSliders[i].notNil) { ~pitchSliders[i].value = ~pitches[i].linlin(36, 72, 0, 1) };
            });
        }.defer;
    });

    win.onClose = { ~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop }) };
});
)