//
//  ViewController.h
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addProtocol.h"
#import "UpdateProtocol.h"

@interface AllToDoViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,addProtocol,UpdateProtocol,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *allTableView;

@property NSMutableArray<NSMutableDictionary*> *dictArray;

@property (weak, nonatomic) IBOutlet UISearchBar *allTodoSearch;

@end

