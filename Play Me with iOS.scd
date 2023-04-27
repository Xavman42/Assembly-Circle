//Performance script for Assembly Circle

//Wait for the server to be booted, then run the following block
(
~my_ip = NetAddr.new("127.0.0.1", 57120); //my ip address (for windows, go to cmd, then type ipconfig.
~server_ip = NetAddr.new("127.0.0.1", 57120); //ip of the server
~username = "renzo_ios";//Your username goes here
~speaker_number = 0;//Coordinate your speaker number with the ensemble. They must all be unique!
"Client.scd".resolveRelative.load;


~pinch_r = 0.05;
NetAddr.langPort.postln;

// pad_x corresponds to buffer location, pad_y corresponds to playback rate
OSCdef(\ios_osc_pad, {                    // Monitor for PAD data
	arg msg;
	~pad_x = msg[1];
	~pad_y = msg[2];
	~server_ip.sendMsg('/phone_override_msg', ~speaker_number, (~pad_y+1)/2,  (~pad_x+1), ~pinch_r);
}, '/syntien/touchpad/1/touchpad1/press');

// Pinch radius influences grain length
OSCdef(\ios_osc_pinch, {                    // Monitor for PINCH data
	arg msg;
	~pinch_x = msg[1];  // unused
	~pinch_y = msg[2];  // unused
	~pinch_r = (msg[3]/5).max(0.05);
}, '/syntien/touchpad/1/touchpad1/pinch');

// Swipe from sides to engage effects.
// Swipe from left to engage reverb. Higher y position means wetter
// Swipe from right to engage distortion. Higher y position means wetter
// Swipe from top to engage resonant filter. Higher x position means wetter
// Swipe from bottom to engage chorus. Higher x position means wetter
OSCdef(\ios_osc_swipe, {                    // Monitor for SWIPE data
	arg msg;
	msg.postln;
	~swipe_x = msg[1];
	~swipe_y = msg[2];
	~direction = msg[3];
	if ((~swipe_x < 0.1) || (~swipe_x > 0.9) || (~swipe_y < 0.1) || (~swipe_y > 0.9)){
		case
		{~direction == 0 } {~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \mix, ~swipe_y);} // left to right
		{~direction == 1 } {~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \mix, ~swipe_y);} // right to left
		{~direction == 2 } {~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \mix, ~swipe_x*0.7);} // up to down
		{~direction == 3 } {~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \mix, ~swipe_x*0.7);}; // down to up
	};


}, '/syntien/touchpad/1/touchpad1/swipe');

// Other gestures; rotate, long
)