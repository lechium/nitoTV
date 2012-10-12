//
//  SMFComplexProcessDropShadowControl.m
//  SMFramework
//
//  Created by Thomas Cool on 2/28/11.
//  Copyright 2011 Thomas Cool. All rights reserved.
//

	//#import "SMFComplexProcessDropShadowControl.h"

@interface NSObject (smfcpdsc)
-(void)process:(id)p ended:(NSString *)s;

@end


static char const * const kSMFCPDSCApKey = "SMFCPDSCAp";

static BOOL _finished = TRUE;
static int _returnCode = 0;


%subclass SMFComplexProcessDropShadowControl : SMFComplexDropShadowControl


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
//            NSLog(@"s: %@",s);
            [self performSelectorOnMainThread:@selector(appendToText:) withObject:[s stringByAppendingString:@"\n"] waitUntilDone:YES];
        }
    }

    _returnCode = pclose(fp);
    _finished =YES;
    

	if ([[self delegate] respondsToSelector:@selector(process:ended:)]) {
        [[self delegate] process:self ended:[self ap]];
    }
		
	
	[pool release];
    return _returnCode;
}
	//@end

%end