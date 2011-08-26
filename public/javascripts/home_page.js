		$(document).ready(function() {
        var title = "Success!";
        var icon = "success";
				$('#register-btn').click(function () {
					$.ajax({
						type: "POST",
						url: "/users",
						data: $("#sign_up_form").serialize(), 
						success: function(data){
								var response = data;
								if(response.result == "success") {
                  $("#user_e").val("");
                  $("#user_n").val("");

                  var text = response.message;
                  $("#notif_container").notify("create", {
                      title: title,
                      text: text,
                      icon: icon
                     },
                     {
                      click: function(e,instance){
                      instance.close();
                     }
                   });
								}
								else {
									$("#signup-btn").trigger('click');
									$("#get-share-code").width("320px");
									$("#get-share-code label").width("80px");
									$("#error-signup").html("");
									var errors = $("#error-signup");
									errors.append("<h2>"+response.message+"</h2><ul>");
									$.each(response.error, function(key, value) { 
										errors.append("<li>"+value+"</li>");
									});
									errors.append("</ul>");
									$("#TB_title").hide();
									if($("#user_email").val().length==0)
										$("#user_email").val($("#user_e").val());
									if($("#user_name").val().length==0)
                    $("#user_name").val($("#user_n").val());
								}
							}
						});
					});

				$('#register-btn1').click(function () {
					$.ajax({
						type: "POST",
						url: "/users",
						data: $("#new_user").serialize(), 
						success: function(data){
								var response = data;
								if(response.result == "success") {
                  tb_remove();
                  $("#user_e").val("");
                  $("#user_n").val("");
                  var text = response.message;
                  $("#notif_container").notify("create", {
                      title: title,
                      text: text,
                      icon: icon
                     },
                     {
                      click: function(e,instance){
                      instance.close();
                     }
                   });
									//window.location.href = "/";
								}
								else {
									$("#error-signup").html("");
									var errors = $("#error-signup");
									errors.append("<h2>"+response.message+"</h2><ul>");
									$.each(response.error, function(key, value) { 
										errors.append("<li>"+value+"</li>");
									});
									errors.append("</ul>");
									$("#TB_title").hide();
								}
							}
						});
					});
		});
		function signIn(){
			$.ajax({
				type: "POST",
				url: "/user_sessions",
				data: $("#new_user_session").serialize(), 
				success: function(data){
						var response = data;
						if(response.result == "success") {
							window.location.href = response.path;
						}
						else {
							$("#error-explanation").html("");
							var errors = $("#error-explanation");
							errors.append("<h2>"+response.message+"</h2><ul>");
							$.each(response.error, function(key, value) { 
								errors.append("<li>"+value+"</li>");
							});
							errors.append("</ul>");
						}
					}
				});
		}
		function social_connect(id) {
			$('#oauth_provider_'+id).attr('checked','checked');
			$('#oauth_form').submit();
		}
