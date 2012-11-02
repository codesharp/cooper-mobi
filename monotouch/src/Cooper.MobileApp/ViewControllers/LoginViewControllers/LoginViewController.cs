
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
		private DomainLabel labelDomain { get; set; }
		private UITextField textUsername { get; set; }
		private UITextField textPassword { get; set; }
		private UIImageView imgLogo { get; set; }
		private CustomButton btnLogin { get; set; }
		private UIButton btnSkip { get; set; }

		public LoginViewController ()
			: base (UserInterfaceIdiomIsPhone ? "LoginViewController_iPhone" : "LoginViewController_iPad", null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			string login_btn_text = "登录";
			string skip_btn_text = "跳过";
			string googlelogin_btn_text = "使用谷歌账号登录";

			this.imgLogo = new UIImageView(new RectangleF(75, 30, 179, 50));
			this.imgLogo.Image = UIImage.FromFile("images/logo.png");
			this.View.AddSubview(this.imgLogo);

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
			this.loginTableView.BackgroundColor = UIColor.FromPatternImage(UIImage.FromFile("images/bg-line.png"));
			this.loginTableView.AllowsSelection = false;
			this.loginTableView.Source = new DataSource(this);
			this.loginTableView.ScrollEnabled = false;
			this.View.AddSubview(this.loginTableView);

			this.btnLogin = new CustomButton(new RectangleF(320 - 150 - 320 / 16.0f, 250 +  50, 70, 40), UIImage.FromFile("images/btn_center.png"));
			this.btnLogin.Layer.CornerRadius = 10.0f;
			this.btnLogin.Layer.MasksToBounds = true;
			this.btnLogin.TouchUpInside += (sender, e) => {
				this.Login();
			};
			this.btnLogin.SetTitle(login_btn_text, UIControlState.Normal);
			this.btnLogin.TitleLabel.Font = UIFont.BoldSystemFontOfSize(20.0f);
			this.View.AddSubview(this.btnLogin);

			this.btnSkip = UIButton.FromType(UIButtonType.RoundedRect);
			this.btnSkip.Frame = new RectangleF(320 - 70 - 320 / 16.0f, 250 + 50, 70, 40);
			this.btnSkip.Layer.CornerRadius = 6.0f;
			this.btnSkip.Layer.MasksToBounds = true;
			this.btnSkip.TouchUpInside += (sender, e) => {
				//UNDONE:
			};
			this.btnSkip.SetTitle(skip_btn_text, UIControlState.Normal);
			this.btnSkip.TitleLabel.Font = UIFont.BoldSystemFontOfSize(20.0f);
			this.View.AddSubview(this.btnSkip);
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

		#region private methods

		private void Login ()
		{
			Console.WriteLine ("start login");
			if (this.labelDomain.Text.Length > 0
				&& this.textUsername.Text.Length > 0
				&& this.textPassword.Text.Length > 0) {
				
			} else {
				Tools.Alert("请输入用户名和密码");
			}
		}
		private UITableViewCell CreateDomainCell (string identifier)
		{
			UITableViewCell cell = new UITableViewCell(UITableViewCellStyle.Value1, identifier);

			float width = UserInterfaceIdiomIsPhone ? 285 : 660;
			this.labelDomain = new DomainLabel(new RectangleF(0, 0, 210, 30));
			this.labelDomain.Text = "TAOBAO-HZ";
			this.labelDomain.BackgroundColor = UIColor.Clear;
			this.labelDomain.UserInteractionEnabled = true;
			this.labelDomain.GetDomainTextHandler += HandleGetDomainTextHandler;
			UITapGestureRecognizer recognizer = new UITapGestureRecognizer(action => {
				this.labelDomain.BecomeFirstResponder();
			});
			this.labelDomain.AddGestureRecognizer(recognizer);
			cell.TextLabel.Text = "域名";
			cell.AccessoryView = this.labelDomain;

			return cell;
		}
		private UITableViewCell CreateUsernameCell (string identifier)
		{
			UITableViewCell cell = new UITableViewCell(UITableViewCellStyle.Default, identifier);
			
			float width = UserInterfaceIdiomIsPhone ? 285 : 660;
			this.textUsername = new UITextField(new RectangleF(0, 0, width, 20));
			this.textUsername.Placeholder = "用户名";
			this.textUsername.AutocapitalizationType = UITextAutocapitalizationType.None;
			this.textUsername.ReturnKeyType = UIReturnKeyType.Done;
			this.textUsername.EditingDidEndOnExit += (sender, e) => 
			{ 
				
			};
			cell.AccessoryView = this.textUsername;
			
			return cell;
		}
		private UITableViewCell CreatePasswordCell (string identifier)
		{
			UITableViewCell cell = new UITableViewCell(UITableViewCellStyle.Default, identifier);
			
			float width = UserInterfaceIdiomIsPhone ? 285 : 660;
			this.textPassword = new UITextField(new RectangleF(0, 0, width, 20));
			this.textPassword.SecureTextEntry = true;
			this.textPassword.Placeholder = "密码";
			this.textPassword.AutocapitalizationType = UITextAutocapitalizationType.None;
			this.textPassword.ReturnKeyType = UIReturnKeyType.Done;
			this.textPassword.EditingDidEndOnExit += (sender, e) => 
			{ 
				
			};
			cell.AccessoryView = this.textPassword;
			
			return cell;
		}
		private void HandleGetDomainTextHandler (DomainLabel label, string value)
		{
			label.Text = value;
		}

		#endregion

		#region Source

		class DataSource : UITableViewSource
		{
			LoginViewController _controller;

			public DataSource(LoginViewController controller)
			{
				this._controller = controller;
			}

			public override int NumberOfSections (UITableView tableView)
			{
				return 1;
			}
			public override int RowsInSection (UITableView tableview, int section)
			{
				//TODO:if ali-version is 3.
				return 3;
			}
			public override float GetHeightForRow (UITableView tableView, NSIndexPath indexPath)
			{
				return 35.0f;
			}
			public override UITableViewCell GetCell (UITableView tableView, NSIndexPath indexPath)
			{
				UITableViewCell cell = null;
				string identifier = "BaseCell";
				if (indexPath.Row == 0) {
					identifier = "DomainCell";
					cell = tableView.DequeueReusableCell (identifier);
					if (cell == null) {
						cell = this._controller.CreateDomainCell (identifier);
					}
				} else if (indexPath.Row == 1) {
					identifier = "UsernameCell";
					cell = tableView.DequeueReusableCell (identifier);
					if (cell == null) {
						cell = this._controller.CreateUsernameCell (identifier);
					}
				} else if (indexPath.Row == 2) {
					identifier = "PasswordCell";
					cell = tableView.DequeueReusableCell (identifier);
					if (cell == null) {
						cell = this._controller.CreatePasswordCell (identifier);
					}
				}
				return cell;
			}
		}

		#endregion
	}
}

