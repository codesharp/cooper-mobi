
(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };
	
	var HttpRequest = function() { 
	
	}

	HttpRequest.prototype.get = function(url) {
		var defaults = {
			url: url
		}
		Cordova.exec("HttpRequest.get", defaults);
	};
    
    HttpRequest.prototype.post = function(url, defaults, successCallback, failCallback) {
        //defaults.url = url;
		Cordova.exec(successCallback, failCallback, "HttpRequest", "post", [url, defaults]);
	};
	
	Cordova.addConstructor(function()  {
		if(!window.plugins) {
			window.plugins = {};
		}
		window.plugins.httpRequest = new HttpRequest();
	});
 })();