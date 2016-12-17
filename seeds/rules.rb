# General route helpers
transform = -> (item) { item.transform }

# HTML rules
app.nonrouted
  .select { |item| item.extensions.include?("html") }
  .each   { |item| item.route = item.basename }
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
