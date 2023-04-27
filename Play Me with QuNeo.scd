//Performance script for Assembly Circle

//Wait for the server to be booted, then run the following block
(
~my_ip = NetAddr.new("127.0.0.1", 57120); //my ip address (for windows, go to cmd, then type ipconfig.
~server_ip = NetAddr.new("127.0.0.1", 57120); //ip of the server
~username = "Xavier2";//Your username goes here
~speaker_number = 0;//Coordinate your speaker number with the ensemble. They must all be unique!
"Client.scd".resolveRelative.load;

MIDIClient.init;
MIDIIn.connectAll;
m = MIDIOut(1);

m.noteOff(1, 58, 64);
~rhombus_hold = False;
~pad_1_pressure = 0;
~pad_2_pressure = 0;
~pad_3_pressure = 0;
~pad_4_pressure = 0;
~pad_5_pressure = 0;
~pad_6_pressure = 0;
~pad_7_pressure = 0;
~pad_8_pressure = 0;
~pad_9_pressure = 0;
~pad_10_pressure = 0;
~pad_11_pressure = 0;
~pad_12_pressure = 0;
~pad_13_pressure = 0;
~pad_14_pressure = 0;
~pad_15_pressure = 0;
~pad_16_pressure = 0;
~big_slider_location = 63;
~big_slider_width = 0;
~lr_1_sum = 0.5;
~lr_2_sum = 0.5;
~lr_3_sum = 0.5;
~lr_4_sum = 5;
~stop_play_sum = 500;


//QuNeo Preset 1 mapping
//transport buttons
MIDIdef.cc(\diamond_pressure, { arg data; ~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mylen, (Pkey(\dur)).asCompileString);}, 84);
MIDIdef.cc(\stop_pressure, { arg data;
	~stop_play_sum = (data.linexp(0, 127, 1.0, 1.1).reciprocal * ~stop_play_sum).clip(60.0, 10000.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \freq, ~stop_play_sum);
}, 85);
MIDIdef.cc(\play_pressure, { arg data;
	~stop_play_sum = (data.linexp(0, 127, 1.0, 1.1) * ~stop_play_sum).clip(60.0, 10000.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \freq, ~stop_play_sum);
}, 86);

//horizontal slider 1 //effect 1
MIDIdef.cc(\left_1_pressure, { arg data; data.postln;
	~lr_1_sum = (data.linlin(0, 127, 0.0, -0.05) + ~lr_1_sum).clip(0.01, 1.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \bwr, ~lr_1_sum);
}, 71);
MIDIdef.cc(\right_1_pressure, { arg data; data.postln;
	~lr_1_sum = (data.linlin(0, 127, 0.0, 0.05) + ~lr_1_sum).clip(0.01, 1.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \bwr, ~lr_1_sum);
}, 72);
MIDIdef.cc(\slider_1_pressure, { arg data; }, 12);
MIDIdef.cc(\slider_1_location, { arg data; ~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \mix, data.linlin(0, 127, 0.0, 1.0));
}, 0); //effect wetness

//horizontal slider 2 //effect 2
MIDIdef.cc(\left_2_pressure, { arg data;
	~lr_2_sum = (data.linexp(0, 127, 0.001, 0.1).neg + ~lr_2_sum).clip(0.0001, 1.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \depth, ~lr_2_sum);
}, 73);
MIDIdef.cc(\right_2_pressure, { arg data;
	~lr_2_sum = (data.linexp(0, 127, 0.001, 0.1) + ~lr_2_sum).clip(0.0001, 1.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \depth, ~lr_2_sum);
}, 74);
MIDIdef.cc(\slider_2_pressure, { arg data; data.postln;}, 13);
MIDIdef.cc(\slider_2_location, { arg data; ~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \mix, data.linlin(0, 127, 0.0, 1.0));
}, 1);

//horizontal slider 3
MIDIdef.cc(\left_3_pressure, { arg data;
	~lr_3_sum = (data.linexp(0, 127, 1, 70).neg + ~lr_3_sum).clip(2, 300);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \lvl, ~lr_3_sum);
}, 75);
MIDIdef.cc(\right_3_pressure, { arg data;
	~lr_3_sum = (data.linexp(0, 127, 1, 70) + ~lr_3_sum).clip(2, 300);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \lvl, ~lr_3_sum);
}, 76);
MIDIdef.cc(\slider_3_pressure, { arg data; data.postln;}, 14);
MIDIdef.cc(\slider_3_location, { arg data; ~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \mix, data.linlin(0, 127, 0.0, 1.0));
}, 2);

//horizontal slider 4
MIDIdef.cc(\left_4_pressure, { arg data;
	~lr_4_sum = (data.linexp(0, 127, 0.1, 1.0).neg + ~lr_4_sum).clip(0.1, 10.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \revtime, ~lr_4_sum);
}, 77);
MIDIdef.cc(\right_4_pressure, { arg data;
	~lr_4_sum = (data.linexp(0, 127, 0.1, 1.0) + ~lr_4_sum).clip(0.1, 10.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \revtime, ~lr_4_sum);
}, 78);
MIDIdef.cc(\slider_4_pressure, { arg data; data.postln;}, 15);
MIDIdef.cc(\slider_4_location, { arg data; ~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \mix, data.linlin(0, 127, 0.0, 1.0));
}, 3);

//left circle
MIDIdef.cc(\left_circle_pressure, { arg data;
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mypos, (Pgauss(0.5, 0.5)).asCompileString);
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mylen, (Pwhite(2.2, 3.0)).asCompileString);
}, 16);
MIDIdef.cc(\left_circle_direction, { arg data; data.postln;}, 4);

//right circle
MIDIdef.cc(\right_circle_pressure, { arg data;
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \myrate, (Pwhite(0.2, 2.0)).asCompileString);
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mydur, (Pwhite(0.2, 2.0)).asCompileString);
}, 17);
MIDIdef.cc(\right_circle_direction, { arg data; data.postln;}, 5);

//rhombus
MIDIdef.cc(\rhombus_pressure, { arg data;
	if (data > 0, {~rhombus_hold = True}, {
		~rhombus_hold = False;
		~sequence = List();
		~amp_sequence = List();
		~rate_sequence = List();
		if (~pad_1_on == True, {~sequence.add(~pad_1_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_2_on == True, {~sequence.add(~pad_2_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_3_on == True, {~sequence.add(~pad_3_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_4_on == True, {~sequence.add(~pad_4_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_5_on == True, {~sequence.add(~pad_5_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_6_on == True, {~sequence.add(~pad_6_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_7_on == True, {~sequence.add(~pad_7_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_8_on == True, {~sequence.add(~pad_8_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_9_on == True, {~sequence.add(~pad_9_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_10_on == True, {~sequence.add(~pad_10_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_11_on == True, {~sequence.add(~pad_11_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_12_on == True, {~sequence.add(~pad_12_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_13_on == True, {~sequence.add(~pad_13_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_14_on == True, {~sequence.add(~pad_14_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_15_on == True, {~sequence.add(~pad_15_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});
		if (~pad_16_on == True, {~sequence.add(~pad_16_x.linlin(0, 127, -0.5, 0.5)+1)}, {~sequence.add(Rest(1))});

		if (~pad_1_on == True, {~amp_sequence.add(~pad_1_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_2_on == True, {~amp_sequence.add(~pad_2_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_3_on == True, {~amp_sequence.add(~pad_3_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_4_on == True, {~amp_sequence.add(~pad_4_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_5_on == True, {~amp_sequence.add(~pad_5_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_6_on == True, {~amp_sequence.add(~pad_6_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_7_on == True, {~amp_sequence.add(~pad_7_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_8_on == True, {~amp_sequence.add(~pad_8_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_9_on == True, {~amp_sequence.add(~pad_9_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_10_on == True, {~amp_sequence.add(~pad_10_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_11_on == True, {~amp_sequence.add(~pad_11_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_12_on == True, {~amp_sequence.add(~pad_12_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_13_on == True, {~amp_sequence.add(~pad_13_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_14_on == True, {~amp_sequence.add(~pad_14_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_15_on == True, {~amp_sequence.add(~pad_15_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});
		if (~pad_16_on == True, {~amp_sequence.add(~pad_16_pressure.linlin(0, 127, 0.8, 1.5))}, {~amp_sequence.add(Rest(1))});

		if (~pad_1_on == True, {~rate_sequence.add(~pad_1_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_2_on == True, {~rate_sequence.add(~pad_2_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_3_on == True, {~rate_sequence.add(~pad_3_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_4_on == True, {~rate_sequence.add(~pad_4_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_5_on == True, {~rate_sequence.add(~pad_5_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_6_on == True, {~rate_sequence.add(~pad_6_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_7_on == True, {~rate_sequence.add(~pad_7_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_8_on == True, {~rate_sequence.add(~pad_8_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_9_on == True, {~rate_sequence.add(~pad_9_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_10_on == True, {~rate_sequence.add(~pad_10_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_11_on == True, {~rate_sequence.add(~pad_11_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_12_on == True, {~rate_sequence.add(~pad_12_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_13_on == True, {~rate_sequence.add(~pad_13_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_14_on == True, {~rate_sequence.add(~pad_14_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_15_on == True, {~rate_sequence.add(~pad_15_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});
		if (~pad_16_on == True, {~rate_sequence.add(~pad_16_y.linexp(0, 127, 0.05, 10.0))}, {~rate_sequence.add(Rest(1))});

		~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mydur, (Pseq(~sequence, inf)*
			(~big_slider_location.linexp(0, 127, 0.01, 2)+
				Pwhite(0, ~big_slider_width.linlin(0, 127, 0.0, 1.0)))).asCompileString);
		~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mymul, (Pseq(~amp_sequence, inf)).asCompileString);
		~server_ip.sendMsg('/pattern_msg', ~speaker_number, \myrate, (Pseq(~rate_sequence, inf)).asCompileString);
	});
}, 79);


//vertical sliders
MIDIdef.cc(\vertical_slider_1_pressure, {arg data; data.postln;
	~vertical_slider_1_pressure = data;
}, 18);
MIDIdef.cc(\vertical_slider_1_location, {arg data; ~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mypos, (data.linlin(0, 127, 0.0, 1.0) + ~vertical_slider_1_pressure.linlin(0, 127, -0.1,0.1)).asString);}, 6);
MIDIdef.cc(\vertical_slider_2_pressure, {arg data; ~vertical_slider_2_pressure = data;}, 19);
MIDIdef.cc(\vertical_slider_2_location, {arg data; data.postln; ~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mylen, (data.linexp(0, 127, 0.05, 10.0) + ~vertical_slider_2_pressure.linexp(0, 127, 0.001,1.0)).asString);}, 7);
MIDIdef.cc(\vertical_slider_3_pressure, {arg data; data.postln; ~vertical_slider_3_pressure = data;}, 20);
MIDIdef.cc(\vertical_slider_3_location, {arg data; data.postln;	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \myrate, (data.linexp(0, 127, 0.1, 20.0) + ~vertical_slider_3_pressure.linexp(0, 127, 0.1, 2.0)).asString);}, 8);
MIDIdef.cc(\vertical_slider_4_pressure, {arg data; data.postln;	~vertical_slider_4_pressure = data;}, 21);
MIDIdef.cc(\vertical_slider_4_location, {arg data; data.postln;	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mydur, (data.linexp(0, 127, 0.05, 10.0) + ~vertical_slider_4_pressure.linexp(0, 127, 0.01, 1.0)).asString);}, 9);

//pad 1-16 pressure, x, and y
MIDIdef.cc(\pad_1_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 0, 64); m.noteOn(1, 2, 64); m.noteOn(1, 16, 64); m.noteOn(1, 18, 64); ~pad_1_on = True;
			if (~pad_1_pressure < data, {~pad_1_pressure = data});
		},
		{m.noteOff(1, 0, 64); m.noteOff(1, 2, 64); m.noteOff(1, 16, 64); m.noteOff(1, 18, 64); ~pad_1_on = False; ~pad_1_pressure = 0;});
}, 23);
MIDIdef.cc(\pad_1_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_1_x = data;})}, 24);
MIDIdef.cc(\pad_1_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_1_y = data;})}, 25);

MIDIdef.cc(\pad_2_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 4, 64); m.noteOn(1, 6, 64); m.noteOn(1, 20, 64); m.noteOn(1, 22, 64); ~pad_2_on = True;
			if (~pad_2_pressure < data, {~pad_2_pressure = data});
		},
		{m.noteOff(1, 4, 64); m.noteOff(1, 6, 64); m.noteOff(1, 20, 64); m.noteOff(1, 22, 64); ~pad_2_on = False; ~pad_2_pressure = 0;});
}, 26);
MIDIdef.cc(\pad_2_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_2_x = data;})}, 27);
MIDIdef.cc(\pad_2_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_2_y = data;})}, 28);

MIDIdef.cc(\pad_3_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 8, 64); m.noteOn(1, 10, 64); m.noteOn(1, 24, 64); m.noteOn(1, 26, 64); ~pad_3_on = True;
			if (~pad_3_pressure < data, {~pad_3_pressure = data});
		},
		{m.noteOff(1, 8, 64); m.noteOff(1, 10, 64); m.noteOff(1, 24, 64); m.noteOff(1, 26, 64); ~pad_3_on = False; ~pad_3_pressure = 0;});
}, 29);
MIDIdef.cc(\pad_3_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_3_x = data;})}, 30);
MIDIdef.cc(\pad_3_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_3_y = data;})}, 31);

MIDIdef.cc(\pad_4_pressure, {arg data;
	if (~rhombus_hold == True,
		{m.noteOn(1, 12, 64); m.noteOn(1, 14, 64); m.noteOn(1, 28, 64); m.noteOn(1, 30, 64); ~pad_4_on = True;
			if (~pad_4_pressure < data, {~pad_4_pressure = data});
		},
		{m.noteOff(1, 12, 64); m.noteOff(1, 14, 64); m.noteOff(1, 28, 64); m.noteOff(1, 30, 64); ~pad_4_on = False; ~pad_4_pressure = 0;});
}, 32);
MIDIdef.cc(\pad_4_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_4_x = data;})}, 33);
MIDIdef.cc(\pad_4_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_4_y = data;})}, 34);

MIDIdef.cc(\pad_5_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 32, 64); m.noteOn(1, 34, 64); m.noteOn(1, 48, 64); m.noteOn(1, 50, 64); ~pad_5_on = True;
			if (~pad_5_pressure < data, {~pad_5_pressure = data});
		},
		{m.noteOff(1, 32, 64); m.noteOff(1, 34, 64); m.noteOff(1, 48, 64); m.noteOff(1, 50, 64); ~pad_5_on = False; ~pad_5_pressure = 0;});
}, 35);
MIDIdef.cc(\pad_5_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_5_x = data;})}, 36);
MIDIdef.cc(\pad_5_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_5_y = data;})}, 37);

MIDIdef.cc(\pad_6_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 36, 64); m.noteOn(1, 38, 64); m.noteOn(1, 52, 64); m.noteOn(1, 54, 64); ~pad_6_on = True;
			if (~pad_6_pressure < data, {~pad_6_pressure = data});
		},
		{m.noteOff(1, 36, 64); m.noteOff(1, 38, 64); m.noteOff(1, 52, 64); m.noteOff(1, 54, 64); ~pad_6_on = False; ~pad_6_pressure = 0;});
}, 38);
MIDIdef.cc(\pad_6_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_6_x = data;})}, 39);
MIDIdef.cc(\pad_6_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_6_y = data;})}, 40);

MIDIdef.cc(\pad_7_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 40, 64); m.noteOn(1, 42, 64); m.noteOn(1, 56, 64); m.noteOn(1, 58, 64); ~pad_7_on = True;
			if (~pad_7_pressure < data, {~pad_7_pressure = data});
		},
		{m.noteOff(1, 40, 64); m.noteOff(1, 42, 64); m.noteOff(1, 56, 64); m.noteOff(1, 58, 64); ~pad_7_on = False; ~pad_7_pressure = 0;});
}, 41);
MIDIdef.cc(\pad_7_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_7_x = data;})}, 42);
MIDIdef.cc(\pad_7_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_7_y = data;})}, 43);

MIDIdef.cc(\pad_8_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 44, 64); m.noteOn(1, 46, 64); m.noteOn(1, 60, 64); m.noteOn(1, 62, 64); ~pad_8_on = True;
			if (~pad_8_pressure < data, {~pad_8_pressure = data});
		},
		{m.noteOff(1, 44, 64); m.noteOff(1, 46, 64); m.noteOff(1, 60, 64); m.noteOff(1, 62, 64); ~pad_8_on = False; ~pad_8_pressure = 0;});
}, 44);
MIDIdef.cc(\pad_8_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_8_x = data;})}, 45);
MIDIdef.cc(\pad_8_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_8_y = data;})}, 46);

MIDIdef.cc(\pad_9_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 64, 64); m.noteOn(1, 66, 64); m.noteOn(1, 80, 64); m.noteOn(1, 82, 64); ~pad_9_on = True;
			if (~pad_9_pressure < data, {~pad_9_pressure = data});
		},
		{m.noteOff(1, 64, 64); m.noteOff(1, 66, 64); m.noteOff(1, 80, 64); m.noteOff(1, 82, 64); ~pad_9_on = False; ~pad_9_pressure = 0;});
}, 47);
MIDIdef.cc(\pad_9_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_9_x = data;})}, 48);
MIDIdef.cc(\pad_9_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_9_y = data;})}, 49);

MIDIdef.cc(\pad_10_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 68, 64); m.noteOn(1, 70, 64); m.noteOn(1, 84, 64); m.noteOn(1, 86, 64); ~pad_10_on = True;
			if (~pad_10_pressure < data, {~pad_10_pressure = data});
		},
		{m.noteOff(1, 68, 64); m.noteOff(1, 70, 64); m.noteOff(1, 84, 64); m.noteOff(1, 86, 64); ~pad_10_on = False; ~pad_10_pressure = 0;});
}, 50);
MIDIdef.cc(\pad_10_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_10_x = data;})}, 51);
MIDIdef.cc(\pad_10_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_10_y = data;})}, 52);

MIDIdef.cc(\pad_11_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 72, 64); m.noteOn(1, 74, 64); m.noteOn(1, 88, 64); m.noteOn(1, 90, 64); ~pad_11_on = True;
			if (~pad_11_pressure < data, {~pad_11_pressure = data});
		},
		{m.noteOff(1, 72, 64); m.noteOff(1, 74, 64); m.noteOff(1, 88, 64); m.noteOff(1, 90, 64);  ~pad_11_on = False; ~pad_11_pressure = 0;});
}, 53);
MIDIdef.cc(\pad_11_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_11_x = data;})}, 54);
MIDIdef.cc(\pad_11_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_11_y = data;})}, 55);

MIDIdef.cc(\pad_12_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 76, 64); m.noteOn(1, 78, 64); m.noteOn(1, 92, 64); m.noteOn(1, 94, 64); ~pad_12_on = True;
			if (~pad_12_pressure < data, {~pad_12_pressure = data});
		},
		{m.noteOff(1, 76, 64); m.noteOff(1, 78, 64); m.noteOff(1, 92, 64); m.noteOff(1, 94, 64);  ~pad_12_on = False; ~pad_12_pressure = 0;});
}, 56);
MIDIdef.cc(\pad_12_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_12_x = data;})}, 57);
MIDIdef.cc(\pad_12_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_12_y = data;})}, 58);

MIDIdef.cc(\pad_13_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 96, 64); m.noteOn(1, 98, 64); m.noteOn(1, 112, 64); m.noteOn(1, 114, 64); ~pad_13_on = True;
			if (~pad_13_pressure < data, {~pad_13_pressure = data});
		},
		{m.noteOff(1, 96, 64); m.noteOff(1, 98, 64); m.noteOff(1, 112, 64); m.noteOff(1, 114, 64); ~pad_13_on = False; ~pad_13_pressure = 0;});
}, 59);
MIDIdef.cc(\pad_13_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_13_x = data;})}, 60);
MIDIdef.cc(\pad_13_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_13_y = data;})}, 61);

MIDIdef.cc(\pad_14_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 100, 64); m.noteOn(1, 102, 64); m.noteOn(1, 116, 64); m.noteOn(1, 118, 64); ~pad_14_on = True;
			if (~pad_14_pressure < data, {~pad_14_pressure = data});
		},
		{m.noteOff(1, 100, 64); m.noteOff(1, 102, 64); m.noteOff(1, 116, 64); m.noteOff(1, 118, 64); ~pad_14_on = False; ~pad_14_pressure = 0;});
}, 62);
MIDIdef.cc(\pad_14_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_14_x = data;})}, 63);
MIDIdef.cc(\pad_14_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_14_y = data;})}, 64);

MIDIdef.cc(\pad_15_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 104, 64); m.noteOn(1, 106, 64); m.noteOn(1, 120, 64); m.noteOn(1, 122, 64); ~pad_15_on = True;
			if (~pad_15_pressure < data, {~pad_15_pressure = data});
		},
		{m.noteOff(1, 104, 64); m.noteOff(1, 106, 64); m.noteOff(1, 120, 64); m.noteOff(1, 122, 64); ~pad_15_on = False; ~pad_15_pressure = 0;});
}, 65);
MIDIdef.cc(\pad_15_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_15_x = data;})}, 66);
MIDIdef.cc(\pad_15_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_15_y = data;})}, 67);

MIDIdef.cc(\pad_16_pressure, {arg data; data.postln;
	if (~rhombus_hold == True,
		{m.noteOn(1, 108, 64); m.noteOn(1, 110, 64); m.noteOn(1, 124, 64); m.noteOn(1, 126, 64); ~pad_16_on = True;
			if (~pad_16_pressure < data, {~pad_16_pressure = data});
		},
		{m.noteOff(1, 108, 64); m.noteOff(1, 110, 64); m.noteOff(1, 124, 64); m.noteOff(1, 126, 64); ~pad_16_on = False; ~pad_16_pressure = 0;});
}, 68);
MIDIdef.cc(\pad_16_x, {arg data; if (~rhombus_hold == True && data != 63, {~pad_16_x = data;})}, 69);
MIDIdef.cc(\pad_16_y, {arg data; if (~rhombus_hold == True && data != 63, {~pad_16_y = data;})}, 70);

//up-down left
MIDIdef.cc(\up_left_pressure, {arg data; data.postln;}, 80);
MIDIdef.cc(\down_left_pressure, {arg data; data.postln;}, 81);

//big slider
MIDIdef.cc(\big_slider_pressure, {arg data;}, 22);
MIDIdef.cc(\big_slider_location, {arg data; ~big_slider_location = data;}, 10);
MIDIdef.cc(\big_slider_width, {arg data; ~big_slider_width = data; ~big_slider_width.postln;}, 11);

//up-down left
MIDIdef.cc(\up_right_pressure, {arg data; data.postln;}, 82);
MIDIdef.cc(\down_right_pressure, {arg data; data.postln;}, 83);
)