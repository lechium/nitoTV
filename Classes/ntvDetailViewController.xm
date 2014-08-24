//
//  ntvDetailViewController.xm
//  nitoTV
//
//  Created by Kevin Bradley on 11/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


%subclass ntvDetailViewController : BRController


%new - (float)headerHeightForTableView:(id)tableView
{
	return 28.0f;
}

%new - (long)numberOfColumnsInTableView:(id)tableView
{
	
}

%new - (long)numberOfHeaderColumnsInTableView:(id)tableView
{
	
}

%new - (long)numberOfRowsInTableView:(id)tableView 
{
	
}

%new - (id)tableView:(id)view headerForColumn:(long)column
{
	
}

%new - (float)tableView:(id)view heightForRow:(long)row
{
	return 25.0f;
}

%new - (id)tableView:(id)view itemForRow:(long)row inColumn:(long)column
{
	
}

%new - (float)tableView:(id)view widthForColumn:(long)column
{
	return 207.5f;
}

%new - (float)tableView:(id)view widthForHeaderColumn:(long)headerColumn
{
	return 207.5f;
}


%end
