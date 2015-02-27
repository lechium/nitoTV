
%subclass ntvMediaShelfView : BRMediaShelfView


- (void)_layoutShelfContents {
    
    /*
     start origin is 38 if there are two items to the left in the flow
     if one item its 88
     and their width becomes 17 if they are out of view
     
     check the flat range to see what items are displayed flat (derp!)
     
     if the count is 11 then we are likely on the first item, but still need to be certain
     12 then we are either one item flowed out from the left or the right
     13 two on either left or right
     14 3 items faded out on both sides
     
     
     
     */
    
    %log;
    %orig; //theres still some stuff we dun' wanna figure out, let them do the dimmness and angled science for the coverflow science
    
    NSRange flatRange = MSHookIvar<NSRange>(self, "_flatRange");
    id cellz = [self valueForKey:@"_cells"];
    int cellCount = [cellz count];
    float startOrigin = 128;
    int currentCell = flatRange.location;
    int flatSize = flatRange.length;
    id theCell = nil;
    CGRect theFrame;
    CGRect theBounds;

    
    switch (flatRange.location)
    {
        case 0:
            
            break;
        case 1:
            theCell = [cellz objectAtIndex:0];
            theFrame = [theCell frame];
            theFrame.size.width = 17;
            theBounds = [theCell bounds];
            theFrame.origin.x = 88;
            theBounds.origin.x = 0;
            theBounds.size.width = 99;
            [theCell setFrame:theFrame];
            [theCell setBounds:theBounds];
            break;
            
        case 2:
            
            theCell = [cellz objectAtIndex:0];
            theFrame = [theCell frame];
            theBounds = [theCell bounds];
            
            theFrame.size.width = 17;
            theFrame.origin.x = 38;
            theBounds.origin.x = 0;
            theBounds.size.width = 99;
            [theCell setFrame:theFrame];
            [theCell setBounds:theBounds];
            
            theCell = [cellz objectAtIndex:1];
            theFrame.origin.x = 88;
            
            [theCell setFrame:theFrame];
            
            [theCell setBounds:theBounds];
            
            break;
            
       default:
            
            currentCell = 2;
            theCell = [cellz objectAtIndex:0];
            theFrame = [theCell frame];
            theBounds = [theCell bounds];
            
            theFrame.size.width = 17;
            theFrame.origin.x = 38;
            theBounds.origin.x = 0;
            theBounds.size.width = 99;
            [theCell setFrame:theFrame];
            [theCell setBounds:theBounds];
            
            theCell = [cellz objectAtIndex:1];
            theFrame.origin.x = 88;
            
            [theCell setFrame:theFrame];
            
            [theCell setBounds:theBounds];
            
            break;
       
            
    }
    
    int i = 0;
    int overFlowCount = 0;
    int flatCount = cellCount - currentCell;
    for (i = currentCell; i < cellCount; i++ )
    {
      //  if (i > cellCount) return;
        id cell = [cellz objectAtIndex:i];
        CGRect frame = [cell frame];
        CGRect bounds = [cell bounds];
        bounds.origin.x = 0;
        bounds.size.width = 99;
        frame.origin.x = startOrigin;
        frame.size.width = 99;
      
        
        if (startOrigin == 1052)
        {
            if (overFlowCount == 0)
            {
                frame.origin.x = 1052;
                
            } else if (overFlowCount == 1)
            {
                frame.size.width = 17;
                frame.origin.x = 1175;
            } else if (overFlowCount == 2)
            {
                frame.size.width = 17;
                frame.origin.x = 1224;
            } else if (overFlowCount >= 3)
            {
                frame.size.width = 17;
                frame.origin.x = 1274;
            }
            overFlowCount++;
            
            
            
        } else {
        
            startOrigin = startOrigin + 132;
            
            
        }
       
        
        [cell setFrame:frame];
        [cell setBounds:bounds];
        
        currentCell++;
        
    }
    
    
}

- (BOOL)autoresizesSubviews
{
    return FALSE;
}

- (BOOL)translatesAutoresizingMaskIntoConstraints
{
    return FALSE;
}

%end