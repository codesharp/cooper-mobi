package com.codesharp.cooper.Repositories;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;

import android.R.integer;
import android.R.string;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.codesharp.cooper.ChangeLogDao;
import com.codesharp.cooper.Constant;
import com.codesharp.cooper.MainActivity;
import com.codesharp.cooper.Task;
import com.codesharp.cooper.TaskDao;
import com.codesharp.cooper.TaskIdx;
import com.codesharp.cooper.TaskIdxDao;
import com.codesharp.cooper.Tools;

public class TaskIdxRepository {

	private MainActivity _activity;
	private TaskIdxDao _taskIdxDao;
	private SharedPreferences _sharedPrefs;
	
	public TaskIdxRepository(MainActivity activity) {
		this._activity = activity;
		this._taskIdxDao = this._activity.getSession().getTaskIdxDao();
		this._sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this._activity.getApplicationContext());
	}
	
	public List<TaskIdx> getAllTaskIdxByTemp()
	{
		List<TaskIdx> taskIdxs = this._taskIdxDao.queryBuilder()
				.where(TaskIdxDao.Properties.AccountId.eq(""))
				.list();
		return taskIdxs;
	}

	public void updateTaskIdxByNewId(String oldId, String newId, String tasklistId) throws JSONException {
		
		List<TaskIdx> taskIdxs = this.getAllTaskIdx(tasklistId);
		for (TaskIdx taskIdx : taskIdxs) {
			JSONArray sIndexesArray = new JSONArray(taskIdx.getIndexes());
			int i = 0;
			for(int index = 0; index < sIndexesArray.length(); index++)
			{
				String taskId = sIndexesArray.getString(index);
				if(taskId == oldId)
				{
					sIndexesArray.put(i, newId);
					break;
				}
				i++;
			}
			taskIdx.setIndexes(sIndexesArray.toString());
		}
		this._taskIdxDao.updateInTx(taskIdxs);
	}

	public void deleteAll(String tasklistId) {
		
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			this._taskIdxDao.queryBuilder()
					.where(TaskIdxDao.Properties.AccountId.eq(username)
							, TaskIdxDao.Properties.TasklistId.eq(tasklistId))
					.buildDelete()
					.executeDeleteWithoutDetachingEntities();
		}
		else
		{
			this._taskIdxDao.queryBuilder()
					.where(TaskIdxDao.Properties.AccountId.eq("")
							, TaskIdxDao.Properties.TasklistId.eq(tasklistId))
					.buildDelete()
					.executeDeleteWithoutDetachingEntities();
		}
		//this._taskIdxDao.deleteInTx(taskIdxs);
	}

	public void updateTasklistIdByNewId(String oldId, String newId) {
		
		List<TaskIdx> taskIdxs = this.getAllTaskIdx(oldId);
		for (TaskIdx taskIdx : taskIdxs) {
			taskIdx.setTasklistId(newId);
		}
		if(taskIdxs.size() > 0)
		{
			this._taskIdxDao.updateInTx(taskIdxs);
		}
	}

	public void addTaskIdxs(List<TaskIdx> taskIdxs) {
		
		this._taskIdxDao.insertInTx(taskIdxs);
	}

	public List<TaskIdx> getAllTaskIdx(String tasklistId) {
		List<TaskIdx> taskIdxs = null;
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			taskIdxs = this._taskIdxDao.queryBuilder()
					.where(TaskIdxDao.Properties.AccountId.eq(username)
							, TaskIdxDao.Properties.TasklistId.eq(tasklistId))
					.list();
		}
		else
		{
			taskIdxs = this._taskIdxDao.queryBuilder()
					.where(TaskIdxDao.Properties.AccountId.eq("")
							, TaskIdxDao.Properties.TasklistId.eq(tasklistId))
					.list();
		}
		return taskIdxs;
	}

	public void addTaskIdx(String taskId, String key, String tasklistId) {
		
		List<TaskIdx> taskIdxs = null;
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			if(!Tools.isNullOrEmpty(username))
			{
				taskIdxs = this._taskIdxDao.queryBuilder()
						.where(TaskIdxDao.Properties.Key.eq(key)
								, TaskIdxDao.Properties.TasklistId.eq(tasklistId)
								, TaskIdxDao.Properties.AccountId.eq(username))
						.list();
			}
			else
			{
				taskIdxs = this._taskIdxDao.queryBuilder()
						.where(TaskIdxDao.Properties.Key.eq(key)
								, TaskIdxDao.Properties.TasklistId.eq(tasklistId)
								, TaskIdxDao.Properties.AccountId.eq(""))
						.list();
			}
		}
		
		TaskIdx taskIdx = null;
		JSONArray indexesArray = null;
		if(taskIdxs == null || (taskIdxs != null && taskIdxs.size() == 0))
		{
			taskIdx = new TaskIdx();
			taskIdx.setBy("priority");
			taskIdx.setKey(key);
			taskIdx.setName(key.equals("0") ? Constant.PRIORITY_TITLE_1 : (key.equals("1") 
					? Constant.PRIORITY_TITLE_2 : Constant.PRIORITY_TITLE_3));
			if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
			{
				String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
				taskIdx.setAccountId(username);
			}
			else
			{
				taskIdx.setAccountId("");
			}
			indexesArray = new JSONArray();
		}
		else
		{
			taskIdx = taskIdxs.get(0);
			if(Tools.isNullOrEmpty(taskIdx.getIndexes()))
			{
				indexesArray = new JSONArray();
			}
			else
			{
				try {
					indexesArray = new JSONArray(taskIdx.getIndexes());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		indexesArray.put(taskId);
		taskIdx.setIndexes(indexesArray.toString());
		taskIdx.setTasklistId(tasklistId);
		
		if(taskIdxs == null || (taskIdxs != null && taskIdxs.size() == 0))
		{
			this._taskIdxDao.insert(taskIdx);
		}
		else 
		{
			this._taskIdxDao.update(taskIdx);
		}
	}

	public void updateTaskIdx(String taskId, String key, String tasklistId) {
		
		List<TaskIdx> taskIdxs = null;
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			if(!Tools.isNullOrEmpty(username))
			{
				taskIdxs = this._taskIdxDao.queryBuilder()
						.where(TaskIdxDao.Properties.TasklistId.eq(tasklistId)
								, TaskIdxDao.Properties.AccountId.eq(username))
						.list();
			}
			else
			{
				taskIdxs = this._taskIdxDao.queryBuilder()
						.where(TaskIdxDao.Properties.TasklistId.eq(tasklistId)
								, TaskIdxDao.Properties.AccountId.eq(""))
						.list();
			}
		}
		
		if(taskIdxs != null) 
		{
			for (TaskIdx taskIdx : taskIdxs) {
				JSONArray indexesArray = null;
				JSONArray newIndexesArray = null;
				try {
					indexesArray = new JSONArray(taskIdx.getIndexes());
					newIndexesArray = new JSONArray();
					for (int i = 0; i < indexesArray.length(); i++) {
						String currentTaskId = indexesArray.getString(i);
						if(!currentTaskId.equals(taskId))
						{
							newIndexesArray.put(currentTaskId);
						}
					}
					if(taskIdx.getKey().equals(key))
					{
						newIndexesArray.put(taskId);
					}
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				taskIdx.setIndexes(newIndexesArray.toString());
			}
			
			this._taskIdxDao.updateInTx(taskIdxs);
		}
	}

	public void deleteTaskIndexesByTaskId(String taskId, String tasklistId) {
		
		List<TaskIdx> taskIdxs = null;
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			if(!Tools.isNullOrEmpty(username))
			{
				taskIdxs = this._taskIdxDao.queryBuilder()
						.where(TaskIdxDao.Properties.TasklistId.eq(tasklistId)
								, TaskIdxDao.Properties.AccountId.eq(username))
						.list();
			}
			else
			{
				taskIdxs = this._taskIdxDao.queryBuilder()
						.where(TaskIdxDao.Properties.TasklistId.eq(tasklistId)
								, TaskIdxDao.Properties.AccountId.eq(""))
						.list();
			}
		}
		
		if(taskIdxs != null) 
		{
			for (TaskIdx taskIdx : taskIdxs) {
				JSONArray indexesArray = null;
				JSONArray newIndexesArray = null;
				try {
					indexesArray = new JSONArray(taskIdx.getIndexes());
					newIndexesArray = new JSONArray();
					for (int i = 0; i < indexesArray.length(); i++) {
						String currentTaskId = indexesArray.getString(i);
						if(!currentTaskId.equals(taskId))
						{
							newIndexesArray.put(currentTaskId);
						}
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				if(newIndexesArray != null)
				{
					taskIdx.setIndexes(newIndexesArray.toString());
				}
			}
			
			this._taskIdxDao.updateInTx(taskIdxs);
		}
	}

	//批量更新任务排序
	public void updateTaskIdxs(List<TaskIdx> taskIdxs) {
		
		this._taskIdxDao.updateInTx(taskIdxs);
	}
}
