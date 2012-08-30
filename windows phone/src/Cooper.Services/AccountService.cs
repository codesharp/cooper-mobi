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
using System.IO;
using System.Collections.Generic;
using MyToolkit.Networking;
using System.Text;
using Hammock;

namespace Cooper.Services
{
    public class AccountService : WebRequestWrapper
    {
        /// <summary>
        /// Ark登录
        /// </summary>
        /// <param name="domain">域</param>
        /// <param name="username">用户名</param>
        /// <param name="password">密码</param>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void Login(string domain
            , string username
            , string password
            , Action<RestResponse> successCallback
            , Action<Exception> failCallback)
        {
            //WebRequestWrapper.cookieContainer = null;

            var dict = new Dictionary<string, string>();
            dict.Add("cbDomain", domain);
            dict.Add("tbLoginName", username);
            dict.Add("tbPassword", password);
            dict.Add("state", "login");

            //string loginServiceAddress = Constant.LOGIN_URL;

            //var text = string.Format("{{ \"cbDomain\": \"{0}\", \"tbLoginName\": \"{1}\", \"tbPassword\": \"{2}\", \"state\": \"login\"}}",
            //    domain, username, password);

            //var request = new HttpPostRequest(loginServiceAddress);

            //request.RawData = Encoding.UTF8.GetBytes(text);
            //request.ContentType = "application/json";
            //Http.Post(request, AuthenticationCompleted);

            this.UploadString(Constant.LOGIN_URL, dict, successCallback, failCallback);

            #region 过时
            //var request = HttpWebRequest.CreateHttp(Constant.LOGIN_URL);
            //request.Method = "POST";
            //string resultString = string.Empty;
            //request.BeginGetResponse((IAsyncResult result) =>
            //{
            //    var webRequest = result.AsyncState as HttpWebRequest;
            //    var webResponse = (HttpWebResponse)webRequest.EndGetResponse(result);
            //    using (Stream streamResult = webResponse.GetResponseStream())
            //    {
            //        using (StreamReader reader = new StreamReader(streamResult))
            //        {
            //            //获取的返回值
            //            resultString = reader.ReadToEnd();
            //        }
            //    }
            //}, request);
            //return resultString;
            #endregion
        }
        /// <summary>
        /// 普通登录
        /// </summary>
        /// <param name="username">用户名</param>
        /// <param name="password">密码</param>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void Login(string username
            , string password
            , Action<RestResponse> successCallback
            , Action<Exception> failCallback)
        {
            //WebRequestWrapper.cookieContainer = null;

            var dict = new Dictionary<string, string>();
            dict.Add("userName", username);
            dict.Add("password", password);

            //string loginServiceAddress =Constant.LOGIN_URL;

            //var text = string.Format("{{ \"userName\": \"{0}\", \"password\": \"{1}\"}}",
            //    username, password);

            //var request = new HttpPostRequest(loginServiceAddress);
            
            //request.RawData = Encoding.UTF8.GetBytes(text);
            //request.ContentType = "application/json";
            //Http.Post(request, AuthenticationCompleted);

            this.UploadString(Constant.LOGIN_URL, dict, successCallback, failCallback);
        }
        /// <summary>
        /// 用户注销
        /// </summary>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void Logout(Action<RestResponse> successCallback
            , Action<Exception> failCallback)
        {
            this.UploadString(Constant.LOGOUT_URL, new Dictionary<string, string>(), successCallback, failCallback);
        }

        private void AuthenticationCompleted(HttpResponse authResponse)
        {
            string serviceAddress = Constant.GETTASKLISTS_URL;
            if (authResponse.Successful)
            {
                var sessionCookies = authResponse.Cookies;
                //var request = new HttpGetRequest(serviceAddress);
                //request.Cookies.Add(new Cookie("SessionId", sessionCookie.Value));
                //Http.Get(request, OperationCallCompleted);
            }
        }
    }
}
