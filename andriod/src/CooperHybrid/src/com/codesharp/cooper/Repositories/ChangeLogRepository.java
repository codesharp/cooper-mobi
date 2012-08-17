package com.codesharp.cooper.Repositories;

import java.util.List;

import android.R.string;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.codesharp.cooper.ChangeLog;
import com.codesharp.cooper.ChangeLogDao;
import com.codesharp.cooper.Constant;
import com.codesharp.cooper.MainActivity;
import com.codesharp.cooper.TaskIdx;
import com.codesharp.cooper.TaskIdxDao;

import de.greenrobot.dao.WhereCondition;

public class ChangeLogRepository {
	
	private MainActivity _activity;
	private ChangeLogDao _changeLogDao;
	private SharedPreferences _sharedPrefs;
	
	public ChangeLogRepository(MainActivity activity) {
		this._activity = activity;
		this._changeLogDao = this._activity.getSession().getChangeLogDao();
		this._sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this._activity.getApplicationContext());
	}
	
	public List<ChangeLog> getAllChangeLogByTemp()
	{
		List<ChangeLog> changeLogs = this._changeLogDao.queryBuilder()
				.where(ChangeLogDao.Properties.AccountId.eq(""))
				.list();
		return changeLogs;
	}

	public void updateTasklistIdByNewId(String oldId, String newId) {
		
		List<ChangeLog> changeLogs = this.getAllChangeLog(oldId);
		for (ChangeLog changeLog : changeLogs) {
			changeLog.setTasklistId(newId);
		}
		if(changeLogs.size() > 0)
			this._changeLogDao.updateInTx(changeLogs);
	}

	public void updateAllToSend(String tasklistId) {
		
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			this._changeLogDao.queryBuilder()
					.where(ChangeLogDao.Properties.AccountId.eq(username)
							, ChangeLogDao.Properties.TasklistId.eq(tasklistId))
					.buildDelete()
					.executeDeleteWithoutDetachingEntities();
		}
		else
		{
			this._changeLogDao.queryBuilder()
					.where(ChangeLogDao.Properties.AccountId.eq("")
							, ChangeLogDao.Properties.TasklistId.eq(tasklistId))
					.buildDelete()
					.executeDeleteWithoutDetachingEntities();
		}
	}

	public void addChangeLog(String type, String taskId, String name, String value, String tasklistId) {
		
		ChangeLog changeLog = new ChangeLog();
		changeLog.setChangeType(type);
		changeLog.setDataid(taskId);
		changeLog.setName(name);
		changeLog.setValue(value);
		changeLog.setIsSend(false);
		changeLog.setTasklistId(tasklistId);
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			changeLog.setAccountId(username);
		}
		else
		{
			changeLog.setAccountId("");
		}
		this._changeLogDao.insert(changeLog);
	}

	//批量更新Changelog记录
	public void updateChangeLogs(List<ChangeLog> changeLogs) {
		
		this._changeLogDao.updateInTx(changeLogs);
	}

	public List<ChangeLog> getAllChangeLog(String tasklistId) {
		
		List<ChangeLog> changeLogs = null;
		if(this._sharedPrefs.contains(Constant.USERNAME_KEY))
		{
			String username = this._sharedPrefs.getString(Constant.USERNAME_KEY, "");
			changeLogs = this._changeLogDao.queryBuilder()
					.where(ChangeLogDao.Properties.AccountId.eq(username)
							, ChangeLogDao.Properties.TasklistId.eq(tasklistId))
					.list();
		}
		else
		{
			changeLogs = this._changeLogDao.queryBuilder()
					.where(ChangeLogDao.Properties.AccountId.eq("")
							, ChangeLogDao.Properties.TasklistId.eq(tasklistId))
					.list();
		}
		return changeLogs;
	}
}
