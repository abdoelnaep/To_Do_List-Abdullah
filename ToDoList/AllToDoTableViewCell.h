//
//  AllToDoTableViewCell.h
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllToDoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *priorityImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

NS_ASSUME_NONNULL_END
