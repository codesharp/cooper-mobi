using System;
using MonoTouch.UIKit;
using System.Drawing;

namespace Cooper.MobileApp
{
	public class CustomButton : UIButton
	{
		public CustomButton (RectangleF frame, UIImage image)
			: base(frame)
		{
			this.Layer.CornerRadius = 14.0f;
			this.Layer.MasksToBounds = true;
			this.TitleLabel.Font = UIFont.BoldSystemFontOfSize(14.0f);
			this.SetBackgroundImage(image, UIControlState.Normal);
		}
		public CustomButton (RectangleF frame, UIColor color)
			: base(frame)
		{
			this.Layer.CornerRadius = 14.0f;
			this.Layer.MasksToBounds = true;
			this.TitleLabel.Font = UIFont.BoldSystemFontOfSize(14.0f);
			this.BackgroundColor = color;
		}
	}
}

