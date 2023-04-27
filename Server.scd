//Chat server
//Must be initialized before clients can connect
//To run this piece solo, do the following:
// set ~num_players = 1
// Execute the first code block in this file (lines 10 - 217) Note the port number in the post window
// Ensure ~my_ip and ~server_ip both have the IP address 127.0.0.1 in Play Me.scd
// You may need to change the port number as well, but it is probably 57120
// Execute the first code block in Play Me.scd (or whichever "Play Me" file you are using)
// Execute the second code block in this file to start the piece (lines 265 - END)
(
// s.options.outDevice_("ASIO : MOTU Audio ASIO"); // This one for Windows 11 in Studio X
s.options.outDevice_("MME : Out 1-24 (2- MOTU Pro Audio)"); // This one for MOTU UltraLite AVB
~num_players = 8; // Number of performers/speakers
~studio_X_offset = 0;
s.options.numOutputBusChannels = ~num_players + ~studio_X_offset;
s.options.memSize = 65536;
// s.options.outDevice = "MME : Out 1-24 (MOTU Pro Audio)";
/*ServerOptions.outDevices.do({
arg item;
item.postln;
})*/
s.waitForBoot{
	~path = PathName(thisProcess.nowExecutingPath).parentPath;
	~ips = List.new();
	~samples = List.new();
	NetAddr.langPort.postln;

	//Load the sample files into a list of buffers
	Buffer.freeAll;
	s.sync;
	PathName(~path ++ "Samples/Compressed/").entries.do({
		arg file;
		~samples.add(Buffer.read(s, file.fullPath));
	});
	s.sync;

	SynthDef.new(\grain, {
		arg out, trigger = 100, len = 0.39, sndbuf, rate = 1.0, pos = 4.6, interp = 2, pan = 0, mul = 1;
		var sig, env;
		sig = GrainBuf.ar(
			numChannels: 1,
			trigger: Impulse.ar(trigger),
			dur: len,
			sndbuf: sndbuf,
			rate: rate,
			pos: pos,
			interp: interp,
			pan: pan,
			envbufnum: -1,
			maxGrains: 300,
		);
		env = EnvGen.kr(Env.perc(releaseTime: len), doneAction: 2);
		// sig = Compander.ar(sig, sig) * mul;
		sig = sig * env* mul;
		Out.ar(out, sig);
	}).add;
	SynthDef.new(\reso, {
		arg in, out, freq = 440, bwr = 1.0, mul = 1.0, mix = 0.0;
		var dry, wet, sig;
		dry = In.ar(in);
		wet = Resonz.ar(dry, freq, bwr);
		wet = Limiter.ar(wet, -10.dbamp, 0.001);
		sig = XFade2.ar(dry, wet, mix*2-1, mul);
		Out.ar(out, sig);
	}).add;
	SynthDef.new(\chorus, {
		arg in, out, predelay = 0.08, speed = 0.05, depth = 0.1, ph_diff = 0.5, mul = 1.0, mix = 0.0;
		var sig, dry, wet, modulators, numDelays = 12;
		dry = In.ar(in);
		wet = dry * numDelays.reciprocal;
		modulators = Array.fill(numDelays, {arg i; LFPar.kr(speed * rrand(0.94, 1.06), ph_diff * i, depth, predelay);});
		wet = DelayC.ar(wet, 0.5, modulators);
		wet = wet.sum;
		sig = XFade2.ar(dry, wet, 2*mix-1, mul);
		Out.ar(out, sig);
	}).add;
	SynthDef.new(\distortion, {
		arg in, out, lvl = 100, mix = 0.0, mul = 1.0;
		var sig, dry, wet;
		dry = In.ar(in);
		wet = dry * lvl;
		wet = wet.softclip;
		wet = Limiter.ar(wet, -26.dbamp, 0.001);
		sig = XFade2.ar(dry, wet, 2*mix-1, mul);
		Out.ar(out, sig);
	}).add;
	SynthDef.new(\reverb, {
		arg in, out, predelay = 1, revtime = 10, lpf = 4500, mix = 0.0, mul = 1.0;
		var sig, dry, wet, temp;
		dry = In.ar(in);
		temp = dry;
		wet = 0;
		temp = DelayN.ar(temp, 0.2, predelay);
		16.do{temp = AllpassN.ar(temp, 0.05, {Rand(0.001, 0.05)}, revtime); //Maybe AllpassL
			temp = LPF.ar(temp, lpf);
			wet = wet + temp;
		};
		sig = XFade2.ar(dry, wet, mix*2-1, mul);
		Out.ar(out, sig);
	}).add;
	SynthDef(\snd, {
		arg in, pos, out = 0;
		var sig;
		sig = In.ar(in, 1);
		sig = LeakDC.ar(sig);
		sig = PanAz.ar(~num_players, sig, pos%~num_players*2/~num_players, 1, 1, 1.0, 0);
		Out.ar(out+~studio_X_offset, sig);
	}).add;

	OSCdef(\server_chat_handler, {
		arg msg;
		var username, chat;
		msg.postln;
		username = msg[1];
		chat = msg[2];
		~ips.do({
			arg item;
			NetAddr.new(item[0].asString, NetAddr.langPort).sendMsg('/receive', username, chat);
		});
	}, '/chat');

	OSCdef(\server_registration, {
		arg msg;
		var ip, username, speaker_num;
		ip = msg[1];
		username = msg[2];
		speaker_num = msg[3];
		~ips.add([ip, username, speaker_num]);
		NetAddr.new(ip.asString, NetAddr.langPort).sendMsg('/receive', username, "Username sucessfully registered");
	}, '/registration');
	s.sync;

	~countdown = {
		arg duration = 10;
		var r1;

		r1 = Routine({
			duration.do({
				arg num;
				~ips.do({
					arg item;
					NetAddr.new(item[0].asString, NetAddr.langPort).sendMsg('/timer_recieve', (duration-num));
				});
				1.wait;
			});

		});
		r1.play;
	};

	~conduct = {
		arg slider_num, current_value, target_value, current_msg = "current_msg", next_msg = "next_msg", duration = 0;
		var r1, anim_rate;
		anim_rate = 30;
		~ips.do({ // Set the text for current_msg and next_msg in performer score
			arg item;
			NetAddr.new(item[0].asString, NetAddr.langPort).sendMsg('/conductor_receive', current_msg, next_msg);
		});


		if (duration > 0) {
			r1 = Routine({ // Animate the slider moving from current_value to target_value
				(anim_rate*duration).do({
					arg num;
					var increment;
					increment = target_value-current_value/duration;
					~ips.do({
						arg item;
						NetAddr.new(item[0].asString, NetAddr.langPort).sendMsg('/timer_recieve', (duration-(num/anim_rate)).round);
						NetAddr.new(item[0].asString, NetAddr.langPort).sendMsg('/conduct', slider_num, (current_value+(increment*(num+1)/anim_rate)));
					});
					(1/anim_rate).wait;
				});
			});
			r1.play;
		}
		{

			~ips.do({
				arg item;
				NetAddr.new(item[0].asString, NetAddr.langPort).sendMsg('/conduct', slider_num, target_value);
			});

		};
	};

	~slide = {
		arg slider_num, value;
		~ips.do({
			arg item, i;

		});
	};

	~pattern_msg_handler = {
		arg speaker_offset = 0;
		OSCdef(\pattern_msg, {
			arg msg;
			var speaker_number, key, pattern;
			speaker_number = (msg[1] + speaker_offset)%~num_players;
			speaker_number.postln;
			key = (msg[2].asString ++ "_" ++ speaker_number.asString).asSymbol;
			pattern = msg[3];
			msg.postln;
			Pdefn(key, pattern.asString.interpret);
		}, '/pattern_msg');
	};
	~pattern_msg_handler.value(0);

	~fx_msg_handler = {
		arg speaker_offset = 0;
		OSCdef(\fx_msg, {
			arg msg;
			var speaker_number, key, synth, value;
			speaker_number = (msg[1] + speaker_offset)%~num_players;
			synth = msg[2];
			key = msg[3];
			value = msg[4];
			msg.postln;
			(synth.asString ++ "s" ++ ([speaker_number]).asString).postln;
			((synth.asString ++ "s" ++ ([speaker_number]).asString).interpret).set(key, value);
		}, '/fx_msg');
	};
	~fx_msg_handler.value(0);

	~pause_pattern = List.newClear(8);

	~phone_override_handler = {
		arg speaker_offset = 0;
		OSCdef(\phone_override_msg, {
			arg msg;
			var speaker_number, pos, rate, len, mul;
			speaker_number = (msg[1] + speaker_offset)%~num_players;
			pos = msg[2];
			rate = msg[3];
			len = msg[4];
			if (msg[5] != nil, {mul = msg[5]},{mul = 1});
			mul.postln;
			msg.postln;
			Synth(\grain, [
				out: ~reso_buses[speaker_number%~num_players],
				sndbuf: ~samples[(msg[1]+speaker_offset)%~num_players],
				trigger: 1,
				len: len,
				pos: pos,
				rate: rate,
				mul: mul
			]);
			~pause_pattern[speaker_offset%7].stop;
			~pause_pattern[speaker_offset%7] = Routine({
				var this_num;
				this_num = speaker_number%~num_players;
				~pattern_conductors[this_num].pause;
				10.yield;
				~pattern_conductors[this_num].resume;
			});
			~pause_pattern[speaker_offset%7].play;
		}, '/phone_override_msg');
	};
	~phone_override_handler.value(0);
};
)

//Play the piece here
(
s.waitForBoot{
	//Create buses
	//Each performer's output will be sent to a bus which can be rotated around the room
	//There are also some effects buses
	s.newBusAllocators;
	~reso_buses = List.new();
	~num_players.do({
		arg item, i;
		~reso_buses.add(Bus.audio(s, 1));
	});
	~chorus_buses = List.new();
	~num_players.do({
		arg item, i;
		~chorus_buses.add(Bus.audio(s, 1));
	});
	~distortion_buses = List.new();
	~num_players.do({
		arg item, i;
		~distortion_buses.add(Bus.audio(s, 1));
	});
	~reverb_buses = List.new();
	~num_players.do({
		arg item, i;
		~reverb_buses.add(Bus.audio(s, 1));
	});
	~snd_buses = List.new();
	~num_players.do({
		arg item, i;
		~snd_buses.add(Bus.audio(s, 1))
	});

	s.sync;

	//Create synths
	//
	~snd_synths = List.new();
	~num_players.do({
		arg item, i;
		~snd_synths.add(
			Synth(\snd, [in: ~snd_buses[i], pos: i, out: 0]);
		);
	});
	~reverb_synths = List.new();
	~num_players.do({
		arg item, i;
		~reverb_synths.add(
			Synth(\reverb, [in: ~reverb_buses[i], out: ~snd_buses[i]]);
		);
	});
	~distortion_synths = List.new();
	~num_players.do({
		arg item, i;
		~distortion_synths.add(
			Synth(\distortion, [in: ~distortion_buses[i], out: ~reverb_buses[i]]);
		);
	});
	~chorus_synths = List.new();
	~num_players.do({
		arg item, i;
		~chorus_synths.add(
			Synth(\chorus, [in: ~chorus_buses[i], out: ~distortion_buses[i]]);
		);
	});
	~reso_synths = List.new();
	~num_players.do({
		arg item, i;
		~reso_synths.add(
			Synth(\reso, [in: ~reso_buses[i], out: ~chorus_buses[i]]);
		);
	});

	s.sync;
	s.record(numChannels: ~num_players + ~studio_X_offset);
	s.sync;
	//Initial pbinds made here
	//Note which paramenters can be controlled by Pdefn
	~pbinds = List.new();
	~num_players.do({
		arg item, i;
		~pbinds.add(
			Pbind(
				\instrument, \grain,
				\sndbuf, ~samples[i],
				\trigger, Pdefn(("\mytrigger_" ++ i).asSymbol, Pwhite(1, 5)),
				\len, Pdefn(("\mylen_" ++ i).asSymbol, Pkey(\dur)*1),
				\dur, Pdefn(("\mydur_" ++ i).asSymbol, Pwhite(0.1, 0.3)),
				\rate, Pdefn(("\myrate_" ++ i).asSymbol, Pwhite(0.2, 1.3)),
				\pos, Pdefn(("\mypos_" ++ i).asSymbol, Pgauss(0.5, 0.5)), //between 0 and 1
				\mul, Pdefn(("\mymul_" ++ i).asSymbol, 1),
				\out, Pdefn(("\myout_" ++ i).asSymbol, ~reso_buses[i])
			)
		)
	});
	//Play the pbinds here
	~pattern_conductors = List.new();
	~num_players.do({
		arg item, i;
		~pattern_conductors.add(PatternConductor(~pbinds[i], quant: 0));
		~pattern_conductors[i].play;
	});

	~pattern_off = {
		~num_players.do({
			arg item, i;
			~pattern_conductors[i].stop;
		});
	};

	// Three axes:
	// Dense - Sparse
	// Random - Patterned
	// Homogeneous - Distinct
	~rotate = {
		arg offset;
		~pattern_msg_handler.value(offset.neg); //Adjust the music_msg receiver such that commands are rotated to the correct speaker
		~fx_msg_handler.value(offset.neg);
		~phone_override_handler.value(offset.neg);
		~snd_synths.do({
			arg item, i;
			item.set(\pos, i+offset)
		});
		8.do({arg item; ~pause_pattern[item].play;});
	};
	~avg = 60;

	r = Routine({
		~conduct.value(1, 0.0, 1.0, "", "", 1);
		~conduct.value(2, 0.0, 1.0, "", "", 1);
		~conduct.value(3, 0.0, 1.0, "", "", 1);
		1.wait;

		~conduct.value(2, 1.0, 0.0, "More sparse", "More distinct", ~avg-30); //state 2
		(~avg-30).wait;
		~rotate.value(1);

		~conduct.value(1, 1.0, 0.0, "More distinct", "More patterned and homogeneous", ~avg-30); //state 3
		(~avg-30).wait;
		~rotate.value(2);

		~conduct.value(1, 0.0, 1.0, "More patterned and homogeneous", "Stay patterned", ~avg+30); //state 4
		~conduct.value(3, 1.0, 0.0, "More patterned and homogeneous", "Stay patterned", ~avg+30); //state 4
		(~avg+30).wait;
		~rotate.value(3);

		~conduct.value(3, 0.0, 0.0, "Stay patterned", "More dense", ~avg+30); //state 5
		(~avg+30).wait;
		~rotate.value(4);

		~conduct.value(2, 0.0, 1.0, "More dense", "More random", ~avg-30); //state 6
		(~avg-30).wait;
		~rotate.value(5);

		~conduct.value(3, 0.0, 1.0, "More random", "More distinct", 30); //state 7
		(30).wait;
		~rotate.value(6);

		~conduct.value(1, 1.0, 0.0, "More distinct", "More sparse", 30); //state 8
		(30).wait;
		~rotate.value(7);

		~conduct.value(2, 1.0, 0.60, "More sparse", "More sparse", 30); //state 9
		(30).wait;
		~rotate.value(8);

		~conduct.value(2, 0.60, 0.30, "More sparse", "More sparse", 30); //state 9
		(30).wait;
		~rotate.value(9);

		~conduct.value(2, 0.30, 0.0, "More sparse", "All done", 30); //state 9
		(30).wait;

		~conduct.value(2, 0.0, 0.0, "All done", "", 5); //state 9
		5.wait;

		~pattern_off.value;
		OSCdef(\phone_override_msg).free;

	});
	r.play;
};
)