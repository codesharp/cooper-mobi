using System;

using MonoTouch.Foundation;
using MonoTouch.UIKit;

namespace Cooper.MobileApp
{
	public class MainViewController : BaseViewController
	{
		private UINavigationController _loginUINavigationController;

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			if (this._loginUINavigationController == null) {
				this._loginUINavigationController = new UINavigationController(new LoginViewController());
			}
			this.NavigationController.PresentModalViewController(this._loginUINavigationController, false);
		}
	}
}

