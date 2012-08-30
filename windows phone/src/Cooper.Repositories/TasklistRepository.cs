using System;
using System.Collections.Generic;
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
using System.IO.IsolatedStorage;

namespace Cooper.Repositories
{
    public class TasklistRepository
    {
        private CooperContext _context;

        public TasklistRepository()
        {
            this._context = new CooperContext();
        }

        public List<Tasklist> GetAllTasklistByUserAndTemp()
        {
            List<Tasklist> tasklists = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasklists = this._context.Tasklists.Where(o => o.TasklistId.IndexOf("temp_") >= 0
                    && o.AccountId.Equals(username))
                    .OrderBy(o => o.TasklistId)
                    .ToList();
            }
            else
            {
                tasklists = this._context.Tasklists.Where(o => o.TasklistId.IndexOf("temp_") >= 0
                    && string.IsNullOrEmpty(o.AccountId))
                    .OrderBy(o => o.TasklistId)
                    .ToList();
            }
            return tasklists;
        }

        public List<Tasklist> GetAllTasklistByTemp()
        {
            List<Tasklist> tasklists = this._context.Tasklists
                .Where(o => o.TasklistId.IndexOf("temp_") >= 0
                    && o.AccountId.Equals(""))
                    .ToList();
            return tasklists;
        }

        public List<Tasklist> GetAllTasklist()
        {
            List<Tasklist> tasklists = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals(username))
                    .OrderBy(o => o.TasklistId)
                    .ToList();
            }
            else
            {
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals(""))
                    .OrderBy(o => o.TasklistId)
                    .ToList();
            }
            return tasklists;
        }

        public Tasklist GetTasklistById(string tasklistId)
        {
            Tasklist tasklist = null;
            List<Tasklist> tasklists = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals(username)
                    && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            else
            {
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals("")
                   && o.TasklistId.Equals(tasklistId))
                   .ToList();
            }
            if (tasklists != null && tasklists.Count > 0)
            {
                tasklist = tasklists[0];
            }
            return tasklist;
        }

        public void UpdateTasklistByNewId(string oldId, string newId)
        {
            Tasklist tasklist = this.GetTasklistById(oldId);
            if (tasklist != null)
            {
                tasklist.TasklistId = newId;
            }
            this._context.SubmitChanges();
        }

        public void DeleteAll()
        {
            List<Tasklist> tasklists = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals(username)).ToList();
            }
            else
            {
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals("")).ToList();
            }
            if (tasklists != null && tasklists.Count > 0)
            {
                this._context.Tasklists.DeleteAllOnSubmit<Tasklist>(tasklists);
                this._context.SubmitChanges();
            }   
        }

        public void AddTasklist(Tasklist tasklist)
        {
            this._context.Tasklists.InsertOnSubmit(tasklist);
            this._context.SubmitChanges();
        }

        public void AddTasklists(List<Tasklist> tasklists)
        {
            this._context.Tasklists.InsertAllOnSubmit<Tasklist>(tasklists);
            this._context.SubmitChanges();
        }

        public void UpdateEditable(int editable, string tasklistId)
        {
            Tasklist tasklist = this.GetTasklistById(tasklistId);
            if (tasklist != null)
            {
                tasklist.Editable = editable == 1;
            }
            this._context.SubmitChanges();
        }

        public void UpdateTasklists(List<Tasklist> tasklists)
        {
            this._context.SubmitChanges();
        }

        public void AdjustWithNewId(string oldId, string newId)
        {
            Tasklist tasklist = null;
            List<Tasklist> tasklists = this._context.Tasklists.Where(o => o.TasklistId.Equals(oldId)).ToList();
            if (tasklists.Count > 0)
            {
                tasklist = tasklists[0];
                tasklist.TasklistId = newId;
            }
            this._context.SubmitChanges();
        }
    }
}
