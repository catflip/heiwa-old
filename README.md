<h1>
  <img src="./.github/banner.svg" alt="Heiwa Banner Image" width="100%">
</h1>

**Heiwa** is a versatile and developer-friendly widget system for Linux desktops. It enables you to create interactive widgets without any hindrance.

> [!WARNING]
> Heiwa is currently in an *alpha* version. Expect bugs and breaking changes when using it.

## Getting Started

To install Heiwa, make sure that you have an installation of [Ruby](https://www.ruby-lang.org/en/) and its package manager, `gem`.

After that, you can simply install it on your machine:

```sh
gem install heiwa 
```

### What Are Widgets?

In Heiwa, **widgets** refer to "a window that contain renderable components".

> [!NOTE]
> A (renderable) component is something that can be rendered on the screen. Components may be as simple as a rectangle, or be as complex as form inputs.

These widgets may contain two things:

- *top-level components*, which are ordinary components added to the widget tree.
- a *root component*, which is a simple component wrapper to avoid having to explicitly add each component to the widget tree. There can only be **one** root component in a widget.

### Your First Widget

As an example to show off Heiwa's capabilities, let's create a simple bar panel that will render the available *workspaces* and the *time*.

#### Configuring Heiwa

This step is quite quick. Make sure that the file `~/.config/heiwa/config.rb` exists, and if it doesn't, create it.

Here is what it should look like:

```rb
# config.rb

Config.make_config do |conf|
  conf.widgets = [:bar]
end
```

This will tell Heiwa to load the file at `~/.config/heiwa/bar/init.rb`.

#### Widget Markup

In Heiwa, you create widgets in Ruby. Heiwa offers an expressive and powerful DSL for creating your widgets.

Let's start by defining our widget:

```rb
# bar/init.rb

make_widget(
  title: 'Bar Panel',
  x: 0, y: 0,
  width: :max,
  height: 80,
  type: :dock
)
```

The `make_widget` function will let Heiwa know the type of widget we are creating. Let's see what this does:

- `title` will set the window title.
- `x` and `y` will set the window's position.
- `width` and `height` will set the window's height.  
  The `:max` symbol will automatically resolve the maximum allowed size. For top-level components and the widget itself, it's `Screen.width` or `Screen.height`.
- The `:dock` `type` will tell Heiwa to make the window's position *fixed*.

Now, let's create the panel itself:

```rb
panel = make(
  :rect,
  x: 0, y: 0,
  width: :max, height: :max,
  color: Color.new(30, 30, 30, 255)
)

# Add the panel to the widget root
panel.add_to_root
```

The code above will create a simple rectangle, that is the size of our widget, and has a dark color.

> [!NOTE]
> We use `add_to_root` instead of wrapping our elements in a `root` method, since we only have a single top-level component: the `panel`.

#### Events

In Heiwa, a component can have *registered events*. When an event is triggered, your code block will also get executed.

Here is an example, where we print `Hello, world!` when a rectangle is clicked on:

```rb
click_area = make :rect, width: 200, height: 200, color: Color.new(255, 0, 0)

click_area.add_event :mouse_up do |event|
  next unless event.left?

  puts 'Hello, world!'
end
```

> [!important]
> If you want to create guard clauses or want to `return` from the event, make sure that you **always** use `next` instead of `return` or `break`.

#### Reactivity

Now would be a great time to learn about **reactivity**.

Heiwa implements *reactive variables*. This means that when updating the variable, there is no need for manual reassignment.

Here is an example *without* reactive variables:

```rb
x, y = 0, 0

root do |r, children|
  fake_cursor = make  :rect,
                      x:, y:, width: 20, height: 20,
                      color: Color.new(255, 255, 255)

  def update_position
    fake_cursor.set({ x:, y: })
  end

  r.add_event :mouse_move do |event|
    x = event.x
    y = event.y
    update_position
  end

  children << fake_cursor
end
```

The example above will position a white rectangle to the cursor's current position.

Here is the same example *with* reactive variables:

```rb
x, y = reactive(0), reactive(0)

root do |r, children|
  fake_cursor = make  :rect,
                      x:, y:, width: 20, height: 20,
                      color: Color.new(255, 255, 255)

  r.add_event :mouse_move do |event|
    x.value = event.x
    y.value = event.y
  end

  children << fake_cursor
end
```

Much simpler, right?

Heiwa components always know how to handle reactive variables, so you don't need to worry about doing anything else than just *making* them reactive using the `reactive` function.

> [!note]
> Notice how we don't use `.value` when passing it to the `make` function. This happens because `$x.value` will return the primitive value, while `$x` will return a `Reactive` class.

Heiwa also implements *computed variables*. As the name suggests, computed variables *compute* values, instead of directly assigning them.

For example, we can construct an RGB value automatically from an HSL value:

```rb
hue = 120
color = computed { Color.from_hsl(hue, 100, 100) }

root do |_, children|
  children << make :rect, width: :max, height: :max, color:
end
```

This way, if we ever change `hue`, `color` will change along with it.

As a cherry on top, Heiwa also implements the *watch* function. This is nothing fancy, but you can use it to listen for updates on reactive elements:

```rb
some_number = reactive(0)
watch some_number do |new, old|
  puts "`some_number` changed: #{new} -> #{old}"
end

root do |r, _|
  r.add_event :mouse_up do
    some_number.value += 1
  end
end
```
