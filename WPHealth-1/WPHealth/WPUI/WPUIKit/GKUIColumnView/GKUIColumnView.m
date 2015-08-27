//
//  GKUIColumnView.m
//
//  Created by Hager Hu on 5/23/11.
//  Add dobule cache by Test Sup on 11/18/11
//  Copyright 2011 dreamblock.net. All rights reserved.
//

#import "GKUIColumnView.h"

#define LASTCELL	@"lastcell"
#define NEXTCELL	@"nextcell"
#define GKUICOLUMNVIEWCACHENUMBER	3

@interface GKUIColumnView(private)

- (void)prepareLeftAndRightCacheForColumnAtIndex:(NSUInteger)index;

- (void)setOnScreeCellViewAtIndex:(NSInteger)index;

- (void)setOffScreenCellViewAtIndex:(NSInteger)index;

@end


@implementation GKUIColumnView

@synthesize numberOfColumns;

@synthesize pageIndex;

@synthesize pageEnadle;
@synthesize cacheNumber;
@synthesize cacheEnadle;

@synthesize viewDelegate;
@synthesize viewDataSource;


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    
    if (self)
	{
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        onScreenViewDic = [[NSMutableDictionary alloc] init];
        offScreenViewDic = [[NSMutableDictionary alloc] init];
        _tempoffScreenViewDic = [[NSMutableDictionary alloc] init];
		
        originPointList = [[NSMutableArray alloc] init];
        itemIdList = [[NSMutableDictionary alloc] init];
		
		//self.delegate = self;
		currentOffset_x = 0;
        numberOfColumns = 0;
        pageIndex = 0;
		
		pageEnadle = NO;
		cacheEnadle = NO;
		cacheNumber = 0;
		
        startIndex = 0;
        endIndex = 0;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    onScreenViewDic = [[NSMutableDictionary alloc] init];
    offScreenViewDic = [[NSMutableDictionary alloc] init];
    _tempoffScreenViewDic = [[NSMutableDictionary alloc] init];
    
    originPointList = [[NSMutableArray alloc] init];
    itemIdList = [[NSMutableDictionary alloc] init];
    
    //self.delegate = self;
    currentOffset_x = 0;
    numberOfColumns = 0;
    pageIndex = 0;
    
    pageEnadle = NO;
    cacheEnadle = NO;
    cacheNumber = 0;
    
    startIndex = 0;
    endIndex = 0;
}

#pragma mark -
#pragma mark Public method implementation

//cell缓存机制
- (GKUIColumnViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if ([[offScreenViewDic allKeys] containsObject:identifier]) 
	{
    	NSMutableSet *cacheSet = (NSMutableSet *)[offScreenViewDic objectForKey:identifier];
        id reused = [cacheSet anyObject];
        if (reused != nil)
		{
			if (!cacheEnadle)
			{
				[cacheSet removeObject:reused];
			}
            return (GKUIColumnViewCell *)reused;
        }
	}
	
	if (!cacheEnadle)
	{
		return nil;
	}
    
	for(NSNumber *numkey in [onScreenViewDic allKeys]) 
	{
		GKUIColumnViewCell *onCell = (GKUIColumnViewCell *)[onScreenViewDic objectForKey:numkey];
		
		if (NSOrderedSame == [onCell.reuseIdentifier compare:identifier]) 
		{
			NSLog(@"(this log should not appear)old	cache cell id : %@ ", onCell.reuseIdentifier);
			return onCell;
		}
	}
	
//	NSLog(@"need new cell: %@", identifier);
	return nil;
}


#pragma mark -
#pragma mark Handle rect

//翻页属性
- (void)setPageEnadle:(BOOL)page
{
	pageEnadle = page;
	self.pagingEnabled = page;
}

//取cell的宽度，如果设置pageEnadle为YES,则回调不生效，width值始终取：self.frame.size.width
- (CGFloat)widthForColumnAtIndex:(NSInteger)index
{
	float viewWidth = 0.0;
	if (pageEnadle) 
	{
		viewWidth = self.frame.size.width;
	}
	else
	{
		viewWidth = [viewDelegate columnView:self widthForColumnAtIndex:index];
	}
	
	return viewWidth;
}

//计算scrollView得contentSize
- (float)contentSizeWidth 
{
    float width = 0.0;
    numberOfColumns = viewDataSource == nil ? 0 : [viewDataSource numberOfColumnsInColumnView:self];
    for (int i = 0; i < numberOfColumns; i++)
	{
        float itemWidth = [self widthForColumnAtIndex:i];
        width += itemWidth;
    }
    //NSLog(@"content size: %f", width);
    
    return width;
}

//存储每个cell得x坐标
- (void)calculateAllItemsOrigin
{
    float viewOrigin = 0;
    [originPointList removeAllObjects];
    for (int i = 0; i < numberOfColumns; i++) 
	{
        [originPointList addObject:[NSNumber numberWithFloat:viewOrigin]];
        viewOrigin += [self widthForColumnAtIndex:i];
    }
}

//计算移动的起始页（startIndex， endIndex）
- (void)calculateItemIndexRange
{
    float lowerBound = MAX(self.contentOffset.x, 0);
    float upperBound = MIN(self.contentOffset.x + self.bounds.size.width, self.contentSize.width);
	
	//	NSLog(@"contentOffset = %f", self.contentOffset.x );
	//    NSLog(@"lowerBound:%f upperBound:%f", lowerBound, upperBound);
	
	if(self.contentOffset.x >= currentOffset_x)
	{
		//		NSLog(@"scroll direction : ringt");
		isScrollDirectionRight = YES;
	}
	else
	{
		//		NSLog(@"scroll direction : left");
		isScrollDirectionRight = NO;
	}
	currentOffset_x = self.contentOffset.x;
	
    for (int i = 0; i < numberOfColumns; i++) 
	{
        if ([[originPointList objectAtIndex:i] floatValue] <= lowerBound) 
		{
            startIndex = i;
        }
        
        if ([[originPointList objectAtIndex:i] floatValue] < upperBound) 
		{
            endIndex = i;
        }
    }
	//    NSLog(@"startIndex = %d, endIndex = %d", startIndex, endIndex);
}

//滚动到指定页
- (void)scrollToColumnAtIndex:(NSUInteger)index animated:(BOOL)animated;
{
	NSInteger number = viewDataSource == nil ? 0 : [viewDataSource numberOfColumnsInColumnView:self];
	
	if (index == pageIndex) 
		return;
	
	if (index < number)
	{
		float viewOrigin = 0;
		for (int i = 0; i < index; i++)
		{
			viewOrigin += [self widthForColumnAtIndex:i];
		}
		
		[self prepareLeftAndRightCacheForColumnAtIndex:index];
		
		[self setContentOffset:CGPointMake(viewOrigin, 0) animated:animated];
		
		pageIndex = index;
	}
}


#pragma mark -
#pragma mark Set Cache

//是否开启缓存模式（左右页面提前加载）
- (void)setCacheEnadle:(BOOL)needCache
{
	cacheEnadle = needCache;
	if (needCache) 
	{
		cacheNumber = GKUICOLUMNVIEWCACHENUMBER;
	}
	else
	{
		cacheNumber = 0;
	}

}

- (void)setOnScreeCellViewAtIndex:(NSInteger)index
{
	GKUIColumnViewCell *viewCell = [viewDataSource columnView:self viewForColumnAtIndex:index];
	
	NSNumber *key = [NSNumber numberWithInt:index];
	NSString *value = [NSString stringWithFormat:@"%@", viewCell.reuseIdentifier];
	[itemIdList setObject:value forKey:key];
	
	[onScreenViewDic setObject:viewCell forKey:key];
}

- (void)setOffScreenCellViewAtIndex:(NSInteger)index
{
	GKUIColumnViewCell *viewCell = [viewDataSource columnView:self viewForColumnAtIndex:index];
	
	NSNumber *key = [NSNumber numberWithInt:index];
	NSString *value = [NSString stringWithFormat:@"%@", viewCell.reuseIdentifier];
	[itemIdList setObject:value forKey:key];
	
	NSMutableSet *newSet = [NSMutableSet setWithObject:viewCell];
	[_tempoffScreenViewDic setObject:newSet forKey:viewCell.reuseIdentifier];
	
}

//准备左右缓存页
- (void)prepareLeftAndRightCacheForColumnAtIndex:(NSUInteger)index
{
	NSInteger currentIndex = index;

	if (0 == numberOfColumns || !cacheEnadle) 
	{
		return;
	}
	[self setOffScreenCellViewAtIndex:index];
	for (NSInteger cacheIndex = 1; cacheIndex <= cacheNumber; cacheIndex++) 
	{
		//prepare left cache
		if (currentIndex+cacheIndex < numberOfColumns)
		{
			//NSLog(@"	right	cache cell index : %d", currentIndex+cacheIndex);
			[self setOffScreenCellViewAtIndex:currentIndex+cacheIndex];
		}
		//prepare right cache
		if (currentIndex-cacheIndex >= 0)
		{
			//NSLog(@"	left		cache cell index : %d", currentIndex-cacheIndex);
			[self setOffScreenCellViewAtIndex:currentIndex-cacheIndex];
		}
	}
	
	[offScreenViewDic removeAllObjects];
	for (NSString *key in [_tempoffScreenViewDic allKeys]) 
	{
		[offScreenViewDic setObject:[_tempoffScreenViewDic objectForKey:key] forKey:key];
	}
	[_tempoffScreenViewDic removeAllObjects];
}

#pragma mark -
#pragma mark Get cell info

//通过cell取索引
- (NSUInteger)indexForCell:(GKUIColumnViewCell *)cell
{
	//temp
	return 0;
}

//通过索引取cell
- (GKUIColumnViewCell *)cellForColumnAtIndex:(NSUInteger)index
{
	GKUIColumnViewCell *viewCell = nil;
	NSString *identifier = nil;
	NSNumber *indexKey = [NSNumber numberWithInt:index];
	
	if ([[itemIdList allKeys] containsObject:indexKey])
	{
		identifier = [itemIdList objectForKey:indexKey];
	}
	else
	{
		return nil;
	}

	//find from onScreen
	if ([[onScreenViewDic allKeys] containsObject:indexKey])
	{
		viewCell = (GKUIColumnViewCell *)[onScreenViewDic objectForKey:indexKey];
		
		if (viewCell)
		{
			return viewCell;
		}
	}
		 
	//find from offScreen
	viewCell = [self dequeueReusableCellWithIdentifier:identifier];
	if (viewCell)
	{
		return viewCell;
	}
	
	return nil;
}

#pragma mark -
#pragma mark Set View and Data

//清空cell
- (void)clearAllCells
{
	for (NSNumber *key in [onScreenViewDic allKeys]) 
	{
		GKUIColumnViewCell *cell = [onScreenViewDic objectForKey:key];
		
		[cell removeFromSuperview];
    }
	
	[onScreenViewDic removeAllObjects];
	
    [offScreenViewDic removeAllObjects];
}

- (void)updateOffScreenViewWithKey:(NSNumber *)key
{
	GKUIColumnViewCell *cell = [onScreenViewDic objectForKey:key];
	
	if ([[offScreenViewDic allKeys] containsObject:cell.reuseIdentifier])
	{
		NSMutableSet *viewSet = [offScreenViewDic objectForKey:cell.reuseIdentifier];
		[viewSet addObject:cell];
	}
	else 
	{
		NSMutableSet *newSet = [NSMutableSet setWithObject:cell];
		[offScreenViewDic setObject:newSet forKey:cell.reuseIdentifier];
	}
	
	[onScreenViewDic removeObjectForKey:key];
	[cell removeFromSuperview];
}

//刷新当前页
- (void)updateOnScreenViewAtIndex:(NSUInteger)index
{
	NSUInteger cellIndex = index;
	
	//add current cell
	GKUIColumnViewCell *viewCell = [viewDataSource columnView:self viewForColumnAtIndex:cellIndex];
	
	NSNumber *key = [NSNumber numberWithInt:cellIndex];
	NSString *value = [NSString stringWithFormat:@"%@", viewCell.reuseIdentifier];
	[itemIdList setObject:value forKey:key];
	
	[onScreenViewDic setObject:viewCell forKey:key];
	
	//view change ways
	float viewWidth = [self widthForColumnAtIndex:cellIndex];
	float viewOrigin = [[originPointList objectAtIndex:[key intValue]] floatValue];
	viewCell.frame = CGRectMake(viewOrigin, 0, viewWidth, self.bounds.size.height);
	
	[self addSubview:viewCell];
}

//数据重载
- (void)reloadData
{
    NSInteger newColumnsNum = viewDataSource == nil ? 0: [viewDataSource numberOfColumnsInColumnView:self];
    
    //如果个数改变，则重新计算contentsize和offset
    if (newColumnsNum != numberOfColumns)
    {
        BOOL isNumDown = NO;
        if (newColumnsNum < numberOfColumns) 
        {
            isNumDown = YES;
        }
        
        self.contentSize = CGSizeMake([self contentSizeWidth], self.bounds.size.height);
        [self calculateAllItemsOrigin];
        
        self.contentOffset = CGPointMake(pageIndex*self.frame.size.width, self.contentOffset.y);
        
        if (self.contentOffset.x > self.contentSize.width - self.frame.size.width)
        {
            NSLog(@"offset = %f, step = %f", self.contentOffset.x, self.contentSize.width - self.frame.size.width);
            self.contentOffset = CGPointMake(0.0, self.contentOffset.y);
            pageIndex = 0;
        }
        
        if (0 == numberOfColumns || isNumDown == YES)
        {
            self.contentOffset = CGPointMake(0.0, self.contentOffset.y);
            pageIndex = 0;
            
            [self clearAllCells];
            //return;
        } 
    }
    
	for (NSNumber *key in [onScreenViewDic allKeys]) 
	{
		if (!cacheEnadle)
		{
			[self updateOffScreenViewWithKey:key];
			
			[self updateOnScreenViewAtIndex:[key intValue]];
		}
    }
	
	if (numberOfColumns > 0 && 0 == [onScreenViewDic count]) 
	{
		[self layoutSubviews];
	}
}

//获取cell并显示
- (void)addSubviewsOnScreen 
{
    if (self.zooming ||self.zoomBouncing) 
    {
        return;
    }
    
    //计算起始结束位置
    [self calculateItemIndexRange];
    
	//首次加载
	if (0 == [onScreenViewDic count] && 0 == endIndex)
	{
		[self prepareLeftAndRightCacheForColumnAtIndex:endIndex];
	}
	
    //将不在起止范围内得cell从屏幕上取下，并放入offscreen存储
    for (NSNumber *key in [onScreenViewDic allKeys]) 
	{
        if ([key intValue] < startIndex || [key intValue] > endIndex)
		{
//		//	NSLog(@"startIndex = %d, endIndex = %d", startIndex, endIndex);
            GKUIColumnViewCell *cell = [onScreenViewDic objectForKey:key];
			//save old cell
            //非缓存模式下，存入offscreen
			if (!cacheEnadle)
			{
				if ([[offScreenViewDic allKeys] containsObject:cell.reuseIdentifier])
				{
					NSMutableSet *viewSet = [offScreenViewDic objectForKey:cell.reuseIdentifier];
					[viewSet addObject:cell];
				}
				else 
				{
					NSMutableSet *newSet = [NSMutableSet setWithObject:cell];
					[offScreenViewDic setObject:newSet forKey:cell.reuseIdentifier];
				}
			}
            //缓存模式下准备左右缓存
			else
			{
				if ([[offScreenViewDic allKeys] containsObject:cell.reuseIdentifier]) 
				{
					//NSLog(@"cache %@ have exist", cell.reuseIdentifier);			
				}
				//	else
				{
                    //准备左右缓存
					[self prepareLeftAndRightCacheForColumnAtIndex:endIndex];
				}
				if([offScreenViewDic count] > ((cacheNumber*2)+1))
					NSLog(@"--------------------------------------------->bug here");
			}

			pageIndex = endIndex;
			
            [onScreenViewDic removeObjectForKey:key];
            [cell removeFromSuperview];
        }
    }
    
    //获取新的当前页面cell
    for (int i = startIndex; i < endIndex + 1; i++)
	{
        if (![[onScreenViewDic allKeys] containsObject:[NSNumber numberWithInt:i]])
		{
			[self updateOnScreenViewAtIndex:i];
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (numberOfColumns == 0) 
	{
    	numberOfColumns = viewDataSource == nil ? 0: [viewDataSource numberOfColumnsInColumnView:self];
    }
    //NSLog(@"column count:%d", numberOfColumns);
    
    if (self.contentSize.width == 0)
	{
        self.contentSize = CGSizeMake([self contentSizeWidth], self.bounds.size.height);
    }
    
    if ([originPointList count] == 0 && numberOfColumns != 0) 
	{
        [self calculateAllItemsOrigin];
    }
    
	if (0 == numberOfColumns) 
	{
		return;
	}
	
    [self addSubviewsOnScreen];
}

#pragma mark -
#pragma mark UISwipeGestureRecognizer

//- (void)updateSelectedView:(NSInteger)index
//{
//	
//	UIView *current = [viewsArray objectAtIndex:selectedIndex];
//	UIView *next = [viewsArray objectAtIndex:index];
//	
//	UITableViewCell *current = [viewDataSource columnView:self viewForColumnAtIndex:index];
//	
//	CGContextRef ref = UIGraphicsGetCurrentContext();
//	[UIView beginAnimations:nil context:ref];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//	[UIView setAnimationBeginsFromCurrentState:YES];
//	[UIView setAnimationDuration:0.4f];
//	
//	//[current setAlpha:0.0];
//	//current.transform = CGAffineTransformMakeScale(0.25, 0.25);	
//	
//	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:current cache:YES];
//	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:current cache:YES];

//	[current removeFromSuperview];
//	[self addSubview:next];

//	[UIView commitAnimations];
//		
//}

#pragma mark -
#pragma mark UIScrollViewDelegate method implementation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    self.contentOffset = scrollView.contentOffset;
}

#pragma mark -
#pragma mark UIEvent Handle method

//点击事件处理
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view 
{
    if (event.type == UIEventTypeTouches) 
	{
        UITouch *touch = (UITouch *)[touches anyObject];
        
       	CGPoint point = [touch locationInView:self];
       // NSLog(@"point in self:%@", NSStringFromCGPoint(point));
        
        float viewWidth = 0;
        for (int i = 0; i < [viewDataSource numberOfColumnsInColumnView:self]; i++) 
		{
            if (viewWidth < point.x &&
                (viewWidth + [self widthForColumnAtIndex:i]) > point.x) 
			{
                [viewDelegate columnView:self didSelectColumnAtIndex:i];
                break;
            }
			else 
			{
                viewWidth += [self widthForColumnAtIndex:i];
            }
            
        }
    }
	
    return [super touchesShouldBegin:touches withEvent:event inContentView:view];
}

#pragma mark - UIResponder

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeTouches)
    {
        UITouch *touch = (UITouch *)[touches anyObject];
        
       	CGPoint point = [touch locationInView:self];
        // NSLog(@"point in self:%@", NSStringFromCGPoint(point));
        
        float viewWidth = 0;
        for (int i = 0; i < [viewDataSource numberOfColumnsInColumnView:self]; i++)
        {
            if (viewWidth < point.x &&
                (viewWidth + [self widthForColumnAtIndex:i]) > point.x)
            {
                [viewDelegate columnView:self touchesEnded:i];
                break;
            }
            else
            {
                viewWidth += [self widthForColumnAtIndex:i];
            }
            
        }
    }
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc 
{
    [onScreenViewDic removeAllObjects];
    [offScreenViewDic removeAllObjects];
    [_tempoffScreenViewDic removeAllObjects];
}


@end
