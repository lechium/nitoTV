

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