using System;

using MonoTouch.UIKit;
using MonoTouch.Foundation;

namespace Cooper.Core
{
	/// <summary>
	/// 辅助工具
	/// </summary>
	public static class Tools
	{
		/// <summary>
		/// 应用程序默认背景颜色
		/// </summary>
		public static readonly UIColor APP_BACKGROUNDCOLOR = UIColor.FromRGBA(47, 157, 216, 255);

		public static void Alert(string title)
		{
			UIAlertView alertView = new UIAlertView(title, null, null, "确定", null);
			alertView.Show();
		}
	}
}

 