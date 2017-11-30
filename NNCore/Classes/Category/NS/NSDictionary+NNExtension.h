//
//  NSDictionary+NNExtension.h
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#import <Foundation/Foundation.h>

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (NNExtension)

/**
 过滤keys中元素 获取新的NSDictionary 集合
 
 @param keys 需要过滤的keys
 @return 过滤后的NSDictionary
 */
- (nullable NSDictionary<KeyType, ObjectType> *)filterKeys:(nonnull NSArray<KeyType> *)keys;

/**
 获取对应Key的object
 
 @param key          对应的key
 @return id  or nil
 */
- (nullable ObjectType)safeObjectForKey:(nonnull KeyType)key;

/**
 获取对应Key的object
 
 @param key          对应的key
 @param defaultValue 默认值
 @return id or defaultValue or nil
 */
- (nullable ObjectType)safeObjectForKey:(nonnull KeyType)key
                           defaultValue:(nullable KeyType)defaultValue;

/**
 获取对应Object的key
 
 @param object 需要获取key的Object
 @return KeyType or nil
 */
- (nullable KeyType)safeKeyOfObject:(nonnull ObjectType)object;


/**
 获取对应Object的key集合

 @param object 需要获取key的Object
 @return NSArray<KeyType> or nil
 */
- (nullable NSArray<KeyType> *)safeKeysOfObject:(nonnull ObjectType)object;

/**
 判断NSDictionary中是否存在对应的Key
 
 @param key 需要判断的KEY
 @return YES or NO
 */
- (BOOL)anyKeyExists:(nonnull KeyType)key;

/**
 判断NSDictionary 中是否存在对应的Object
 
 @param object  需要判断的Object
 @return YES or NO
 */
- (BOOL)anyObjectExists:(nonnull ObjectType)object;

/**
 Returns an NSString for encoded self;
 
 @return NSString or nil
 */
- (nullable NSString *)jsonValueEncoded;

@end


@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (NNStructExtension)

/**
 获取对应Key存储的NSNumber
 
 @param key 存储的key
 @return NSNumber or nil
 */
- (nullable NSNumber *)numberValueForKey:(nonnull KeyType)key;

/**
 获取对应Key存储的NSValue
 
 @param key 存储的key
 @return NSValue or nil
 */
- (nullable NSValue *)structValueForKey:(nonnull KeyType)key;

/**
 获取key对应存储的boolValue
 
 @param key    存储的对应key
 @return YES or NO
 */
- (BOOL)boolValueForKey:(nonnull KeyType)key;


/**
 获取对应key存储的integerValue
 
 @param key  存储的key
 @return Value or 0
 */
- (NSInteger)integerValueForKey:(nonnull KeyType)key;

/**
 获取key对应存储的FloatValue
 
 @param key    存储的对应key
 @return CGFloat or CGFloatMin
 */
- (CGFloat)floatValueForKey:(nonnull KeyType)key;

/**
 获取key对应存储的sizeValue
 
 @param key    存储的对应key
 @return CGSizeValue or CGSizeZero
 */
- (CGSize)sizeValueForKey:(nonnull KeyType)key;

/**
 获取key对应存储的RectValue
 
 @param key    存储的对应key
 @return CGRectValue or CGRectZero
 */
- (CGRect)rectValueForKey:(nonnull KeyType)key;

/**
 获取key对应存储的pointValue
 
 @param key    存储的对应key
 @return CGPointValue or CGPointZero
 */
- (CGPoint)pointValueForKey:(nonnull KeyType)key;

@end

@interface NSMutableDictionary<KeyType, ObjectType> (NNStructExtension)

/**
 保存一个bool值到NSDictionary中
 
 @param value 布尔值
 @param key 存储的key
 */
- (void)setBoolValue:(BOOL)value forKey:(nonnull KeyType)key;

/**
 保存一个CGFloat值到NSDictionary中
 
 @param value CGFloat
 @param key 存储的key
 */
- (void)setFloatValue:(CGFloat)value forKey:(nonnull KeyType)key;


/**
 保存一个CGSize值到NSDictionary中
 
 @param value CGSize
 @param key 存储的key
 */
- (void)setSizeValue:(CGSize)value forKey:(nonnull KeyType)key;


/**
 保存一个CGRect值到NSDictionary中
 
 @param value CGRect
 @param key 存储的key
 */
- (void)setRectValue:(CGRect)value forKey:(nonnull KeyType)key;

/**
 保存一个CGPoint值到NSDictionary中
 
 @param value CGPoint
 @param key 存储的key
 */
- (void)setPointValue:(CGPoint)value forKey:(nonnull KeyType)key;

@end


@interface NSDictionary (NNURLExtension)

+ (nullable NSDictionary *)queryDictionaryForURL:(nonnull NSURL *)URL;

@end

