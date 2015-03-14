//
//  NSMFComplexProcessDropShadowControl.m
//  SMFramework
//
//  Created by Thomas Cool on 2/28/11.
//  Copyright 2011 Thomas Cool. All rights reserved.
//

	//#import "NSMFComplexProcessDropShadowControl.h"

@interface NSObject (smfcpdsc)
-(void)process:(id)p ended:(NSString *)s;

@end


static char const * const kSMFCPDSCApKey = "SMFCPDSCAp";

static BOOL _finished = TRUE;
static int _returnCode = 0;
static BOOL _requiresSourceFix = FALSE;
static BOOL _requiresDependFix = FALSE;


%subclass NSMFComplexProcessDropShadowControl : NSMFComplexDropShadowControl


%new - (id)ap {
	
	return [self associatedValueForKey:(void*)kSMFCPDSCApKey];
}

%new - (void)setAp:(id)theAp {

	[self associateValue:theAp withKey:(void*)kSMFCPDSCApKey];
}

-(id)init
{
    self=%orig;
    _returnCode=YES;
    _finished=NO;
    return self;
}
-(void)controlWasActivated
{

    %orig;
    [self performSelectorInBackground:@selector(runProcess) withObject:nil];
}
-(void)dealloc
{
		//self.ap=nil;
    %orig;
}

%new - (BOOL)requiresDependencyFix
{
    return _requiresDependFix;
}

%new - (BOOL)sourceFixRequired
{
    return _requiresSourceFix;
}

%new -(int)returnCode {
	
	return _returnCode;
}

%new -(BOOL)finished {
	
	return _finished;
}

%new -(int)runProcess
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    char line[200];
    
    FILE* fp = popen([[self ap] UTF8String], "r");

    if (fp)
    {
        while (fgets(line, sizeof line, fp))
        {
            NSString *s = [NSString stringWithCString:line encoding:NSUTF8StringEncoding];
            NSLog(@"s: %@",s);
            
            if ([s rangeOfString:@"is not known on line"].location != NSNotFound)
            {
                NSLog(@"found line, source fix required!!");
                _requiresSourceFix = TRUE;
            }
            
            if ([s rangeOfString:@"dependency problems - leaving unconfigured"].location != NSNotFound)
            {
                _requiresDependFix = TRUE;
            }
            
            [self performSelectorOnMainThread:@selector(appendToText:) withObject:[s stringByAppendingString:@"\n"] waitUntilDone:YES];
        }
    }

    _returnCode = pclose(fp);
    _finished =YES;
    
    if (_requiresSourceFix == TRUE)
    {
        [self performSelectorOnMainThread:@selector(appendToText:) withObject:@"Attempting to automatically repair source folder, please try again!" waitUntilDone:YES];
        _returnCode = -1;
    }
    
    if (_requiresDependFix == TRUE)
    {
        [self performSelectorOnMainThread:@selector(appendToText:) withObject:@"### Attempting to automatically repair missing dependencies ###" waitUntilDone:YES];
        _returnCode = -1;
    }
    
    if (_requiresSourceFix == TRUE)
    {
        [self performSelectorOnMainThread:@selector(appendToText:) withObject:@"### Attempting to automatically repair source folder, please try again! ###" waitUntilDone:YES];
        _returnCode = -1;
    }

	if ([[self delegate] respondsToSelector:@selector(process:ended:)]) {
        NSLog(@"%@ responds!", [self delegate]);
        [[self delegate] process:self ended:[self ap]];
    } else {
        NSLog(@"delegate doesnt respond!!: %@", [self delegate]);
    }
		
	
	[pool release];
    return _returnCode;
}
	//@end

%end