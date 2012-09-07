//
//  MoveTableView.h
//  CodesharpSDK
//
//  Created by sunleepy on 12-8-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@class MoveTableView;


@protocol MoveTableViewDelegate<NSObject, UITableViewDelegate>

- (NSIndexPath *)moveTableView:(MoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;
@optional
- (void)moveTableView:(MoveTableView *)tableView willMoveRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@protocol MoveTableViewDataSource<NSObject, UITableViewDataSource>

- (void)moveTableView:(MoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end

@interface MoveTableView : UITableView<UIGestureRecognizerDelegate>

@property (nonatomic,weak) id<MoveTableViewDataSource> dataSource;
@property (nonatomic,weak) id<MoveTableViewDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *movingIndexPath;

- (BOOL)indexPathIsMovingIndexPath:(NSIndexPath *)indexPath;

@end
