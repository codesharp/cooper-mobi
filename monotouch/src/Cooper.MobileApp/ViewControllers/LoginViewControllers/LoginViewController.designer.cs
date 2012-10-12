// WARNING
//
// This file has been generated automatically by MonoDevelop to store outlets and
// actions made in the Xcode designer. If it is removed, they will be lost.
// Manual changes to this file may not be handled correctly.
//
using MonoTouch.Foundation;

namespace Cooper.MobileApp
{
	[Register ("LoginViewController")]
	partial class LoginViewController
	{
		[Outlet]
		MonoTouch.UIKit.UILabel label1 { get; set; }

		[Outlet]
		MonoTouch.UIKit.UILabel label2 { get; set; }

		[Outlet]
		MonoTouch.UIKit.UILabel label3 { get; set; }

		[Outlet]
		MonoTouch.UIKit.UILabel label4 { get; set; }
		
		void ReleaseDesignerOutlets ()
		{
			if (label1 != null) {
				label1.Dispose ();
				label1 = null;
			}

			if (label2 != null) {
				label2.Dispose ();
				label2 = null;
			}

			if (label3 != null) {
				label3.Dispose ();
				label3 = null;
			}

			if (label4 != null) {
				label4.Dispose ();
				label4 = null;
			}
		}
	}
}
