(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };
	
	var DeviceInfo = function() { 
	
	}

	DeviceInfo.prototype.getUniqueIdentifier = function() {
		Cordova.exec("DeviceInfo.getUniqueIdentifier", null);
	};
    
    DeviceInfo.prototype.post = function(url, defaults, successCallback, failCallback) {
        //defaults.url = url;
		Cordova.exec(successCallback, failCallback, "DeviceInfo", "post", [url, defaults]);
	};
	
	Cordova.addConstructor(function()  {
		if(!window.plugins) {
			window.plugins = {};
		}
		window.plugins.deviceInfo = new DeviceInfo();
	});
 })();