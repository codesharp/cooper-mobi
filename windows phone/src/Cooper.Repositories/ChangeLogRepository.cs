using System;
using System.Collections.Generic;
using System.IO.IsolatedStorage;
using System.Linq;
using System.Linq;
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
using Cooper.Core.Models;

namespace Cooper.Repositories
{
    public class ChangeLogRepository
    {
        private CooperContext _context;

        public ChangeLogRepository()
        {
            this._context = new CooperContext();
        }

        public List<ChangeLog> GetAllChangeLogByTemp()
        {
            List<ChangeLog> changeLogs = this._context.ChangeLogs
                .Where(o => o.AccountId.Equals(""))
                .ToList();
            return changeLogs;
        }

        public List<ChangeLog> GetAllChangeLog(string tasklistId)
        {
            List<ChangeLog> changeLogs = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                changeLogs = this._context.ChangeLogs
                    .Where(o => o.AccountId.Equals(username)
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            else
            {
                changeLogs = this._context.ChangeLogs
                    .Where(o => o.AccountId.Equals("")
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            return changeLogs;
        }

        public void UpdateTasklistIdByNewId(string oldId, string newId)
        {
            List<ChangeLog> changeLogs = this.GetAllChangeLog(oldId);
            foreach (var changeLog in changeLogs)
            {
                changeLog.TasklistId = newId;
            }
            if (changeLogs.Count > 0)
            {
                this._context.SubmitChanges();
            }
        }

        public void UpdateAllToSend(string tasklistId)
        {
            List<ChangeLog> changeLogs = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                changeLogs = this._context.ChangeLogs
                    .Where(o => o.AccountId.Equals(username)
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            else
            {
                changeLogs = this._context.ChangeLogs
                    .Where(o => o.AccountId.Equals("")
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            if (changeLogs.Count > 0)
            {
                this._context.ChangeLogs.DeleteAllOnSubmit<ChangeLog>(changeLogs);
                this._context.SubmitChanges();
            }
        }

        public void AddChangeLog(string type, string taskId, string name, string value, string tasklistId)
        {
            ChangeLog changeLog = new ChangeLog();
            changeLog.ChangeType = type;
            changeLog.DataId = taskId;
            changeLog.Name = name;
            changeLog.Value = value;
            changeLog.IsSend = false;
            changeLog.TasklistId = tasklistId;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                changeLog.AccountId = username;
            }
            else
            {
                changeLog.AccountId = "";
            }
            this._context.ChangeLogs.InsertOnSubmit(changeLog);
            this._context.SubmitChanges();
        }

        public void UpdateChangeLogs(List<ChangeLog> changeLogs)
        {
            this._context.SubmitChanges();
        }
    }
}
