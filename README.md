# DCDataViews #

Wrappers around UITableView and UICollectionView to make simpler to use. It also provides a custom grouped tableview that is twitter bootstrapped inspired.

# Dependancies #

Requires Quartz framework. 

# Example #

	DCTableSource *tableSource = [[DCTableSource alloc] init];
	tableSource.delegate = self;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped]; // UITableViewStyleGrouped
    self.tableView.delegate = tableSource;
    self.tableView.dataSource = tableSource;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];//[UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

	id object = [yourobject createObject]; //your custom objects, can be any kind of object
	[tableSource.items addObject:object];
	
	//then implement this delegate to map the object to cell associates.
	-(Class)classForObject:(id)object
	{
	    if([object isKindOfClass:[yourobject class]])
	        return [MessageCell class];
	    return nil;
	}
	
# Requirements #

This framework requires at least iOS 5 above. 

# Install #

The recommended approach for installing DCDataViews is via the CocoaPods package manager, as it provides flexible dependency management and dead simple installation.

via CocoaPods

Install CocoaPods if not already available:

	$ [sudo] gem install cocoapods
	$ pod setup
Change to the directory of your Xcode project, and Create and Edit your Podfile and add RestKit:

	$ cd /path/to/MyProject
	$ touch Podfile
	$ edit Podfile
	platform :ios, '5.0' 
	pod 'DCDataViews'

Install into your project:

	$ pod install
	
Open your project in Xcode from the .xcworkspace file (not the usual project file)

# License #

DCDataViews is license under the Apache License.

# Contact #

### Dalton Cherry ###
* https://github.com/daltoniam
* http://twitter.com/daltoniam