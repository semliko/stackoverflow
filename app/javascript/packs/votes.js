$(document).on('turbolinks:load', function(){

	$('.votes').on('ajax:success', function(e) {
		var votes = e.detail[0];

		v = $(this)
		$(this).children('.upvote_count').empty().append('<p>' + 'Upvotes ' + votes.upvotes + '</p>');
		$(this).children('.downvote_count').empty().append('<p>' + 'Downvotes ' + votes.downvotes + '</p>');
		$(this).children('.total_votes_count').empty().append('<p>' + 'Total votes ' + votes.total + '</p>');
	})
		.on('ajax:error', function (e) {
			var errors = e.detail[0];

			$.each(errors, function(index, value) {
				$('.errors').append('<p>' + value + '</p>');
			})

		})
});
