//
//  EditViewController.h
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController <UpdateProtocol>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@property (weak, nonatomic) IBOutlet UILabel *piriorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property id <UpdateProtocol> UpdateCell;

@property NSMutableDictionary *detailModelDict;
@property NSMutableDictionary *selectedModelDict;
@property NSIndexPath* index;
@property NSInteger indexSearch;

@end

NS_ASSUME_NONNULL_END
