// Box2DBridge.mm — требует исходники Box2D v2.4.1 (https://github.com/erincatto/box2d),
// header search path: <box2d>/include, компиляция в C++17.
#import "Box2DBridge.h"
#include "box2d/box2d.h"
#include <vector>

#pragma mark - B2Shape

@implementation B2Shape {
    B2ShapeType _type;
    float _radius;
    CGPoint _position;
    std::vector<b2Vec2> _vertices;
}

- (B2ShapeType)type { return _type; }
- (float)radius { return _radius; }
- (CGPoint)position { return _position; }
- (NSInteger)vertexCount { return (NSInteger)_vertices.size(); }

+ (nullable instancetype)polygonWithVertices:(NSArray<NSNumber *> *)xy {
    NSInteger n = (NSInteger)xy.count / 2;
    if (n < 3 || n > b2_maxPolygonVertices) return nil;
    std::vector<b2Vec2> pts;
    pts.reserve((size_t)n);
    for (NSInteger i = 0; i < n; i++) {
        pts.emplace_back(xy[(NSUInteger)(2 * i)].floatValue, xy[(NSUInteger)(2 * i + 1)].floatValue);
    }
    b2PolygonShape poly;
    poly.Set(pts.data(), (int32)n);   // Box2D считает выпуклую оболочку
    if (poly.m_count < 3) return nil;
    B2Shape *s = [[B2Shape alloc] init];
    s->_type = B2ShapeTypePolygon;
    s->_vertices.assign(poly.m_vertices, poly.m_vertices + poly.m_count);
    return s;
}

+ (instancetype)boxWithHalfWidth:(float)hx halfHeight:(float)hy center:(CGPoint)center angle:(float)angle {
    b2PolygonShape poly;
    poly.SetAsBox(hx, hy, b2Vec2((float)center.x, (float)center.y), angle);
    B2Shape *s = [[B2Shape alloc] init];
    s->_type = B2ShapeTypePolygon;
    s->_vertices.assign(poly.m_vertices, poly.m_vertices + poly.m_count);
    return s;
}

+ (instancetype)circleWithRadius:(float)radius position:(CGPoint)position {
    B2Shape *s = [[B2Shape alloc] init];
    s->_type = B2ShapeTypeCircle;
    s->_radius = radius;
    s->_position = position;
    return s;
}

- (CGPoint)vertexAtIndex:(NSInteger)index {
    const b2Vec2 &v = _vertices[(size_t)index];
    return CGPointMake(v.x, v.y);
}

- (void)fillShape:(b2PolygonShape *)poly circle:(b2CircleShape *)circle {
    if (_type == B2ShapeTypePolygon) {
        poly->Set(_vertices.data(), (int32)_vertices.size());
    } else {
        circle->m_radius = _radius;
        circle->m_p.Set((float)_position.x, (float)_position.y);
    }
}
@end

#pragma mark - B2Fixture

@interface B2Fixture () {
@public
    b2Fixture *_fixture;
}
@end

@implementation B2Fixture
- (B2ShapeType)type {
    return _fixture->GetType() == b2Shape::e_circle ? B2ShapeTypeCircle : B2ShapeTypePolygon;
}
- (B2Shape *)shape {
    if (_fixture->GetType() == b2Shape::e_circle) {
        const b2CircleShape *c = static_cast<const b2CircleShape *>(_fixture->GetShape());
        return [B2Shape circleWithRadius:c->m_radius position:CGPointMake(c->m_p.x, c->m_p.y)];
    }
    const b2PolygonShape *p = static_cast<const b2PolygonShape *>(_fixture->GetShape());
    NSMutableArray<NSNumber *> *xy = [NSMutableArray array];
    for (int i = 0; i < p->m_count; i++) {
        [xy addObject:@(p->m_vertices[i].x)];
        [xy addObject:@(p->m_vertices[i].y)];
    }
    return [B2Shape polygonWithVertices:xy] ?: [B2Shape circleWithRadius:0 position:CGPointZero];
}
- (float)density { return _fixture->GetDensity(); }
- (void)setDensity:(float)v { _fixture->SetDensity(v); }
- (float)friction { return _fixture->GetFriction(); }
- (void)setFriction:(float)v { _fixture->SetFriction(v); }
- (float)restitution { return _fixture->GetRestitution(); }
- (void)setRestitution:(float)v { _fixture->SetRestitution(v); }
- (uint16_t)categoryBits { return _fixture->GetFilterData().categoryBits; }
- (void)setCategoryBits:(uint16_t)bits {
    b2Filter f = _fixture->GetFilterData(); f.categoryBits = bits; _fixture->SetFilterData(f);
}
- (uint16_t)maskBits { return _fixture->GetFilterData().maskBits; }
- (void)setMaskBits:(uint16_t)bits {
    b2Filter f = _fixture->GetFilterData(); f.maskBits = bits; _fixture->SetFilterData(f);
}
@end

#pragma mark - B2Body

@interface B2World () {
@public
    b2World *_world;
}
@end

@interface B2Body () {
@public
    b2Body *_body;
    B2World *_worldRef;                 // удерживает мир, пока жив хотя бы один B2Body
    NSMutableArray<B2Fixture *> *_fixtures;
}
@end

@implementation B2Body

- (instancetype)init {
    if ((self = [super init])) { _fixtures = [NSMutableArray array]; }
    return self;
}

- (void)dealloc {
    if (_body && _worldRef && _worldRef->_world) {
        _worldRef->_world->DestroyBody(_body);
    }
}

- (CGPoint)position { b2Vec2 p = _body->GetPosition(); return CGPointMake(p.x, p.y); }
- (float)angle { return _body->GetAngle(); }
- (B2BodyType)type {
    switch (_body->GetType()) {
        case b2_staticBody: return B2BodyTypeStatic;
        case b2_kinematicBody: return B2BodyTypeKinematic;
        default: return B2BodyTypeDynamic;
    }
}
- (void)setType:(B2BodyType)type {
    b2BodyType t = type == B2BodyTypeStatic ? b2_staticBody : (type == B2BodyTypeKinematic ? b2_kinematicBody : b2_dynamicBody);
    _body->SetType(t);
}
- (CGPoint)linearVelocity { b2Vec2 v = _body->GetLinearVelocity(); return CGPointMake(v.x, v.y); }
- (void)setLinearVelocity:(CGPoint)v { _body->SetLinearVelocity(b2Vec2((float)v.x, (float)v.y)); }
- (float)angularVelocity { return _body->GetAngularVelocity(); }
- (void)setAngularVelocity:(float)w { _body->SetAngularVelocity(w); }
- (float)gravityScale { return _body->GetGravityScale(); }
- (void)setGravityScale:(float)s { _body->SetGravityScale(s); }
- (BOOL)bullet { return _body->IsBullet(); }
- (void)setBullet:(BOOL)b { _body->SetBullet(b); }
- (BOOL)fixedRotation { return _body->IsFixedRotation(); }
- (void)setFixedRotation:(BOOL)f { _body->SetFixedRotation(f); }
- (float)mass { return _body->GetMass(); }
- (CGPoint)worldCenter { b2Vec2 c = _body->GetWorldCenter(); return CGPointMake(c.x, c.y); }
- (NSArray<B2Fixture *> *)fixtures { return [_fixtures copy]; }

- (void)setTransformX:(float)x y:(float)y angle:(float)angle {
    _body->SetTransform(b2Vec2(x, y), angle);
}

- (B2Fixture *)createFixtureWithShape:(B2Shape *)shape density:(float)density friction:(float)friction
                          restitution:(float)restitution categoryBits:(uint16_t)cat maskBits:(uint16_t)mask {
    b2PolygonShape poly; b2CircleShape circle;
    [shape fillShape:&poly circle:&circle];
    b2FixtureDef def;
    def.shape = (shape.type == B2ShapeTypePolygon) ? static_cast<b2Shape *>(&poly) : static_cast<b2Shape *>(&circle);
    def.density = density; def.friction = friction; def.restitution = restitution;
    def.filter.categoryBits = cat; def.filter.maskBits = mask;
    B2Fixture *f = [[B2Fixture alloc] init];
    f->_fixture = _body->CreateFixture(&def);
    [_fixtures addObject:f];
    return f;
}

- (void)destroyFixture:(B2Fixture *)fixture {
    if (![_fixtures containsObject:fixture]) return;
    _body->DestroyFixture(fixture->_fixture);
    fixture->_fixture = nullptr;
    [_fixtures removeObject:fixture];
}

- (void)destroyAllFixtures {
    for (B2Fixture *f in [_fixtures copy]) [self destroyFixture:f];
}

- (void)resetMassData { _body->ResetMassData(); }

- (CGPoint)worldPointForLocalPoint:(CGPoint)p {
    b2Vec2 w = _body->GetWorldPoint(b2Vec2((float)p.x, (float)p.y));
    return CGPointMake(w.x, w.y);
}
@end

#pragma mark - B2World

class B2ContactListenerImpl : public b2ContactListener {
public:
    __unsafe_unretained B2World *owner = nil;
    void BeginContact(b2Contact *c) override;
    void EndContact(b2Contact *c) override;
};

@implementation B2World {
    B2ContactListenerImpl _listener;
}

- (instancetype)initWithGravityX:(float)x y:(float)y allowSleep:(BOOL)allowSleep {
    if ((self = [super init])) {
        _world = new b2World(b2Vec2(x, y));
        _world->SetAllowSleeping(allowSleep);
        _listener.owner = self;
        _world->SetContactListener(&_listener);
    }
    return self;
}

- (void)dealloc {
    delete _world;
    _world = nullptr;
}

- (CGPoint)gravity { b2Vec2 g = _world->GetGravity(); return CGPointMake(g.x, g.y); }
- (void)setGravity:(CGPoint)g { _world->SetGravity(b2Vec2((float)g.x, (float)g.y)); }

- (B2Body *)createBodyWithType:(B2BodyType)type allowSleep:(BOOL)allowSleep {
    b2BodyDef def;
    def.type = type == B2BodyTypeStatic ? b2_staticBody : (type == B2BodyTypeKinematic ? b2_kinematicBody : b2_dynamicBody);
    def.allowSleep = allowSleep;
    B2Body *body = [[B2Body alloc] init];
    body->_worldRef = self;
    body->_body = _world->CreateBody(&def);
    body->_body->GetUserData().pointer = (uintptr_t)(__bridge void *)body;   // без retain
    return body;
}

- (void)stepWithDelta:(float)dt velocityIterations:(int)v positionIterations:(int)p {
    _world->Step(dt, v, p);
}
@end

static B2Body *B2BodyFromB2(b2Body *b) {
    return (__bridge B2Body *)(void *)b->GetUserData().pointer;
}

void B2ContactListenerImpl::BeginContact(b2Contact *c) {
    B2ContactBlock block = owner.beginContact;
    if (block) block(B2BodyFromB2(c->GetFixtureA()->GetBody()), B2BodyFromB2(c->GetFixtureB()->GetBody()));
}
void B2ContactListenerImpl::EndContact(b2Contact *c) {
    B2ContactBlock block = owner.endContact;
    if (block) block(B2BodyFromB2(c->GetFixtureA()->GetBody()), B2BodyFromB2(c->GetFixtureB()->GetBody()));
}
