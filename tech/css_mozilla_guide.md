*link*: https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Getting_started

###\# Why use CSS?

When a user prints a web page, you provide different style information that makes the printed page easy to read.

When you use CSS, you normally avoid using these features of the markup language so that all your document's style information is in one place.

###\# How CSS works

When a browser displays a document, it must combine the document's content with its style information. It processes the document in two stages:

+ The browser converts the markup language and the CSS into a structure called the DOM (Document Object Model). The DOM represents the document in the computer's memory. It combines the document's content with its style.
+ The browser displays the contents of the DOM.

```html
<p>
  <strong>C</strong>ascading
  <strong>S</strong>tyle
  <strong>S</strong>heets
</p>
```

generates DOM:

```
P
├─STRONG
│ └─"C"
├─"ascading"
├─STRONG
│ └─"S"
├─"tyle"
├─STRONG
│ └─"S"
└─"heets"
```

###\# Cascading and inheritance

Three main sources of style information form a cascade. They are *the browse, the user, the author*.

For styles in the cascade, author stylesheets have priority, then reader stylesheets, then the browser's defaults.

For inherited styles, a child node's own style has priority over style inherited from its parent.

###\# Selectors

An ID selector is more specific than a class selector, which in turn is more specific than a tag selector.

You can specify other attributes by using square brackets. For example, the selector [type='button'] selects all elements that have a type attribute with the value button.

If the stylesheet has conflicting rules and they are equally specific, then CSS gives priority to the rule that is later in the stylesheet.

**Pseudo-classes selectors**

[useful link](http://www.w3.org/TR/selectors/#selectors)

```css
selector:pseudo-class {
  property: value;
}

:active       Adds a style to an element that is activated
:focus        Adds a style to an element that has keyboard input focus
:hover        Adds a style to an element when you mouse over it
:lang         Adds a style to an element with a specific lang attribute
:link         Adds a style to an unvisited link
:visited      Adds a style to a visited link
```

**Selectors based on relationships**

Common selectors based on relationships

```
Selector  Selects
A E             Any E element that is a descendant of an A element (that is: a child, or a child of a child, etc.)
A > E           Any E element that is a child of an A element
E:first-child   Any E element that is the first child of its parent
B + E           Any E element that is the next sibling of a B element (that is: the next child of the same parent)
```

###\# Text Styles

`font`

+ Bold, italic, and small-caps (small capitals)
+ The size
+ The line height
+ The font typeface

```css
p {font: italic 75%/125% "Comic Sans MS", cursive;}
```

**Font faces**
You cannot predict what typefaces the readers of your document will have. So when you specify font typefaces, it is a good idea to give a list of alternatives in order of preference.

End the list with one of the built-in default typefaces: *serif, sans-serif, cursive, fantasy or monospace*

If the typeface does not support some features in the document, then the browser can substitute a different typeface. For example, the document might contain special characters that the typeface does not support. If the browser can find another typeface that has those characters, then it will use the other typeface.

To specify a typeface on its own, use the font-family property.




