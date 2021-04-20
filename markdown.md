## 在右键菜单添加.md

- 使用以下注册表（编辑后改为`.reg`后缀，双击运行）

  ```
  Windows Registry Editor Version 5.00
  
  [HKEY_CLASSES_ROOT\.md]
  @="MarkdownFile"
  "PerceivedType"="text"
  "Content Type"="text/plain"
  
  [HKEY_CLASSES_ROOT\.md\ShellNew]
  "NullFile"=""
  
  [HKEY_CLASSES_ROOT\MarkdownFile]
  @="Markdown File"
  
  [HKEY_CLASSES_ROOT\MarkdownFile\DefaultIcon]
  @="%SystemRoot%\system32\imageres.dll,-102"
  
  [HKEY_CLASSES_ROOT\MarkdownFile\shell]
  
  [HKEY_CLASSES_ROOT\MarkdownFile\shell\open]
  
  [HKEY_CLASSES_ROOT\MarkdownFile\shell\open\command]
  @="%SystemRoot%\system32\NOTEPAD.EXE %1"
  ```

- 若使用 Typora，可再添加以下注册表，让新建图标变为 Typora 的

  ```
  Windows Registry Editor Version 5.00
  
  [HKEY_CLASSES_ROOT\.md]
  @="TyporaMarkdownFile"
  "PerceivedType"="text"
  "Content Type"="text/plain"
  
  [HKEY_CLASSES_ROOT\.md\ShellNew]
  "NullFile"=""
  ```

  