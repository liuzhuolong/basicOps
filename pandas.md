## 数据处理
- pd.factorize()：字符转数字（用于标签处理）

## 提高速度
- 使用apply而非for循环来遍历DataFrame
- 使用apply时注意：只传需要的参数，不要传整个DataFrame，这会极大拖慢运行速度
