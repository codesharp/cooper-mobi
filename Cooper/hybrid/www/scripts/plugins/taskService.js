
(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };
	
	var TaskService = function() { 
	
	}

	TaskService.prototype.getTasks = function(successCallback, failCallback) {
		Cordova.exec(successCallback, failCallback, "TaskService", "getTasks", []);
	};
	
	Cordova.addConstructor(function()  {
		if(!window.plugins) {
			window.plugins = {};
		}
		window.plugins.taskService = new TaskService();
	});
 })();