//
//  InProgressViewController.h
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface InProgressViewController : UIViewController  <UITableViewDelegate,UITableViewDataSource,UpdateProtocol,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *inProgressTableView;

@property NSMutableArray <NSMutableDictionary*> *inProgressArray;
@property NSMutableDictionary *inProgressDict;
@property NSMutableDictionary *detailModelDict;
@property (weak, nonatomic) IBOutlet UISearchBar *inProgressFilter;

@end

NS_ASSUME_NONNULL_END
