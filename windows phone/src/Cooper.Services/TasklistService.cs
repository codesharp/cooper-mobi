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
using System.Collections.Generic;
using Hammock;

namespace Cooper.Services
{
    public class TasklistService : WebRequestWrapper
    {
        /// <summary>
        /// 获取任务列表
        /// </summary>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void GetTasklists(Action<RestResponse, object> successCallback
            , Action<Exception> failCallback
            , object userState)
        {
             this.UploadString(Constant.GETTASKLISTS_URL
                 , new Dictionary<string, string>()
                 , successCallback
                 , failCallback
                 , userState);
        }
        /// <summary>
        /// 同步任务列表
        /// </summary>
        /// <param name="name"></param>
        /// <param name="type"></param>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void SyncTasklist(string name, string type
            , Action<RestResponse, object> successCallback
            , Action<Exception> failCallback
            , object userState)
        {
            Dictionary<string, string> dict = new Dictionary<string, string>();
            dict.Add("name", name);
            dict.Add("type", type);
            this.UploadString(Constant.TASKLIST_SYNC_URL, dict, successCallback, failCallback, userState);
        }
    }
}
