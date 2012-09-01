%hook LTNTPStartupController

- (void)wasPushed
{
  [[self stack] popController];
}

%end
