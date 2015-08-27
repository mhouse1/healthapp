//
//  GKUIColumnView.h
//
//  Created by Hager Hu on 5/23/11.
//  Add dobule cache by Test Sup on 11/18/11
//  Copyright 2011 dreamblock.net. All rights reserved.
//

//  This class provides the view whose content is larger than its frame.
//  It just like UITableView, you can use it easily.

#import <UIKit/UIKit.h>
#import "GKUIColumnViewCell.h"

@protocol GKUIColumnViewDelegate;
@protocol GKUIColumnViewDataSource;


@interface GKUIColumnView : UIScrollView <UIScrollViewDelegate>
{
    NSMutableDictionary         *onScreenViewDic;       //当前可见cell存储
    NSMutableDictionary         *offScreenViewDic;      //不可见cell得存储
    NSMutableDictionary			*_tempoffScreenViewDic;
	
    NSUInteger					numberOfColumns;  //total count of columns of column view
    
    NSUInteger					startIndex; //current start index of view cell on screen
    NSUInteger					endIndex; //current end index of view cell on screen
    
	float						currentOffset_x;
	BOOL							isScrollDirectionRight;
	BOOL							pageEnadle;
	BOOL							cacheEnadle;
	
    NSMutableArray              *originPointList; //store the view cell's left origin for all view cells
	NSMutableDictionary			*itemIdList;		//store the view cell's index and identifier
}

/*
 The number of cells
 */
@property (nonatomic, readonly) NSUInteger	numberOfColumns;

/*
 The current visible cell index (pagingEnabled == YES)
 当前页索引，pagingEnabled == YES时有效
 */
@property (nonatomic, readonly) NSUInteger pageIndex;

/*
 default is NO, if set YES, cell width will be equal to the view
 是否为翻页模式
 */
@property (nonatomic, assign) BOOL pageEnadle;

/*
if need prepare left and right cache
 是否准备左右缓存
 */
@property (nonatomic, assign) BOOL cacheEnadle;
/*
 Left or right cache cells number, if cacheEnadle == NO, cacheNumber = 0
 左右缓存个数，cacheEnadle == YES时有效
 */
@property (nonatomic, readonly) NSUInteger cacheNumber;

/*
 UIColumnView delegate
 */
@property (nonatomic, assign) id<GKUIColumnViewDelegate> viewDelegate;

/*
 UIColumnView data source
 */
@property (nonatomic, assign) id<GKUIColumnViewDataSource> viewDataSource;


/*
 Set current visible cell
 滚动到某一页
 */
- (void)scrollToColumnAtIndex:(NSUInteger)index animated:(BOOL)animated;

/*
 Get	cell info
 */
//get index by cell view
//取cell得索引，如果cell不可见则返回0
- (NSUInteger)indexForCell:(GKUIColumnViewCell *)cell;                      // returns nil if cell is not visible

//get cell view by index
//通过索引取cell，如果cell不可见或者index超出范围则返回空
- (GKUIColumnViewCell *)cellForColumnAtIndex:(NSUInteger)index;            // returns nil if cell is not visible or index path is out of range

/*
 Return the reused view cell for this column view, nil if no cell can be reused
 @param identifier the reused identifier
 */
- (GKUIColumnViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;


/*
 Update view manully after the data model updated
 */
- (void)reloadData;


@end



@protocol GKUIColumnViewDelegate <NSObject>

/*
 This method is invoked when user select an view cell of it
 @param index the index user selected
 */
- (void)columnView:(GKUIColumnView *)columnView didSelectColumnAtIndex:(NSUInteger)index;

/*
 This method is invoked when user select an view cell of it
 @param index the index user selected
 */
- (void)columnView:(GKUIColumnView *)columnView touchesEnded:(NSUInteger)index;

/*
 The width for column at the index
 UIColumnView will get the width of column at the index from this method
 @param index the index of column view cell
 
 if set pageEnable YES,  get the width of column at the index will be const
 */
- (CGFloat)columnView:(GKUIColumnView *)columnView widthForColumnAtIndex:(NSUInteger)index;

@end



@protocol GKUIColumnViewDataSource <NSObject>

/*
 The count of column view cell in this column view
 @param columnView the object of UIColumnView
 */
- (NSUInteger)numberOfColumnsInColumnView:(GKUIColumnView *)columnView;


/*
 The relative view for the column at the index
 @param index the index for the column view
 */
- (GKUIColumnViewCell *)columnView:(GKUIColumnView *)columnView viewForColumnAtIndex:(NSUInteger)index;

@end