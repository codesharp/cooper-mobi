
(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };
	
	var TaskService = function() { 
	
	}

	TaskService.prototype.getTasks = function(params, successCallback, failCallback) {
		Cordova.exec(successCallback, failCallback, "TaskService", "getTasks", params);
	};
	
	Cordova.addConstructor(function()  {
		if(!window.plugins) {
			window.plugins = {};
		}
		window.plugins.taskService = new TaskService();
	});
 })();