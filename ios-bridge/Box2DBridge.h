// Box2DBridge.h — Objective-C фасад над Box2D 2.4.x (C++), доступный из Swift.
// Нужен только тот API Box2D, который использует Catroid (physics/*).
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, B2BodyType) {
    B2BodyTypeStatic = 0,
    B2BodyTypeKinematic = 1,
    B2BodyTypeDynamic = 2
};

typedef NS_ENUM(NSInteger, B2ShapeType) {
    B2ShapeTypeCircle = 0,
    B2ShapeTypePolygon = 1
};

@class B2World, B2Body, B2Fixture;

#pragma mark - Shape

@interface B2Shape : NSObject
@property (nonatomic, readonly) B2ShapeType type;
/// Circle: радиус
@property (nonatomic, readonly) float radius;
/// Circle: центр в локальных координатах
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) NSInteger vertexCount;

/// xy — плоский массив [x0,y0,x1,y1,...]. До 8 вершин; выпуклая оболочка считается Box2D (b2PolygonShape::Set).
+ (nullable instancetype)polygonWithVertices:(NSArray<NSNumber *> *)xy NS_SWIFT_NAME(polygon(vertices:));
+ (instancetype)boxWithHalfWidth:(float)hx halfHeight:(float)hy center:(CGPoint)center angle:(float)angle NS_SWIFT_NAME(box(halfWidth:halfHeight:center:angle:));
+ (instancetype)circleWithRadius:(float)radius position:(CGPoint)position NS_SWIFT_NAME(circle(radius:position:));
- (CGPoint)vertexAtIndex:(NSInteger)index NS_SWIFT_NAME(vertex(at:));
@end

#pragma mark - Fixture

@interface B2Fixture : NSObject
@property (nonatomic, readonly) B2ShapeType type;
@property (nonatomic, readonly) B2Shape *shape;
@property (nonatomic) float density;
@property (nonatomic) float friction;
@property (nonatomic) float restitution;
@property (nonatomic) uint16_t categoryBits;
@property (nonatomic) uint16_t maskBits;
@end

#pragma mark - Body

@interface B2Body : NSObject
@property (nonatomic, strong, nullable) id userData;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) float angle;          // радианы
@property (nonatomic) B2BodyType type;
@property (nonatomic) CGPoint linearVelocity;
@property (nonatomic) float angularVelocity;          // рад/с
@property (nonatomic) float gravityScale;
@property (nonatomic) BOOL bullet;
@property (nonatomic) BOOL fixedRotation;
@property (nonatomic, readonly) float mass;
@property (nonatomic, readonly) CGPoint worldCenter;
@property (nonatomic, readonly) NSArray<B2Fixture *> *fixtures;

- (void)setTransformX:(float)x y:(float)y angle:(float)angle NS_SWIFT_NAME(setTransform(x:y:angle:));
- (B2Fixture *)createFixtureWithShape:(B2Shape *)shape
                              density:(float)density
                             friction:(float)friction
                          restitution:(float)restitution
                         categoryBits:(uint16_t)categoryBits
                             maskBits:(uint16_t)maskBits NS_SWIFT_NAME(createFixture(shape:density:friction:restitution:categoryBits:maskBits:));
- (void)destroyFixture:(B2Fixture *)fixture;
- (void)destroyAllFixtures;
- (void)resetMassData;
/// Transform.mul: локальная точка тела → мировые координаты
- (CGPoint)worldPointForLocalPoint:(CGPoint)p NS_SWIFT_NAME(worldPoint(local:));
@end

#pragma mark - World

typedef void (^B2ContactBlock)(B2Body *bodyA, B2Body *bodyB);

@interface B2World : NSObject
@property (nonatomic) CGPoint gravity;
@property (nonatomic, copy, nullable) B2ContactBlock beginContact;
@property (nonatomic, copy, nullable) B2ContactBlock endContact;

- (instancetype)initWithGravityX:(float)x y:(float)y allowSleep:(BOOL)allowSleep;
- (B2Body *)createBodyWithType:(B2BodyType)type allowSleep:(BOOL)allowSleep NS_SWIFT_NAME(createBody(type:allowSleep:));
- (void)stepWithDelta:(float)dt velocityIterations:(int)velocityIterations positionIterations:(int)positionIterations NS_SWIFT_NAME(step(delta:velocityIterations:positionIterations:));
@end

NS_ASSUME_NONNULL_END
