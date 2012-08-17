package com.codesharp.cooper.Repositories;

import java.util.List;

import android.R.integer;
import android.R.string;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.codesharp.cooper.Constant;
import com.codesharp.cooper.MainActivity;
import com.codesharp.cooper.Tasklist;
import com.codesharp.cooper.TasklistDao;
import com.codesharp.cooper.Tools;
import com.codesharp.cooper.ChangeLogDao.Properties;

public class TasklistRepository {
	
	private MainActivity _activity;
	private TasklistDao _tasklistDao;
	private SharedPreferences _sharedPrefs;
	
	public TasklistRepository(MainActivity activity) {
		this._activity = activity;
		this._tasklistDao = this._activity.getSession().getTasklistDao();
		this._sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this._activity.getApplicationContext());
	}
	
	public List<Tasklist> getAllTasklistByUserAndTemp()
	{
		List<Tasklist> tasklists = null;
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			if(!Tools.isNullOrEmpty(username))
			{
				tasklists  = this._tasklistDao.queryBuilder()
						.where(TasklistDao.Properties.TasklistId.like("temp_%")
								, TasklistDao.Properties.AccountId.eq(username))
							.orderAsc(TasklistDao.Properties.TasklistId)
							.list();
			}
			else
			{
				tasklists  = this._tasklistDao.queryBuilder()
						.where(TasklistDao.Properties.TasklistId.like("temp_%")
								, TasklistDao.Properties.AccountId.eq(""))
							.orderAsc(TasklistDao.Properties.TasklistId)
							.list(); 
			}
		}
		return tasklists;
	}
	
	public List<Tasklist> getAllTasklistByTemp()
	{
		List<Tasklist> tasklists = this._tasklistDao.queryBuilder()
				.where(TasklistDao.Properties.TasklistId.like("temp_%")
						, TasklistDao.Properties.AccountId.eq(""))
				.orderAsc(TasklistDao.Properties.TasklistId)
				.list();
		return tasklists;
	}
	
	public List<Tasklist> getAllTasklist()
	{
		List<Tasklist> tasklists;
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			tasklists = this._tasklistDao.queryBuilder()
					.where(TasklistDao.Properties.AccountId.eq(username))
					.orderAsc(TasklistDao.Properties.TasklistId)
					.list();
		}
		else 
		{
			tasklists = this._tasklistDao.queryBuilder()
					.where(TasklistDao.Properties.AccountId.eq(""))
					.orderAsc(TasklistDao.Properties.TasklistId)
					.list();
		}
		return tasklists;
	}
	
	public Tasklist getTasklistById(String tasklistId)
	{
		Tasklist tasklist = null;
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			
			List<Tasklist> tasklists = null;
			if(!Tools.isNullOrEmpty(username))
			{
				tasklists = this._tasklistDao.queryBuilder()
						.where(TasklistDao.Properties.AccountId.eq(username)
								, TasklistDao.Properties.TasklistId.eq(tasklistId))
						.list();
			}
			else
			{
				tasklists = this._tasklistDao.queryBuilder()
						.where(TasklistDao.Properties.AccountId.eq("")
								, TasklistDao.Properties.TasklistId.eq(tasklistId))
						.list();
			}
			if(tasklists.size() > 0)
			{
				tasklist = tasklists.get(0);
			}
		}
		return tasklist;
	}

	public void updateTasklistIdByNewId(String oldId, String newId) {
		
		Tasklist tasklist = this.getTasklistById(oldId);
		if(tasklist != null)
		{
			tasklist.setTasklistId(newId);
		}
		this._tasklistDao.update(tasklist);
	}

	public void deleteAll() {
		
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			 this._tasklistDao.queryBuilder()
					.where(TasklistDao.Properties.AccountId.eq(username))
					.orderAsc(TasklistDao.Properties.TasklistId)
					.buildDelete()
					.executeDeleteWithoutDetachingEntities();
		}
		else 
		{
			this._tasklistDao.queryBuilder()
					.where(TasklistDao.Properties.AccountId.eq(""))
					.orderAsc(TasklistDao.Properties.TasklistId)
					.buildDelete()
					.executeDeleteWithoutDetachingEntities();
		}
	}

	public void addTasklist(Tasklist tasklist) {
		this._tasklistDao.insert(tasklist);
	}

	public void addTasklists(List<Tasklist> tasklists) {
		this._tasklistDao.insertInTx(tasklists);
	}

	public void updateEditable(int editable, String tasklistId) {
		Tasklist tasklist = this.getTasklistById(tasklistId);
		if(tasklist != null)
		{
			tasklist.setEditable(editable == 1 ? true : false);
		}
		this._tasklistDao.update(tasklist);
	}

	//批量更新任务列表
	public void updateTasklists(List<Tasklist> tasklists) {
		
		this._tasklistDao.updateInTx(tasklists);
	}
}
