package com.codesharp.cooper;

import android.R.color;
import android.os.Debug;

public class Constant {
	public static final String LOGIN = "Login";
	public static final String LOGOUT = "Logout";
	public static final String SYNCTASKLISTS = "SyncTasklists";
	public static final String SYNCTASKS = "SyncTasks";
	public static final String GETNETWORKSTATUS = "GetNetworkStatus";
	public static final String GETCURRENTUSER = "GetCurrentUser";
	public static final String GETTASKLISTS = "GetTasklists";
	public static final String GETTASKLISTS_SERVER = "GetTasklists_Server";
	public static final String GETTASKSBYPRIORITY = "GetTasksByPriority";
	public static final String GETTASKSBYPRIORITY_SERVER = "GetTasksByPriority_Server";
	public static final String CREATETASKLIST = "CreateTasklist";
	public static final String CREATETASK = "CreateTask";
	public static final String UPDATETASK = "UpdateTask";
	public static final String DELETETASK = "DeleteTask";
	
	public static final String ANONYMOUS = "anonymous";
	public static final String NORMAL = "normal";
	
	public static final String MESSAGE_TAG = "CooperMsg";
	//全局键
	public static final String USERNAME_KEY = "username";
	public static final String ISGUESTUSER_KEY = "isguestuser";
	
	//Service路径
	public static final String DOMAIN = "cooper.apphb.com";
	public static final String ROOTURL = "https://" + DOMAIN;
//	public static final String DOMAIN = "debug.incooper.net";
//	public static final String ROOTURL = "http://" + DOMAIN;
	public static final String LOGIN_URL = ROOTURL + "/Account/Login";
	public static final String LOGOUT_URL = ROOTURL + "/Account/logout";
	public static final String GETTASKLISTS_URL = ROOTURL + "/Personal/GetTaskFolders";
	public static final String TASK_GETBYPRIORITY_URL = ROOTURL + "/Personal/GetByPriority";
	public static final String TASKLISTS_SYNC_URL = ROOTURL + "/Personal/CreateTaskFolders";
	public static final String TASK_SYNC_URL = ROOTURL + "/Personal/Sync";
	
	public static final String PRIORITY_TITLE_1 = "尽快完成";
	public static final String PRIORITY_TITLE_2 = "稍后完成";
	public static final String PRIORITY_TITLE_3 = "迟些再说";
}
