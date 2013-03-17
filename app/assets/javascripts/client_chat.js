$(function() {
	//$('#chat').text("Loading finished. Should be calling now...");
	$('#chat').load('http://localhost:7000');
});

// var socket = io.connect('http://localhost:7000');

// 	// on connection to server, ask for user's name with an anonymous callback
// 	socket.on('connect', function(){
// 		$('#chat').text("building socket");
// 		// call the server-side function 'adduser' and send one parameter (value of prompt)
// 		socket.emit('adduser', "DJ");
// 	});

// 	// listener, whenever the server emits 'updatechat', this updates the chat body
// 	socket.on('updatechat', function (username, data) {
// 		$('#conversation').append('<tr><td><b>'+username + ':</b></td><td> ' + data + '</td></tr>');
// 	});

// 	// listener, whenever the server emits 'updateusers', this updates the username list
// 	socket.on('updateusers', function(data) {
// 		$('#users').empty();
// 		$.each(data, function(key, value) {
// 			$('#users').append('<div><b>' + key + '</b></div>');
// 		});
// 	});

// 	// on load of page
// 	$(function() {
// 		$('#chat').text("Loading finished. Should be calling now...");
// 		// when the client clicks SEND
// 		$('#datasend').click( function() {
// 			var message = $('#data').val();
// 			$('#data').val('');
// 			$('#chat').text('data has been sent');
// 			// tell server to execute 'sendchat' and send along one parameter
// 			socket.emit('sendchat', message);
// 		});

// 		// when the client hits ENTER on their keyboard
// 		$('#data').keypress(function(e) {
// 			if(e.which == 13) {
// 				$(this).blur();socket.io.js
// 				$('#datasend').focus().click();
// 			}
// 		});
// 	});