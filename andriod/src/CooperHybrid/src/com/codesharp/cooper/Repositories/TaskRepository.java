package com.codesharp.cooper.Repositories;

import java.util.List;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.codesharp.cooper.Constant;
import com.codesharp.cooper.MainActivity;
import com.codesharp.cooper.Task;
import com.codesharp.cooper.TaskDao;
import com.codesharp.cooper.Tasklist;
import com.codesharp.cooper.TasklistDao;

public class TaskRepository {
	private MainActivity _activity;
	private TaskDao _taskDao;
	private SharedPreferences _sharedPrefs;
	
	public TaskRepository(MainActivity activity) {
		this._activity = activity;
		this._taskDao = this._activity.getSession().getTaskDao();
		this._sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this._activity.getApplicationContext());
	}
	
	public List<Task> getAllTaskByTemp()
	{
		List<Task> tasks = this._taskDao.queryBuilder()
				.where(TaskDao.Properties.AccountId.isNull())
				.orderAsc(TaskDao.Properties.TaskId)
				.list();
		return tasks;
	}

	public void updateTasklistIdByNewId(String oldId, String newId) {
		
		List<Task> tasks = this.getAllTask(oldId);
		for (Task task : tasks) {
			task.setTasklistId(newId);
		}
		if(tasks.size() > 0)
		{
			this._taskDao.updateInTx(tasks);
		}
	}

	public void updateTaskIdByNewId(String oldId, String newId, String tasklistId) {
		Task task = this.getTaskById(oldId);
		if(task != null)
		{
			task.setTaskId(newId);
		}
		this._taskDao.update(task);
	}

	public void deleteAll(String tasklistId) {
		
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			this._taskDao.queryBuilder()
					.where(TaskDao.Properties.AccountId.eq(username)
							, TaskDao.Properties.TasklistId.eq(tasklistId))
					.buildDelete()
					.executeDeleteWithoutDetachingEntities();
		}
		else 
		{
			this._taskDao.queryBuilder()
					.where(TaskDao.Properties.AccountId.eq("")
							, TaskDao.Properties.TasklistId.eq(tasklistId))
					.buildDelete()
					.executeDeleteWithoutDetachingEntities();
		}
	}

	private List<Task> getAllTask(String tasklistId) {
		List<Task> tasks;
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			tasks = this._taskDao.queryBuilder()
					.where(TaskDao.Properties.AccountId.eq(username)
							, TaskDao.Properties.TasklistId.eq(tasklistId))
					.orderAsc(TaskDao.Properties.TaskId)
					.list();
		}
		else 
		{
			tasks = this._taskDao.queryBuilder()
					.where(TaskDao.Properties.AccountId.eq("")
							, TaskDao.Properties.TasklistId.eq(tasklistId))
					.orderAsc(TaskDao.Properties.TaskId)
					.list();
		}
		return tasks;
	}

	public void addTasks(List<Task> tasks) {
		
		this._taskDao.insertInTx(tasks);
	}

	public Task getTaskById(String taskId) {
		List<Task>tasks = this._taskDao.queryBuilder()
			.where(TaskDao.Properties.TaskId.eq(taskId))
			.list();
		
		Task task = null;
		if(tasks.size() > 0)
		{
			task = tasks.get(0);
		}
		return task;
	}

	public void addTask(Task task) {
		this._taskDao.insert(task);
	}

	public void updateTask(Task task) {
		this._taskDao.update(task);
	}

	//批量更新任务
	public void updateTasks(List<Task> tasks) {
		
		this._taskDao.updateInTx(tasks);
	}

	public void deleteTask(Task task) {
		
		this._taskDao.delete(task);
	}
	
	
}
