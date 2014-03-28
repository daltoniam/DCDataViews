# DCDataViews #

Wrappers around UITableView and UICollectionView to make simpler to use. It also provides a custom grouped tableview that is twitter bootstrapped inspired. DCCollectionViewLayout provides dynamic/variable sized cell support. OS X version can be found [here](https://github.com/daltoniam/ACDataViews)

# Dependencies #

Requires Quartz framework. 

# TableView Example #
	
```obj-c
//first create a tableSource datasource manager
DCTableSource *tableSource = [[DCTableSource alloc] init];
tableSource.delegate = self;
//next create a tableview and assign it's delegate and datasource to the manager
self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped]; // UITableViewStyleGrouped
self.tableView.delegate = tableSource;
self.tableView.dataSource = tableSource;
self.tableView.backgroundView = nil;
self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];//[UIColor whiteColor];
self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

yourObject* object = [[yourObject alloc] init]; //your custom objects, can be any kind of object
object.text = @"Hello World!";
[tableSource.items addObject:object];

//then implement this delegate to map the object to cell associates.
-(Class)classForObject:(id)object
{
    if([object isKindOfClass:[yourobject class]])
        return [MessageCell class];
    return nil;
}


//then in your MessageCell.m class (which is a subclass of DCTableViewCell provided):

+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return 44; //the normal UITableViewCell
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
    	//the usual UITableViewCell init method
    	self.textLabel.textColor = [UIColor greenColor]; //just an example
    	return self;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //layout your subviews as you normally would
}
-(void)setObject:(id)object
{
    [super setObject:object];
    //example of using your custom object to set the textLabel of UITableViewCell
    yourObject* item = object;
    self.textLabel.text = item.text; //this would be "Hello World!" as the example above
    //the rest of your your custom logic here
}
```
# CollectionView Example #

```obj-c
DCCollectionSource *dataSource = [[DCCollectionSource alloc] init];
dataSource.delegate = self;
DCCollectionViewLayout *layout = [[DCCollectionViewLayout alloc] initWithDataSource:dataSource];
layout.enabledSpring = YES;
layout.horizontalSpacing = 0;
self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
self.collectionView.delegate = self.dataSource;
self.collectionView.dataSource = self.dataSource;
[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
self.collectionView.backgroundColor = [UIColor whiteColor];
[self.view addSubview:self.collectionView];

yourObject* object = [[yourObject alloc] init]; //your custom objects, can be any kind of object
object.text = @"Hello World!";
[dataSource.items addObject:object];

//then implement this delegate to map the object to cell associates.
-(Class)classForObject:(id)object
{
    if([object isKindOfClass:[yourobject class]])
        return [MessageCell class];
    return nil;
}


//then in your MessageCell.m class (which is a subclass of DCCollectionViewCell provided):

+(CGSize)collectionView:(UICollectionView*)collectionView sizeForObject:(id)object
{
    return CGSizeMake(collectionView.frame.size.width, 88);//CGSizeMake(56.7, 56.7);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //layout your subviews as you normally would
} 
-(void)setObject:(id)object
{
    [super setObject:object];
    yourObject* item = object;
    //the rest of your your custom logic here
}
```

# Requirements #

This framework requires at least iOS 5 above. 

# Install #

The recommended approach for installing DCDataViews is via the CocoaPods package manager, as it provides flexible dependency management and dead simple installation.

via CocoaPods

Install CocoaPods if not already available:

	$ [sudo] gem install cocoapods
	$ pod setup
Change to the directory of your Xcode project, and Create and Edit your Podfile and add DCDataViews:

	$ cd /path/to/MyProject
	$ touch Podfile
	$ edit Podfile
	platform :ios, '5.0' 
	pod 'DCDataViews'

Install into your project:

	$ pod install
	
Open your project in Xcode from the .xcworkspace file (not the usual project file)

# TODO #

- Need to support horizontal scrolling in DCCollectionViewLayout.
- Need to support sections in CollectionView.

# License #

DCDataViews is license under the Apache License.

# Contact #

### Dalton Cherry ###
* https://github.com/daltoniam
* http://twitter.com/daltoniam
