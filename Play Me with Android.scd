//Performance script for Assembly Circle

//Wait for the server to be booted, then run the following block
(
~my_ip = NetAddr.new("127.0.0.1", 57120); //my ip address (for windows, go to cmd, then type ipconfig.
~server_ip = NetAddr.new("127.0.0.1", 57120); //ip of the server
~username = "Xavier";//Your username goes here
~speaker_number = 0;//Coordinate your speaker number with the ensemble. They must all be unique!
"Client.scd".resolveRelative.load;


NetAddr.langPort.postln;
OSCdef(\phone_osc_acc_x, {                    // Monitor for accelerometer data
	arg msg;
	~acc_x = msg[1];
}, '/multisense/accelerometer/x');

~cumulative_y_acc = 0;
OSCdef(\phone_osc_acc_y, {
	arg msg;
	~acc_y = msg[1];
}, '/multisense/accelerometer/y');

OSCdef(\phone_osc_acc_z, {
	arg msg;
	~acc_z = msg[1];
}, '/multisense/accelerometer/z');

OSCdef(\phone_osc_pad_x, {                    // Monitor for PAD data
	arg msg;
	~pad_x = msg[1];
}, '/multisense/pad/x');

OSCdef(\phone_osc_pad_y, {
	arg msg;
	~pad_y = msg[1];
	if (~acc_y.abs > 2.0,
		{
			~cumulative_y_acc = (~cumulative_y_acc - (~acc_y/1000)).clip(0.0, 1.0);
	});
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \mix, ~cumulative_y_acc);
	~server_ip.sendMsg('/phone_override_msg', ~speaker_number, (~pad_y+1)/2,  (~pad_x+1), ~acc_x.abs/3);
}, '/multisense/pad/y');
)
