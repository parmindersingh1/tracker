$(document).ready(function() {

	// $("#new_school").submit(function(event) {
		// var phone = ("#school_phone_no").val();
		// if(!phonenumber(phone)){
			// event.preventDefault();
			// $(this).children(".alert-danger").html('<button class="close"   type="button">x</button><li>Please Enter Correct Number</li>');
			// $(this).children(".alert-danger").css("display", "block");
		// }
// 
	// });
	
	
	$("#new_device").submit(function(event) {
		var phone = ("#device_mobile_no").val();
		if(!phonenumber(phone)){
			event.preventDefault();
			$(this).children(".alert-danger").html('<button class="close"   type="button">x</button><li>Please Enter Correct Number</li>');
			$(this).children(".alert-danger").css("display", "block");
		}

	});
	
	
	
	function phonenumber(inputtxt) {
			var phoneno = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
			if (phoneno) {
				return true;
			} else {
				return false;
			}
		}

}); 