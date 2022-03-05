//
//  DoneTableViewCell.h
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *donePriorityImageView;
@property (weak, nonatomic) IBOutlet UILabel *doneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneDateLabel;

@end

NS_ASSUME_NONNULL_END
