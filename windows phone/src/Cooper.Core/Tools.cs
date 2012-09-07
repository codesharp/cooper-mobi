using System;
using System.Linq;
using System.Net;
using Microsoft.Phone.Controls;

using System.Windows.Navigation;
using Microsoft.Phone.Net.NetworkInformation;
using System.Threading;
using System.Windows;

namespace Cooper.Core
{
    /// <summary>
    /// 辅助工具类
    /// </summary>
    public static class Tools
    {
        /// <summary>
        /// 是否连接网络
        /// </summary>
        /// <returns></returns>
        public static bool IsOnline()
        {
            var interfaceList = new NetworkInterfaceList();
            var interfaceInfo = interfaceList.First();

            bool connected = interfaceInfo.InterfaceState == ConnectState.Connected;
            return connected;
        }
        /// <summary>
        /// 转换为Json字符串
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static string ToJSONString(this object obj)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(obj);
        }

        public static object ToJSONObject(this string value)
        {
            return Newtonsoft.Json.JsonConvert.DeserializeObject(value);
        }

        public static DateTime ToDefault(this DateTime value)
        {
            return DateTime.Parse("1970-01-01");
        }
    }
}
