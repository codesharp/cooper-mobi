using System;
using System.Collections.Generic;
using System.IO;
using System.IO.IsolatedStorage;
using System.Net;
using System.Runtime.Serialization;
using Cooper.Core;
using Cooper.Services;
using Newtonsoft.Json;
using WP7CordovaClassLib.Cordova;
using WP7CordovaClassLib.Cordova.Commands;
using WP7CordovaClassLib.Cordova.JSON;
using Hammock;
using Newtonsoft.Json.Linq;
using Cooper.Core.Models;
using Cooper.Repositories;

namespace Cordova.Extension.Commands
{
    /// <summary>
    /// Cooper-Phonegap插件
    /// </summary>
    public class CooperPlugin : BaseCommand
    {
        #region JSON实例类

        /// <summary>
        /// 结果
        /// </summary>
        public class ResultCode
        {
            [JsonProperty(Required = Required.Default
                , PropertyName = "status")]
            public bool Status;

            [JsonProperty(Required = Required.AllowNull
                , PropertyName = "data"
                , DefaultValueHandling = DefaultValueHandling.IgnoreAndPopulate)]
            public object Data;

            [JsonProperty(Required = Required.AllowNull
                , PropertyName = "message"
                , DefaultValueHandling = DefaultValueHandling.IgnoreAndPopulate)]
            public string Message;
        }
        /// <summary>
        /// 用户信息
        /// </summary>
        public class UserInfo
        {
            [JsonProperty(Required = Required.Default
                , PropertyName = "username")]
            public string Username;
        }

        ///////////////////////////////////////////////////////////////////////////////////////////////

        [DataContract]
        public class SignKeyOptions
        {
            [DataMember(IsRequired = true, Name = "key")]
            public string Key;
        }
        [DataContract]
        public class LoginOptions : SignKeyOptions
        {
            [DataMember(IsRequired = false, Name = "type")]
            public string Type;

            [DataMember(IsRequired = false, Name = "domain")]
            public string Domain;

            [DataMember(IsRequired = false, Name = "username")]
            public string Username;

            [DataMember(IsRequired = false, Name = "password")]
            public string Password;
        }
        [DataContract]
        public class SyncTasklistsOptions : SignKeyOptions
        {
            [DataMember(IsRequired = false, Name = "tasklistId")]
            public string TasklistId;
        }
        [DataContract]
        public class GetTasksByPriorityOptions : SignKeyOptions
        {
            [DataMember(IsRequired = false, Name = "tasklistId")]
            public string TasklistId;
        }
        [DataContract]
        public class CreateTasklistOptions : SignKeyOptions
        {
            [DataMember(IsRequired = false, Name = "id")]
            public string Id;

            [DataMember(IsRequired = false, Name = "name")]
            public string Name;

            [DataMember(IsRequired = false, Name = "type")]
            public string Type;
        }
        [DataContract]
        public class DeleteTaskOptions : SignKeyOptions
        {
            [DataMember(IsRequired = false, Name = "tasklistId")]
            public string TasklistId;

            [DataMember(IsRequired = false, Name = "taskId")]
            public string TaskId;
        }
        #endregion

        //控制台输出
        private DebugConsole _console = new DebugConsole();

        private AccountService _accountService;
        private TasklistService _tasklistService;
        private TaskService _taskService;
        private TasklistRepository _tasklistRepository;
        private TaskRepository _taskRepository;
        private TaskIdxRepository _taskIdxRepository;
        private ChangeLogRepository _changeLogRepository;

        public CooperPlugin()
        {
            this._accountService = new AccountService();
            this._tasklistService = new TasklistService();
            this._taskService = new TaskService();
            this._tasklistRepository = new TasklistRepository();
            this._taskRepository = new TaskRepository();
            this._taskIdxRepository = new TaskIdxRepository();
            this._changeLogRepository = new ChangeLogRepository();
        }

        /// <summary>
        /// 刷新，与服务端交互
        /// </summary>
        /// <param name="options">条件</param>
        public void refresh(string options)
        {
            ResultCode resultCode = new ResultCode();

            var keyOptions = JsonHelper.Deserialize<SignKeyOptions>(options);
            if (keyOptions.Key.Equals(Constant.LOGIN))
            {
                var loginOptions = JsonHelper.Deserialize<LoginOptions>(options);
                if (string.IsNullOrEmpty(loginOptions.Type))
                {
                    resultCode.Status = false;
                    resultCode.Message = "type不能为空!";

                    this.DispatchCommandResult(resultCode);
                }
                else if (!loginOptions.Type.Equals(Constant.ANONYMOUS)
                    && !loginOptions.Type.Equals(Constant.NORMAL))
                {
                    resultCode.Status = true;
                    resultCode.Message = "type参数必须为anonymous或normal";

                    this.DispatchCommandResult(resultCode);
                }
                else
                {
                    if (loginOptions.Type.Equals(Constant.ANONYMOUS))
                    {
                        #region 跳过登录
                        IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] = "";
                        IsolatedStorageSettings.ApplicationSettings[Constant.ISGUESTUSER_KEY] = true;

                        resultCode.Status = true;

                        this.DispatchCommandResult(resultCode);
                        #endregion
                    }
                    else
                    {
                        #region 登录
                        string domain = loginOptions.Domain;
                        string username = loginOptions.Username;
                        string password = loginOptions.Password;

                        if (string.IsNullOrEmpty(domain))
                        {
                            this._accountService.Login(username
                                , password
                                , response =>
                                {
                                    if (response.StatusCode == HttpStatusCode.OK)
                                    {
                                        var responseString = response.Content;
                                        this._console.log(string.Format("登录response返回的字符串:{0}"
                                            , responseString));
                                        IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] = username;
                                        IsolatedStorageSettings.ApplicationSettings[Constant.ISGUESTUSER_KEY] = false;
                                        IsolatedStorageSettings.ApplicationSettings.Save();

                                        resultCode.Status = true;
                                        resultCode.Data = true;

                                        this.DispatchCommandResult(resultCode);
                                    }
                                    else
                                    {
                                        this.DispatchCommandResult(response);
                                    }
                                }
                                , exception =>
                                {
                                    this.DispatchCommandResult(exception);
                                });
                        }
                        else
                        {
                            this._accountService.Login(domain
                                , username
                                , password
                                , response =>
                                {
                                    if (response.StatusCode == HttpStatusCode.OK)
                                    {
                                        var responseString = response.Content;
                                        this._console.log(string.Format("登录response返回的字符串:{0}"
                                            , responseString));
                                        if (responseString.IndexOf("window.opener.loginSuccess") >= 0)
                                        {
                                            IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] = username;
                                            IsolatedStorageSettings.ApplicationSettings[Constant.ISGUESTUSER_KEY] = false;
                                            IsolatedStorageSettings.ApplicationSettings.Save();

                                            resultCode.Status = true;
                                            resultCode.Data = true;

                                            this.DispatchCommandResult(resultCode);
                                        }
                                        else
                                        {
                                            this.DispatchCommandResult(response);
                                        }
                                    }
                                    else
                                    {
                                        this.DispatchCommandResult(response);
                                    }
                                }
                                , exception => 
                                {
                                    this.DispatchCommandResult(exception);
                                });
                        }
                        #endregion
                    }
                }
            }
            else if (keyOptions.Key.Equals(Constant.LOGOUT))
            {
                #region 注销
                this._accountService.Logout(response =>
                    {
                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            IsolatedStorageSettings.ApplicationSettings.Remove(Constant.DOMAIN);
                            IsolatedStorageSettings.ApplicationSettings.Remove(Constant.USERNAME_KEY);
                            IsolatedStorageSettings.ApplicationSettings.Remove(Constant.ISGUESTUSER_KEY);

                            resultCode.Status = true;
                            this.DispatchCommandResult(resultCode);
                        }
                        else
                        {
                            this.DispatchCommandResult(response);
                        }
                    }
                , exception =>
                    {
                        this.DispatchCommandResult(exception);
                    });
                #endregion
            }
            else if (keyOptions.Key.Equals(Constant.SYNCTASKLISTS))
            {
                #region 同步任务列表
                var isGuestUser = (bool)IsolatedStorageSettings.ApplicationSettings[Constant.ISGUESTUSER_KEY];
                if (isGuestUser)
                {
                    resultCode.Status = false;
                    resultCode.Message = "匿名用户不能同步任务";

                    this.DispatchCommandResult(resultCode);
                }
                else
                {
                    var synctasklistOptions = JsonHelper.Deserialize<SyncTasklistsOptions>(options);
                    if (string.IsNullOrEmpty(synctasklistOptions.TasklistId))
                    {
                        List<Tasklist> tempTasklists = this._tasklistRepository.GetAllTasklistByTemp();
                        string username = IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY) ?
                            IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string : "";

                        List<Tasklist> tasklists = this._tasklistRepository.GetAllTasklistByUserAndTemp();
                        tempTasklists.AddRange(tasklists);

                        foreach (var tasklist in tasklists)
                        {
                            tasklist.AccountId = username;
                        }

                        if (tasklists.Count > 0)
                            this._tasklistRepository.UpdateTasklists(tasklists);

                        List<Task> tasks = this._taskRepository.GetAllTaskByTemp();
                        foreach (var task in tasks)
                        {
                            task.AccountId = username;
                        }

                        if (tasks.Count > 0)
                            this._taskRepository.UpdateTasks(tasks);

                        List<TaskIdx> taskIdxs = this._taskIdxRepository.GetAllTaskIdxByTemp();
                        foreach (var taskIdx in taskIdxs)
                        {
                            taskIdx.AccountId = username;
                        }

                        if (taskIdxs.Count > 0)
                            this._taskIdxRepository.UpdateTaskIdxs(taskIdxs);

                        List<ChangeLog> changeLogs = this._changeLogRepository.GetAllChangeLogByTemp();
                        foreach (var changeLog in changeLogs)
                        {
                            changeLog.AccountId = username;
                        }

                        if (changeLogs.Count > 0)
                            this._changeLogRepository.UpdateChangeLogs(changeLogs);

                        foreach (var tasklist in tempTasklists)
                        {
                            this._tasklistService.SyncTasklist(tasklist.Name
                                , tasklist.ListType
                                , response =>
                                    {
                                        if (response.StatusCode == HttpStatusCode.OK)
                                        {
                                            this.SyncTasklistAfterResponse("", tasklist, resultCode, response);
                                        }
                                        else
                                        {
                                            this.DispatchCommandResult(response);
                                        }
                                    }
                                , exception =>
                                    {
                                        this.DispatchCommandResult(exception);
                                    });
                        }

                        this._tasklistService.GetTasklists(response =>
                            {
                                if (response.StatusCode == HttpStatusCode.OK)
                                {
                                    this.GetTasklistsAfterResponse("", resultCode, response);
                                }
                                else
                                {
                                    this.DispatchCommandResult(response);
                                }
                            }
                        , exception =>
                            {
                                this.DispatchCommandResult(exception);
                            });
                    }
                    else
                    {
                        string tasklistId = synctasklistOptions.TasklistId;
                        if (tasklistId.IndexOf("temp_") >= 0)
                        {
                            Tasklist tasklist = this._tasklistRepository.GetTasklistById(tasklistId);
                            this._tasklistService.SyncTasklist(tasklist.Name, tasklist.ListType
                                , response =>
                                    {
                                        if (response.StatusCode == HttpStatusCode.OK)
                                        {
                                            this.SyncTasklistAfterResponse(tasklistId, tasklist, resultCode, response);
                                        }
                                        else
                                        {
                                            this.DispatchCommandResult(response);
                                        }
                                    }
                                , exception =>
                                    {
                                        this.DispatchCommandResult(exception);
                                    });

                            this._tasklistService.GetTasklists(response =>
                                {
                                    if (response.StatusCode == HttpStatusCode.OK)
                                    {
                                        this.GetTasklistsAfterResponse(tasklistId, resultCode, response);
                                    }
                                    else
                                    {
                                        this.DispatchCommandResult(response);
                                    }
                                }
                                , exception =>
                                    {
                                        this.DispatchCommandResult(exception);
                                    });
                        }
                        else
                        {
                            this._taskService.SyncTasks(tasklistId
                                , response =>
                                    {
                                        if (response.StatusCode == HttpStatusCode.OK)
                                        {
                                            this.SyncTasksAfterResponse(tasklistId, resultCode, response);
                                        }
                                        else
                                        {
                                            this.DispatchCommandResult(response);
                                        }
                                    }
                                , exception =>
                                    {
                                        this.DispatchCommandResult(exception);
                                    });
                        }
                    }
                }
                #endregion
            }
        }
        /// <summary>
        /// 获取
        /// </summary>
        /// <param name="options"条件></param>
        public void get(string options)
        {
            ResultCode resultCode = new ResultCode();

            SignKeyOptions keyOptions = JsonHelper.Deserialize<SignKeyOptions>(options);
            if (keyOptions.Key.Equals(Constant.GETNETWORKSTATUS))
            {
                #region 是否连接网络
                bool isOnline = Tools.IsOnline();
                resultCode.Status = true;
                resultCode.Data = isOnline;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
            else if (keyOptions.Key.Equals(Constant.GETCURRENTUSER))
            {
                #region 获取当前用户名  
                string username = "";
                //if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                //{
                //    username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY].ToString();
                //}

                var userInfo = new UserInfo();
                userInfo.Username = username;
                resultCode.Data = userInfo;
                resultCode.Status = true;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
            else if (keyOptions.Key.Equals(Constant.GETTASKLISTS))
            {
                #region 获取任务列表
                List<Tasklist> tasklists = this._tasklistRepository.GetAllTasklist();
                bool isDefaultTasklistExist = false;
                foreach (var tasklist in tasklists)
                {
                    if (tasklist.TasklistId.Equals("0"))
                    {
                        isDefaultTasklistExist = true;
                        break;
                    }
                }
                if (!isDefaultTasklistExist)
                {
                    Tasklist defaultTasklist = new Tasklist();
                    defaultTasklist.TasklistId = "0";
                    defaultTasklist.Name = "默认列表";
                    defaultTasklist.ListType = "personal";
                    defaultTasklist.Editable = true;
                    if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                    {
                        defaultTasklist.AccountId = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY].ToString();
                    }
                    else
                    {
                        defaultTasklist.AccountId = "";
                    }
                    this._tasklistRepository.AddTasklist(defaultTasklist);
                    tasklists.Add(defaultTasklist);
                }

                Dictionary<string, string> dict = new Dictionary<string, string>();
                foreach (var tasklist in tasklists)
                {
                    dict.Add(tasklist.TasklistId, tasklist.Name);
                }
                resultCode.Data = dict;
                resultCode.Status = true;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
            else if (keyOptions.Key.Equals(Constant.GETTASKSBYPRIORITY))
            {
                #region 获取任务
                var getTasksByPriorityOptions = JsonHelper.Deserialize<GetTasksByPriorityOptions>(options);
                string tasklistId = getTasksByPriorityOptions.TasklistId;

                Tasklist tasklist = this._tasklistRepository.GetTasklistById(tasklistId);

                Dictionary<string, object> dict = new Dictionary<string, object>();
                dict.Add("editable", tasklist.Editable);

                List<TaskIdx> taskIdxs = this._taskIdxRepository.GetAllTaskIdx(tasklistId);

                List<Dictionary<string, object>> task_array = new List<Dictionary<string, object>>();
                List<Dictionary<string, object>> taskIdx_array = new List<Dictionary<string, object>>();

                foreach (var taskIdx in taskIdxs)
                {
                    JArray taskIdsDict = (JArray)taskIdx.Indexes.ToJSONObject();
                    for (int i = 0; i < taskIdsDict.Count; i++)
                    {
                        string taskId = taskIdsDict[i].Value<string>();
                        Task task = this._taskRepository.GetTaskById(taskId);
                        if (task != null)
                        {
                            Dictionary<string, object> taskDict = new Dictionary<string, object>();
                            taskDict.Add("id", task.TaskId);
                            taskDict.Add("subject", task.Subject);
                            taskDict.Add("body", task.Body);
                            taskDict.Add("isCompleted", task.Status == 1 ? "true" : "false");
                            taskDict.Add("dueTime", !task.DueDate.HasValue ? "" : task.DueDate.Value.ToString("yyyy-MM-dd"));
                            taskDict.Add("priority", task.Priority);

                            task_array.Add(taskDict);
                        }
                    }

                    Dictionary<string, object> taskIdx_dict = new Dictionary<string, object>();
                    taskIdx_dict.Add("by", "priority");
                    taskIdx_dict.Add("key", taskIdx.Key);
                    taskIdx_dict.Add("name", taskIdx.Name);
                    taskIdx_dict.Add("indexs", taskIdsDict);
                    taskIdx_array.Add(taskIdx_dict);
                }

                dict.Add("tasks", task_array);
                dict.Add("sorts", taskIdx_array);

                resultCode.Status = true;
                resultCode.Data = dict;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
        }
        /// <summary>
        /// 保存
        /// </summary>
        /// <param name="options">条件</param>
        public void save(string options)
        {
            ResultCode resultCode = new ResultCode();

            SignKeyOptions keyOptions = JsonHelper.Deserialize<SignKeyOptions>(options);
            if (keyOptions.Key.Equals(Constant.CREATETASKLIST))
            {
                #region 创建任务列表
                CreateTasklistOptions createTasklistOptions = JsonHelper.Deserialize<CreateTasklistOptions>(options);

                string tasklistId = createTasklistOptions.Id;
                string tasklistName = createTasklistOptions.Name;
                string tasklistType = createTasklistOptions.Type;

                Tasklist tasklist = new Tasklist();
                tasklist.TasklistId = tasklistId;
                tasklist.Name = tasklistName;
                tasklist.ListType = tasklistType;
                tasklist.Editable = true;
                if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                {
                    tasklist.AccountId = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY].ToString();
                }
                else
                {
                    tasklist.AccountId = "";
                }
                this._tasklistRepository.AddTasklist(tasklist);

                resultCode.Status = true;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
            else if (keyOptions.Key.Equals(Constant.CREATETASK))
            {
                #region 创建任务
                JObject updateTaskOptions = (JObject)options.ToJSONObject();

                string tasklistId = updateTaskOptions["tasklistId"].Value<string>();

                JToken taskDict = (JToken)updateTaskOptions["task"];
                JArray changesArray = (JArray)updateTaskOptions["changes"];

                DateTime currentDate = DateTime.Now;

                string subject = taskDict["subject"].Value<string>();
                string body = taskDict["body"].Value<string>();
                string isCompleted = taskDict["isCompleted"].Value<string>();
                string priority = taskDict["priority"].Value<string>();
                string id = taskDict["id"].Value<string>();
                string dueTime = taskDict["dueTime"].Value<string>();

                Task t = new Task();
                t.TaskId = id;
                t.Subject = subject;
                t.LastUpdateDate = currentDate;
                t.Body = body;
                t.IsPublic = true;
                if (isCompleted.ToLower().Equals("true"))
                {
                    t.Status = 1;
                }
                else
                {
                    t.Status = 0;
                }
                t.Priority = priority;
                if (!string.IsNullOrEmpty(dueTime))
                {
                    t.DueDate = Convert.ToDateTime(dueTime);
                }
                t.Editable = true;
                t.TasklistId = tasklistId;
                if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                {
                    t.AccountId = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY].ToString();
                }
                else
                {
                    t.AccountId = "";
                }
                this._taskRepository.AddTask(t);

                this._taskIdxRepository.AddTaskIdx(id, priority, tasklistId);

                for (int i = 0; i < changesArray.Count; i++)
                {
                    JToken dict = (JToken)changesArray[i];
                    string name = dict["Name"].Value<string>();
                    string value = dict["Value"].Value<string>();
                    string taskId = dict["ID"].Value<string>();
                    string type = dict["Type"].Value<string>();

                    this._changeLogRepository.AddChangeLog(type, taskId, name, value, tasklistId);
                }

                resultCode.Status = true;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
            else if (keyOptions.Key.Equals(Constant.UPDATETASK))
            {
                #region 更新任务
                JObject updateTaskOptions = (JObject)options.ToJSONObject();

                string tasklistId = updateTaskOptions["tasklistId"].Value<string>();

                JToken taskDict = (JToken)updateTaskOptions["task"];
                JArray changesArray = (JArray)updateTaskOptions["changes"];

                DateTime currentDate = DateTime.Now;

                string subject = taskDict["subject"].Value<string>();
                string body = taskDict["body"].Value<string>();
                string isCompleted = taskDict["isCompleted"].Value<string>();
                string priority = taskDict["priority"].Value<string>();
                string id = taskDict["id"].Value<string>();
                string dueTime = taskDict["dueTime"].Value<string>();

                Task t = this._taskRepository.GetTaskById(id);
                string oldPriority = priority;
                if (t != null)
                {
                    oldPriority = t.Priority;
                }
                t.Subject = subject;
                t.LastUpdateDate = currentDate;
                t.Body = body;
                t.IsPublic = true;
                if (isCompleted.ToLower().Equals("true"))
                {
                    t.Status = 1;
                }
                else
                {
                    t.Status = 0;
                }
                t.Priority = priority;
                if (!string.IsNullOrEmpty(dueTime))
                {
                    t.DueDate = Convert.ToDateTime(dueTime);
                }
                t.Editable = true;
                t.TasklistId = tasklistId;
                this._taskRepository.UpdateTask(t);

                if (!oldPriority.Equals(priority))
                {
                    this._taskIdxRepository.UpdateTaskIdx(id, priority, tasklistId);
                }

                for (int i = 0; i < changesArray.Count; i++)
                {
                    JToken dict = (JToken)changesArray[i];
                    string name = dict["Name"].Value<string>();
                    string value = dict["Value"].Value<string>();
                    string taskId = dict["ID"].Value<string>();
                    string type = dict["Type"].Value<string>();

                    this._changeLogRepository.AddChangeLog(type, taskId, name, value, tasklistId);
                }

                resultCode.Status = true;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
            else if (keyOptions.Key.Equals(Constant.DELETETASK))
            {
                #region 删除任务
                DeleteTaskOptions deleteTaskOptions = JsonHelper.Deserialize<DeleteTaskOptions>(options);

                string tasklistId = deleteTaskOptions.TasklistId;
                string taskId = deleteTaskOptions.TaskId;

                this._changeLogRepository.AddChangeLog("1", taskId, "", "", tasklistId);

                this._taskIdxRepository.DeleteTaskIndexesByTaskId(taskId, tasklistId);

                Task task = this._taskRepository.GetTaskById(taskId);
                if (task != null)
                {
                    this._taskRepository.DeleteTask(task);
                }

                resultCode.Status = true;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
        }
        /// <summary>
        /// 调试
        /// </summary>
        /// <param name="options">条件</param>
        public void debug(string options)
        {
            this._console.log(options);
        }

        private void DispatchCommandResult(ResultCode resultCode)
        {
            this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK) { Message = resultCode.ToJSONString() });
        }
        private void DispatchCommandResult(RestResponse response)
        {
            ResultCode resultCode = new ResultCode();
            resultCode.Status = false;
            resultCode.Message = string.Format("错误验证码:{0},错误消息:{1}"
                , response.StatusCode
                , response.StatusDescription);
            DispatchCommandResult(new PluginResult(PluginResult.Status.OK, resultCode));
        }
        private void DispatchCommandResult(Exception exception)
        {
            ResultCode resultCode = new ResultCode();
            resultCode.Status = false;
            resultCode.Message = string.Format("异常日志:{0}"
                , exception.ToString());
            DispatchCommandResult(new PluginResult(PluginResult.Status.OK, resultCode));
        }
        private string GetResponseString(HttpWebResponse response)
        {
            using(Stream responseStream = response.GetResponseStream())
                using (StreamReader sr = new StreamReader(responseStream))
                {
                    string responseString = sr.ReadToEnd();
                    Console.WriteLine(responseString);
                    return responseString;
                }
        }
        private string SyncTasklistAfterResponse(string tasklistId, Tasklist tasklist, ResultCode resultCode, RestResponse response)
        {
            string result = response.Content;

            this._tasklistRepository.AdjustWithNewId(tasklist.TasklistId, result);

            this._console.log(string.Format("任务列表旧值ID:{0} 变为新值ID:{1}", tasklist.TasklistId, result));

            string newTasklistId = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = (string)IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY];

                if (!string.IsNullOrEmpty(username))
                {
                    this._taskRepository.UpdateTasklistIdByNewId(tasklist.TasklistId, result);
                    this._taskIdxRepository.UpdateTasklistIdByNewId(tasklist.TasklistId, result);
                    this._changeLogRepository.UpdateTasklistIdByNewId(tasklist.TasklistId, result);

                    newTasklistId = result;
                }
            }

            return newTasklistId;
        }
        private void SyncTasklistAfterResponse(string tasklistId, ResultCode resultCode, RestResponse response)
        {
            string result = response.Content;
            List<Dictionary<string, string>> responseArray = (List<Dictionary<string, string>>)result.ToJSONObject();

            string newTasklistId = null;
            for (int i = 0; i < responseArray.Count; i++)
            {
                Dictionary<string, string> dict = responseArray[i];
                string oldId = dict["OldId"];
                string newId = dict["NewId"];

                this._console.log(string.Format("任务列表旧值ID:{0}, 变为新值ID:{1}", oldId, newId));

                this._tasklistRepository.UpdateTasklistByNewId(oldId, newId);

                if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                {
                    string username = (string)IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY];

                    if (!string.IsNullOrEmpty(username))
                    {
                        this._taskRepository.UpdateTasklistIdByNewId(oldId, newId);
                        this._taskIdxRepository.UpdateTasklistIdByNewId(oldId, newId);
                        this._changeLogRepository.UpdateTasklistIdByNewId(oldId, newId);

                        newTasklistId = newId;
                    }
                }
            }

            if (string.IsNullOrEmpty(tasklistId))
            {
                this._tasklistService.GetTasklists(response1 =>
                    {
                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            result = response1.Content;
                            Dictionary<string, string> tasklistsDict = (Dictionary<string, string>)result.ToJSONObject();

                            //删除当前账户所有列表
                            this._tasklistRepository.DeleteAll();

                            List<Tasklist> tasklists = new List<Tasklist>();
                            foreach (string key in tasklistsDict.Keys)
                            {
                                string value = tasklistsDict[key];

                                Tasklist tasklist = new Tasklist();
                                tasklist.TasklistId = key;
                                tasklist.Name = value;
                                tasklist.ListType = "personal";
                                tasklist.Editable = true;
                                if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                                {
                                    string username = (string)IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY];
                                    tasklist.AccountId = username;
                                }
                                else
                                {
                                    tasklist.AccountId = "";
                                }
                                tasklists.Add(tasklist);
                            }
                            Tasklist defaultTasklist = new Tasklist();
                            defaultTasklist.TasklistId = "0";
                            defaultTasklist.Name = "默认列表";
                            defaultTasklist.ListType = "personal";
                            defaultTasklist.Editable = true;
                            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                            {
                                string username = (string)IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY];
                                defaultTasklist.AccountId = username;
                            }
                            else
                            {
                                defaultTasklist.AccountId = "";
                            }
                            tasklists.Add(defaultTasklist);

                            this._tasklistRepository.AddTasklists(tasklists);

                            if (tasklists.Count == 0)
                            {
                                resultCode.Status = true;
                            }
                            else
                            {
                                foreach (var tasklist in tasklists)
                                {
                                    //HACK:Fetch模式不支持同步变更
                                    if (tasklist.TasklistId.Equals("github")
                                        || tasklist.TasklistId.Equals("ifree")
                                        || tasklist.TasklistId.Equals("wf"))
                                    {
                                        this._taskService.GetTasks(tasklist.TasklistId
                                            , response2 =>
                                                {
                                                    if (response2.StatusCode == HttpStatusCode.OK)
                                                    {
                                                        this.GetTasksAfterResponse(tasklist.TasklistId, resultCode, response2);
                                                    }
                                                    else
                                                    {
                                                        this.DispatchCommandResult(response2);
                                                    }
                                                }
                                            , exception =>
                                                {
                                                    this.DispatchCommandResult(exception);
                                                });
                                    }
                                    else
                                    {
                                        this._taskService.SyncTasks(tasklist.TasklistId
                                            , response2 =>
                                                {
                                                    if (response2.StatusCode == HttpStatusCode.OK)
                                                    {
                                                        this.SyncTasksAfterResponse(tasklist.TasklistId, resultCode, response2);
                                                    }
                                                    else
                                                    {
                                                        this.DispatchCommandResult(response2);
                                                    }
                                                }
                                            , exception =>
                                                {
                                                    this.DispatchCommandResult(exception);
                                                });
                                    }
                                    resultCode.Status = true;
                                }
                            }
                        }
                        else
                        {
                            this.DispatchCommandResult(response1);
                        }
                    }
                , exception =>
                    {
                        this.DispatchCommandResult(exception);
                    });
            }
        }
        private void GetTasklistsAfterResponse(string tasklistId, ResultCode resultCode, RestResponse response)
        {
            string result = response.Content;
            Dictionary<string, string> tasklistDict = JsonConvert.DeserializeObject<Dictionary<string, string>>(result);
            //删除当前账户的所有任务列表
            this._tasklistRepository.DeleteAll();

            List<Tasklist> tasklists = new List<Tasklist>();
            foreach (var key in tasklistDict.Keys)
            {
                string value = tasklistDict[key];

                Tasklist tasklist = new Tasklist();
                tasklist.TasklistId = key;
                tasklist.Name = value;
                tasklist.ListType = "personal";
                tasklist.Editable = true;
                if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                {
                    tasklist.AccountId = (string)IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY];
                }
                else
                {
                    tasklist.AccountId = "";
                }
                tasklists.Add(tasklist);
            }
            Tasklist defaultTasklist = new Tasklist();
            defaultTasklist.TasklistId = "0";
            defaultTasklist.Name = "默认列表";
            defaultTasklist.ListType = "personal";
            defaultTasklist.Editable = true;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                defaultTasklist.AccountId = (string)IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY];
            }
            else
            {
                defaultTasklist.AccountId = "";
            }
            tasklists.Add(defaultTasklist);

            this._tasklistRepository.AddTasklists(tasklists);

            if (tasklists.Count == 0)
            {
                resultCode.Status = true;

                this.DispatchCommandResult(resultCode);
            }
            else
            {
                foreach(Tasklist tempTasklist in tasklists)
		        {
		        	//HACK:Fetch模式不支持同步变更
		        	if(tempTasklist.TasklistId.Equals("github")
                            || tempTasklist.TasklistId.Equals("ifree")
                            || tempTasklist.TasklistId.Equals("wf"))
		        	{
                        this._taskService.GetTasks(tempTasklist.TasklistId
                            , response1 =>
                            {
                                if (response1.StatusCode == HttpStatusCode.OK)
                                {
                                    this.GetTasksAfterResponse(tempTasklist.TasklistId, resultCode, response1);
                                }
                                else
                                {
                                    this.DispatchCommandResult(response1);
                                }
                            }
                            , exception =>
                            {
                                this.DispatchCommandResult(exception);
                            });	
		        	}
		        	else 
		        	{
		        		this._console.log("tasklistId:" + tempTasklist.TasklistId);
                        this._taskService.SyncTasks(tempTasklist.TasklistId
                            , response1 =>
                            {
                                if (response1.StatusCode == HttpStatusCode.OK)
                                {
                                    this.SyncTasksAfterResponse(tempTasklist.TasklistId, resultCode, response1);
                                }
                                else
                                {
                                    this.DispatchCommandResult(response1);
                                }
                            }
                            , exception =>
                            {
                                this.DispatchCommandResult(exception);
                            });
			        	
					}     		
		        }
                resultCode.Status = true;

                this.DispatchCommandResult(resultCode);
			}
        }
        private void GetTasksAfterResponse(string tasklistId, ResultCode resultCode, RestResponse response)
        {
            string result = response.Content;

            JObject dict = (JObject)result.ToJSONObject();
            string tasklist_editableString = dict["Editable"].Value<string>();

            this._tasklistRepository.UpdateEditable(tasklist_editableString.ToLower().Equals("true") ? 1 : 0, tasklistId);
            this._taskRepository.DeleteAll(tasklistId);
            this._taskIdxRepository.DeleteAll(tasklistId);

            JArray tasksArray = (JArray)dict["List"];
            JArray taskIdxsArray = (JArray)dict["Sorts"];

            List<Task> tasks = new List<Task>();
            for (int i = 0; i < tasksArray.Count; i++)
            {
                JToken taskDict = tasksArray[i];
                string taskId = taskDict["ID"].Value<string>();
                string subject = taskDict["Subject"].Value<string>();
                string body = taskDict["Body"].Value<string>();
                bool isCompleted = taskDict["IsCompleted"].Value<bool>();
                string priority = taskDict["Priority"].Value<string>();
                bool editable = taskDict["Editable"].Value<bool>();
                string dueTimeString = taskDict["DueTime"].Value<string>();

                Task task = new Task();
                task.Subject = subject;
                DateTime currentDate = DateTime.Now;
                task.CreateDate = currentDate;
                task.LastUpdateDate = currentDate;
                task.Body = body;
                task.IsPublic = true;
                task.Status = isCompleted ? 1 : 0;
                task.Priority = priority;
                task.TaskId = taskId;
                DateTime dueTime;
                if (DateTime.TryParse(dueTimeString, out dueTime))
                {
                    task.DueDate = dueTime;
                }
               
                task.Editable = editable;
                task.TasklistId = tasklistId;
                if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                {
                    string username = (string)IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY];
                    task.AccountId = username;
                }
                else
                {
                    task.AccountId = "";
                }
                tasks.Add(task);
            }
            this._taskRepository.AddTasks(tasks);

            List<TaskIdx> taskIdxs = new List<TaskIdx>();
            for (int i = 0; i < taskIdxsArray.Count; i++)
            {
                JToken taskIdxDict = taskIdxsArray[i];
                string by = taskIdxDict["By"].Value<string>();
                string taskIdxKey = taskIdxDict["Key"].Value<string>();
                string name = taskIdxDict["Name"].Value<string>();

                JArray indexsArray = (JArray)taskIdxDict["Indexs"];
                string indexes = indexsArray.ToJSONString();

                TaskIdx taskIdx = new TaskIdx();
                taskIdx.By = by;
                taskIdx.Key = taskIdxKey;
                taskIdx.Name = name;
                taskIdx.Indexes = indexes;
                taskIdx.TasklistId = tasklistId;
                if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                {
                    string username = (string)IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY];
                    taskIdx.AccountId = username;
                }
                else
                {
                    taskIdx.AccountId = "";
                }
                taskIdxs.Add(taskIdx);
            }
            this._taskIdxRepository.AddTaskIdxs(taskIdxs);

            resultCode.Status = true;

            this.DispatchCommandResult(resultCode);
        }
        private void SyncTasksAfterResponse(string tasklistId, ResultCode resultCode, RestResponse response)
        {
            string result = response.Content;
            JArray array = (JArray)result.ToJSONObject();
            //List<object> array = (List<object>)result.ToJSONObject();
            if (array.Count > 0)
            {
                for (int i = 0; i < array.Count; i++)
                {
                    JToken dict = array[i];
                    string oldId = dict["OldId"].Value<string>();
                    string newId = dict["NewId"].Value<string>();

                    this._console.log(string.Format("任务旧值ID:{0} 变为新值ID:{1}", oldId, newId));

                    this._taskRepository.UpdateTaskIdByNewId(oldId, newId, tasklistId);
                    this._taskIdxRepository.UpdateTaskIdxByNewId(oldId, newId, tasklistId);
                }
            }

            this._changeLogRepository.UpdateAllToSend(tasklistId);

            this._taskService.GetTasks(tasklistId
                , response1 =>
                    {
                        if (response1.StatusCode == HttpStatusCode.OK)
                        {
                            this.GetTasksAfterResponse(tasklistId, resultCode, response1);
                        }
                        else
                        {
                            this.DispatchCommandResult(response1);
                        }
                    }
                , exception =>
                    {
                        this.DispatchCommandResult(exception);
                    });
        }
    }
}
