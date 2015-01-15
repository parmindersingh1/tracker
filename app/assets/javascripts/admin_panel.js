$(document).ready(function() {	
	$(document).on("submit", "#changeRole", function(e) {				
		var role = $("#role").val();
		var user_id = $("#user_id").val();
		if (role === "" || role === null) {
			e.preventDefault();
			$(this).children(".alert-danger").html('<button class="close"   type="button">x</button><li>Please Select Role</li>');
			$(this).children(".alert-danger").css("display", "block");
		}
	});

});
$(document).on("click",".close",function(){	
		$(this).parent("div").css("display","none");
});
