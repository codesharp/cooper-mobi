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
using System.Data.Linq;
using Cooper.Core.Models;

namespace Cooper.Core
{
    public class CooperContext : DataContext
    {
        public CooperContext()
            : base(Constant.DB_CONNSTRING)
        { }

        public Table<Tasklist> Tasklists;
        public Table<Task> Tasks;
        public Table<TaskIdx> TaskIdxs;
        public Table<ChangeLog> ChangeLogs;
    }
}
