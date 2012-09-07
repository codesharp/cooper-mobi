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
    /// 任务
    /// </summary>
    [Table]
    public class Task
    {
        public Task()
        {
            this.CreateDate = DateTime.Now;
            this.LastUpdateDate = DateTime.Now;
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
        public string Body { get; set; }

        [Column]
        public DateTime CreateDate { get; set; }

        [Column(CanBeNull = true)]
        public DateTime? DueDate { get; set; }

        [Column]
        public string TaskId { get; set; }

        [Column]
        public bool IsPublic { get; set; }

        [Column]
        public DateTime LastUpdateDate { get; set; }

        [Column]
        public string Priority { get; set; }

        [Column]
        public int Status { get; set; }

        [Column]
        public bool Editable { get; set; }

        [Column]
        public string Subject { get; set; }

        [Column]
        public string TasklistId { get; set; }
    }
}
