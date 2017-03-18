# General route helpers
transform = -> (item) { item.transform }

# Blog rules
blog_items =
  app.nonrouted
    .select  { |item| item.relpath?("blog") }
    .sort_by { |item| item.basename }
    .each    { |item| item[:hide] = item.extensions.include?("draft") }
    .each    { |item| item[:text] = item.content.valid_encoding? }
    .each    { |item| item.route = "blog/#{item.basename}" }
    .reverse

blog_public_items = blog_items.select { |i| !i[:hide] && i[:text] }
blog_index_items = blog_public_items[0..7]

blog_items
  .select { |item| item[:text] }
  .each   { |item| item.layout = "blog_show" }
  .each(&transform)

app.create("blog-index.html.erb", "", posts: blog_index_items)
  .each { |item| item.route  = "blog" }
  .each { |item| item.layout = "blog_index" }
  .each(&transform)

app.create("blog-archive.html.erb", "", posts: blog_public_items)
  .each { |item| item.route  = "blog/archives" }
  .each { |item| item.layout = "blog_archives" }
  .each(&transform)

# Home page rules
app.nonrouted
  .select { |item| item.relpath?("home") }
  .select { |item| item.type == :text }
  .each   { |item| item.route = "#{item.basepath.sub(%r{^home/}, "")}" }
  .each   { |item| item.layout = "default" }
  .each(&transform)

# Asset route helpers
def app_asset(subdir)
  app.nonrouted
    .select { |item| item.relpath?("assets/#{subdir}") }
    .reject { |item| item.basename[0] == "_" }
end

# Font rules
app_asset("fonts")
  .each { |item| item.route = "/assets/#{item.filename}" }

# Image rules
app_asset("images")
  .each { |item| item.route = "/assets/#{item.filename}" }

# JS rules
app_asset("javascripts")
  .each { |item| item.route = "/assets/#{item.basename}.js" }
  .each(&transform)

# CSS rules
app_asset("stylesheets")
  .each { |item| item.route = "/assets/#{item.basename}.css" }
  .each(&transform)

# Sitemap
html_pages =
  app.routed
    .reject  { |item| item.route.nil? }
    .select  { |item| item.extensions.include?("html") }
    .sort_by { |item| item.route }

system.global_data[:sitemap_pages] = html_pages
