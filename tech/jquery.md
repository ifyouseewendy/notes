## Basics

jQuery 是一个 JavaScript 函数库。

jQuery 库包含以下特性：

+ HTML 元素选取
+ HTML 元素操作
+ CSS 操作
+ HTML 事件函数
+ JavaScript 特效和动画
+ HTML DOM 遍历和修改
+ AJAX
+ Utilities

**添加jQuery库**

```html
<head>
<script type="text/javascript" src="jquery.js"></script>
</head>

# 使用 Google 的 CDN
<head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9/jquery.min.js"></script>
</head>
```

**jQuery语法**

基础语法是：$(selector).action()

+ 美元符号定义 jQuery
+ 选择符（selector）“查询”和“查找” HTML 元素
+ jQuery 的 action() 执行对元素的操作

**文档就绪函数**

```html
$(document).ready(function(){

--- jQuery functions go here ----

});
```

这是为了防止文档在完全加载（就绪）之前运行 jQuery 代码。

如果在文档没有完全加载之前就运行函数，操作可能失败。下面是两个具体的例子：

+ 试图隐藏一个不存在的元素
+ 获得未完全加载的图像的大小

**jQuery选择器**

jQuery 元素选择器和属性选择器允许您通过**标签名、属性名或内容**对 HTML 元素进行选择。

选择器允许您对 HTML 元素组或单个元素进行操作。

在 HTML DOM 术语中：

选择器允许您对 DOM 元素组或单个 DOM 节点进行操作。

+ jQuery 元素选择器

  jQuery 使用 CSS 选择器来选取 HTML 元素。

  $("p") 选取 \<p> 元素。

  $("p.intro") 选取所有 class="intro" 的 \<p> 元素。

  $("p#demo") 选取所有 id="demo" 的 \<p> 元素。

+ jQuery 属性选择器

  jQuery 使用 XPath 表达式来选择带有给定属性的元素。

  $("[href]") 选取所有带有 href 属性的元素。

  $("[href='#']") 选取所有带有 href 值等于 "#" 的元素。

  $("[href!='#']") 选取所有带有 href 值不等于 "#" 的元素。

  $("[href$='.jpg']") 选取所有 href 值以 ".jpg" 结尾的元素。

**jQuery事件**

jQuery 是为事件处理特别设计的。

jQuery 事件处理方法是 jQuery 中的核心函数。

事件处理程序指的是当 HTML 中发生某些事件时所调用的方法。术语由事件“触发”（或“激发”）经常会被使用。

通常会把 jQuery 代码放到 \<head>部分的事件处理方法中.

```html
<html>
<head>
<script type="text/javascript" src="jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
  $("button").click(function(){
    $("p").hide();
  });
});
</script>
</head>
```

**jQuery名称冲突**

jQuery 使用 $ 符号作为 jQuery 的简介方式。

某些其他 JavaScript 库中的函数（比如 Prototype）同样使用 $ 符号。

jQuery 使用名为 noConflict() 的方法来解决该问题。

var jq=jQuery.noConflict()，帮助您使用自己的名称（比如 jq）来代替 $ 符号。

```html
<html>
<head>
<script type="text/javascript" src="jquery.js"></script>
<script type="text/javascript">
var jq=jQuery.noConflict();
jq(document).ready(function(){
  jq("button").click(function(){
    jq("p").hide();
  });
});

$.noConflict();
jQuery(document).ready(function(){
  jQuery("button").click(function(){
    jQuery("p").hide();
  });
});
</script>
</head>
```

**小结**

由于 jQuery 是为处理 HTML 事件而特别设计的，那么当您遵循以下原则时，您的代码会更恰当且更易维护：

+ 把所有 jQuery 代码置于事件处理函数中
+ 把所有事件处理函数置于文档就绪事件处理器中
+ 把 jQuery 代码置于单独的 .js 文件中
+ 如果存在名称冲突，则重命名 jQuery 库

