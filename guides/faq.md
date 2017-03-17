# FAQ

## How do you concatenate JavaScript files into one?

In your `application.js.erb` file, you can do something like this:

```erb
<%= %w(_file1.js _file2.js _file3.js)
  .map { |l| render(items["#{javascripts_root}/#{l}"]) }
  .join(";") %>
```

This renders each of the javascript files, then concatenates all the files, and
uses `;` as the separator.

## How do you import Sass libraries such as bourbon or neat?

After installing [Bourbon](http://bourbon.io/) into your Gemfile, go into your
`stylesheets_root` directory. This is usually in `src/assets/stylesheets/`.
Install the library by running the appropriate command, for example `bourbon
install`.

In `lib/sass.rb`, you can add the following line:

```ruby
Munge::Go.add_sass_load_path!(root_path, config[:source], File.join(AssetRoots.stylesheets_root, "bourbon"))
```

This will allow you to `@import "bourbon";` in your `application.css.scss` file.

These directions should be similar regardless of what Sass libraries are used.

## What is an `item.id`?

The `item.id` is primarily used for querying for items. For example,
`index.html.erb` could be accessed in the templates with `items["index.html"]`.

The ID is very similar to `item.relpath` except that it excludes dynamic
extensions, such as `erb`, `scss`, etc.

Here are a few examples:

relpath                                 | id
----------------------------------------|-------------------------------
`index.html.erb`                        | `index.html`
`blog/1482530041.html.md`               | `blog/1482530041.html`
`assets/stylesheets/style.css.scss.erb` | `assets/stylesheets/style.css`
`about/profile.jpg`                     | `about/profile.jpg`
