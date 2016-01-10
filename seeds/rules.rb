# HTML rules
app.source
  .select { |item| item.extensions.include?("html") }
  .each   { |item| item.route = item.basename }
  .each   { |item| item.layout = "default" }
  .each   { |item| item.transform }

# CSS rules
app.source
  .select { |item| item.extensions.include?("scss") }
  .reject { |item| item.basename[0] == "_" }
  .each   { |item| item.route = "/styles/#{item.basename}.css" }
  .each   { |item| item.transform }

# Sitemap
html_pages =
  app.source
    .reject  { |item| item.route.nil? }
    .select  { |item| item.extensions.include?("html") }
    .sort_by { |item| item.route }

system.global_data[:sitemap_pages] = html_pages
