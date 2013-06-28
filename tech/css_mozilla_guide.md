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

To specify a typeface on its own, use the `font-family` property.

```
font-family
font-size
    small, medium, large
  smaller, larger
  14px, 150%, 1.5em
line-height
text-decoration
  underline, line-through
font-style
  italic
font-weight
  normal, bold

```

###\# Color

```
#000  black
#f00  red
#0f0  green
#00f  blue
#fff  white
```

`background-color` can be set to *transparent* to explicitly remove any color, revealing the parent element's background.

###\# Content

Content specified in a stylesheet can consist of text or images. You specify content in your stylesheet when the content is closely linked to the document's structure.

> Specifying content in a stylesheet can cause complications, like language, but no problem with  symbols or images that apply in all languages and cultures.

Content specified in a stylesheet does not become part of the DOM.

```css
.ref:before {
  font-weight: bold;
  color: navy;
  content: "Reference: ";
}

# adds a space and an icon after every link that has the class glossary
a.glossary:after {content: " " url("../images/glossary-icon.gif");}

# background default with repeat
#sidebar-box {background: url("../images/sidebar-ground.png") no-repeat;}
```

###\# Lists

`list-style`

```
# unordered list
disc, circle, square

# ordered list
decimal, lower-roman, upper-roman, lower-latin, upper-latin
```

###\# Boxes

In the middle, there is the space that the element needs to display its content. Around that, there is padding. Around that, there is a border. Around that, there is a margin that separates the element from other elements.

The padding is always the same color as the element's background. So when you set the background color, you see the color applied to the element itself and its padding. The margin is always transparent.

`border`

```css
solid, dotted, dashed, double
inset, outset, ridge, groove

none, hidden
```

`margin` & `padding`

If you specify one width, it applies all around the element (top, right, bottom and left).

If you specify two widths, the first applies to the top and bottom, the second to the right and left.

You can specify all four widths in the order: top, right, bottom, left.

###\# Layout

**Size units**

For many purposes it is better to specify sizes as a percentage or in ems (em). An em is nominally the size of the current font (the width of a letter m). When the user changes the font size, your layout adjusts automatically.

**Text layout**

```css
text-align
  left, right, center, justify
text-indent
```

**Floats**

forces an element to the left or right.

`clear` property on other elements to make them stay clear of floats.

```css
ul, #numbered {float: left;}
h3 {clear: left;}
```

**Positions**


+ **relative**
The element's position is shifted relative to its normal position. Use this to shift an element by a specified amount. You can sometimes use the element's margin to achieve the same effect.

+ **fixed**
The element's position is fixed. Specify the element's position relative to the document window. Even if the rest of the document scrolls, the element remains fixed.

+ **absolute**
The element's position is fixed relative to a parent element. Only a parent that is itself positioned with relative, fixed or absolute will do. You can make any parent element suitable by specifying position: relative; for it without specifying any shift.

+ **static**
The default. Use this value if you need to turn positioning off explicitly. 

Along with these values of the position property (except for static), specify one or more of the properties: `top, right, bottom, left, width, height` to identify where you want the element to appear, and perhaps also its size.

###\# Tables

```html
<table>
  <thead>
    <tr>
      <th></th>
      <th>COL-HEAD1</th>
      <th>COL-HEAD2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>ROW-HEAD1</th>
      <td>row-data1-1</td>
      <td>row-data1-2</td>
    </tr>
    <tr>
      <th>ROW-HEAD2</th>
      <td>row-data2-1</td>
      <td>row-data2-2</td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <th>total</th>
      <td></td>
      <td></td>
  </tfoot>
</table>
```

**Borders**

+ Cells have no margins.

+ Cells do have borders and padding. By default, the borders are separated by the value of the table's `border-spacing` property. You can also remove the spacing completely by setting the table's `border-collapse` property to _collapse_.

**Captions**

A `<caption>` element is a label that applies to the entire table. By default, it is displayed at the top of the table. `caption-side` can be set to bottum.

**Empty Cells**

You can display empty cells (that is, their borders and backgrounds) by specifying `empty-cells: show;` for the table element.

You can hide them by specifying `empty-cells: hide;`. Then, if a cell's parent element has a background, it shows through the empty cell.

###\# Media

To specify rules that are specific to a type of media, use `@media` followed by the media type, followed by curly braces that enclose the rules.

```
screen 	        Color computer display
print 	        Paged media
projection 	Projected display
all 	        All media (the default)
```

```css
/* print only */
@media print {

h1 {
  page-break-before: always;
  padding-top: 2em;
  }

h1:first-child {
  page-break-before: avoid;
  counter-reset: page;
  }
...
}
```

In CSS you can use `@import` at the start of a stylesheet to import another stylesheet from a URL, optionally specifying the media type.
