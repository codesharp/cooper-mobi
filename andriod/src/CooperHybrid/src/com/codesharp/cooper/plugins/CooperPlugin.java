package com.codesharp.cooper.plugins;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.cordova.api.PluginResult;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CookieStore;
import org.apache.http.cookie.Cookie;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.R.string;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;
import android.util.Log;

import com.codesharp.cooper.Constant;
import com.codesharp.cooper.MainActivity;
import com.codesharp.cooper.Task;
import com.codesharp.cooper.TaskIdx;
import com.codesharp.cooper.Tasklist;
import com.codesharp.cooper.Tools;
import com.codesharp.cooper.Repositories.ChangeLogRepository;
import com.codesharp.cooper.Repositories.TaskIdxRepository;
import com.codesharp.cooper.Repositories.TaskRepository;
import com.codesharp.cooper.Repositories.TasklistRepository;
import com.codesharp.cooper.Services.AccountService;
import com.codesharp.cooper.Services.TaskService;
import com.codesharp.cooper.Services.TasklistService;
import com.phonegap.api.Plugin;

public class CooperPlugin extends Plugin {

	private AccountService _accountService;
	private TasklistService _tasklistService;
	private TaskService _taskService;
	private TasklistRepository _tasklistRepository;
	private TaskRepository _taskRepository;
	private TaskIdxRepository _taskIdxRepository;
	private ChangeLogRepository _changeLogRepository;
	private SharedPreferences _sharedPrefs;
	private MainActivity _activity;
	
	private void initCore() {
		this._activity = (MainActivity)this.ctx.getActivity();
		this._accountService = new AccountService(this._activity);
		this._tasklistService = new TasklistService(this._activity);
		this._taskService = new TaskService(this._activity);
		this._tasklistRepository = new TasklistRepository(this._activity);
		this._taskRepository = new TaskRepository(this._activity);
		this._taskIdxRepository = new TaskIdxRepository(this._activity);
		this._changeLogRepository = new ChangeLogRepository(this._activity);
		this._sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this._activity.getApplicationContext());
	}
	
	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {

		//初始化
		this.initCore();
		
		try
		{
			//刷新服务端同步相关
			if(action.equals("refresh")) 
			{		
				JSONObject resultCode = new JSONObject();
				JSONObject params = data.getJSONObject(0);
				String key = (String)params.get("key");
				
				//登录
				if(key.equals(Constant.LOGIN)) 
				{
					String type = (String)params.get("type");
					
					if(type == null || type.length() == 0)
					{
						//type不能为空
						resultCode.put("status", false);
						resultCode.put("message", "type不能为空!");
					}
					else if(!type.equals(Constant.ANONYMOUS) 
							&& !type.equals(Constant.NORMAL))
					{
						//type参数必须为anonymous或normal
						resultCode.put("status", false);
						resultCode.put("message", "type参数必须为anonymous或normal");
					}
					
					if(type.equals(Constant.ANONYMOUS))
					{
						//跳过登录
						Editor editor = this._sharedPrefs.edit();
						editor.putString(Constant.USERNAME_KEY, "");
						editor.putBoolean(Constant.ISGUESTUSER_KEY, true);
						editor.commit();
						
						resultCode.put("status", true);
					}
					else
					{
						//登录
						String username = (String)params.get("username");
						String password = (String)params.get("password");
						HttpResponse response = this._accountService.login(username, password);
						if(response.getStatusLine().getStatusCode() == 200)
						{
							//取得返回的字符串  
			                String result = EntityUtils.toString(response.getEntity());    
			                Log.v("CooperMsg", "登录response返回字符串: " + result);
			                   
			                //写入缓存
							Editor editor = this._sharedPrefs.edit();
							//将cookie写入SharePrefs
			                CookieStore cookieStore = this._accountService.getHttpClient().getCookieStore();
			                List<Cookie> cookies = cookieStore.getCookies();
			                if(cookies != null)
			                {
			                    for(Cookie cookie : cookies)
			                    {
			                    	Date expiryDate = cookie.getExpiryDate();
			                    	//TODO:...
//			                    	String expiryDateString = Tools.toShortDateString(expiryDate);
			                    	SimpleDateFormat dataFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			                    	String expiryDateString = dataFormat.format(expiryDate);
			                        String cookieString = cookie.getName() + ";" 
			                        		+ cookie.getValue() + ";" 
			                        		+ cookie.getDomain() + ";"
			                        		+ expiryDateString + ";"
			                        		+ cookie.getPath() + ";"
			                        		+ cookie.getComment() + ";"
			                        		+ cookie.getCommentURL() + ";"
			                        		+ cookie.getVersion();                        
			                        editor.putString(cookie.getDomain(), cookieString);
			                    }
			                }
							editor.putString(Constant.USERNAME_KEY, username);
							editor.putBoolean(Constant.ISGUESTUSER_KEY, false);
							editor.commit();

							resultCode.put("status", true);
							resultCode.put("data", true);
						}
						else //TODO:statusCode:400
						{		
							this.putResultCodeFailed(resultCode, response);							
						}	
					}
				}
				else if(key.equals(Constant.LOGOUT))
				{
					//注销
					HttpResponse response = this._accountService.logout();
					if(response.getStatusLine().getStatusCode() == 200)
					{
						//移除Domain中的cookies,username,isguestuser保存数据
						Editor editor = this._sharedPrefs.edit();
						editor.remove(Constant.DOMAIN);
						editor.remove(Constant.USERNAME_KEY);
						editor.remove(Constant.ISGUESTUSER_KEY);
						editor.commit();
						
						resultCode.put("status", true);
					}
					else
					{
						this.putResultCodeFailed(resultCode, response);
					}
				}
				else if(key.equals(Constant.SYNCTASKLISTS))
				{
					//同步任务列表
					if(this._sharedPrefs.contains(Constant.ISGUESTUSER_KEY))
					{
						Boolean isGuestUser = this._sharedPrefs.getBoolean(Constant.ISGUESTUSER_KEY, false);
						if(isGuestUser)
						{
							resultCode.put("status", false);
							resultCode.put("message", "匿名用户不能同步任务");
						}
						else
						{
							if(Tools.isNullOrEmpty(params.getString("tasklistId")))
							{
								//同步任务列表
								HttpResponse response = this._tasklistService.syncTasklists();
								
								if(response.getStatusLine().getStatusCode() == 200)
								{
									this.syncTasklistsAfterResponse("", resultCode, response);
								}
								else
								{
									this.putResultCodeFailed(resultCode, response);
								}
							}
							else
							{
								String tasklistId = (String)params.get("tasklistId");
								
								if(tasklistId.indexOf("temp_") >= 0)
								{
									HttpResponse response = this._tasklistService.syncTasklists(tasklistId);
									if(response.getStatusLine().getStatusCode() == 200)
									{
										this.syncTasklistsAfterResponse(tasklistId, resultCode, response);
										resultCode.put("status", true);
									}
									else
									{
										this.putResultCodeFailed(resultCode, response);
									}
								}
								else 
								{
									HttpResponse response = this._taskService.syncTasks(tasklistId);
									if(response.getStatusLine().getStatusCode() == 200)
									{
										this.syncTasksAfterResponse(tasklistId, resultCode, response);
									}
									else
									{
										this.putResultCodeFailed(resultCode, response);
									}
								}	
							}
						}
					}
				}
				
				Log.v(Constant.MESSAGE_TAG, "Native返回的JS端数据: " + resultCode.toString());
				PluginResult result = new PluginResult(PluginResult.Status.OK, resultCode);
				this.success(result, callbackId);
				return result;
			}
			else if(action.equals("get")) 
			{
				JSONObject resultCode = new JSONObject();
				JSONObject params = data.getJSONObject(0);
				String key = (String)params.get("key");
				
				if(key.equals(Constant.GETNETWORKSTATUS))
				{
					//判断设备是否连线
					Boolean isOnline = Tools.isOnline(this._activity);
					resultCode.put("status", true);
					resultCode.put("data", isOnline);
				}
				else if(key.equals(Constant.GETCURRENTUSER))
				{
					resultCode.put("status", true);
					
					//设置用户名
					String username = "";
					if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
					{
						username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
					}
					JSONObject userDict = new JSONObject();
					userDict.put("username", username);
					
					resultCode.put("data", userDict);
				}
				else if(key.equals(Constant.GETTASKLISTS))
				{
					List<Tasklist> tasklists = this._tasklistRepository.getAllTasklist();
					Boolean isDefaultTasklistExist = false;
					for (Tasklist tasklist : tasklists) {
						if(tasklist.getTasklistId().equals("0"))
						{
							isDefaultTasklistExist = true;
							break;
						}
					}
					if(!isDefaultTasklistExist)
					{
						Tasklist defaultTasklist = new Tasklist();
						defaultTasklist.setTasklistId("0");
						defaultTasklist.setName("默认列表");
						defaultTasklist.setListType("personal");
						defaultTasklist.setEditable(true);
						if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
						{
							defaultTasklist.setAccountId(this._sharedPrefs.getString(Constant.USERNAME_KEY, ""));
						}
						else 
						{
							defaultTasklist.setAccountId("");
						}
						this._tasklistRepository.addTasklist(defaultTasklist);
						tasklists.add(defaultTasklist);
					}
					
					JSONObject dict = new JSONObject();
					for (Tasklist tasklist : tasklists) {
						dict.put(tasklist.getTasklistId(), tasklist.getName());
					}
					resultCode.put("data", dict);
					resultCode.put("status", true);
				}
				else if(key.equals(Constant.GETTASKSBYPRIORITY)){
					String tasklistId = (String)params.get("tasklistId");
					
					Tasklist tasklist = this._tasklistRepository.getTasklistById(tasklistId);
					
					JSONObject dict = new JSONObject();
					dict.put("editable", tasklist.getEditable());
					
					List<TaskIdx> taskIdxs = this._taskIdxRepository.getAllTaskIdx(tasklistId);
					
					JSONArray task_aray = new JSONArray();
					JSONArray taskIdx_array = new JSONArray();

					for (TaskIdx taskIdx : taskIdxs) {
						JSONArray taskIdsDict = new JSONArray(taskIdx.getIndexes());
						for (int i = 0; i < taskIdsDict.length(); i++) {
							String taskId = taskIdsDict.getString(i);
							Task task = this._taskRepository.getTaskById(taskId);
							if(task != null)
							{
								JSONObject taskDict = new JSONObject();
								taskDict.put("id", task.getTaskId());
								taskDict.put("subject", task.getSubject());
								taskDict.put("body", task.getBody());
								taskDict.put("isCompleted", task.getStatus() == 1 ? "true" : "false");
								taskDict.put("dueTime", task.getDueDate() == null 
										? "" : new SimpleDateFormat("yyyy-MM-dd").format(task.getDueDate()));
								taskDict.put("priority", task.getPriority());
								
								task_aray.put(taskDict);
							}
						}
						
						JSONObject taskIdx_dict = new JSONObject();
						taskIdx_dict.put("by", "priority");
						taskIdx_dict.put("key", taskIdx.getKey());
						taskIdx_dict.put("name", taskIdx.getName());
						taskIdx_dict.put("indexs", taskIdsDict);
						taskIdx_array.put(taskIdx_dict);
					}
					
					dict.put("tasks", task_aray);
					dict.put("sorts", taskIdx_array);
					
					resultCode.put("status", true);
					resultCode.put("data", dict);
				}
				
				
				Log.v(Constant.MESSAGE_TAG, "Native返回的JS端数据: " + resultCode.toString());
				PluginResult result = new PluginResult(PluginResult.Status.OK, resultCode);
				this.success(result, callbackId);
				return result;
			}
			else if(action.equals("save")) 
			{
				JSONObject resultCode = new JSONObject();
				JSONObject params = data.getJSONObject(0);
				String key = (String)params.get("key");
				
				if(key.equals(Constant.CREATETASKLIST))
				{
					String tasklistId = params.getString("id");
					String tasklistName = params.getString("name");
					String tasklistType = params.getString("type");
					
					Tasklist tasklist = new Tasklist();
					tasklist.setTasklistId(tasklistId);
					tasklist.setName(tasklistName);
					tasklist.setListType(tasklistType);
					tasklist.setEditable(true);
					if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
					{
						tasklist.setAccountId(this._sharedPrefs.getString(Constant.USERNAME_KEY, ""));
					}
					else {
						tasklist.setAccountId("");
					}
					this._tasklistRepository.addTasklist(tasklist);
					
					resultCode.put("status", true);
				}
				else if(key.equals(Constant.CREATETASK))
				{
					JSONObject taskDict = params.getJSONObject("task");
					JSONArray changesArray = params.getJSONArray("changes");
					String tasklistId = params.getString("tasklistId");
					
					Date currentDate = new Date();
					
					String subject = taskDict.getString("subject");
					String body = taskDict.getString("body");
					String isCompleted = taskDict.getString("isCompleted");
					String priority = taskDict.getString("priority");
					String id = taskDict.getString("id");
					String dueTime = taskDict.getString("dueTime");
					
					Task task = new Task();
					task.setTaskId(id);
					task.setSubject(subject);
					task.setLastUpdateDate(currentDate);
					task.setBody(body);
					task.setIsPublic(true);
					if(isCompleted.equals("true"))
					{
						task.setStatus(1);
					}
					else {
						task.setStatus(0);
					}
					task.setPriority(priority);
					if(!Tools.isNullOrEmpty(dueTime))
					{
						SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
						try {
							Date dueTimeDate = format.parse(dueTime);
							task.setDueDate(dueTimeDate);
						} catch (java.text.ParseException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					task.setEditable(true);
					task.setTasklistId(tasklistId);
					if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
					{
						String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
						task.setAccountId(username);
					}
					else {
						task.setAccountId("");
					}
					this._taskRepository.addTask(task);
					
					TaskIdx taskIdxs = new TaskIdx();
					this._taskIdxRepository.addTaskIdx(id, priority, tasklistId);
					
					for (int i = 0; i < changesArray.length(); i++) {
						JSONObject dict = changesArray.getJSONObject(i);
						String name = dict.getString("Name");
						String value = dict.getString("Value");
						String taskId = dict.getString("ID");
						String type = dict.getString("Type"); 
						
						this._changeLogRepository.addChangeLog(type
								, taskId
								, name
								, value
								, tasklistId);
					}
					
				    resultCode.put("status", true);
				}
				else if(key.equals(Constant.UPDATETASK))
				{
					JSONObject taskDict = params.getJSONObject("task");
					JSONArray changesArray = params.getJSONArray("changes");
					String tasklistId = params.getString("tasklistId");
					
					Date currentDate = new Date();
					
					String subject = taskDict.getString("subject");
					String body = taskDict.getString("body");
					String isCompleted = taskDict.getString("isCompleted");
					String priority = taskDict.getString("priority");
					String id = taskDict.getString("id");
					String dueTime = taskDict.getString("dueTime");
					
					Task task = this._taskRepository.getTaskById(id);
			        String oldPriority = priority;
			        if(task != null)
			        {
			            oldPriority = task.getPriority();
			        }
					task.setSubject(subject);
					task.setLastUpdateDate(currentDate);
					task.setBody(body);
					task.setIsPublic(true);
					if(isCompleted.equals("true"))
					{
						task.setStatus(1);
					}
					else {
						task.setStatus(0);
					}
					task.setPriority(priority);
					if(!Tools.isNullOrEmpty(dueTime))
					{
						SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
						try {
							Date dueTimeDate = format.parse(dueTime);
							task.setDueDate(dueTimeDate);
						} catch (java.text.ParseException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					task.setEditable(true);
					task.setTasklistId(tasklistId);
			        this._taskRepository.updateTask(task);
			        
			        if(!oldPriority.equals(priority))
			        {
			        	this._taskIdxRepository.updateTaskIdx(id, priority, tasklistId);
			        }
			        
			        for (int i = 0; i < changesArray.length(); i++) {
						JSONObject dict = changesArray.getJSONObject(i);
						String name = dict.getString("Name");
						String value = dict.getString("Value");
						String taskId = dict.getString("ID");
						String type = dict.getString("Type"); 
						
						this._changeLogRepository.addChangeLog(type
								, taskId
								, name
								, value
								, tasklistId);
					}
			        
			        resultCode.put("status", true);
				}
				else if(key.equals(Constant.DELETETASK))
				{
					String tasklistId = params.getString("tasklistId");
					String taskId = params.getString("taskId");
					
					this._changeLogRepository.addChangeLog("1"
							, taskId
							, ""
							, ""
							, tasklistId);
					this._taskIdxRepository.deleteTaskIndexesByTaskId(taskId, tasklistId);
					
					Task task = this._taskRepository.getTaskById(taskId);
					this._taskRepository.deleteTask(task);
					
					resultCode.put("status", true);
				}
				
				Log.v(Constant.MESSAGE_TAG, "Native返回的JS端数据: " + resultCode.toString());
				PluginResult result = new PluginResult(PluginResult.Status.OK, resultCode);
				this.success(result, callbackId);
				return result;
			}
			else if(action.equals("debug")) 
			{
				Log.v("CooperMsg", data.toString());
				return new PluginResult(PluginResult.Status.OK);
			}
		} 
		catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
			JSONObject errorCode = new JSONObject();
			try {
				errorCode.put("status", false);
				errorCode.put("message", e.toString());
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			Log.v(Constant.MESSAGE_TAG, "Native返回的JS端的错误数据: " + errorCode.toString());
			//发送错误提示
			PluginResult result = new PluginResult(PluginResult.Status.ERROR, errorCode);
			this.success(result, callbackId);
			return result;
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}

	private void syncTasklistsAfterResponse(String tasklistId,
			JSONObject resultCode, HttpResponse response) throws ParseException, IOException, JSONException {
		String result = EntityUtils.toString(response.getEntity());
		JSONArray responseArray = new JSONArray(result);
		
		String newTasklistId = null;
		for(int i = 0; i < responseArray.length(); i++)
		{
			JSONObject dict = (JSONObject)responseArray.get(i);
			String oldId = dict.getString("OldId");
			String newId = dict.getString("NewId");
			
			Log.v(Constant.MESSAGE_TAG, String.format("任务列表旧值ID: %s 变为新值ID: %s", oldId, newId));
			
			this._tasklistRepository.updateTasklistIdByNewId(oldId, newId);
			
			if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
			{
				String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
				if(username != null && username != "")
				{
					this._taskRepository.updateTasklistIdByNewId(oldId, newId);
					this._taskIdxRepository.updateTasklistIdByNewId(oldId, newId);
					this._changeLogRepository.updateTasklistIdByNewId(oldId, newId);
					
					newTasklistId = newId;
				}
			}
		}
		
		if(Tools.isNullOrEmpty(tasklistId))
		{
			response = this._tasklistService.getTasklists();
			if(response.getStatusLine().getStatusCode() == 200)
			{
				result = EntityUtils.toString(response.getEntity());
				JSONObject tasklistsDict = new JSONObject(result);
				
				//删除当前账户所有列表
				this._tasklistRepository.deleteAll();
				
				List<Tasklist> tasklists = new ArrayList<Tasklist>();
				Iterator keyIter = tasklistsDict.keys();   
		        while(keyIter.hasNext())   
		        {   
		            String key = (String)keyIter.next();   
		            String value = (String)tasklistsDict.get(key);   
	
		            Tasklist tasklist = new Tasklist();
		            tasklist.setTasklistId(key);
		            tasklist.setName(value);
		            tasklist.setListType("personal");
		            tasklist.setEditable(true);
		            if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		            {
		            	tasklist.setAccountId(this._sharedPrefs.getString(Constant.USERNAME_KEY, ""));
		            }
		            else {
						tasklist.setAccountId("");
					}
		            tasklists.add(tasklist);
		        } 
		        Tasklist defaultTasklist = new Tasklist();
		        defaultTasklist.setTasklistId("0");
		        defaultTasklist.setName("默认列表");
		        defaultTasklist.setListType("personal");
		        defaultTasklist.setEditable(true);
	            if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
	            {
	            	defaultTasklist.setAccountId(this._sharedPrefs.getString(Constant.USERNAME_KEY, ""));
	            }
	            else {
					defaultTasklist.setAccountId("");
				}
	            tasklists.add(defaultTasklist);
	            
	            this._tasklistRepository.addTasklists(tasklists);
		        
		        if(tasklists.size() == 0)
		        {
		        	resultCode.put("status", true);
		        }
		        else
		        {
		        	for(Tasklist tasklist : tasklists)
		        	{
		        		//HACK:Fetch模式不支持同步变更
		        		if(tasklist.getTasklistId().equals("github"))
		        		{
		        			response = this._taskService.getTasks(tasklist.getTasklistId());
		        			if(response.getStatusLine().getStatusCode() == 200)
			        		{
		        				this.getTasksAfterResponse(tasklist.getTasklistId(), resultCode, response);
			        		}
		        			else 
			        		{
			        			this.putResultCodeFailed(resultCode, response);
							}
		        		}
		        		else 
		        		{
		        			response = this._taskService.syncTasks(tasklist.getTasklistId());
			        		if(response.getStatusLine().getStatusCode() == 200)
			        		{
			        			this.syncTasksAfterResponse(tasklist.getTasklistId(), resultCode, response);
			        		}
			        		else 
			        		{
			        			this.putResultCodeFailed(resultCode, response);
							}
						}     		
		        	}
		        	resultCode.put("status", true);
				}	
			}
			else
			{
				this.putResultCodeFailed(resultCode, response);
			}
		}
		else 
		{
			if(!Tools.isNullOrEmpty(newTasklistId))
			{
				response = this._taskService.syncTasks(newTasklistId);
	    		if(response.getStatusLine().getStatusCode() == 200)
	    		{
	    			this.syncTasksAfterResponse(newTasklistId, resultCode, response);
	    		}
	    		else 
	    		{
	    			this.putResultCodeFailed(resultCode, response);
				}
			}
		}
	}

	private void getTasksAfterResponse(String tasklistId, JSONObject resultCode,
			HttpResponse response) throws ParseException, IOException, JSONException {
		
		String result = EntityUtils.toString(response.getEntity());
		
		JSONObject dict = new JSONObject(result);
		String tasklist_editableString = dict.getString("Editable");
		
		this._tasklistRepository.updateEditable(tasklist_editableString.equals("true") ? 1 : 0, tasklistId);
		this._taskRepository.deleteAll(tasklistId);
		this._taskIdxRepository.deleteAll(tasklistId);
		
		JSONArray tasksArray = dict.getJSONArray("List");
		JSONArray taskIdxsArray = dict.getJSONArray("Sorts");
		
		List<Task> tasks = new ArrayList<Task>();
		for (int i = 0; i < tasksArray.length(); i++) {
			JSONObject taskDict = tasksArray.getJSONObject(i);
			String taskId = taskDict.getString("ID");
			String subject = !Tools.isNullOrEmpty(taskDict.getString("Subject")) ? taskDict.getString("Subject") : "";
			String body = !Tools.isNullOrEmpty(taskDict.getString("Body")) ? taskDict.getString("Body") : "";
			Boolean isCompleted = taskDict.getBoolean("IsCompleted");
			String priority = taskDict.getString("Priority");
			
			Boolean editable = taskDict.getBoolean("Editable");
			String dueTimeString = taskDict.getString("DueTime");
			
			Task task = new Task();
			task.setSubject(subject);
			Date currentDate = new Date();
			task.setCreateDate(currentDate);
			task.setLastUpdateDate(currentDate);
			task.setBody(body);
			task.setIsPublic(true);
			task.setStatus(isCompleted ? 1 : 0);
			task.setPriority(priority);
			task.setTaskId(taskId);
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			if(!Tools.isNullOrEmpty(dueTimeString))
			{
				try {
					Date dueTime = format.parse(dueTimeString);
					task.setDueDate(dueTime);
				} catch (java.text.ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			task.setEditable(editable);
			task.setTasklistId(tasklistId);
			if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
			{
				task.setAccountId(this._sharedPrefs.getString(Constant.USERNAME_KEY, ""));
			}
			else {
				task.setAccountId("");
			}
			tasks.add(task);
		}
		this._taskRepository.addTasks(tasks);
		
		List<TaskIdx> taskIdxs = new ArrayList<TaskIdx>();
		for (int i = 0; i < taskIdxsArray.length(); i++) {
			JSONObject taskIdxDict = taskIdxsArray.getJSONObject(i);
			String by = taskIdxDict.getString("By");
			String taskIdxKey = taskIdxDict.getString("Key");
			String name = taskIdxDict.getString("Name");
			
			JSONArray indexesArray = taskIdxDict.getJSONArray("Indexs");
			String indexes = indexesArray.toString();
			
			TaskIdx taskIdx = new TaskIdx();
			taskIdx.setBy(by);
			taskIdx.setKey(taskIdxKey);
			taskIdx.setName(name);
			taskIdx.setIndexes(indexes);
			taskIdx.setTasklistId(tasklistId);
			if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
			{
				taskIdx.setAccountId(this._sharedPrefs.getString(Constant.USERNAME_KEY, ""));
			}
			else {
				taskIdx.setAccountId("");
			}
			taskIdxs.add(taskIdx);
		}
		this._taskIdxRepository.addTaskIdxs(taskIdxs);
		
		resultCode.put("status", true);
	}

	private void syncTasksAfterResponse(String tasklistId,
			JSONObject resultCode,
			HttpResponse response) throws ParseException, IOException, JSONException {
		
		String result = EntityUtils.toString(response.getEntity());
		JSONArray array = new JSONArray(result);
		if(array.length() > 0)
		{
			for (int i = 0; i < array.length(); i++) {
				JSONObject dict = (JSONObject)array.get(i);
				String oldId = dict.getString("OldId");
				String newId = dict.getString("NewId");
				
				Log.v(Constant.MESSAGE_TAG, String.format("任务旧值ID: %s 变为新值ID: %s", oldId, newId));
			
				this._taskRepository.updateTaskIdByNewId(oldId, newId, tasklistId);
				this._taskIdxRepository.updateTaskIdxByNewId(oldId, newId, tasklistId);
			}
		}
		
		//修正changeLog
		this._changeLogRepository.updateAllToSend(tasklistId);
		
//		this.getTasksAfterResponse(tasklistId, resultCode, response);
		response = this._taskService.getTasks(tasklistId);
		if(response.getStatusLine().getStatusCode() == 200)
		{
			this.getTasksAfterResponse(tasklistId, resultCode, response);
			
		}
		else 
		{
			this.putResultCodeFailed(resultCode, response);
		}
		
	}

	private void putResultCodeFailed(JSONObject resultCode,
			HttpResponse response) throws JSONException {
		resultCode.put("status", false);
		resultCode.put("message", String.format("错误验证码:%s,错误消息:%s"
				, response.getStatusLine().getStatusCode()
				, response.getStatusLine().getReasonPhrase()));	
	}
}
