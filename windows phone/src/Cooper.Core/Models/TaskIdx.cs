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
    /// 任务排序
    /// </summary>
    [Table]
    public class TaskIdx
    {
        [Column(IsPrimaryKey = true
            , IsDbGenerated = true
            , DbType = "BIGINT NOT NULL Identity"
            , CanBeNull = false
            , AutoSync = AutoSync.OnInsert)]
        public long Id { get; set; }

        [Column]
        public string AccountId { get; set; }

        [Column]
        public string By { get; set; }

        [Column]
        public string Indexes { get; set; }

        [Column]
        public string Key { get; set; }

        [Column]
        public string Name { get; set; }

        [Column]
        public string TasklistId { get; set; }
    }
}
