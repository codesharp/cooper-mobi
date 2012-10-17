
using System;
using System.Drawing;

using MonoTouch.Foundation;
using MonoTouch.UIKit;
using Cooper.Core;

namespace Cooper.MobileApp
{
	public partial class LoginViewController : BaseViewController
	{
		private UITableView loginTableView { get; set; }

		public LoginViewController ()
			: base (UserInterfaceIdiomIsPhone ? "LoginViewController_iPhone" : "LoginViewController_iPad", null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			this.label1.Frame = new RectangleF(20, 240, 100, 30);
			this.label1.BackgroundColor = UIColor.Clear;
			this.label1.TextColor = UIColor.Gray;
			this.View.AddSubview(this.label1);

			this.label2.Frame = new RectangleF(20, 260, 50, 30);
			this.label2.BackgroundColor = UIColor.Clear;
			this.label2.TextColor = UIColor.Gray;
			this.View.AddSubview(this.label2);

			this.label3.Frame = new RectangleF(60, 260, 100, 30);
			this.label3.BackgroundColor = UIColor.Clear;
			this.label3.TextColor = Tools.APP_BACKGROUNDCOLOR;
			this.View.AddSubview(this.label3);

			this.label4.Frame = new RectangleF(160, 260, 100, 30);
			this.label4.BackgroundColor = UIColor.Clear;
			this.label4.TextColor = UIColor.Gray;
			this.View.AddSubview(this.label4);

			this.loginTableView = new UITableView(new RectangleF(0, 90, 320, 120), UITableViewStyle.Grouped);
			this.loginTableView.BackgroundColor = Tools.APP_BACKGROUNDCOLOR;
			this.loginTableView.AllowsSelection = false;
			this.loginTableView.Delegate = null;
			this.loginTableView.DataSource = null;
			this.loginTableView.ScrollEnabled = false;
			this.View.AddSubview(this.loginTableView);
		}
		
		public override void ViewDidUnload ()
		{
			base.ViewDidUnload ();
			
			// Clear any references to subviews of the main view in order to
			// allow the Garbage Collector to collect them sooner.
			//
			// e.g. myOutlet.Dispose (); myOutlet = null;
			
			ReleaseDesignerOutlets ();
		}

		public override void ViewWillAppear (bool animated)
		{
			this.NavigationController.NavigationBar.Hidden = true;
		}

		public override void ViewWillDisappear (bool animated)
		{
			this.NavigationController.NavigationBar.Hidden = false;
		}

		#region Delegate And DataSource

		class TableDelegate : UITableViewDelegate
		{
			LoginViewController _controller;

			public TableDelegate(LoginViewController controller)
			{
				this._controller = controller;
			}
		}

		class TableDataSource : UITableViewDataSource
		{
			LoginViewController _controller;

			public TableDataSource(LoginViewController controller)
			{
				this._controller = controller;
			}
		}

		class TableSource : UITableViewSource
		{
		}

		#endregion
	}
}

