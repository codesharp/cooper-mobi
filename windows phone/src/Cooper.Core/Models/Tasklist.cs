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
using System.Data.Linq.Mapping;

namespace Cooper.Core.Models
{
    /// <summary>
    /// 任务列表
    /// </summary>
    [Table]
    public class Tasklist
    {
        public Tasklist()
        {
            this.CreateTime = DateTime.Now;
        }

        [Column(IsPrimaryKey = true
            , IsDbGenerated = true
            , DbType = "BIGINT NOT NULL Identity"
            , CanBeNull = false
            , AutoSync = AutoSync.OnInsert)]
        public long Id { get; set; }

        [Column]
        public string AccountId { get; set; }

        [Column]
        public DateTime CreateTime { get; set; }

        [Column]
        public bool Editable { get; set; }

        [Column]
        public string Extensions { get; set; }

        [Column]
        public string TasklistId { get; set; }

        [Column]
        public string ListType { get; set; }

        [Column]
        public string Name { get; set; }
    }
}
