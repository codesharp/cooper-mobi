package com.codesharp.cooper.Services;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.protocol.ClientContext;
import org.apache.http.cookie.Cookie;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.cookie.BasicClientCookie;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.codesharp.cooper.ChangeLog;
import com.codesharp.cooper.Constant;
import com.codesharp.cooper.MainActivity;
import com.codesharp.cooper.Task;
import com.codesharp.cooper.TaskIdx;
import com.codesharp.cooper.Tasklist;
import com.codesharp.cooper.TasklistDao;
import com.codesharp.cooper.Tools;
import com.codesharp.cooper.Repositories.ChangeLogRepository;
import com.codesharp.cooper.Repositories.TaskIdxRepository;
import com.codesharp.cooper.Repositories.TaskRepository;
import com.codesharp.cooper.Repositories.TasklistRepository;
import com.codesharp.cooper.plugins.RequestManager;

import android.R.dimen;
import android.R.integer;
import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.util.Log;

public class TasklistService {
	
	private MainActivity _activity;
	private RequestManager _requestManager;
	private DefaultHttpClient _httpClient;
	
	private SharedPreferences _sharedPrefs;
	private TasklistRepository _repository;
	private TaskRepository _taskRepository;
	private TaskIdxRepository _taskIdxRepository;
	private ChangeLogRepository _changeLogRepository;
	
	public DefaultHttpClient getHttpClient() {
		return this._httpClient;
	}
	
	public TasklistService(MainActivity activity)
	{
		this._activity = activity;
		this._sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this._activity.getApplicationContext());
		this._repository = new TasklistRepository(this._activity);
		this._taskRepository = new TaskRepository(this._activity);
		this._taskIdxRepository = new TaskIdxRepository(this._activity);
		this._changeLogRepository = new ChangeLogRepository(this._activity);
		
		this._requestManager = new RequestManager(this._activity);
	}
	
	public HttpResponse syncTasklists(String tasklistId)  throws JSONException, ClientProtocolException, IOException  {
		Tasklist tasklist = this._repository.getTasklistById(tasklistId);
		
		JSONArray array = new JSONArray();
		JSONObject dict = new JSONObject();
		dict.put("ID", tasklist.getTasklistId());
		dict.put("Name", tasklist.getName());
		dict.put("Type", tasklist.getListType());
		array.put(dict);
		
		String tasklistsJson = array.toString();
		
		HttpPost request = new HttpPost(Constant.TASKLISTS_SYNC_URL);
		List<NameValuePair> postParameters = new ArrayList<NameValuePair>();
		postParameters.add(new BasicNameValuePair("data", tasklistsJson));

		UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(postParameters);
		request.setEntity(formEntity);

		this._httpClient = this._requestManager.getHttpClient();
		
		HttpResponse response = this._httpClient.execute(request);
		return response;
	}
	
	public HttpResponse syncTasklists() throws JSONException, ClientProtocolException, IOException {
		
		List<Tasklist> tempTasklists = this._repository.getAllTasklistByTemp();
		String username = this._sharedPrefs.contains(Constant.USERNAME_KEY) ? 
				 this._sharedPrefs.getString(Constant.USERNAME_KEY, "") : "";

		List<Tasklist> tasklists = this._repository.getAllTasklistByUserAndTemp();
		tempTasklists.addAll(tasklists);
		
		for (Tasklist tasklist : tasklists) {
			tasklist.setAccountId(username);
		}
		if(tasklists.size() > 0)
			this._repository.updateTasklists(tasklists);
		
		List<Task> tasks = this._taskRepository.getAllTaskByTemp();
		for (Task task : tasks) {
			task.setAccountId(username);
		}
		if(tasks.size() > 0)
			this._taskRepository.updateTasks(tasks);
		
		List<TaskIdx> taskIdxs = this._taskIdxRepository.getAllTaskIdxByTemp();
		for (TaskIdx taskIdx : taskIdxs) {
			taskIdx.setAccountId(username);
		}
		if(taskIdxs.size() > 0)
			this._taskIdxRepository.updateTaskIdxs(taskIdxs);
		
		List<ChangeLog> changeLogs = this._changeLogRepository.getAllChangeLogByTemp();
		for (ChangeLog changeLog : changeLogs) {
			changeLog.setAccountId(username);
		}		
		if(changeLogs.size() > 0)
			this._changeLogRepository.updateChangeLogs(changeLogs);
		
		JSONArray array = new JSONArray();
		for (Tasklist tasklist : tempTasklists) {
			JSONObject dict = new JSONObject();
			dict.put("ID", tasklist.getTasklistId());
			dict.put("Name", tasklist.getName());
			dict.put("Type", tasklist.getListType());
			array.put(dict);
		}
		
		String tasklistsJson = array.toString();
		
		HttpPost request = new HttpPost(Constant.TASKLISTS_SYNC_URL);
		List<NameValuePair> postParameters = new ArrayList<NameValuePair>();
		postParameters.add(new BasicNameValuePair("data", tasklistsJson));

		UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(postParameters);
		request.setEntity(formEntity);

		this._httpClient = this._requestManager.getHttpClient();
		
		HttpResponse response = this._httpClient.execute(request);
		return response;
	}

	public HttpResponse getTasklists() throws JSONException, ClientProtocolException, IOException {
		
		HttpPost request = new HttpPost(Constant.GETTASKLISTS_URL);
		this._httpClient = this._requestManager.getHttpClient();
		HttpResponse response = this._httpClient.execute(request);
		return response;
	}
}
