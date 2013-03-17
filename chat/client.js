var socket = io.connect('http://localhost:7000');

//When connecting to server, ask for username before sending connect request
socket.on('connect', function () {
	socket.emit('adduser', prompt('Please enter your username'));
});

socket.on('updatechat', function (username, data) {
	$('#/conversation').append('<b>' + username + ':</b>' + data + '<br>');
});

socket.on('updateuser', function (data) {
	$('#/users').empty;
	$.each(data, function (key, value) {
		$('#/users').append('<div>' + key + '</div')
	});
});

//JQuery executed when page has finished loading
$(function () {
	//On datasend button click
	$('#datasend').click( function () {
		var message = $('#data').val();
		//empty #data box
		$('#data').val('');
		socket.emit('sendchat', message);
	});

	//On hitting Enter button do the same
	$('#data').keypress(function (e) {
		if(e.which == 13) {
			//lose focus on #data
			$(this).blur;
			//create datasend.click event
			$('#datasend').focus().click();
		});
	});
});