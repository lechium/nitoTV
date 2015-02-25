
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
    
    
    //	NSRange flatRange = [[self valueForKey:@"_flatRange"] rangeValue];
    NSRange flatRange = MSHookIvar<NSRange>(self, "_flatRange");
    id cellz = [self valueForKey:@"_cells"];
    int cellCount = [cellz count];
    float startOrigin = 128;
    int currentCell = 0;
    int flatSize = flatRange.length;
    NSLog(@"flatSize: %i", flatSize);
    for (id cell in cellz)
    {
        CGRect frame = [cell frame];
        CGRect bounds = [cell bounds];
        bounds.origin.x = 0;
        bounds.size.width = 99;
        frame.origin.x = startOrigin;
        frame.size.width = 99;
        
        
        if (flatRange.location == 0)
        {
            
            if (currentCell+1 > flatSize)
            {
                NSLog(@"currentCell: %i is >= %i", currentCell+1, flatSize);
                frame.size.width = 17;
                if (currentCell == 8)
                {
                    frame.origin.x = 1175;
                }
                else if (currentCell == 9)
                {
                    frame.origin.x = 1224;
                    
                } else if (currentCell == 10)
                {
                    frame.origin.x = 1274;
                    
                } else {
                    
                    frame.origin.x = 1274;
                    NSLog(@"ever here???: %i", currentCell);
                    
                }
            }
            
            [cell setFrame:frame];
            [cell setBounds:bounds];
        }
        if (flatRange.location == 1)
        {
            if (currentCell == 0)
            {
                frame.origin.x = 88;
                frame.size.width = 17;
                startOrigin = -4;
            }
            
            if (currentCell+1 > flatSize)
            {
                NSLog(@"currentCell: %i is >= %i", currentCell+1, flatSize);
                frame.size.width = 17;
                if (currentCell == 8)
                {
                    frame.origin.x = 1175;
                }
                else if (currentCell == 9)
                {
                    frame.origin.x = 1224;
                    
                } else if (currentCell == 10)
                {
                    frame.origin.x = 1274;
                    
                } else {
                    
                    frame.origin.x = 1274;
                    NSLog(@"ever here???: %i", currentCell);
                    
                }
            }
            
            [cell setFrame:frame];
            [cell setBounds:bounds];
        }
        
        //CALayer layer = [cell layer];
        currentCell++;
        startOrigin = startOrigin + 132;
    }
    NSLog(@"cells after _layoutShelfContents: %@", cellz);
    
}

%end