using System;
using MonoTouch.UIKit;
using System.Collections.Generic;
using MonoTouch.Foundation;
using System.Drawing;

namespace Cooper.MobileApp
{
	public delegate void GetDomainTextHandler(DomainLabel label, string value);

	public class DomainLabel : UILabel
	{
		public event GetDomainTextHandler GetDomainTextHandler;

		protected static bool UserInterfaceIdiomIsPhone
		{
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		UIPopoverController popoverController;
		UIToolbar inputAccessoryView;

	    UIPickerView picker { get; set; }
	    List<string> values { get; set; }


		public DomainLabel(RectangleF frame)
			: base(frame)
		{
			this.values = new List<string>();
			this.values.AddRange(new string[] { "TAOBAO-HZ", "ALIPAY", "HZ", "SP" });

			this.InitalizeInputView();
		}

		public override UIView InputAccessoryView
		{
			get
			{
				if (!UserInterfaceIdiomIsPhone)
				{ 
					return null;
				}
				if (this.inputAccessoryView == null)
				{
					this.inputAccessoryView = new UIToolbar();
					this.inputAccessoryView.BarStyle = UIBarStyle.BlackTranslucent;
					this.inputAccessoryView.AutoresizingMask = UIViewAutoresizing.FlexibleHeight;
					this.inputAccessoryView.SizeToFit();
					RectangleF frame = this.inputAccessoryView.Frame;
					frame.Size.Height = 44.0f;
					this.inputAccessoryView.Frame = frame;

					UIBarButtonItem doneBtn = new UIBarButtonItem(UIBarButtonSystemItem.Done, delegate {

						this.ResignFirstResponder();
					}); 
					UIBarButtonItem flexibleSpaceLeft = new UIBarButtonItem(UIBarButtonSystemItem.FlexibleSpace, null, null);
					UIBarButtonItem[] array = new UIBarButtonItem[] { flexibleSpaceLeft, doneBtn };
					this.inputAccessoryView.SetItems (array, false);
				}
				return this.inputAccessoryView;
			}
		}
		public override bool BecomeFirstResponder ()
		{
			NSNotificationCenter.DefaultCenter.AddObserver((NSString)"UIDeviceOrientationDidChangeNotification", notification => {
				
			});
			return base.BecomeFirstResponder ();
		}
		public override bool ResignFirstResponder ()
		{
			NSNotificationCenter.DefaultCenter.RemoveObserver(this, (NSString)"UIDeviceOrientationDidChangeNotification", null);
			return base.ResignFirstResponder ();
		}
		public override UIView InputView {
			get {
				if(!UserInterfaceIdiomIsPhone)
				{
					return null;
				}
				else
				{
					return this.picker;
				}
			}
		}
		public override bool CanBecomeFirstResponder 
		{
			get
			{
				return true;
			}
		}

		private void InitalizeInputView ()
		{
			this.picker = new UIPickerView ();
			this.picker.ShowSelectionIndicator = true;
			this.picker.AutoresizingMask = UIViewAutoresizing.FlexibleHeight;
			this.picker.Delegate = new PickerViewDelegate(this);
			this.picker.DataSource = new PickerViewDataSource(this);
			if (!UserInterfaceIdiomIsPhone) {
			} else {
				this.picker.SetNeedsDisplay();
			}
		}

		class PickerViewDataSource : MonoTouch.UIKit.UIPickerViewDataSource
		{
			private DomainLabel _domainLabel;

			public PickerViewDataSource(DomainLabel domainLabel)
			{
				this._domainLabel = domainLabel;
			}

			public override int GetComponentCount (UIPickerView pickerView)
			{
				return 1;
			}
			public override int GetRowsInComponent (UIPickerView pickerView, int component)
			{
				return this._domainLabel.values.Count;
			}
		}
		class PickerViewDelegate : MonoTouch.UIKit.UIPickerViewDelegate
		{
			private DomainLabel _domainLabel;

			public PickerViewDelegate(DomainLabel domainLabel)
			{
				this._domainLabel = domainLabel;
			}

			public override string GetTitle (UIPickerView pickerView, int row, int component)
			{
				return this._domainLabel.values[row];
			}
			public override float GetComponentWidth (UIPickerView pickerView, int component)
			{
				return 300.0f;
			}

			public override void Selected (UIPickerView pickerView, int row, int component)
			{
				string value = this._domainLabel.values [row];

				if (this._domainLabel.GetDomainTextHandler != null) {
					this._domainLabel.GetDomainTextHandler(this._domainLabel, value);
				}
			}
		}
	}
}

