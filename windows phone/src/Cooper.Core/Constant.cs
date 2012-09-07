using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;

namespace Cooper.Core
{
    /// <summary>
    /// 常量
    /// </summary>
    public class Constant
    {
        public static readonly String LOGIN = "Login";
	    public static readonly String LOGOUT = "Logout";
	    public static readonly String SYNCTASKLISTS = "SyncTasklists";
	    public static readonly String SYNCTASKS = "SyncTasks";
	    public static readonly String GETNETWORKSTATUS = "GetNetworkStatus";
	    public static readonly String GETCURRENTUSER = "GetCurrentUser";
	    public static readonly String GETTASKLISTS = "GetTasklists";
	    public static readonly String GETTASKLISTS_SERVER = "GetTasklists_Server";
	    public static readonly String GETTASKSBYPRIORITY = "GetTasksByPriority";
	    public static readonly String GETTASKSBYPRIORITY_SERVER = "GetTasksByPriority_Server";
	    public static readonly String CREATETASKLIST = "CreateTasklist";
	    public static readonly String CREATETASK = "CreateTask";
	    public static readonly String UPDATETASK = "UpdateTask";
	    public static readonly String DELETETASK = "DeleteTask";
	
	    public static readonly String ANONYMOUS = "anonymous";
	    public static readonly String NORMAL = "normal";
	
	    public static readonly String MESSAGE_TAG = "CooperMsg";
	    //全局键
	    public static readonly String USERNAME_KEY = "username";
	    public static readonly String ISGUESTUSER_KEY = "isguestuser";
	
	    //Service路径
        //public static readonly String DOMAIN = "cooper.wf.taobao.org";
        //public static readonly String ROOTURL = "https://" + DOMAIN;
	    public static readonly String DOMAIN = "cooper.apphb.com";
        public static readonly String ROOTURL = "https://" + DOMAIN;
        //public static readonly String DOMAIN = "10.13.25.81:9012";
        //public static readonly String ROOTURL = "http://" + DOMAIN;
        public static readonly String LOGIN_URL = ROOTURL + "/Account/Login";
	    //public static readonly String LOGIN_URL = ROOTURL + "/Account/ArkLogin";
	    public static readonly String LOGOUT_URL = ROOTURL + "/Account/Logout";
	    public static readonly String GETTASKLISTS_URL = ROOTURL + "/Personal/GetTasklists";
	    public static readonly String TASK_GETBYPRIORITY_URL = ROOTURL + "/Personal/GetByPriority";
	    public static readonly String TASKLISTS_SYNC_URL = ROOTURL + "/Personal/CreateTasklists";
	    public static readonly String TASKLIST_SYNC_URL = ROOTURL + "/Personal/CreateTasklist";
	    public static readonly String TASK_SYNC_URL = ROOTURL + "/Personal/Sync";

        public static readonly String PRIORITY_TITLE_1 = "尽快完成";
	    public static readonly String PRIORITY_TITLE_2 = "稍后完成";
	    public static readonly String PRIORITY_TITLE_3 = "迟些再说";

        public static readonly String DB_CONNSTRING = "Data Source=isostore:/Cooper.sdf";
    }
}
