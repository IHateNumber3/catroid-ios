# Box2D bridge

Нужны исходники Box2D v2.4.1: https://github.com/erincatto/box2d (тег v2.4.1)

В CI:
    git clone --depth 1 --branch v2.4.1 https://github.com/erincatto/box2d.git third_party/box2d

В проект добавить:
- third_party/box2d/src/**/*.cpp  (компилировать как C++17)
- HEADER_SEARCH_PATHS: third_party/box2d/include third_party/box2d/src
- Box2DBridge.h/.mm
- SWIFT_OBJC_BRIDGING_HEADER = ios-bridge/Catroid-Bridging-Header.h
