using System;
using System.Collections.Generic;
using System.IO.IsolatedStorage;
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
    public class TaskRepository
    {
        private CooperContext _context;

        public TaskRepository()
        {
            this._context = new CooperContext();
        }

        public List<Task> GetAllTaskByTemp()
        {
            List<Task> tasks = this._context.Tasks
                .Where(o => o.AccountId.Equals(""))
                .ToList();
            return tasks;
        }

        public List<Task> GetAllTask(string tasklistId)
        {
            List<Task> tasks = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasks = this._context.Tasks.Where(o => o.AccountId.Equals(username)
                    && o.TasklistId.Equals(tasklistId))
                    .OrderBy(o => o.TaskId)
                    .ToList();
            }
            else
            {
                tasks = this._context.Tasks.Where(o => o.AccountId.Equals("")
                    && o.TasklistId.Equals(tasklistId))
                    .OrderBy(o => o.TaskId)
                    .ToList();
            }
            return tasks;
        }

        public Task GetTaskById(string taskId)
        {
            List<Task> tasks = this._context.Tasks.Where(o => o.TaskId.Equals(taskId)).ToList();
            Task task = null;
            if (tasks.Count > 0)
            {
                task = tasks[0];
            }
            return task;
        }

        public void UpdateTasklistIdByNewId(string oldId, string newId)
        {
            List<Task> tasks = this.GetAllTask(oldId);
            foreach (var task in tasks)
            {
                task.TasklistId = newId;
            }
            if (tasks.Count > 0)
            {
                this._context.SubmitChanges();
            }
        }

        public void UpdateTaskIdByNewId(string oldId, string newId, string tasklistId)
        {
            Task task = this.GetTaskById(oldId);
            if (task != null)
            {
                task.TaskId = newId;
            }
            this._context.SubmitChanges();
        }

        public void DeleteAll(string tasklistId)
        {
            List<Task> tasks = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasks = this._context.Tasks.Where(o => o.AccountId.Equals(username)
                    && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            else
            {
                tasks = this._context.Tasks.Where(o => o.AccountId.Equals("")
                    && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            if (tasks.Count > 0)
            {
                this._context.Tasks.DeleteAllOnSubmit<Task>(tasks);
                this._context.SubmitChanges();
            }
        }

        public void AddTasks(List<Task> tasks)
        {
            this._context.Tasks.InsertAllOnSubmit<Task>(tasks);
            this._context.SubmitChanges();
        }

        public void AddTask(Task task)
        {
            this._context.Tasks.InsertOnSubmit(task);
            this._context.SubmitChanges();
        }

        public void UpdateTask(Task task)
        {
            this._context.SubmitChanges();
        }

        public void UpdateTasks(List<Task> tasks)
        {
            this._context.SubmitChanges();
        }

        public void DeleteTask(Task task)
        {
            this._context.Tasks.DeleteOnSubmit(task);
            this._context.SubmitChanges();
        }
    }
}
