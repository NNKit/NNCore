//
//  NSArray+NNExtension.h
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (NNExtension)

/**
 执行execute 方法, 对每个对象执行block方法

 @param handler 对于每个handler执行的block,  return YES时, 停止后续object执行
 */
- (void)execute:(void (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))handler;

/**
 执行map方法,将已有数组内数据 过滤成一个新的数组
 
 @param handler 执行转换的handler
 @return 返回结果
 */
- (NSArray<ObjectType> *)map:(id(^)(ObjectType obj, NSInteger index))handler;

/**
 提供数组过滤功能
 
 @param handler   YES 过滤数据 NO 保留数据
 @return 过滤后的数组
 */
- (NSArray<ObjectType> *)filter:(BOOL(^)(ObjectType obj))handler;

/**
 只获取符合条件的第一个元素
 
 @param handler 过滤block YES 返回该元素, NO 继续查找,  handler如果为nil 返回第一个元素
 @return id or nil
 */
- (nullable ObjectType)fetchOneObject:(BOOL(^)(ObjectType obj))handler;

/**
 执行查询方法,判断数组内是否有符合条件的元素
 
 @param handler handler
 @return YES or NO
 */
- (BOOL)any:(BOOL(^)(ObjectType obj))handler;


/**
 安全获取数组内元素,数组存在越界情况
 
 @param index  需要获取的index
 @return       index对应的数据 or nil
 */
- (nullable ObjectType)safeObjectAtIndex:(NSUInteger)index;

/**
 获取元素对应的index
 
 @param object 需要获取的数据
 @return       index  or NSNotFound
 */
- (NSUInteger)safeIndexOfObject:(ObjectType)object;

/**
 判断当前数组是否为空
 
 @return YES or NO
 */
- (BOOL)isEmpty;

/**
 Returns an NSString for encoded self;
 
 @return NSString or nil
 */
- (nullable NSString *)jsonValueEncoded;

@end

NS_ASSUME_NONNULL_END
