
$(function(){
	index.init();
});

var index = {
    validateUser: function(userName, password)
    {
        
        Cordova.exec(function (result) 
                     {
                     alert(result);
                     }, 
                     function () { }
                     , "Account"
                     , "login", 
                     [{ userName: userName, password: password}]
                     );
    },
    login: function()
    {
        var userName = 'sunleepy@gmail.com';
        var password = 'xxxxxxx';

        index.validateUser(userName, password);
        
//        //var url = 'https://cooper.wf.taobao.org/account/arklogin';
//        
//        Cordova.exec(function(data)
//                     {
//                     
//		$.mobile.showPageLoadingMsg('a','正在加载');
//		
//                     plugins.taskService.getTasks({}, function(data1){
//			if(data1) {
//				
//				//var str = JSON.stringify(data);
//				//alert(str);
//				
//				$("#taskTemplate").tmpl(data1.List).appendTo("#list");
//				$('#list').listview('refresh');
//			}
//			
//			$.mobile.hidePageLoadingMsg();
//			
//		},
//		function(error){
//			alert("error:" + error);
//			
//			$.mobile.hidePageLoadingMsg();
//		});
//                     
//                     }
//                     , null
//                     , "HttpRequest"
//                     , "post", 
//                     [url, defaults]);
    },
	init: function() {
		$.mobile.touchOverflowEnabled = true;
		$.mobile.page.prototype.options.domCache = false;
		$.mobile.loadingMessageTextVisible = true;
		$.ajaxSetup({ cache: false });
	
		index._bind();
		$(document).bind('pageload', function () { index._bind(); });
		document.addEventListener("deviceready", index._onDeviceReady, false);
	},
	_bind: function() {
		$('.link_account').unbind().click(function () { location.href = url_account; });
			$('.link_sync').unbind().click(function(){ 
				
			});
	
			$('#list a').unbind().click(function () {
				var id = $(this).attr('id');
				$.mobile.changePage('MobileDetail?id=' + id, { transition: 'slide' });
			});
	
			$('.link_home').unbind().click(function () {
				$.mobile.changePage('Mobile', { transition: "slide", direction: 'reverse' });
			});
	
			$('.link_append').unbind().click(function () {
				$.mobile.changePage('MobileDetail?_' + new Date().getTime(), { transition: 'slide' });
			});
			$('.link_save').unbind().click(function () {
				var arr = $("#edit form").serializeArray();
				var data = {};
				$.each(arr, function (i, n) { data[n['name']] = n['value']; });
				$.post(url_m_detail, data, function () {
					$.mobile.changePage('Mobile', { transition: "slide", direction: 'reverse' });
				});
			});
			$('.link_cancel').unbind().click(function () { $.mobile.changePage('Mobile', { transition: "slide", direction: 'reverse' }); });
	},
	_onDeviceReady: function() {
		
		
		//alert(window.device.name);
//		plugins.navigationBar.init()
//                    
//		plugins.navigationBar.create() 
//		plugins.navigationBar.hideLeftButton()
//		plugins.navigationBar.hideRightButton()
//		
//		plugins.navigationBar.setTitle("My heading")
//		
//		plugins.navigationBar.showLeftButton()
//		plugins.navigationBar.showRightButton()
//                    
//		// Create left navigation button with a title (you can either have a title or an image, not both!)
//		plugins.navigationBar.setupLeftButton("Text", null, function() {
//											  alert("left nav button tapped")
//											  })
//		
//		// Create right navigation button from a system-predefined button (see the full list in NativeControls.m)
//		// or from an image
//		plugins.navigationBar.setupRightButton(
//											   null,
//											   "barButton:Bookmarks", // or your own file like "/www/stylesheets/images/ajax-loader.png",
//											   function() {
//											   alert("right nav button tapped")
//											   }
//											   )
//                    
//		plugins.navigationBar.show()
//		
//		plugins.tabBar.init()
//		
//		plugins.tabBar.create()
//		plugins.tabBar.createItem("contacts", "Unused, iOS replaces this text by Contacts", "tabButton:Contacts")
//		plugins.tabBar.createItem("recents", "Unused, iOS replaces this text by Recents", "tabButton:Recents")
//		
//		// Example with selection callback
//		plugins.tabBar.createItem("another", "Some text", "/www/your-own-image.png", {
//								  onSelect: function() {
//								  alert("another tab selected")
//								  }
//								  })
//		
//		plugins.tabBar.show()
//		// Or with custom style (defaults to 49px height, positioned at bottom): plugins.tabBar.show({height: 80, position: 'top'})
//		plugins.tabBar.showItems("contacts", "recents", "another")
//		
//		window.addEventListener("resize", function() { plugins.tabBar.resize() }, false)
                    
        index.login();
                    
//                   var defaults = {
//                        state: 'login',
//                        cbDomain: 'TAOBAO-HZ',
//                        tbLoginName: 'xiaoxuan.lp',
//                        tbPassword:'Lp053049'
//                    };
//                    window.plugins.httpRequest.post('https://cooper.wf.taobao.org/account/arklogin',
//                                                    defaults, 
//                                                    function(data){ 
//                                                        alert(data);
//
//		$.mobile.showPageLoadingMsg('a','正在加载');
//		
//		plugins.taskService.getTasks(function(data){
//			if(data) {
//				
////				var str = JSON.stringify(data);
////				alert(str);
////				
////				$("#taskTemplate").tmpl(data.List).appendTo("#list");
////				$('#list').listview('refresh');
//			}
//			
//			$.mobile.hidePageLoadingMsg();
//			
//		},
//		function(error){
//			alert(error);
//			
//			$.mobile.hidePageLoadingMsg();
//		});
//		
//                                                    },
//                                                    function(error){
////                                                    alert(error);
//                                                    });
	}
};
