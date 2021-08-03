# Syntax

## Function

### Decorator
- See: https://www.liaoxuefeng.com/wiki/1016959663602400/1017451662295584

```python
@dec2
@dec1
def func(arg1, arg2, ...):
    pass
```

is equivalent to:

```python
def func(arg1, arg2, ...):
    pass
func = dec2(dec1(func))
```

Another example, used to record function's running time:

```python
import time
import functools

def metric(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        t = time.time()
        r = func(*args, **kwargs)
        t = time.time() - t
        print("Function: %s is completed in %ss" % (func.__name__, t))
        return r
    return wrapper
    
@metric
def test(x, y):
    time.sleep(0.1234)
    print("Hello")
    return x + y
    
print(test.__name__)
# test
f = test(11 + 22)
print(f)
# Function: test is completed in 0.1234s
# 33
```

The decorator `@functools.wraps` is used to maintain functions' `__name__`, with this decorator, `test.__name__` will become `wrapper`.


### Positional-Only / Keyword-Only Syntax
- `/` is positional-only symbol, means that all parameters before the `/` can only be passed by position
- `*` is keyword-only symbol, means that all parameters after the `*` can only be passed by keyword

For a function like `def test(a, b, /, c, d=1, *, e, f=2)`
- a, b can only be passed as postional arguments
- c, d can be passed as positional or keyword arguments
- e, f can only be passed as keywork arguments 

Also see:
```python
def f(pos1, pos2, /, pos_or_kwd, *, kwd1, kwd2):
      -----------    ----------     ----------
        |             |                  |
        |        Positional or keyword   |
        |                                - Keyword only
         -- Positional only
```

## Class

### @property
- Function decorated by @property is used when get attributes, the value returned will be attributes' value
- Function decorated by @<attr>.setter is called when set attributes, usually used for checking legality of values

A example:
    
```python
class test:
    def __init__(self,):
        self._a = 123
        
    @property
    def a(self,):
        return self._a
    
    @a.setter
    def a(self, value):
        if value >= 100:
            raise ValueError("Cannot larger than 100!")
        self._a = value

t = test()
print(t.a)
# 123
t.a = 13
print(t.a)
# 13
t.a = 111
# Traceback ...
# ...
# ValueError: Cannot larger than 100!
```


