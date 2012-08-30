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
using Cooper.Core;
using Hammock;
using System.Collections.Generic;
using Cooper.Core.Models;
using Cooper.Repositories;
using Newtonsoft.Json.Linq;

namespace Cooper.Services
{
    public class TaskService : WebRequestWrapper
    {
        private ChangeLogRepository _changeLogRepository;
        private TaskIdxRepository _taskIdxRepository;

        public TaskService()
        {
            this._changeLogRepository = new ChangeLogRepository();
            this._taskIdxRepository = new TaskIdxRepository();
        }

        public void GetTasks(string tasklistId
            , Action<RestResponse> successCallback
            , Action<Exception> failCallback)
        {
            Dictionary<string, string> dict = new Dictionary<string, string>();
            dict.Add("tasklistId", tasklistId);
            this.UploadString(Constant.TASK_GETBYPRIORITY_URL, dict, successCallback, failCallback);
        }

        public void SyncTasks(string tasklistId
            , Action<RestResponse> successCallback
            , Action<Exception> failCallback)
        {
            List<ChangeLog> changeLogs = this._changeLogRepository.GetAllChangeLog(tasklistId);
            List<Dictionary<string, string>> changeLogsArray = new List<Dictionary<string, string>>();
            foreach (var changeLog in changeLogs)
            {
                Dictionary<string, string> dict = new Dictionary<string, string>();
                dict.Add("Type", changeLog.ChangeType);
                dict.Add("ID", changeLog.DataId);
                dict.Add("Name", changeLog.Name);
                dict.Add("Value", changeLog.Value);

                changeLogsArray.Add(dict);
            }

            List<TaskIdx> taskIdxs = this._taskIdxRepository.GetAllTaskIdx(tasklistId);
            List<Dictionary<string, string>> taskIdxsArray = new List<Dictionary<string, string>>();
            foreach(var taskIdx in taskIdxs)
            {
                Dictionary<string, string> dict = new Dictionary<string,string>();
                dict.Add("By", taskIdx.By);
                dict.Add("Key", taskIdx.Key);
                dict.Add("Name", taskIdx.Name);

                JArray indexesArray = null;
                if(string.IsNullOrEmpty(taskIdx.Indexes))
                {
                    indexesArray = new JArray();
                }
                else
                {
                    indexesArray = (JArray)taskIdx.Indexes.ToJSONObject();
                }
                dict.Add("Indexs", indexesArray.ToJSONString());

                taskIdxsArray.Add(dict);
            }

            string changeLogsJson = changeLogsArray.ToJSONString();
            //TODO:暂不处理排序功能
            string taskIdxsJson = "[]";

            Console.WriteLine("changeLogsJson: " + changeLogsJson);
            Console.WriteLine("taskIdxsJson: " + taskIdxsJson);

            Dictionary<string, string> postDict = new Dictionary<string,string>();
            postDict.Add("tasklistId", tasklistId);
            postDict.Add("changes", changeLogsJson);
            postDict.Add("by", "ByPriority");
            postDict.Add("sorts", taskIdxsJson);

            this.UploadString(Constant.TASK_SYNC_URL, postDict, successCallback, failCallback);
        }
    }
}
