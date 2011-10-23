function doOrientation(orientation)
{
	$("body").toggleClass('portrait', false);
	$("body").toggleClass('portraitUpsideDown', false);
	$("body").toggleClass('landscapeLeft', false);
	$("body").toggleClass('landscapeRight', false);
	$("body").toggleClass(orientation, true);
}

function doit()
{
	$("#oriented").load("orientation.html #orient", function (response, status, xhr) {
		if (status == "error") {
			var msg = "Sorry but there was an error: ";
			alert(msg);
		}
		else {
			try {
				doOrientation($("#orient").html());
			}
			catch (err) { alert(err); }
		}
	});
}

var a = setInterval("doit()", 1000);
