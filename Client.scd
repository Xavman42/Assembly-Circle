//Client for Assembly Circle

(
~primary_color = Color.fromHexString("#378cb1");
~secondary_color = Color.fromHexString("#89afc0");
~tertiary_color = Color.fromHexString("#cbc9c7");
~highlight_color = Color.fromHexString("#e1a638");
~background_color = Color.fromHexString("#f5f5f5");
~initialize_text_chat = {
	var win, composite, scroll, field, score, conductor, msg_canvas, msg_layout, field_canvas, field_layout, score_canvas, score_layout, conductor_canvas, conductor_layout, i = 0;

	var initialize_chat_receiver = {
		OSCdef(\chat_receiver, {
			arg msg;
			defer{
				msg_layout.insert(receive_msg.value(msg[1], msg[2]), 0);
			};
		}, '/receive')
	};

	var initialize_conductor_receiver = {
		OSCdef(\conductor_receiver, {
			arg msg;
			defer{
				~current_msg.string = msg[1];
				~next_msg.string = msg[2];
			};
		}, '/conductor_receive');
		OSCdef(\timer_receiver, {
			arg msg;
			defer{
				~timer.string = msg[1];
			};
		}, '/timer_recieve');
	};

	var initialize_conducting_receiver = {
		OSCdef(\conducting_receiver, {
			arg msg;
			var slider_num, value;
			slider_num = msg[1];
			value = msg[2];
			defer{
				case
				{ slider_num == 1 } {~slider_1.value = value}
				{ slider_num == 2 } {~slider_2.value = value}
				{ slider_num == 3 } {~slider_3.value = value}
			};
		}, '/conduct')
	};

	var receive_msg = {
		arg usr, msg;
		var view = View().background_(Color.rand).layout_(
			HLayout(
				StaticText().string_( (usr) ),
				StaticText().string_( (msg) )
			)
		);
		i = i + 1;
		view;
	};

	var register_ip = {
		~server_ip.sendMsg('/registration', ~my_ip.ip, ~username, ~speaker_number);
	};

	register_ip.value;
	initialize_chat_receiver.value;
	initialize_conducting_receiver.value;
	initialize_conductor_receiver.value;

	Window.closeAll;
	"Port number".postln;
	NetAddr.langPort.postln;
	win = Window.new("Instant Messenger", bounds:Rect(0,0,900,400).center_(Window.availableBounds.center)).alwaysOnTop_(true);

	scroll = ScrollView(win, Rect(0,0,300,300)).hasBorder_(true);
	msg_canvas = View();

	field = ScrollView(win, Rect(0,300,300,100)).hasBorder_(true); // Chat box field
	field_canvas = View();

	score = ScrollView(win, Rect(600,0,300,400)).hasBorder_(true);
	score_canvas = View();

	conductor = ScrollView(win, Rect(300, 0, 300, 400)).hasBorder_(true);
	conductor_canvas = View();

	msg_layout = VLayout();

	field_layout = VLayout();
	field_layout.add(View().background_(~background_color).layout_(
		HLayout(
			StaticText().string_(("Type in box to right, RETURN to send")), TextField().action = {
				arg field;
				if(field.value != "",
					{
						~server_ip.sendMsg('/chat', ~username, field.value);
						field.value = "";
				});
			};
		)
	));

	score_layout = VLayout();
	score_layout.add(
		View().background_(~background_color).layout_(
			HLayout(
				StaticText().string_(("Homogeneous")),
				StaticText().string_(("Dense")),
				StaticText().string_(("Random")),
			);
	));
	score_layout.add(
		View().background_(~background_color).layout_(
			HLayout(
				~slider_1 = Slider().enabled_(0),
				~slider_2 = Slider().enabled_(0),
				~slider_3 = Slider().enabled_(0)
			);
	));
	score_layout.add(
		View().background_(~background_color).layout_(
			HLayout(
				StaticText().string_(("Distinct")),
				StaticText().string_(("Sparse")),
				StaticText().string_(("Patterned")),
			);
	));

	conductor_layout = VLayout();
	conductor_layout.add(
		View().background_(~background_color).layout_(
			VLayout(
				~current_msg = StaticText().string_(("current message")).font_(Font("Helvetica", 32)).stringColor_(~primary_color),
				~timer = StaticText().string_(("countdown number")).font_(Font("Helvetica", 32)).stringColor_(~highlight_color),
				~next_msg = StaticText().string_(("next message")).font_(Font("Helvetica", 32)).stringColor_(~secondary_color),
			);
	));

	msg_canvas.layout = msg_layout;
	msg_canvas.layout.add(nil); // stretch remaining empty space

	field_canvas.layout = field_layout;

	score_canvas.layout = score_layout;

	conductor_canvas.layout = conductor_layout;

	scroll.canvas = msg_canvas;
	scroll.front;
	field.canvas = field_canvas;
	field.front;
	score.canvas = score_canvas;
	score.front;
	conductor.canvas = conductor_canvas;
	conductor.front;

	win.front;
};
~initialize_text_chat.value;
)