package com.codesharp.cooper.Services;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.codesharp.cooper.ChangeLog;
import com.codesharp.cooper.Constant;
import com.codesharp.cooper.MainActivity;
import com.codesharp.cooper.TaskIdx;
import com.codesharp.cooper.Tools;
import com.codesharp.cooper.Repositories.ChangeLogRepository;
import com.codesharp.cooper.Repositories.TaskIdxRepository;
import com.codesharp.cooper.plugins.RequestManager;

public class TaskService {
	
	private MainActivity _activity;
	private RequestManager _requestManager;
	private DefaultHttpClient _httpClient;
	
	private ChangeLogRepository _changeLogRepository;
	private TaskIdxRepository _taskIdxRepository;
	
	public TaskService(MainActivity activity)
	{
		this._activity = activity;
		this._changeLogRepository = new ChangeLogRepository(this._activity);
		this._taskIdxRepository = new TaskIdxRepository(this._activity);
		
		this._requestManager = new RequestManager(this._activity);
	}

	public HttpResponse syncTasks(String tasklistId) throws JSONException, ClientProtocolException, IOException {
		
		List<ChangeLog> changeLogs = this._changeLogRepository.getAllChangeLog(tasklistId);	
		JSONArray changeLogsArray = new JSONArray();
		for (ChangeLog changeLog : changeLogs) {
			JSONObject dict = new JSONObject();
			dict.put("Type", changeLog.getChangeType());
			dict.put("ID", changeLog.getDataid());
			dict.put("Name", changeLog.getName() == null ? "" : changeLog.getName());
			dict.put("Value", changeLog.getValue());
			
			changeLogsArray.put(dict);
		}
		
		List<TaskIdx> taskIdxs = this._taskIdxRepository.getAllTaskIdx(tasklistId);
		JSONArray taskIdxsArray = new JSONArray();
		for (TaskIdx taskIdx : taskIdxs) {
			JSONObject dict = new JSONObject();
			dict.put("By", taskIdx.getBy());
			dict.put("Key", taskIdx.getKey());
			dict.put("Name", taskIdx.getName());
			
			JSONArray indexesArray = null;
			if(Tools.isNullOrEmpty(taskIdx.getIndexes()))
			{
				indexesArray = new JSONArray();
			}
			else 
			{
				indexesArray = new JSONArray(taskIdx.getIndexes());
			}
			dict.put("Indexs", indexesArray);
			
			taskIdxsArray.put(dict);
		}
		
		String changeLogsJson = changeLogsArray.toString();
		//TODO:暂不处理排序功能
		String taskIdxsJson = "";
		
		Log.v(Constant.MESSAGE_TAG, "changeLogsJson: " + changeLogsJson);
		Log.v(Constant.MESSAGE_TAG, "taskIdxsJson: " + taskIdxsJson);
		
		HttpPost request = new HttpPost(Constant.TASK_SYNC_URL);
		
		List<NameValuePair> postParameters = new ArrayList<NameValuePair>();
		postParameters.add(new BasicNameValuePair("tasklistId", tasklistId));
		postParameters.add(new BasicNameValuePair("changes", changeLogsJson));
		postParameters.add(new BasicNameValuePair("by", "ByPriority"));
		postParameters.add(new BasicNameValuePair("sorts", taskIdxsJson));
		try {
			UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(postParameters);
			request.setEntity(formEntity);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		this._httpClient = this._requestManager.getHttpClient();
		HttpResponse response = this._httpClient.execute(request);
		return response;
	}

	public HttpResponse getTasks(String tasklistId) throws ClientProtocolException, IOException {
		
		HttpPost request = new HttpPost(Constant.TASK_GETBYPRIORITY_URL);
		
		List<NameValuePair> postParameters = new ArrayList<NameValuePair>();
		postParameters.add(new BasicNameValuePair("tasklistId", tasklistId));
		try {
			UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(postParameters);
			request.setEntity(formEntity);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		this._httpClient = this._requestManager.getHttpClient();
		HttpResponse response = this._httpClient.execute(request);
		return response;
	}
}
