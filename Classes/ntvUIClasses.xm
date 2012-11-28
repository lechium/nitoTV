//
//%hook BRPosterControl
//
//-(CGPoint)position
//{
//
//	%log;
//	CGPoint point = %orig;
//	if (point.x > 1280)
//	{
//	
//		point.x = 858;
//	
//	}
//	
//	if (point.x < 0)
//	{
//		point.x = 858;
//	}
//	
//	return point;
//
//}
//
//-(CGRect)frame
//{
//
//	%log;
//	CGRect theFrame = %orig;
//	if (theFrame.origin.x > 1280)
//	{
//		theFrame.origin.x = 858;
//	}
//	if (theFrame.origin.x < 0)
//	{
//		theFrame.origin.x = 858;
//	}
//	
//	return theFrame;
//
//}
//
//%end

%subclass ntvTextControl : BRTextControl

-(CGSize)renderedSize
{
	return %orig;
}

%end


%subclass ntvWindow : BRWindow

+ (CGRect)interfaceFrame
{
	return %orig;
}

+ (CGSize)maxBounds
{ return %orig; }

%end

%subclass ntvImageControl: BRImageControl

-(CGSize)pixelBounds
{
	return %orig;
}

%end

%subclass ntvImage : BRImage

-(CGSize)pixelBounds
{
	return %orig;
}

%end

